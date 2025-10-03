"use client";

import { useEffect, useState, useCallback } from "react";
import { collection, query, where, orderBy, onSnapshot, Timestamp } from "firebase/firestore";
import { db, auth } from "@/lib/firebase";
import { RoleGate } from "@/components/role-gate";
import { toast } from "sonner";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { ClipboardList, AlertCircle } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { useProfileStore } from "@/store/profile";

type Claim = {
  id: string;
  type: string;
  description: string;
  status: "requested" | "inReview" | "approved" | "rejected";
  rejectionReason?: string;
  createdAt: Timestamp;
  requesterId: string;
};

export default function ClaimsHistory() {
    const { profile } = useProfileStore();
    const [claims, setClaims] = useState<Claim[]>([]);
    const [loading, setLoading] = useState(true);

    const subscribeToClaims = useCallback(() => {
        if (!profile) return () => {};

        let claimsQuery;
        
        if (profile.role === 'admin' || profile.role === 'manager' || profile.role === 'claims') {
            // Admins, managers, and claims officers see all claims
             claimsQuery = query(collection(db, "claims"), orderBy("createdAt", "desc"));
        } else {
            // Other roles (support, dispatcher) only see their own
            claimsQuery = query(
                collection(db, "claims"), 
                where("requesterId", "==", profile.uid),
                orderBy("createdAt", "desc")
            );
        }

        const unsubscribe = onSnapshot(claimsQuery, (snapshot) => {
            const data: Claim[] = snapshot.docs.map((d) => ({ id: d.id, ...d.data() } as Claim));
            setClaims(data);
            setLoading(false);
        }, (error) => {
            console.error("Error fetching real-time claims:", error);
            toast.error("Failed to load claims history.");
            setLoading(false);
        });
        
        return unsubscribe;
    }, [profile]);

    useEffect(() => {
        const unsubscribe = subscribeToClaims();
        return () => unsubscribe();
    }, [subscribeToClaims]);
    
    const getStatusVariant = (status: Claim['status']) => {
        switch (status) {
            case 'requested': return 'secondary';
            case 'inReview': return 'default';
            case 'approved': return 'default'; // Using 'default' which is less vibrant than success
            case 'rejected': return 'destructive';
            default: return 'outline';
        }
    }


    return (
        <RoleGate roles={["dispatcher", "claims", "support", "manager", "admin"]}>
            <div className="space-y-6">
                <div className="space-y-1">
                    <h1 className="text-2xl font-bold tracking-tight font-headline">Claims History</h1>
                    <p className="text-muted-foreground">
                        {profile?.role === 'admin' || profile?.role === 'manager' || profile?.role === 'claims'
                            ? "View all past and present claims in the system."
                            : "Track the status of all your submitted claim requests."
                        }
                    </p>
                </div>
                <Separator />

                <Card>
                    <CardHeader>
                        <div className="flex items-center gap-2">
                            <ClipboardList className="h-5 w-5 text-primary" />
                            <CardTitle>All Claims</CardTitle>
                        </div>
                    </CardHeader>
                    <CardContent>
                        {loading ? (
                            <div className="space-y-2 p-4">
                                {[...Array(5)].map((_, i) => <Skeleton key={i} className="h-10 w-full" />)}
                            </div>
                        ) : (
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Date</TableHead>
                                    <TableHead>Type</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead>Description</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                            {claims.length === 0 ? (
                                <TableRow>
                                    <TableCell colSpan={4} className="text-center text-muted-foreground h-24">
                                        No claims found.
                                    </TableCell>
                                </TableRow>
                            ) : claims.map((c) => (
                                <TableRow key={c.id}>
                                    <TableCell className="text-xs">
                                        {c.createdAt ? new Date(c.createdAt.seconds * 1000).toLocaleString() : 'N/A'}
                                    </TableCell>
                                    <TableCell>
                                        <Badge variant="outline" className="capitalize">
                                            {c.type}
                                        </Badge>
                                    </TableCell>
                                     <TableCell>
                                        <Badge variant={getStatusVariant(c.status)} className="capitalize">
                                            {c.status}
                                        </Badge>
                                    </TableCell>
                                    <TableCell>
                                        <p className="font-medium max-w-xs truncate">{c.description}</p>
                                        {c.status === 'rejected' && c.rejectionReason && (
                                            <p className="text-xs text-destructive flex items-center gap-1 mt-1">
                                                <AlertCircle className="h-3 w-3" />
                                                Reason: {c.rejectionReason}
                                            </p>
                                        )}
                                    </TableCell>
                                </TableRow>
                            ))}
                            </TableBody>
                        </Table>
                        )}
                    </CardContent>
                </Card>
            </div>
        </RoleGate>
    );
}