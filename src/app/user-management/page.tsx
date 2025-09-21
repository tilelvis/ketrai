"use client";

import { useEffect, useState, useCallback } from "react";
import { collection, getDocs, doc, updateDoc, query, orderBy, Timestamp } from "firebase/firestore";
import { auth, db } from "@/lib/firebase";
import { getFunctions, httpsCallable } from 'firebase/functions';
import { Profile } from "@/store/profile";
import { RoleGate } from "@/components/role-gate";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { RefreshCw, Users, Mail, Ban } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { InviteForm } from "./invite-form";
import { logEvent } from "@/lib/audit-log";
import { useProfileStore } from "@/store/profile";

type Invite = {
    id: string;
    email: string;
    role: Profile['role'];
    status: "pending" | "accepted" | "expired" | "cancelled";
    token: string;
    createdAt: Timestamp;
    expiresAt: Timestamp;
}

function InvitesTable() {
    const [invites, setInvites] = useState<Invite[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchInvites = useCallback(async () => {
        setLoading(true);
        try {
            const q = query(collection(db, "invites"), orderBy("createdAt", "desc"));
            const snap = await getDocs(q);
            const data: Invite[] = snap.docs.map((d) => ({ id: d.id, ...d.data() } as Invite));
            setInvites(data);
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to fetch invites: ${message}`);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchInvites();
    }, [fetchInvites]);
    
    async function cancelInvite(id: string) {
        toast.info("Cancelling invite...");
        try {
            await updateDoc(doc(db, "invites", id), { status: "cancelled" });
            setInvites(prev => prev.map(i => (i.id === id ? { ...i, status: "cancelled" } : i)));
            toast.success("Invite cancelled.");
        } catch(err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to cancel invite: ${message}`);
        }
    }


    const getStatusVariant = (status: Invite['status']) => {
        switch (status) {
            case 'pending': return 'secondary';
            case 'accepted': return 'default';
            case 'expired': return 'destructive';
            case 'cancelled': return 'outline';
            default: return 'outline';
        }
    }

    return (
         <Card>
            <CardHeader>
                <div className="flex justify-between items-center">
                    <div className="flex items-center gap-2">
                        <Mail className="h-5 w-5 text-primary" />
                        <CardTitle>Sent Invites</CardTitle>
                    </div>
                    <Button variant="outline" size="sm" onClick={fetchInvites} disabled={loading}>
                        <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                        Refresh
                    </Button>
                </div>
                <CardDescription>Track the status of all sent user invitations.</CardDescription>
            </CardHeader>
            <CardContent>
                {loading ? (
                    <div className="space-y-2 p-4">
                        {[...Array(2)].map((_, i) => <Skeleton key={i} className="h-10 w-full" />)}
                    </div>
                ) : (
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead>Email</TableHead>
                                <TableHead>Role</TableHead>
                                <TableHead>Status</TableHead>
                                <TableHead>Expires At</TableHead>
                                <TableHead className="text-right">Actions</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {invites.length === 0 ? (
                                <TableRow>
                                    <TableCell colSpan={5} className="text-center text-muted-foreground h-24">
                                        No invites have been sent yet.
                                    </TableCell>
                                </TableRow>
                            ) : invites.map((invite) => (
                                <TableRow key={invite.id}>
                                    <TableCell className="font-medium">{invite.email}</TableCell>
                                    <TableCell className="capitalize">{invite.role}</TableCell>
                                    <TableCell>
                                        <Badge variant={getStatusVariant(invite.status)} className="capitalize">
                                            {invite.status}
                                        </Badge>
                                    </TableCell>
                                    <TableCell>
                                        {invite.expiresAt ? new Date(invite.expiresAt.seconds * 1000).toLocaleDateString() : 'N/A'}
                                    </TableCell>
                                    <TableCell className="text-right">
                                        {invite.status === 'pending' && (
                                            <Button size="sm" variant="destructive" onClick={() => cancelInvite(invite.id)}>
                                                <Ban className="mr-2 h-4 w-4" />
                                                Cancel
                                            </Button>
                                        )}
                                    </TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                )}
            </CardContent>
        </Card>
    );
}

export default function UsersPage() {
    const [users, setUsers] = useState<Profile[]>([]);
    const [loading, setLoading] = useState(true);
    const { profile: adminProfile } = useProfileStore();

    const fetchUsers = useCallback(async () => {
        setLoading(true);
        try {
            const snap = await getDocs(collection(db, "users"));
            const data: Profile[] = snap.docs.map((d) => d.data() as Profile);
            setUsers(data);
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to fetch users: ${message}`);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchUsers();
    }, [fetchUsers]);

    async function updateRole(uid: string, newRole: Profile["role"]) {
        const admin = auth.currentUser;
        if (!admin || !adminProfile) return;

        const originalUser = users.find(u => u.uid === uid);
        if (!originalUser) return;
        const originalRole = originalUser.role;

        toast.info(`Updating role to ${newRole}...`);

        try {
            const functions = getFunctions();
            const setRole = httpsCallable(functions, 'setRole');
            const response = await setRole({ uid, role: newRole });

            if ((response.data as any)?.success) {
                setUsers((prev) => prev.map((u) => (u.uid === uid ? { ...u, role: newRole } : u)));
                toast.success("Role updated successfully!", {
                    description: "The user must sign out and back in for the change to take effect."
                });

                await logEvent({
                    action: "user_role_updated",
                    actorId: admin.uid,
                    actorRole: adminProfile.role,
                    targetCollection: "users",
                    targetId: uid,
                    context: { details: `User role changed from '${originalRole}' to '${newRole}'.`, previousRole: originalRole, newRole: newRole }
                });
            } else {
                 throw new Error((response.data as any).message || "Unknown function error");
            }

        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to update role: ${message}`);
            // Revert UI on failure
            setUsers((prev) => prev.map((u) => (u.uid === uid ? { ...u, role: originalRole } : u)));
        }
    }

    async function toggleStatus(uid: string, status: Profile["status"]) {
        const admin = auth.currentUser;
        if (!admin || !adminProfile) return;

        const newStatus = status === "active" ? "inactive" : "active";
        try {
            await updateDoc(doc(db, "users", uid), { status: newStatus });
            setUsers((prev) => prev.map((u) => (u.uid === uid ? { ...u, status: newStatus } : u)));
            toast.success(`User ${newStatus === "active" ? "activated" : "deactivated"}`);

            await logEvent({
                action: newStatus === 'active' ? "user_activated" : "user_deactivated",
                actorId: admin.uid,
                actorRole: adminProfile.role,
                targetCollection: "users",
                targetId: uid,
                context: { details: `User account status set to '${newStatus}'.` }
            });

        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to update status: ${message}`);
        }
    }

    return (
        <RoleGate roles={["admin"]}>
            <div className="space-y-6">
                <div className="space-y-1">
                    <h1 className="text-2xl font-bold tracking-tight font-headline">User Management</h1>
                    <p className="text-muted-foreground">Invite, view, and manage all registered users in the system.</p>
                </div>
                <Separator />

                <InviteForm />
                
                <InvitesTable />

                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                            <div className="flex items-center gap-2">
                                <Users className="h-5 w-5 text-primary" />
                                <CardTitle>All Users</CardTitle>
                            </div>
                            <Button variant="outline" size="sm" onClick={fetchUsers} disabled={loading}>
                                <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                                Refresh
                            </Button>
                        </div>
                        <CardDescription>View and manage all currently active users.</CardDescription>
                    </CardHeader>
                    <CardContent>
                        {loading ? (
                             <div className="space-y-4">
                                {[...Array(3)].map((_, i) => (
                                    <div key={i} className="flex items-center space-x-4 p-4 border rounded-md">
                                        <Skeleton className="h-12 w-12 rounded-full" />
                                        <div className="space-y-2 flex-1">
                                            <Skeleton className="h-4 w-[250px]" />
                                            <Skeleton className="h-4 w-[200px]" />
                                        </div>
                                    </div>
                                ))}
                            </div>
                        ) : (
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>User</TableHead>
                                    <TableHead>Role</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead className="text-right">Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                            {users.map((u) => (
                                <TableRow key={u.uid}>
                                    <TableCell>
                                        <div className="flex items-center gap-3">
                                            <Avatar>
                                                <AvatarImage src={u.photoURL} alt={u.name} />
                                                <AvatarFallback>{u.name?.charAt(0).toUpperCase()}</AvatarFallback>
                                            </Avatar>
                                            <div>
                                                <p className="font-medium">{u.name}</p>
                                                <p className="text-sm text-muted-foreground">{u.email}</p>
                                            </div>
                                        </div>
                                    </TableCell>
                                    <TableCell>
                                        <Select value={u.role} onValueChange={(v) => updateRole(u.uid, v as Profile["role"])}>
                                            <SelectTrigger className="w-[140px]">
                                                <SelectValue />
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="dispatcher">Dispatcher</SelectItem>
                                                <SelectItem value="manager">Manager</SelectItem>
                                                <SelectItem value="claims">Claims</SelectItem>
                                                <SelectItem value="support">Support</SelectItem>
                                                <SelectItem value="admin">Admin</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </TableCell>
                                    <TableCell>
                                        <Badge variant={u.status === "active" ? "default" : "destructive"}>
                                            {u.status}
                                        </Badge>
                                    </TableCell>
                                    <TableCell className="text-right">
                                        <Button
                                            size="sm"
                                            variant={u.status === "active" ? "outline" : "secondary"}
                                            onClick={() => toggleStatus(u.uid, u.status)}
                                        >
                                            {u.status === "active" ? "Deactivate" : "Activate"}
                                        </Button>
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