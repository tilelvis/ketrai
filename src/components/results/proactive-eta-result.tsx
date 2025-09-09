"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { AlertTriangle, Clock, MessageSquareText, Info } from "lucide-react";
import { cn } from "@/lib/utils";
import type { ProactiveEtaCalculationOutput } from "@/ai/flows/proactive-eta-calculation";

export function ProactiveEtaResult({ data }: { data: ProactiveEtaCalculationOutput }) {
  const riskStyles = {
    high: {
      card: "border-red-500/30 bg-red-500/10",
      icon: "text-red-600",
      text: "text-red-900",
      description: "text-red-800",
    },
    medium: {
      card: "border-amber-500/30 bg-amber-500/10",
      icon: "text-amber-600",
      text: "text-amber-900",
      description: "text-amber-800",
    },
    low: {
        card: "border-emerald-500/30 bg-emerald-500/10",
        icon: "text-emerald-600",
        text: "text-emerald-900",
        description: "text-emerald-800",
    },
  };

  const styles = riskStyles[data.riskLevel];

  return (
    <div className="space-y-6">
       <Card className={cn(styles.card)}>
        <CardHeader>
            <div className="flex items-start gap-3">
                <AlertTriangle className={cn("h-6 w-6 mt-1", styles.icon)} />
                <div>
                    <CardTitle className={cn("font-headline text-lg", styles.text)}>
                        Risk Level: {data.riskLevel.charAt(0).toUpperCase() + data.riskLevel.slice(1)}
                    </CardTitle>
                    <p className={cn("text-sm", styles.description)}>
                        The AI has assessed the potential for delays based on current conditions.
                    </p>
                </div>
            </div>
        </CardHeader>
      </Card>
      
      <Card>
        <CardHeader>
            <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <Clock className="h-5 w-5 text-muted-foreground" />
                Updated ETA
            </div>
        </CardHeader>
        <CardContent className="text-2xl font-bold">
            {new Date(data.recalculatedEta).toLocaleString()}
        </CardContent>
      </Card>

      <Card>
         <CardHeader>
            <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <MessageSquareText className="h-5 w-5 text-muted-foreground" />
                Customer Notification
            </div>
        </CardHeader>
        <CardContent>
          <p className="rounded-md border bg-secondary/50 p-4 text-sm">{data.customerMessage}</p>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
            <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <Info className="h-5 w-5 text-muted-foreground" />
                Dispatcher Notes
            </div>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground">{data.explanation}</p>
        </CardContent>
      </Card>
    </div>
  );
}
