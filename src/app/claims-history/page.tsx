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
import { RefreshCw, ClipboardList, FileText, FileJson, Sparkles, Loader2, User } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { runAutomatedClaim } from "@/app/automated-claim/actions";
import { useProfileStore } from "@/store/profile";
import { useNotificationStore } from "@/store/notifications";


type Claim = {
  id: string;
  packageTrackingHistory: string;
  productDetails: string;
  claimReason: string;
  status: "pending_review" | "drafted" | "rejected";
  claimDraftText?: string;
  claimDraftJson?: string;
  createdAt: Timestamp;
  requester: {
      uid: string;
      name: string;
      email: string;
  }
};

function ClaimDetailsDialog({ claim }: { claim: Claim }) {
  if (claim.status !== 'drafted' || !claim.claimDraftText || !claim.claimDraftJson) {
      return null;
  }
    
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button variant="outline" size="sm">View Draft</Button>
      </DialogTrigger>
      <DialogContent className="max-w-4xl max-h-[80vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Claim Draft Details</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-4">
          <Card>
            <CardHeader>
              <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <FileText className="h-5 w-5 text-muted-foreground" />
                Claim Narrative
              </div>
            </CardHeader>
            <CardContent>
              <div className="rounded-md border bg-secondary/50 p-4 text-sm whitespace-pre-wrap">{claim.claimDraftText}</div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader>
              <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <FileJson className="h-5 w-5 text-muted-foreground" />
                Structured Data (JSON)
              </div>
            </CardHeader>
            <CardContent>
              <pre className="rounded-md border bg-secondary/50 p-4 text-xs overflow-x-auto">
                <code>{JSON.stringify(JSON.parse(claim.claimDraftJson), null, 2)}</code>
              </pre>
            </CardContent>
          </Card>
        </div>
      </DialogContent>
    </Dialog>
  );
}


export default function ClaimsHistoryPage({ isPersonalView = false }: { isPersonalView?: boolean }) {
    const { profile } = useProfileStore();
    const [claims, setClaims] = useState<Claim[]>([]);
    const [loading, setLoading] = useState(true);
    const [draftingId, setDraftingId] = useState<string | null>(null);
    const addNotification = useNotificationStore(s => s.add);

    const fetchClaims = useCallback(async () => {
        if (!auth.currentUser) return;
        setLoading(true);
        try {
            let claimsQuery;
            const claimsCollection = collection(db, "claims");

            if (isPersonalView) {
                // Fetch only the current user's claims
                claimsQuery = query(claimsCollection, where("requester.uid", "==", auth.currentUser.uid), orderBy("createdAt", "desc"));
            } else {
                 // Admins/managers/claims see all claims
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
        fetchClaims();
    }, [fetchClaims]);

    async function handleDraftClaim(claim: Claim) {
        setDraftingId(claim.id);
        toast.info("Generating AI claim draft...");

        const result = await runAutomatedClaim({
            claimId: claim.id,
            packageTrackingHistory: claim.packageTrackingHistory,
            productDetails: claim.productDetails,
            claimReason: claim.claimReason,
        });

        if (result.success) {
            toast.success("Claim drafted successfully!");
            // Send notification to the user who requested it
            addNotification({
                message: `Your claim for "${claim.claimReason}" has been drafted by an admin.`,
                type: 'success',
                category: 'claims'
            }, claim.requester.uid);
            fetchClaims(); // Refresh the list to show the new status
        } else {
            toast.error(result.error);
        }
        setDraftingId(null);
    }

    const getStatusVariant = (status: Claim['status']) => {
        switch (status) {
            case 'pending_review': return 'secondary';
            case 'drafted': return 'default';
            case 'rejected': return 'destructive';
            default: return 'outline';
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
                                {!isPersonalView && <TableHead>Requester</TableHead>}
                                <TableHead>Date</TableHead>
                                <TableHead>Reason</TableHead>
                                <TableHead>Status</TableHead>
                                <TableHead className="text-right">Actions</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                        {claims.length === 0 ? (
                            <TableRow>
                                <TableCell colSpan={isPersonalView ? 4 : 5} className="text-center text-muted-foreground h-24">
                                    No claim requests have been submitted yet.
                                </TableCell>
                            </TableRow>
                        ) : claims.map((c) => (
                            <TableRow key={c.id}>
                                {!isPersonalView && 
                                    <TableCell>
                                        <div className="flex items-center gap-2">
                                            <User className="h-4 w-4 text-muted-foreground" />
                                            <div className="flex flex-col">
                                                <span className="font-medium">{c.requester.name}</span>
                                                <span className="text-xs text-muted-foreground">{c.requester.email}</span>
                                            </div>
                                        </div>
                                    </TableCell>
                                }
                                <TableCell>
                                    {c.createdAt ? new Date(c.createdAt.seconds * 1000).toLocaleString() : 'N/A'}
                                </TableCell>
                                    <TableCell>
                                    <p className="font-medium max-w-sm">{c.claimReason}</p>
                                </TableCell>
                                <TableCell>
                                    <Badge variant={getStatusVariant(c.status)} className="capitalize">
                                        {c.status.replace('_', ' ')}
                                    </Badge>
                                </TableCell>
                                <TableCell className="text-right space-x-2">
                                    {c.status === 'drafted' && <ClaimDetailsDialog claim={c} />}
                                    <RoleGate roles={['admin']}>
                                        {c.status === 'pending_review' && !isPersonalView && (
                                            <Button size="sm" onClick={() => handleDraftClaim(c)} disabled={draftingId === c.id}>
                                                {draftingId === c.id ? (
                                                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                                                ) : (
                                                    <Sparkles className="mr-2 h-4 w-4" />
                                                )}
                                                Draft Claim
                                            </Button>
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
