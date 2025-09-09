
"use client";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import type { CrossCarrierRiskVisibilityOutput } from "@/ai/flows/cross-carrier-risk-visibility";
import { Button } from "../ui/button";
import { CheckCircle, AlertTriangle } from "lucide-react";

export function CrossCarrierResult({ data, onReset }: { data: CrossCarrierRiskVisibilityOutput, onReset: () => void }) {
  return (
    <div className="space-y-6">
        <Card className="bg-green-500/10 border-green-500/30">
            <CardHeader>
                <div className="flex items-center gap-3">
                    <CheckCircle className="h-8 w-8 text-green-600" />
                    <div>
                        <CardTitle className="font-headline text-lg text-green-900">Report Generated</CardTitle>
                        <CardDescription className="text-green-800">The AI has analyzed all inputs and generated a risk report.</CardDescription>
                    </div>
                </div>
            </CardHeader>
        </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-lg font-headline">Executive Summary</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground">{data.summary}</p>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
            <CardTitle className="text-lg font-headline">Grouped Risks</CardTitle>
            <CardDescription>Shipments grouped by the primary risk factor identified.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {data.groupedRisks.map((risk, i) => (
            <div key={i} className="border bg-secondary/30 rounded-lg p-4">
                <div className="font-semibold text-base flex items-center gap-2 mb-2">
                    <AlertTriangle className="h-5 w-5 text-amber-600" />
                    {risk.riskType}
                </div>
                <p className="text-sm text-muted-foreground mb-2">{risk.note}</p>
                <div className="text-xs">
                    <span className="font-medium">Affected Shipments: </span>
                    <span className="font-mono bg-secondary rounded px-1.5 py-0.5">{risk.shipments.join(", ")}</span>
                </div>
            </div>
          ))}
           {data.groupedRisks.length === 0 && (
            <p className="text-sm text-muted-foreground text-center py-4">No specific risks were identified for the given shipments.</p>
           )}
        </CardContent>
      </Card>
      <Button onClick={onReset} variant="outline" className="w-full">
        Start New Report
      </Button>
    </div>
  );
}
