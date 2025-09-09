
"use client";

import { useEffect, useState, useCallback } from "react";
import { collection, getDocs, doc, updateDoc } from "firebase/firestore";
import { db } from "@/lib/firebase";
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
import { RefreshCw } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";


export default function UsersPage() {
    const [users, setUsers] = useState<Profile[]>([]);
    const [loading, setLoading] = useState(true);

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

    async function updateRole(uid: string, role: Profile["role"]) {
        try {
            await updateDoc(doc(db, "users", uid), { role });
            setUsers((prev) => prev.map((u) => (u.uid === uid ? { ...u, role } : u)));
            toast.success("Role updated successfully!");
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to update role: ${message}`);
        }
    }

    async function toggleStatus(uid: string, status: Profile["status"]) {
        const newStatus = status === "active" ? "inactive" : "active";
        try {
            await updateDoc(doc(db, "users", uid), { status: newStatus });
            setUsers((prev) => prev.map((u) => (u.uid === uid ? { ...u, status: newStatus } : u)));
            toast.success(`User ${newStatus === "active" ? "activated" : "deactivated"}`);
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
                    <p className="text-muted-foreground">View and manage all registered users in the system.</p>
                </div>
                <Separator />

                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                            <CardTitle>All Users</CardTitle>
                            <Button variant="outline" size="sm" onClick={fetchUsers} disabled={loading}>
                                <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                                Refresh
                            </Button>
                        </div>
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
                                    <TableHead>Actions</TableHead>
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
                                    <TableCell>
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
