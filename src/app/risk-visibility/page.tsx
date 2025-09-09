
"use client";

import { useState } from "react";
import { CrossCarrierForm } from "@/components/forms/cross-carrier-form";
import { CrossCarrierResult } from "@/components/results/cross-carrier-result";
import { Separator } from "@/components/ui/separator";
import type { CrossCarrierRiskVisibilityOutput } from "@/ai/flows/cross-carrier-risk-visibility";

export default function RiskVisibilityPage() {
  const [result, setResult] = useState<CrossCarrierRiskVisibilityOutput | null>(null);

  return (
    <div className="space-y-6">
      <div className="space-y-1">
          <h1 className="text-2xl font-bold tracking-tight font-headline">Cross-Carrier Visibility Hub</h1>
          <p className="text-muted-foreground">
              Aggregate shipment data to identify and report on supply chain risks.
          </p>
      </div>
      <Separator />
      
      {!result ? (
        <CrossCarrierForm onComplete={setResult} />
      ) : (
        <CrossCarrierResult data={result} onReset={() => setResult(null)} />
      )}
    </div>
  );
}
