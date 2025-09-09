
"use client";

import { useState } from "react";
import { SmartDispatchForm } from "@/components/forms/smart-dispatch-form";
import { SmartDispatchResult } from "@/components/results/smart-dispatch-result";
import { Separator } from "@/components/ui/separator";
import type { SmartDispatchRecommendationOutput } from "@/ai/flows/smart-dispatch-recommendation";

export default function SmartDispatchPage() {
  const [result, setResult] = useState<SmartDispatchRecommendationOutput | null>(null);

  return (
     <div className="space-y-6">
      <div className="space-y-1">
          <h1 className="text-2xl font-bold tracking-tight font-headline">Smart Dispatch Assessor</h1>
          <p className="text-muted-foreground">
            Analyze route risks to find the optimal and safest path.
          </p>
      </div>
      <Separator />

      {!result ? (
          <SmartDispatchForm onComplete={setResult} />
      ) : (
          <SmartDispatchResult data={result} onReset={() => setResult(null)} />
      )}
    </div>
  );
}
