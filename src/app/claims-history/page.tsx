"use client";

import { useEffect, useState, useCallback } from "react";
import { collection, getDocs, orderBy, query, Timestamp, where } from "firebase/firestore";
import { db, auth } from "@/lib/firebase";
import { RoleGate } from "@/components/role-gate";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { RefreshCw, ClipboardList, User, Check, X } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { approveClaim, rejectClaim } from "@/lib/claims";
import { useProfileStore } from "@/store/profile";
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

function RejectClaimDialog({ claimId, onComplete }: { claimId: string, onComplete: () => void }) {
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
        <Dialog>
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
                    <Button variant="outline" onClick={() => (document.querySelector('[data-radix-dialog-default-open="true"] button[aria-label="Close"]')?.click())}>Cancel</Button>
                    <Button onClick={handleReject} disabled={loading || !reason}>
                        {loading ? "Rejecting..." : "Confirm Rejection"}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    )
}

export default function ClaimsHistoryPage({ isPersonalView = false }: { isPersonalView?: boolean }) {
    const { profile } = useProfileStore();
    const [claims, setClaims] = useState<Claim[]>([]);
    const [loading, setLoading] = useState(true);
    const [actionLoading, setActionLoading] = useState<Record<string, boolean>>({});

    const fetchClaims = useCallback(async () => {
        if (!auth.currentUser) return;
        setLoading(true);
        try {
            let claimsQuery;
            const claimsCollection = collection(db, "claims");

            if (isPersonalView) {
                claimsQuery = query(claimsCollection, where("requesterId", "==", auth.currentUser.uid), orderBy("createdAt", "desc"));
            } else {
                claimsQuery = query(claimsCollection, orderBy("createdAt", "desc"));
            }
            
            const snap = await getDocs(claimsQuery);
            const data: Claim[] = snap.docs.map((d) => ({ id: d.id, ...d.data() } as Claim));
            setClaims(data);
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to fetch claims: ${message}`);
        } finally {
            setLoading(false);
        }
    }, [isPersonalView]);

    useEffect(() => {
        const unsubscribe = auth.onAuthStateChanged(user => {
            if (user) {
                fetchClaims();
            } else {
                setLoading(false);
                setClaims([]);
            }
        });
        return () => unsubscribe();
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

    const getStatusVariant = (status: Claim['status']) => {
        switch (status) {
            case 'requested': return 'secondary';
            case 'inReview': return 'default';
            case 'approved': return 'default';
            case 'rejected': return 'destructive';
            default: return 'outline';
        }
    }
    
     const getStatusBadgeClass = (status: Claim['status']) => {
        switch (status) {
            case 'approved': return 'bg-green-500/20 text-green-700 border-green-500/30';
            default: return '';
        }
    }

    const PageTitle = isPersonalView ? "My Claim Requests" : "Claims Queue";
    const PageDescription = isPersonalView ? "Track the status of your submitted insurance claim requests." : "View and process all submitted insurance claim requests.";

    return (
        <div className="space-y-6">
            {!isPersonalView && (
                 <RoleGate roles={["claims", "manager", "admin"]}>
                    <div className="space-y-1">
                        <h1 className="text-2xl font-bold tracking-tight font-headline">{PageTitle}</h1>
                        <p className="text-muted-foreground">{PageDescription}</p>
                    </div>
                    <Separator />
                </RoleGate>
            )}

            <Card>
                <CardHeader>
                    <div className="flex justify-between items-center">
                            <div className="flex items-center gap-2">
                            <ClipboardList className="h-5 w-5 text-primary" />
                            <CardTitle>{isPersonalView ? "My Requests" : "All Claim Requests"}</CardTitle>
                            </div>
                        <Button variant="outline" size="sm" onClick={fetchClaims} disabled={loading}>
                            <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                            Refresh
                        </Button>
                    </div>
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
                                <TableHead>Status</TableHead>
                                <TableHead className="text-right">Actions</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                        {claims.length === 0 ? (
                            <TableRow>
                                <TableCell colSpan={4} className="text-center text-muted-foreground h-24">
                                    No claim requests have been submitted yet.
                                </TableCell>
                            </TableRow>
                        ) : claims.map((c) => (
                            <TableRow key={c.id}>
                                <TableCell>
                                    {c.createdAt ? new Date(c.createdAt.seconds * 1000).toLocaleString() : 'N/A'}
                                </TableCell>
                                <TableCell>
                                    <p className="font-medium max-w-sm">{c.type}</p>
                                </TableCell>
                                <TableCell>
                                    <Badge variant={getStatusVariant(c.status)} className={`capitalize ${getStatusBadgeClass(c.status)}`}>
                                        {c.status.replace('_', ' ')}
                                    </Badge>
                                </TableCell>
                                <TableCell className="text-right space-x-2">
                                    <RoleGate roles={['admin', 'claims']}>
                                        {c.status === 'requested' && !isPersonalView && (
                                            <>
                                            <Button size="sm" variant="secondary" onClick={() => handleApprove(c.id)} disabled={actionLoading[c.id]}>
                                                <Check className="mr-2 h-4 w-4" />
                                                Approve
                                            </Button>
                                            <RejectClaimDialog claimId={c.id} onComplete={fetchClaims} />
                                            </>
                                        )}
                                    </RoleGate>
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
