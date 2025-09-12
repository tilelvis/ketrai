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
import { RefreshCw, ClipboardList } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { useProfileStore } from "@/store/profile";

type Claim = {
  id: string;
  type: string;
  description: string;
  status: "requested" | "inReview" | "approved" | "rejected";
  createdAt: Timestamp;
  requesterId: string;
};

export default function ClaimsHistoryPage({ isPersonalView = false }: { isPersonalView?: boolean }) {
    const { profile } = useProfileStore();
    const [claims, setClaims] = useState<Claim[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchClaims = useCallback(async () => {
        if (!auth.currentUser) return;
        setLoading(true);
        try {
            let claimsQuery;
            const claimsCollection = collection(db, "claims");

            if (isPersonalView) {
                claimsQuery = query(claimsCollection, where("requesterId", "==", auth.currentUser.uid), orderBy("createdAt", "desc"));
            } else {
                 if (profile?.role && ['admin', 'manager', 'claims'].includes(profile.role)) {
                    claimsQuery = query(claimsCollection, orderBy("createdAt", "desc"));
                 } else {
                    setClaims([]);
                    setLoading(false);
                    return;
                 }
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
    }, [isPersonalView, profile?.role]);

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
            case 'rejected': return 'bg-red-500/10 text-red-700 border-red-500/20';
            default: return '';
        }
    }

    const PageTitle = isPersonalView ? "My Claim Requests" : "Claims History";
    const PageDescription = isPersonalView 
        ? "Track the status of your submitted insurance claim requests." 
        : "View a complete history of all submitted claims.";

    // Define roles that can access this page view
    const allowedRoles: (Profile['role'])[] = isPersonalView 
        ? ['dispatcher', 'support', 'claims', 'manager', 'admin', 'user', 'courier'] // Anyone can see their own
        : ['claims', 'manager', 'admin']; // Only these roles can see the full history

    return (
        <RoleGate roles={allowedRoles}>
            <div className="space-y-6">
                {!isPersonalView && (
                    <>
                        <div className="space-y-1">
                            <h1 className="text-2xl font-bold tracking-tight font-headline">{PageTitle}</h1>
                            <p className="text-muted-foreground">{PageDescription}</p>
                        </div>
                        <Separator />
                    </>
                )}

                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                                <div className="flex items-center gap-2">
                                <ClipboardList className="h-5 w-5 text-primary" />
                                <CardTitle>{isPersonalView ? "My Requests" : "All Claims"}</CardTitle>
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
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                            {claims.length === 0 ? (
                                <TableRow>
                                    <TableCell colSpan={3} className="text-center text-muted-foreground h-24">
                                        No claims found.
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
                                            {c.status.replace(/([A-Z])/g, ' $1').trim()}
                                        </Badge>
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