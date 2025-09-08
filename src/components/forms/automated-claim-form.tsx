"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

import { automatedInsuranceClaimDraft } from "@/ai/flows/automated-insurance-claim-draft";
import type { AutomatedInsuranceClaimDraftOutput } from "@/ai/flows/automated-insurance-claim-draft";

import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2 } from "lucide-react";
import { Separator } from "@/components/ui/separator";

const formSchema = z.object({
  packageTrackingHistory: z.string().min(1),
  productDetails: z.string().min(1),
  damagePhotoDataUri: z.string().optional(),
});

export function AutomatedClaimForm() {
  const [loading, setLoading] = useState(false);
  const [result, setResult] = useState<AutomatedInsuranceClaimDraftOutput | null>(null);

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      packageTrackingHistory: "2024-07-28: Picked up. 2024-07-29: In transit. 2024-07-30: Out for delivery. 2024-07-30: Reported as damaged.",
      productDetails: "Item: Vintage Ceramic Vase, Value: $150. SKU: VC-1024",
      damagePhotoDataUri: "", // In a real app, this would come from a file upload.
    },
  });
  
  async function onSubmit(values: z.infer<typeof formSchema>) {
    setLoading(true);
    setResult(null);

    const inputs = {...values};
    // Placeholder for image data URI if not provided, to simulate having one
    if (!inputs.damagePhotoDataUri) {
      // a 1x1 red pixel
      inputs.damagePhotoDataUri = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
    }

    try {
      const output = await automatedInsuranceClaimDraft(inputs);
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
          <FormField
            control={form.control}
            name="packageTrackingHistory"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Package Tracking History</FormLabel>
                <FormControl>
                  <Textarea placeholder="Enter tracking history..." {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
           <FormField
            control={form.control}
            name="productDetails"
            render={({ field }) => (
              <FormItem>
                <FormLabel>Product Details & Value</FormLabel>
                <FormControl>
                  <Input placeholder="Item, value, SKU..." {...field} />
                </FormControl>
                <FormMessage />
              </FormItem>
            )}
          />
          <Button type="submit" disabled={loading} className="w-full">
            {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            Draft Claim
          </Button>
        </form>
      </Form>
      {result && (
        <Card className="bg-secondary/50">
          <CardHeader>
            <CardTitle className="text-base font-headline">Claim Draft</CardTitle>
            <CardDescription>AI-generated insurance claim for review.</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4 text-sm">
            <div>
              <p className="font-semibold mb-2">Claim Text</p>
              <div className="rounded-md border bg-card p-3 whitespace-pre-wrap">{result.claimDraftText}</div>
            </div>
            <Separator />
            <div>
              <p className="font-semibold mb-2">Claim JSON</p>
              <pre className="rounded-md border bg-card p-3 text-xs overflow-x-auto">
                <code>{JSON.stringify(JSON.parse(result.claimDraftJson), null, 2)}</code>
              </pre>
            </div>
          </CardContent>
        </Card>
      )}
    </div>
  );
}
