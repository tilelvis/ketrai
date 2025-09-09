"use client";

import { useState } from "react";
import { useForm, useFieldArray } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import {
    Bar,
    BarChart,
    CartesianGrid,
    XAxis,
    YAxis,
    Tooltip,
  } from "recharts"

import { smartDispatchRecommendation } from "@/ai/flows/smart-dispatch-recommendation";
import type { SmartDispatchRecommendationOutput } from "@/ai/flows/smart-dispatch-recommendation";

import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, Plus, Trash2, Lightbulb, CheckCircle } from "lucide-react";
import { Separator } from "@/components/ui/separator";
import { Progress } from "@/components/ui/progress";
import { ChartContainer, ChartTooltipContent } from "@/components/ui/chart"
import { Skeleton } from "@/components/ui/skeleton";


const routeSchema = z.object({
  routeId: z.string().min(1),
  geoCoordinates: z.string().min(1),
  estimatedTime: z.string().min(1),
});

const formSchema = z.object({
  routes: z.array(routeSchema).min(1),
  theftHotspotData: z.string().min(1),
  realTimeTrafficData: z.string().min(1),
  localEventData: z.string().min(1),
});

const steps = ["Input Route Data", "Analyze & Review", "Confirm Dispatch"];

export function SmartDispatchForm() {
  const [currentStep, setCurrentStep] = useState(0);
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<SmartDispatchRecommendationOutput | null>(null);

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      routes: [
        { routeId: "R1", geoCoordinates: "40.7128,-74.0060 to 40.7580,-73.9855", estimatedTime: "25 mins" },
        { routeId: "R2", geoCoordinates: "40.7128,-74.0060 to 40.7580,-73.9855 via tunnel", estimatedTime: "22 mins" },
      ],
      theftHotspotData: "Area around 42nd St is a known hotspot for package theft.",
      realTimeTrafficData: "Heavy traffic on FDR Drive.",
      localEventData: "Street fair on Broadway between 34th and 42nd.",
    },
  });

  const { fields, append, remove } = useFieldArray({
    control: form.control,
    name: "routes",
  });

  async function onSubmit(values: z.infer<typeof formSchema>) {
    setLoading(true);
    setResult(null);
    try {
      const output = await smartDispatchRecommendation(values);
      setResult(output);
      setCurrentStep(1);
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  }

  const handleConfirm = () => {
    setCurrentStep(2);
  }

  const handleReset = () => {
    setCurrentStep(0);
    setResult(null);
    // form.reset(); // This would clear default values too, maybe not desired.
  }
  
  const progressValue = ((currentStep + 1) / steps.length) * 100;
  
  const chartData = result 
    ? Object.entries(result.riskIndexScores).map(([route, score]) => ({
        name: route,
        score: score,
        fill: route === result.optimalRoute ? 'hsl(var(--primary))' : 'hsl(var(--muted))'
      }))
    : [];

  return (
    <div className="space-y-6">
      <div>
        <Progress value={progressValue} className="h-2 mb-2" />
        <p className="text-sm text-center text-muted-foreground">{steps[currentStep]}</p>
      </div>
      <Separator />

      {currentStep === 0 && (
        <Form {...form}>
          <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
            <div className="space-y-2">
              <FormLabel>Route Options</FormLabel>
              {fields.map((field, index) => (
                <Card key={field.id} className="p-4 space-y-2 relative bg-card">
                   <div className="flex flex-col space-y-2">
                    <FormField
                        control={form.control}
                        name={`routes.${index}.routeId`}
                        render={({ field }) => (
                            <FormItem><FormControl><Input className="h-8" placeholder="Route ID" {...field} /></FormControl><FormMessage /></FormItem>
                        )}
                    />
                    <FormField
                        control={form.control}
                        name={`routes.${index}.estimatedTime`}
                        render={({ field }) => (
                            <FormItem><FormControl><Input className="h-8" placeholder="Est. Time" {...field} /></FormControl><FormMessage /></FormItem>
                        )}
                    />
                   </div>
                  <Button type="button" variant="ghost" size="icon" className="absolute top-1 right-1 h-7 w-7" onClick={() => remove(index)}><Trash2 className="h-4 w-4"/></Button>
                </Card>
              ))}
              <Button type="button" variant="outline" size="sm" onClick={() => append({ routeId: `R${fields.length+1}`, geoCoordinates: "", estimatedTime: "" })}>
                  <Plus className="mr-2 h-4 w-4" /> Add Route
              </Button>
            </div>
            
            <FormField
              control={form.control}
              name="realTimeTrafficData"
              render={({ field }) => (
                <FormItem>
                  <FormLabel>Other Risk Factors (Traffic, Events, etc.)</FormLabel>
                  <FormControl>
                    <Textarea placeholder="Traffic, events, theft data..." {...field} />
                  </FormControl>
                  <FormMessage />
                </FormItem>
              )}
            />
            <Button type="submit" disabled={loading} className="w-full">
              {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
              Assess Routes
            </Button>
          </form>
        </Form>
      )}

      {loading && currentStep === 0 && (
         <div className="space-y-4">
            <div className="space-y-2 animate-pulse">
                <Skeleton className="h-4 w-1/4" />
                <Skeleton className="h-10 w-full" />
                <Skeleton className="h-10 w-full" />
            </div>
            <div className="space-y-2 animate-pulse">
                <Skeleton className="h-4 w-1/4" />
                <Skeleton className="h-20 w-full" />
            </div>
            <Skeleton className="h-10 w-full" />
        </div>
      )}

      {result && currentStep === 1 && (
        <div className="space-y-4">
          <Card className="bg-secondary/50">
            <CardHeader>
              <CardTitle className="text-base font-headline">Assessment Result</CardTitle>
              <CardDescription>AI-generated route recommendation and risk analysis.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4 text-sm">
                <div className="p-3 rounded-md bg-accent/50 border border-accent">
                    <p className="font-semibold flex items-center gap-2"><Lightbulb className="text-primary"/>AI Recommendation</p>
                    <p className="text-xs mt-1 text-accent-foreground">{result.explanation}</p>
                </div>

              <div>
                <p className="font-semibold">Optimal Route: <span className="font-normal bg-primary/20 text-primary-foreground p-1 rounded-md">{result.optimalRoute}</span></p>
              </div>
              <Separator />
              <div>
                  <p className="font-semibold mb-2">Risk Index Comparison (Lower is Better):</p>
                  <div className="h-[150px]">
                    <ChartContainer config={{}} className="h-full w-full">
                        <BarChart data={chartData} accessibilityLayer margin={{ top: 20, right: 20, left: -20, bottom: 0 }}>
                            <CartesianGrid vertical={false} />
                            <XAxis dataKey="name" tickLine={false} tickMargin={10} axisLine={false} />
                            <YAxis domain={[0, 100]} />
                            <Tooltip cursor={false} content={<ChartTooltipContent hideLabel />} />
                            <Bar dataKey="score" radius={8} />
                        </BarChart>
                    </ChartContainer>
                  </div>
              </div>
            </CardContent>
          </Card>
          <div className="flex gap-2">
            <Button variant="outline" onClick={() => setCurrentStep(0)} className="w-full">Back</Button>
            <Button onClick={handleConfirm} className="w-full">Confirm Dispatch</Button>
          </div>
        </div>
      )}

      {currentStep === 2 && (
        <Card>
            <CardHeader className="items-center text-center">
                <CheckCircle className="h-12 w-12 text-green-500 mx-auto" />
                <CardTitle>Dispatch Confirmed</CardTitle>
                <CardDescription>
                  The optimal route <span className="font-semibold bg-primary/20 text-primary-foreground p-1 rounded-md">{result?.optimalRoute}</span> has been dispatched.
                </CardDescription>
            </CardHeader>
            <CardContent>
                <Button onClick={handleReset} className="w-full mt-4">Start New Assessment</Button>
            </CardContent>
        </Card>
      )}
    </div>
  );
}
