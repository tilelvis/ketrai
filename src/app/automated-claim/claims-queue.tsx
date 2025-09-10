
"use client";

import { useEffect, useState, useCallback } from "react";
import { collection, getDocs, orderBy, query, Timestamp, where } from "firebase/firestore";
import { db } from "@/lib/firebase";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { RefreshCw, ClipboardList, Check, X } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { approveClaim, rejectClaim } from "@/lib/claims";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

type Claim = {
  id: string;
  type: string;
  description: string;
  status: "requested" | "inReview" | "approved" | "rejected";
  createdAt: Timestamp;
  requesterId: string;
};

function RejectClaimDialog({ claimId, onComplete }: { claimId: string; onComplete: () => void }) {
    const [reason, setReason] = useState("");
    const [loading, setLoading] = useState(false);

    async function handleReject() {
        setLoading(true);
        toast.info("Rejecting claim...");
        try {
            await rejectClaim(claimId, reason);
            toast.success("Claim rejected.");
            onComplete();
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred.";
            toast.error(`Failed to reject claim: ${message}`);
        }
        setLoading(false);
    }
    
    return (
        <Dialog onOpenChange={(open) => !open && setReason("")}>
            <DialogTrigger asChild>
                <Button size="sm" variant="destructive">
                    <X className="mr-2 h-4 w-4" />
                    Reject
                </Button>
            </DialogTrigger>
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Reject Claim</DialogTitle>
                    <DialogDescription>
                        Please provide a reason for rejecting this claim. This will be logged and sent to the user.
                    </DialogDescription>
                </DialogHeader>
                <div className="py-4">
                    <Label htmlFor="reason">Reason</Label>
                    <Input id="reason" value={reason} onChange={(e) => setReason(e.target.value)} placeholder="e.g., Insufficient evidence provided."/>
                </div>
                <DialogFooter>
                    <DialogTrigger asChild>
                         <Button variant="outline">Cancel</Button>
                    </DialogTrigger>
                    <Button onClick={handleReject} disabled={loading || !reason}>
                        {loading ? "Rejecting..." : "Confirm Rejection"}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    )
}

export default function ClaimsQueue() {
    const [claims, setClaims] = useState<Claim[]>([]);
    const [loading, setLoading] = useState(true);
    const [actionLoading, setActionLoading] = useState<Record<string, boolean>>({});

    const fetchClaims = useCallback(async () => {
        setLoading(true);
        try {
            const claimsQuery = query(collection(db, "claims"), where("status", "==", "requested"), orderBy("createdAt", "asc"));
            const snap = await getDocs(claimsQuery);
            const data: Claim[] = snap.docs.map((d) => ({ id: d.id, ...d.data() } as Claim));
            setClaims(data);
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to fetch claims: ${message}`);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchClaims();
    }, [fetchClaims]);

    async function handleApprove(claimId: string) {
        setActionLoading(prev => ({...prev, [claimId]: true}));
        toast.info("Approving claim...");
        try {
            await approveClaim(claimId);
            toast.success("Claim approved successfully!");
            fetchClaims();
        } catch(err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred.";
            toast.error(`Failed to approve claim: ${message}`);
        }
        setActionLoading(prev => ({...prev, [claimId]: false}));
    }

    return (
        <div className="space-y-6">
            <div className="space-y-1">
                <h1 className="text-2xl font-bold tracking-tight font-headline">Claims Queue</h1>
                <p className="text-muted-foreground">View and process all submitted insurance claim requests.</p>
            </div>
            <Separator />

            <Card>
                <CardHeader>
                    <div className="flex justify-between items-center">
                            <div className="flex items-center gap-2">
                            <ClipboardList className="h-5 w-5 text-primary" />
                            <CardTitle>Pending Requests</CardTitle>
                            </div>
                        <Button variant="outline" size="sm" onClick={fetchClaims} disabled={loading}>
                            <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                            Refresh
                        </Button>
                    </div>
                    <CardDescription>These are new claims that require review and action.</CardDescription>
                </CardHeader>
                <CardContent>
                    {loading ? (
                            <div className="space-y-2 p-4">
                            {[...Array(3)].map((_, i) => <Skeleton key={i} className="h-10 w-full" />)}
                        </div>
                    ) : (
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead>Date</TableHead>
                                <TableHead>Type</TableHead>
                                <TableHead>Description</TableHead>
                                <TableHead className="text-right">Actions</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                        {claims.length === 0 ? (
                            <TableRow>
                                <TableCell colSpan={4} className="text-center text-muted-foreground h-24">
                                    The claims queue is empty.
                                </TableCell>
                            </TableRow>
                        ) : claims.map((c) => (
                            <TableRow key={c.id}>
                                <TableCell>
                                    {c.createdAt ? new Date(c.createdAt.seconds * 1000).toLocaleString() : 'N/A'}
                                </TableCell>
                                <TableCell>
                                    <Badge variant="secondary" className="capitalize">
                                        {c.type}
                                    </Badge>
                                </TableCell>
                                <TableCell>
                                    <p className="font-medium max-w-sm truncate">{c.description}</p>
                                </TableCell>
                                <TableCell className="text-right space-x-2">
                                    <Button size="sm" variant="secondary" onClick={() => handleApprove(c.id)} disabled={actionLoading[c.id]}>
                                        <Check className="mr-2 h-4 w-4" />
                                        Approve
                                    </Button>
                                    <RejectClaimDialog claimId={c.id} onComplete={fetchClaims} />
                                </TableCell>
                            </TableRow>
                        ))}
                        </TableBody>
                    </Table>
                    )}
                </CardContent>
            </Card>
        </div>
    );
}
