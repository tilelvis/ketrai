
"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { db, auth } from "@/lib/firebase";
import { collection, query, where, getDocs, doc, updateDoc, setDoc, Timestamp } from "firebase/firestore";
import { createUserWithEmailAndPassword } from "firebase/auth";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Logo } from "@/components/icons";
import { Loader2 } from "lucide-react";
import type { Profile } from "@/store/profile";

type Invite = {
    id: string;
    email: string;
    role: Profile['role'];
    status: "pending" | "accepted" | "expired";
    token: string;
    createdAt: Timestamp;
    expiresAt: Timestamp;
}

export default function InviteAcceptPage({ params }: { params: { token: string } }) {
  const { token } = params;
  const router = useRouter();

  const [invite, setInvite] = useState<Invite | null>(null);
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchInvite() {
      if (!token) {
        setError("Invalid invite link.");
        setLoading(false);
        return;
      }

      try {
        const q = query(collection(db, "invites"), where("token", "==", token));
        const snap = await getDocs(q);

        if (snap.empty) {
          setError("This invite link is invalid or has been removed.");
        } else {
          const inviteData = { id: snap.docs[0].id, ...snap.docs[0].data() } as Invite;
          
          if (inviteData.status !== "pending") {
            setError("This invite has already been used.");
          } else if (inviteData.expiresAt.toMillis() < Date.now()) {
            setError("This invite has expired.");
          } else {
            setInvite(inviteData);
          }
        }
      } catch(err) {
        setError("An error occurred while trying to verify the invite.");
      } finally {
        setLoading(false);
      }
    }
    fetchInvite();
  }, [token]);

  async function handleAccept() {
    if (!invite || !password) return;
    setLoading(true);
    toast.info("Creating your account...");

    try {
      const cred = await createUserWithEmailAndPassword(auth, invite.email, password);

      const newProfile: Profile = {
        uid: cred.user.uid,
        email: invite.email,
        name: invite.email.split("@")[0],
        role: invite.role,
        theme: "system",
        status: "active",
      };

      await setDoc(doc(db, "users", cred.user.uid), newProfile);

      // Mark invite as accepted
      await updateDoc(doc(db, "invites", invite.id), { status: "accepted" });

      toast.success("Account created successfully!", {
        description: "You will be redirected to the login page."
      });

      router.push("/login");

    } catch (err) {
      const message = err instanceof Error ? err.message : "An unknown error occurred.";
      toast.error(`Failed to create account: ${message}`);
      setLoading(false);
    }
  }
  
  if (loading) {
      return (
          <div className="flex flex-col items-center justify-center min-h-screen">
              <Loader2 className="h-8 w-8 animate-spin text-primary" />
              <p className="text-muted-foreground mt-4">Verifying invite...</p>
          </div>
      )
  }
  
  if (error || !invite) {
    return (
        <div className="flex items-center justify-center min-h-screen bg-background p-4">
            <Card className="max-w-md w-full">
                <CardHeader>
                    <CardTitle className="text-destructive">Invite Error</CardTitle>
                </CardHeader>
                <CardContent>
                    <p>{error || "This invite could not be found."}</p>
                </CardContent>
                <CardFooter>
                    <Button onClick={() => router.push('/login')} className="w-full">Go to Login</Button>
                </CardFooter>
            </Card>
        </div>
    )
  }


  return (
    <div className="flex items-center justify-center min-h-screen bg-background p-4">
      <div className="w-full max-w-md space-y-6">
        <div className="flex flex-col items-center text-center">
            <Logo className="size-12 text-primary" />
            <h1 className="text-3xl font-bold font-headline mt-4">You're Invited!</h1>
        </div>
        <Card>
            <CardHeader>
                <CardTitle>Create Your Account</CardTitle>
                <CardDescription>
                    Welcome! You've been invited to join ChainFlow AI as a <span className="font-semibold text-primary">{invite.role}</span>. 
                    Please set a password to continue.
                </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
                <div className="space-y-2">
                    <Label>Email</Label>
                    <Input value={invite.email} disabled />
                </div>
                <div className="space-y-2">
                    <Label htmlFor="password">Set Password</Label>
                    <Input
                        id="password"
                        type="password"
                        placeholder="Choose a strong password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        autoFocus
                    />
                </div>
                <Button onClick={handleAccept} disabled={!password || loading} className="w-full">
                  {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                  {loading ? 'Creating Account...' : 'Accept & Join'}
                </Button>
            </CardContent>
        </Card>
      </div>
    </div>
  );
}

