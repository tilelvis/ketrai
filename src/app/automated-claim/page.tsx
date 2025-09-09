
"use client";

import { useState } from "react";
import { AutomatedClaimForm } from "@/components/forms/automated-claim-form";
import { AutomatedClaimResult } from "@/components/results/automated-claim-result";
import { Separator } from "@/components/ui/separator";
import type { AutomatedInsuranceClaimDraftOutput } from "@/ai/flows/automated-insurance-claim-draft";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { CheckCircle } from "lucide-react";
import Link from "next/link";

export default function AutomatedClaimPage() {
  const [result, setResult] = useState<AutomatedInsuranceClaimDraftOutput | null>(null);
  const [submitted, setSubmitted] = useState(false);

  const handleComplete = () => {
    setSubmitted(true);
  }

  if (submitted) {
    return (
       <Card className="bg-green-500/10 border-green-500/30">
        <CardHeader>
            <div className="flex items-center gap-3">
                <CheckCircle className="h-8 w-8 text-green-600" />
                <div>
                    <CardTitle className="font-headline text-lg text-green-900 dark:text-green-300">Request Submitted</CardTitle>
                    <CardDescription className="text-green-800 dark:text-green-400">Your claim request has been sent for admin review.</CardDescription>
                </div>
            </div>
        </CardHeader>
        <CardContent className="flex flex-col sm:flex-row gap-4">
            <Button onClick={() => setSubmitted(false)} className="w-full sm:w-auto">
                Submit Another Request
            </Button>
            <Button asChild variant="outline" className="w-full sm:w-auto">
                <Link href="/claims-history">
                    View Claims History
                </Link>
            </Button>
        </CardContent>
      </Card>
    )
  }

  return (
    <div className="space-y-6">
      <div className="space-y-1">
          <h1 className="text-2xl font-bold tracking-tight font-headline">Request a Claim Draft</h1>
          <p className="text-muted-foreground">
              Submit package details to request an AI-generated insurance claim draft. An admin will review and process your request.
          </p>
      </div>
      <Separator />
      
      <AutomatedClaimForm onComplete={handleComplete} />
    </div>
  );
}
