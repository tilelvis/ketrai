"use client";

import { useState } from "react";
import { useForm, useFieldArray } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

import { smartDispatchRecommendation } from "@/ai/flows/smart-dispatch-recommendation";
import type { SmartDispatchRecommendationOutput } from "@/ai/flows/smart-dispatch-recommendation";

import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, Plus, Trash2 } from "lucide-react";
import { Separator } from "@/components/ui/separator";

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

export function SmartDispatchForm() {
  const [loading, setLoading] =useState(false);
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
    } catch (error) {
      console.error(error);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="space-y-4">
      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
          <div className="space-y-2">
            <FormLabel>Route Options</FormLabel>
            {fields.map((field, index) => (
              <Card key={field.id} className="p-4 space-y-2 relative bg-card">
                <FormField
                    control={form.control}
                    name={`routes.${index}.routeId`}
                    render={({ field }) => (
                        <FormItem><FormControl><Input className="h-8" placeholder="Route ID" {...field} /></FormControl></FormItem>
                    )}
                />
                 <FormField
                    control={form.control}
                    name={`routes.${index}.estimatedTime`}
                    render={({ field }) => (
                        <FormItem><FormControl><Input className="h-8" placeholder="Est. Time" {...field} /></FormControl></FormItem>
                    )}
                />
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
                <FormLabel>Other Risk Factors</FormLabel>
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

      {result && (
        <Card className="bg-secondary/50">
          <CardHeader>
            <CardTitle className="text-base font-headline">Assessment Result</CardTitle>
            <CardDescription>AI-generated route recommendation.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4 text-sm">
            <div>
              <p className="font-semibold">Optimal Route: <span className="font-normal bg-primary/20 text-primary-foreground p-1 rounded-md">{result.optimalRoute}</span></p>
              <p className="text-xs mt-1">{result.explanation}</p>
            </div>
            <Separator />
            <div>
                <p className="font-semibold mb-2">Risk Index Scores:</p>
                <div className="space-y-1">
                {Object.entries(result.riskIndexScores).map(([route, score]) => (
                    <div key={route} className="flex justify-between items-center">
                    <span>{route}</span>
                    <span className="font-mono font-semibold">{score.toFixed(2)}</span>
                    </div>
                ))}
                </div>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
