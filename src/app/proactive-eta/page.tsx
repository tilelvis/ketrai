
"use client";

import { useState } from "react";
import { ProactiveEtaForm } from "@/components/forms/proactive-eta-form";
import { ProactiveEtaResult } from "@/components/results/proactive-eta-result";
import { DashboardLayout } from "@/components/dashboard-layout";
import { Separator } from "@/components/ui/separator";
import type { ProactiveEtaCalculationOutput } from "@/ai/flows/proactive-eta-calculation";
import { Card, CardContent } from "@/components/ui/card";

export default function ProactiveEtaPage() {
  const [result, setResult] = useState<ProactiveEtaCalculationOutput | null>(null);

  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="space-y-1">
          <h1 className="text-2xl font-bold tracking-tight font-headline">Proactive ETA</h1>
          <p className="text-muted-foreground">
            Recalculate delivery ETAs in real-time using traffic and weather.
          </p>
        </div>
        <Separator />
        
        <Card>
            <CardContent className="p-6">
                <ProactiveEtaForm onComplete={setResult} />
            </CardContent>
        </Card>

        {result && <ProactiveEtaResult data={result} />}
      </div>
    </DashboardLayout>
  );
}
