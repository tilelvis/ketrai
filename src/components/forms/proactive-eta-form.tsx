"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

import { proactiveEtaCalculation } from "@/ai/flows/proactive-eta-calculation";
import type { ProactiveEtaCalculationOutput } from "@/ai/flows/proactive-eta-calculation";

import { useDeveloper } from "@/hooks/use-developer";
import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, Code } from "lucide-react";
import { useToast } from "@/hooks/use-toast";
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "@/components/ui/accordion";
import { Separator } from "../ui/separator";

const formSchema = z.object({
  courierSystemUpdate: z.string().min(1, "Required."),
  plannedRoute: z.string().min(1, "Required."),
  travelTime: z.string().min(1, "Required."),
  trafficData: z.string().min(1, "Required."),
  weatherData: z.string().min(1, "Required."),
  scheduledTime: z.string().min(1, "Required."),
});

export function ProactiveEtaForm() {
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<ProactiveEtaCalculationOutput | null>(null);
  const { toast } = useToast();
  const { isDeveloperMode } = useDeveloper();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      courierSystemUpdate: "Out for Delivery",
      plannedRoute: "Route from warehouse A to customer address at 123 Main St.",
      travelTime: "35 minutes",
      trafficData: "Moderate congestion on I-5, accident near exit 4.",
      weatherData: "Light rain, 15 mph winds.",
      scheduledTime: "3:00 PM",
    },
  });

  async function onSubmit(values: z.infer<typeof formSchema>) {
    setLoading(true);
    setResult(null);
    try {
      const output = await proactiveEtaCalculation(values);
      setResult(output);
      toast({
        title: "ETA Calculated",
        description: "A new ETA has been determined and a notification drafted.",
      });
    } catch (error) {
      console.error(error);
      toast({
        variant: "destructive",
        title: "Error",
        description: "Failed to calculate ETA. Please try again.",
      });
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="space-y-4">
      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
          <FormField
            control={form.control}
            name="trafficData"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Real-time Traffic Data</FormLabel>
                <FormControl>
                  <Input placeholder="e.g., Moderate congestion..." {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <FormField
            control={form.control}
            name="weatherData"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Weather Data</FormLabel>
                <FormControl>
                  <Input placeholder="e.g., Light rain..." {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <Button type="submit" disabled={loading} className="w-full">
            {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            Calculate ETA
          </Button>
        </form>
      </Form>
      {result && (
        <Card className="bg-secondary/50">
          <CardHeader>
            <CardTitle className="text-base font-headline">Calculation Result</CardTitle>
            <CardDescription>AI-generated ETA and customer notification.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-2 text-sm">
            <p><span className="font-semibold">Updated ETA:</span> {result.updatedEta}</p>
            <p className="font-semibold">SMS to Customer:</p>
            <p className="rounded-md border bg-card p-3">{result.smsText}</p>
          </CardContent>

          {isDeveloperMode && result.developerInfo && (
             <>
              <Separator className="my-4 bg-muted-foreground/20" />
              <Accordion type="single" collapsible className="w-full">
                <AccordionItem value="item-1">
                  <AccordionTrigger className="text-sm px-6 pt-0 font-semibold hover:no-underline">
                    <div className="flex items-center gap-2">
                        <Code className="h-4 w-4"/> Developer Info
                    </div>
                  </AccordionTrigger>
                  <AccordionContent className="px-6">
                    <div className="space-y-4 text-xs">
                        <div>
                            <p className="font-semibold mb-2">Raw Prompt</p>
                            <pre className="rounded-md border bg-card p-3 whitespace-pre-wrap">{result.developerInfo.prompt}</pre>
                        </div>
                        <div>
                            <p className="font-semibold mb-2">Raw Output</p>
                            <pre className="rounded-md border bg-card p-3 whitespace-pre-wrap">{result.developerInfo.rawOutput}</pre>
                        </div>
                    </div>
                  </AccordionContent>
                </AccordionItem>
              </Accordion>
             </>
          )}
        </Card>
      )}
    </div>
  );
}
