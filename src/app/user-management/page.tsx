
"use client";

import { useEffect, useState, useCallback } from "react";
import { getUsers, updateUserRole } from "./actions";
import { Profile } from "@/store/profile";
import { RoleGate } from "@/components/role-gate";
import { Separator } from "@/components/ui/separator";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Skeleton } from "@/components/ui/skeleton";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { RefreshCw } from "lucide-react";

function UserManagementTable() {
    const [users, setUsers] = useState<(Profile & { id: string })[]>([]);
    const [loading, setLoading] = useState(true);
    const [updating, setUpdating] = useState<Record<string, boolean>>({});

    const fetchUsers = useCallback(async () => {
        setLoading(true);
        const result = await getUsers();
        if (result.success) {
            setUsers(result.users || []);
        } else {
            toast.error(result.error);
            setUsers([]);
        }
        setLoading(false);
    }, []);

    useEffect(() => {
        fetchUsers();
    }, [fetchUsers]);

    const handleRoleChange = async (uid: string, newRole: Profile['role']) => {
        setUpdating(prev => ({ ...prev, [uid]: true }));
        const result = await updateUserRole(uid, newRole);
        if (result.success) {
            toast.success("User role updated successfully. The user may need to log out and back in for changes to fully apply.");
            setUsers(users.map(u => u.uid === uid ? { ...u, role: newRole } : u));
        } else {
            toast.error(result.error);
        }
        setUpdating(prev => ({ ...prev, [uid]: false }));
    };

    if (loading) {
        return (
            <div className="space-y-4">
                {[...Array(3)].map((_, i) => (
                    <div key={i} className="flex items-center space-x-4 p-4 border rounded-md">
                        <Skeleton className="h-12 w-12 rounded-full" />
                        <div className="space-y-2 flex-1">
                            <Skeleton className="h-4 w-[250px]" />
                            <Skeleton className="h-4 w-[200px]" />
                        </div>
                        <Skeleton className="h-10 w-[120px]" />
                    </div>
                ))}
            </div>
        )
    }

    return (
        <Card>
            <CardHeader>
                <div className="flex justify-between items-center">
                    <div>
                        <CardTitle>All Users</CardTitle>
                        <CardDescription>View and manage all registered users in the system.</CardDescription>
                    </div>
                    <Button variant="outline" size="sm" onClick={fetchUsers} disabled={loading}>
                        <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                        Refresh
                    </Button>
                </div>
            </CardHeader>
            <CardContent>
                {users.length === 0 ? (
                    <p className="text-sm text-muted-foreground text-center py-8">No users found. This might be due to permissions issues.</p>
                ) : (
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead>User</TableHead>
                                <TableHead>Role</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {users.map(user => (
                                <TableRow key={user.uid}>
                                    <TableCell>
                                        <div className="flex items-center gap-3">
                                            <Avatar>
                                                <AvatarImage src={user.photoURL} alt={user.name} />
                                                <AvatarFallback>{user.name?.charAt(0).toUpperCase()}</AvatarFallback>
                                            </Avatar>
                                            <div>
                                                <p className="font-medium">{user.name}</p>
                                                <p className="text-sm text-muted-foreground">{user.email}</p>
                                            </div>
                                        </div>
                                    </TableCell>
                                    <TableCell>
                                        <Select
                                            value={user.role}
                                            onValueChange={(newRole) => handleRoleChange(user.uid, newRole as Profile['role'])}
                                            disabled={updating[user.uid]}
                                        >
                                            <SelectTrigger className="w-[180px]">
                                                <SelectValue placeholder="Select role" />
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="dispatcher">Dispatcher</SelectItem>
                                                <SelectItem value="manager">Manager</SelectItem>
                                                <SelectItem value="claims">Claims Officer</SelectItem>
                                                <SelectItem value="support">Support</SelectItem>
                                                <SelectItem value="admin">Admin</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                )}
            </CardContent>
        </Card>
    )
}

export default function UserManagementPage() {
    return (
        <div className="space-y-6">
            <div className="space-y-1">
                <h1 className="text-2xl font-bold tracking-tight font-headline">User Management</h1>
                <p className="text-muted-foreground">
                    Manage user roles and permissions across the application.
                </p>
            </div>
            <Separator />
            <RoleGate roles={['admin']}>
                <UserManagementTable />
            </RoleGate>
        </div>
    );
}
