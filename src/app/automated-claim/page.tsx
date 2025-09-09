
"use client";

import { useState } from "react";
import { AutomatedClaimForm } from "@/components/forms/automated-claim-form";
import { AutomatedClaimResult } from "@/components/results/automated-claim-result";
import { Separator } from "@/components/ui/separator";
import type { AutomatedInsuranceClaimDraftOutput } from "@/ai/flows/automated-insurance-claim-draft";
import { Button } from "@/components/ui/button";

export default function AutomatedClaimPage() {
  const [result, setResult] = useState<AutomatedInsuranceClaimDraftOutput | null>(null);

  return (
    <div className="space-y-6">
      <div className="space-y-1">
          <h1 className="text-2xl font-bold tracking-tight font-headline">Automated Insurance Claim</h1>
          <p className="text-muted-foreground">
              Auto-draft insurance claims for damaged or lost packages.
          </p>
      </div>
      <Separator />
      
      {!result ? (
        <AutomatedClaimForm onComplete={setResult} />
      ) : (
        <div className="space-y-4">
          <AutomatedClaimResult data={result} />
          <Button onClick={() => setResult(null)} variant="outline" className="w-full">
            Start New Claim
          </Button>
        </div>
      )}
    </div>
  );
}
