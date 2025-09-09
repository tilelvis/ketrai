
"use client";

import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid, LabelList } from "recharts";
import { SmartDispatchRecommendationOutput } from "@/ai/flows/smart-dispatch-recommendation";
import { Button } from "@/components/ui/button";
import { CheckCircle, Lightbulb, AlertTriangle } from "lucide-react";
import { Separator } from "@/components/ui/separator";

export function SmartDispatchResult({ data, onReset }: { data: SmartDispatchRecommendationOutput, onReset: () => void }) {
    
  const chartData = data.routes.map(route => ({
    name: route.name,
    Risk: route.riskIndex,
    ETA: route.etaMinutes,
    fill: route.name === data.recommendedRoute ? 'hsl(var(--primary))' : 'hsl(var(--muted))'
  }));

  return (
    <div className="space-y-6">
      <Card className="bg-green-500/10 border-green-500/30">
        <CardHeader>
            <div className="flex items-center gap-3">
                <CheckCircle className="h-8 w-8 text-green-600" />
                <div>
                    <CardTitle className="font-headline text-lg text-green-900 dark:text-green-300">Optimal Route Found</CardTitle>
                    <CardDescription className="text-green-800 dark:text-green-400">The AI has analyzed the routes and recommended the best option.</CardDescription>
                </div>
            </div>
        </CardHeader>
        <CardContent className="space-y-2 text-sm">
            <div className="p-3 rounded-md bg-background/50 border">
                <p className="font-semibold flex items-center gap-2 text-base"><Lightbulb className="text-primary h-5 w-5"/>AI Recommendation: <span className="text-primary">{data.recommendedRoute}</span></p>
                <p className="text-xs mt-1 text-muted-foreground">{data.explanation}</p>
            </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="font-headline text-lg">Route Comparison</CardTitle>
          <CardDescription>Visual comparison of risk and ETA for each route.</CardDescription>
        </CardHeader>
        <CardContent className="p-4">
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={chartData} margin={{ top: 20, right: 0, left: 0, bottom: 5 }}>
              <CartesianGrid vertical={false} strokeDasharray="3 3" />
              <XAxis dataKey="name" stroke="hsl(var(--muted-foreground))" fontSize={12} tickLine={false} axisLine={false} />
              <YAxis yAxisId="left" orientation="left" stroke="hsl(var(--muted-foreground))" fontSize={12} tickLine={false} axisLine={false} label={{ value: 'Risk Index', angle: -90, position: 'insideLeft', offset: 10, style: { fontSize: '12px', fill: 'hsl(var(--muted-foreground))' } }} />
              <YAxis yAxisId="right" orientation="right" stroke="hsl(var(--muted-foreground))" fontSize={12} tickLine={false} axisLine={false} label={{ value: 'ETA (mins)', angle: -90, position: 'insideRight', offset: -10, style: { fontSize: '12px', fill: 'hsl(var(--muted-foreground))' } }} />
              <Tooltip
                contentStyle={{
                  background: "hsl(var(--card))",
                  borderColor: "hsl(var(--border))",
                  borderRadius: "var(--radius)",
                  fontSize: "12px",
                }}
                labelStyle={{ fontWeight: 'bold', color: "hsl(var(--foreground))" }}
              />
              <Bar yAxisId="left" dataKey="Risk" name="Risk Index" fill="hsl(var(--destructive) / 0.6)" radius={[4, 4, 0, 0]}>
                <LabelList dataKey="Risk" position="top" style={{ fontSize: '10px', fill: 'hsl(var(--destructive))' }} />
              </Bar>
              <Bar yAxisId="right" dataKey="ETA" name="ETA (minutes)" fill="hsl(var(--primary) / 0.6)" radius={[4, 4, 0, 0]}>
                <LabelList dataKey="ETA" position="top" style={{ fontSize: '10px', fill: 'hsl(var(--primary))' }} />
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>
        
      <Separator />
      
      <div className="space-y-4">
        <h3 className="text-lg font-semibold font-headline">Route Details</h3>
        {data.routes.map((route: any, i: number) => (
          <Card key={i} className={route.name === data.recommendedRoute ? "border-primary" : ""}>
            <CardHeader>
                <CardTitle className="text-base">{route.name}</CardTitle>
                <CardDescription>
                    ETA: {route.etaMinutes} min — Risk: {route.riskIndex}/100
                </CardDescription>
            </CardHeader>
            <CardContent>
              <h4 className="font-semibold text-sm mb-2 flex items-center gap-2"><AlertTriangle className="h-4 w-4 text-amber-500" />Identified Issues</h4>
              <ul className="list-disc list-outside ml-5 space-y-1 text-sm text-muted-foreground">
                {route.issues.map((issue: string, j: number) => (
                  <li key={j}>{issue}</li>
                ))}
              </ul>
            </CardContent>
          </Card>
        ))}
      </div>

      <Button onClick={onReset} variant="outline" className="w-full">Start New Assessment</Button>
    </div>
  );
}
