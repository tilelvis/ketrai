"use client";

import { useState } from "react";
import { crossCarrierRiskVisibility } from "@/ai/flows/cross-carrier-risk-visibility";
import type { CrossCarrierRiskVisibilityOutput } from "@/ai/flows/cross-carrier-risk-visibility";

import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, AlertTriangle } from "lucide-react";

export function RiskVisibilityReport() {
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<CrossCarrierRiskVisibilityOutput | null>(null);

  async function generateReport() {
    setLoading(true);
    setResult(null);
    try {
      // Input is an empty object for this flow
      const output = await crossCarrierRiskVisibility({});
      setResult(output);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="space-y-4">
      <Button onClick={generateReport} disabled={loading} className="w-full">
        {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        Generate Risk Report
      </Button>

      {result && (
        <Card className="bg-secondary/50">
          <CardHeader>
            <CardTitle className="text-base font-headline">Risk Report</CardTitle>
            <CardDescription>Aggregated summary of supply chain risks.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4 text-sm">
            {result.criticalAlerts && result.criticalAlerts.length > 0 && (
                <div className="space-y-2">
                    <h3 className="font-semibold flex items-center gap-2">
                        <AlertTriangle className="h-5 w-5 text-destructive" />
                        Critical Alerts
                    </h3>
                    <ul className="list-disc list-inside space-y-1 rounded-md border border-destructive/50 bg-destructive/10 p-3">
                        {result.criticalAlerts.map((alert, index) => (
                            <li key={index}>{alert}</li>
                        ))}
                    </ul>
                </div>
            )}
            <div>
              <p className="font-semibold mb-2">Dashboard Report (JSON)</p>
              <pre className="rounded-md border bg-card p-3 text-xs overflow-x-auto">
                {result.dashboardReport !== 'No risks identified.' 
                    ? <code>{JSON.stringify(JSON.parse(result.dashboardReport), null, 2)}</code>
                    : <p>{result.dashboardReport}</p>
                }
              </pre>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
