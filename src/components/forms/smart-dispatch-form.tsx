
"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

import { runSmartDispatch } from "@/app/smart-dispatch/actions";
import type { SmartDispatchRecommendationOutput } from "@/ai/flows/smart-dispatch-recommendation";

import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, Route } from "lucide-react";
import { toast } from "sonner";

const formSchema = z.object({
  pickup: z.string().min(1, "Pickup location is required."),
  dropoff: z.string().min(1, "Dropoff location is required."),
});

export function SmartDispatchForm({
  onComplete,
}: {
  onComplete: (result: SmartDispatchRecommendationOutput) => void;
}) {
  const [loading, setLoading] = useState(false);

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      pickup: "475 10th Ave, New York, NY 10018",
      dropoff: "1-3 E 109th St, New York, NY 10029",
    },
  });

  async function handleSubmit(values: z.infer<typeof formSchema>) {
    setLoading(true);
    toast.info("Finding the best route...");
    try {
        const result = await runSmartDispatch(values);
        onComplete(result);
        toast.success("Optimal route found!");
    } catch (error) {
        toast.error(error instanceof Error ? error.message : "An unknown error occurred.");
    } finally {
        setLoading(false);
    }
  }

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-lg font-medium font-headline">Smart Dispatch Assessor</CardTitle>
        <Route className="h-5 w-5 text-muted-foreground" />
      </CardHeader>
      <CardContent>
        <CardDescription className="mb-4">
          Provide pickup and dropoff locations to get an AI-powered risk assessment.
        </CardDescription>
        <Form {...form}>
            <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
                <FormField
                    control={form.control}
                    name="pickup"
                    render={({ field }) => (
                        <FormItem>
                        <FormLabel>Pickup Location</FormLabel>
                        <FormControl>
                            <Input placeholder="Enter pickup location..." {...field} />
                        </FormControl>
                        <FormMessage />
                        </FormItem>
                    )}
                />
                <FormField
                    control={form.control}
                    name="dropoff"
                    render={({ field }) => (
                        <FormItem>
                        <FormLabel>Dropoff Location</FormLabel>
                        <FormControl>
                            <Input placeholder="Enter dropoff location..." {...field} />
                        </FormControl>
                        <FormMessage />
                        </FormItem>
                    )}
                />
                <Button type="submit" disabled={loading} className="w-full">
                    {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                    {loading ? "Calculating..." : "Find Best Route"}
                </Button>
            </form>
        </Form>
      </CardContent>
    </Card>
  );
}
