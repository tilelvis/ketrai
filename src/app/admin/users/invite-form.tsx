"use client";

import { useState } from "react";
import { db } from "@/lib/firebase";
import { collection, addDoc, serverTimestamp } from "firebase/firestore";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { toast } from "sonner";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { MailPlus, Loader2 } from "lucide-react";
import type { Profile } from "@/store/profile";
import { useProfileStore } from "@/store/profile";
import { logEvent } from "@/lib/audit-log";


function generateToken() {
    const arr = new Uint8Array(20);
    crypto.getRandomValues(arr);
    return Array.from(arr, (byte) => byte.toString(16).padStart(2, '0')).join('');
}


export function InviteForm() {
  const { profile } = useProfileStore();
  const [email, setEmail] = useState("");
  const [role, setRole] = useState<Profile["role"]>("dispatcher");
  const [loading, setLoading] = useState(false);

  async function handleInvite() {
    if (!email) {
        toast.error("Please enter an email address.");
        return;
    }
    if (!profile) {
        toast.error("Could not identify the sending admin. Please refresh and try again.");
        return;
    }

    setLoading(true);
    toast.info("Sending invite...");

    try {
      const token = generateToken();
      const expiresAt = new Date(Date.now() + 1000 * 60 * 60 * 24 * 3); // 3 days expiry

      const inviteRef = await addDoc(collection(db, "invites"), {
        email,
        role,
        status: "pending",
        token,
        createdAt: serverTimestamp(),
        expiresAt,
        invitedBy: {
            name: profile.name,
            email: profile.email,
        }
      });
      
      await logEvent(
        "user_invited",
        profile.uid,
        profile.role,
        { id: inviteRef.id, collection: "invites" },
        { invitedEmail: email, assignedRole: role }
      );

      const inviteLink = `${window.location.origin}/invite/${token}`;

      // In a real app, you would use a service to email this link.
      // For now, we'll show a success toast and log it.
      console.log("Invite link:", inviteLink);

      toast.success("Invite created successfully!", {
        description: `The invite link has been logged to the console.`,
        action: {
            label: "Copy Link",
            onClick: () => navigator.clipboard.writeText(inviteLink).then(() => toast.success("Link copied!")),
        },
      });

      setEmail("");
      setRole("dispatcher");

    } catch (err) {
      const message = err instanceof Error ? err.message : "An unknown error occurred.";
      toast.error(`Failed to create invite: ${message}`);
    } finally {
        setLoading(false);
    }
  }

  return (
    <Card>
        <CardHeader>
            <div className="flex items-center gap-2">
                <MailPlus className="h-5 w-5 text-primary" />
                <CardTitle>Invite New User</CardTitle>
            </div>
            <CardDescription>Send an invitation to a new user with a pre-assigned role.</CardDescription>
        </CardHeader>
        <CardContent className="grid md:grid-cols-3 gap-4 items-end">
            <div className="space-y-2">
                <Label htmlFor="invite-email">Email</Label>
                <Input id="invite-email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="user@company.com" />
            </div>
            <div className="space-y-2">
                <Label htmlFor="invite-role">Role</Label>
                <Select value={role} onValueChange={(v) => setRole(v as Profile['role'])}>
                <SelectTrigger id="invite-role">
                    <SelectValue />
                </SelectTrigger>
                <SelectContent>
                    <SelectItem value="dispatcher">Dispatcher</SelectItem>
                    <SelectItem value="manager">Manager</SelectItem>
                    <SelectItem value="claims">Claims Officer</SelectItem>
                    <SelectItem value="support">Support</SelectItem>
                </SelectContent>
                </Select>
            </div>
            <Button onClick={handleInvite} disabled={loading}>
                {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                Send Invite
            </Button>
        </CardContent>
    </Card>
  );
}
