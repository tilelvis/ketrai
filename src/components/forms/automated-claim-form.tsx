
"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

import { runAutomatedClaim } from "@/app/automated-claim/actions";
import type { AutomatedInsuranceClaimDraftOutput } from "@/ai/flows/automated-insurance-claim-draft";
import { useDeveloper } from "@/hooks/use-developer";

import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, FilePenLine } from "lucide-react";
import { Accordion, AccordionContent, AccordionItem, AccordionTrigger } from "../ui/accordion";
import { useToast } from "@/hooks/use-toast";


const formSchema = z.object({
  packageTrackingHistory: z.string().min(1, "Tracking history is required."),
  productDetails: z.string().min(1, "Product details are required."),
  damagePhotoDataUri: z.string().optional(),
});

export function AutomatedClaimForm({
  onComplete,
}: {
  onComplete: (result: AutomatedInsuranceClaimDraftOutput) => void;
}) {
  const [loading, setLoading] = useState(false);
  const { isDeveloperMode } = useDeveloper();
  const { toast } = useToast();
  const [devInfo, setDevInfo] = useState<any>(null);

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      packageTrackingHistory: "2024-07-28: Picked up by carrier.\n2024-07-29: In transit to destination facility.\n2024-07-30: Arrived at local hub, noted as damaged during sort.",
      productDetails: "Item: Hand-painted ceramic vase, Value: $150, SKU: VC-1024",
      damagePhotoDataUri: "",
    },
  });
  
  async function onSubmit(values: z.infer<typeof formSchema>) {
    setLoading(true);
    setDevInfo(null);
    
    // In a real app, you would handle file uploads and convert the image to a Base64 data URI.
    // For this demo, we'll use a placeholder if no data is provided.
    const inputs = {...values};
    if (!inputs.damagePhotoDataUri) {
      // a 1x1 red pixel as a placeholder
      inputs.damagePhotoDataUri = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
    }

    try {
      const output = await runAutomatedClaim(inputs);
      onComplete(output);
      if (isDeveloperMode) {
        setDevInfo({ inputs, output });
      }
    } catch (error) {
       toast({
        variant: "destructive",
        title: "Claim Generation Failed",
        description: error instanceof Error ? error.message : "An unknown error occurred.",
      });
      console.error(error);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="space-y-4">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-medium font-headline">Claim Input Details</CardTitle>
            <FilePenLine className="h-5 w-5 text-muted-foreground" />
        </CardHeader>
        <CardContent>
            <CardDescription className="mb-4">
              Provide the package history, item details, and any evidence to generate a claim draft.
            </CardDescription>
            <Form {...form}>
              <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
                <FormField
                  control={form.control}
                  name="packageTrackingHistory"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Package Tracking History</FormLabel>
                      <FormControl>
                        <Textarea placeholder="Enter tracking history..." {...field} rows={4} />
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
                {/* We could add a file upload here for the damagePhotoDataUri */}
                <Button type="submit" disabled={loading} className="w-full">
                  {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                  Draft Claim
                </Button>
              </form>
            </Form>
        </CardContent>
      </Card>

      {isDeveloperMode && devInfo && (
        <Card className="bg-secondary/30">
           <Accordion type="single" collapsible>
            <AccordionItem value="item-1" className="border-none">
              <AccordionTrigger className="px-6 py-4 text-sm font-semibold">Developer Info</AccordionTrigger>
              <AccordionContent className="px-6">
                <div className="space-y-4 text-xs">
                  <div>
                    <h4 className="font-semibold mb-2">AI Inputs</h4>
                    <pre className="rounded-md border bg-card p-3 overflow-x-auto">
                      <code>{JSON.stringify(devInfo.inputs, null, 2)}</code>
                    </pre>
                  </div>
                  <div>
                    <h4 className="font-semibold mb-2">AI Output</h4>
                    <pre className="rounded-md border bg-card p-3 overflow-x-auto">
                      <code>{JSON.stringify(devInfo.output, null, 2)}</code>
                    </pre>
                  </div>
                </div>
              </AccordionContent>
            </AccordionItem>
          </Accordion>
        </Card>
      )}
    </div>
  );
}
