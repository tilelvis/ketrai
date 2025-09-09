
"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { signInWithEmailAndPassword, createUserWithEmailAndPassword } from "firebase/auth";
import { auth } from "@/lib/firebase";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Loader2 } from "lucide-react";
import { notify } from "@/lib/notify";
import { Logo } from "@/components/icons";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isSignup, setIsSignup] = useState(false);
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!email || !password) {
        notify.error("Please enter both email and password.");
        return;
    }
    setLoading(true);

    try {
      if (isSignup) {
        await createUserWithEmailAndPassword(auth, email, password);
      } else {
        await signInWithEmailAndPassword(auth, email, password);
      }
      notify.success(isSignup ? "Account created successfully!" : "Login successful!");
      router.push("/");
    } catch (err) {
      const message = err instanceof Error ? err.message : "An unknown error occurred.";
      notify.error(`Authentication failed: ${message}`);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="flex items-center justify-center min-h-screen bg-background p-4">
      <div className="w-full max-w-md space-y-6">
        <div className="flex flex-col items-center text-center">
            <Logo className="size-12 text-primary" />
            <h1 className="text-3xl font-bold font-headline mt-4">Welcome to ChainFlow AI</h1>
            <p className="text-muted-foreground">The future of intelligent supply chain orchestration.</p>
        </div>
        <Card>
            <CardHeader>
            <CardTitle>{isSignup ? "Create an Account" : "Sign In"}</CardTitle>
            <CardDescription>
                {isSignup ? "Enter your details to get started." : "Enter your credentials to access your dashboard."}
            </CardDescription>
            </CardHeader>
            <CardContent>
            <form onSubmit={handleSubmit} className="space-y-4">
                <div className="space-y-2">
                <Label htmlFor="email">Email</Label>
                <Input id="email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required placeholder="name@company.com"/>
                </div>
                <div className="space-y-2">
                <Label htmlFor="password">Password</Label>
                <Input id="password" type="password" value={password} onChange={(e) => setPassword(e.target.value)} required placeholder="••••••••"/>
                </div>
                <Button type="submit" disabled={loading} className="w-full">
                  {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                  {loading ? "Please wait…" : isSignup ? "Sign Up" : "Login"}
                </Button>
            </form>
            </CardContent>
            <CardFooter className="flex justify-center text-sm">
            <button
                type="button"
                onClick={() => setIsSignup(!isSignup)}
                className="text-muted-foreground hover:text-primary"
            >
                {isSignup ? "Already have an account? Sign In" : "Don't have an account? Sign Up"}
            </button>
            </CardFooter>
        </Card>
      </div>
    </div>
  );
}
