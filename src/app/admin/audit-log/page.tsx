
"use client";

import { useEffect, useState, useCallback } from "react";
import { collection, getDocs, orderBy, query, Timestamp } from "firebase/firestore";
import { db } from "@/lib/firebase";
import { RoleGate } from "@/components/role-gate";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { RefreshCw, ScrollText, FileJson } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";

type AuditLog = {
  id: string;
  action: string;
  actorId: string;
  actorRole: string;
  targetCollection: string;
  targetId: string;
  context: Record<string, any>;
  timestamp: Timestamp;
};

function LogContextDialog({ context }: { context: Record<string, any> }) {
  if (!context || Object.keys(context).length === 0) {
    return <span className="text-muted-foreground">-</span>;
  }
    
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button variant="outline" size="sm">
            <FileJson className="mr-2 h-3 w-3" />
            Details
        </Button>
      </DialogTrigger>
      <DialogContent>
        <DialogHeader>
          <DialogTitle>Log Event Context</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-4">
           <pre className="rounded-md border bg-secondary/50 p-4 text-xs overflow-x-auto">
              <code>{JSON.stringify(context, null, 2)}</code>
            </pre>
        </div>
      </DialogContent>
    </Dialog>
  );
}


export default function AuditLogPage() {
    const [logs, setLogs] = useState<AuditLog[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchLogs = useCallback(async () => {
        setLoading(true);
        try {
            const logsQuery = query(collection(db, "auditLogs"), orderBy("timestamp", "desc"));
            const snap = await getDocs(logsQuery);
            const data: AuditLog[] = snap.docs.map((d) => ({ id: d.id, ...d.data() } as AuditLog));
            setLogs(data);
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to fetch audit logs: ${message}`);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchLogs();
    }, [fetchLogs]);

    return (
        <RoleGate roles={["admin"]}>
            <div className="space-y-6">
                <div className="space-y-1">
                    <h1 className="text-2xl font-bold tracking-tight font-headline">Audit Log</h1>
                    <p className="text-muted-foreground">A chronological log of all significant events in the system.</p>
                </div>
                <Separator />

                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                             <div className="flex items-center gap-2">
                                <ScrollText className="h-5 w-5 text-primary" />
                                <CardTitle>All Events</CardTitle>
                             </div>
                            <Button variant="outline" size="sm" onClick={fetchLogs} disabled={loading}>
                                <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                                Refresh
                            </Button>
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
                                    <TableHead className="w-[180px]">Timestamp</TableHead>
                                    <TableHead>Action</TableHead>
                                    <TableHead>Actor</TableHead>
                                    <TableHead>Target</TableHead>
                                    <TableHead className="text-right">Context</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                            {logs.length === 0 ? (
                                <TableRow>
                                    <TableCell colSpan={5} className="text-center text-muted-foreground h-24">
                                        No audit events found.
                                    </TableCell>
                                </TableRow>
                            ) : logs.map((log) => (
                                <TableRow key={log.id}>
                                    <TableCell className="text-xs text-muted-foreground">
                                        {log.timestamp ? new Date(log.timestamp.seconds * 1000).toLocaleString() : 'N/A'}
                                    </TableCell>
                                    <TableCell>
                                        <Badge variant="secondary" className="font-mono">{log.action}</Badge>
                                    </TableCell>
                                    <TableCell>
                                        <div className="font-mono text-xs max-w-24 truncate" title={log.actorId}>{log.actorId}</div>
                                        <div className="capitalize text-xs text-muted-foreground">{log.actorRole}</div>
                                    </TableCell>
                                     <TableCell>
                                        <div className="font-mono text-xs max-w-24 truncate" title={log.targetId}>{log.targetId}</div>
                                        <div className="capitalize text-xs text-muted-foreground">{log.targetCollection}</div>
                                    </TableCell>
                                    <TableCell className="text-right">
                                        <LogContextDialog context={log.context} />
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
