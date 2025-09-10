"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { raiseClaim } from "@/lib/claims";
import { Button } from "@/components/ui/button";
import { Form, FormControl, FormDescription, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, FilePenLine } from "lucide-react";
import { toast } from "sonner";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../ui/select";
import { useProfileStore } from "@/store/profile";

const formSchema = z.object({
  type: z.string({ required_error: "Please select a claim type." }),
  description: z.string().min(10, "Description must be at least 10 characters."),
});

export function AutomatedClaimForm() {
  const [loading, setLoading] = useState(false);
  const { profile } = useProfileStore();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      type: "Item Damaged",
      description: "Package containing fragile glassware arrived with contents shattered. Tracking number: TKN12345.",
    },
  });

  async function onSubmit(values: z.infer<typeof formSchema>) {
    if (!profile) {
      toast.error("You must be logged in to submit a claim.");
      return;
    }
    setLoading(true);
    toast.info("Submitting claim request...");

    try {
      await raiseClaim(values);
      toast.success("Claim request submitted successfully!");
      form.reset(); // Clear the form for the next submission
    } catch (err) {
      const message = err instanceof Error ? err.message : "An unknown error occurred.";
      toast.error(`Failed to submit claim: ${message}`);
    }

    setLoading(false);
  }

  return (
    <div className="space-y-4">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
          <CardTitle className="text-lg font-medium font-headline">New Claim Request</CardTitle>
          <FilePenLine className="h-5 w-5 text-muted-foreground" />
        </CardHeader>
        <CardContent>
          <CardDescription className="mb-4">
            Provide the details of the incident. This will be sent to an admin for review.
          </CardDescription>
          <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
              <FormField
                control={form.control}
                name="type"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Claim Type</FormLabel>
                    <Select onValueChange={field.onChange} defaultValue={field.value}>
                      <FormControl>
                        <SelectTrigger>
                          <SelectValue placeholder="Select a type" />
                        </SelectTrigger>
                      </FormControl>
                      <SelectContent>
                        <SelectItem value="Item Damaged">Item Damaged</SelectItem>
                        <SelectItem value="Package Lost">Package Lost</SelectItem>
                        <SelectItem value="Incorrect Item">Incorrect Item</SelectItem>
                        <SelectItem value="Theft or Vandalism">Theft or Vandalism</SelectItem>
                         <SelectItem value="Other">Other</SelectItem>
                      </SelectContent>
                    </Select>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="description"
                render={({ field }) => (
                  <FormItem>
                    <FormLabel>Description</FormLabel>
                    <FormControl>
                      <Textarea placeholder="Describe the issue, including tracking numbers or order IDs..." {...field} rows={5} />
                    </FormControl>
                     <FormDescription>Please be as detailed as possible.</FormDescription>
                    <FormMessage />
                  </FormItem>
                )}
              />
              <Button type="submit" disabled={loading} className="w-full">
                {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                Submit Request
              </Button>
            </form>
          </Form>
        </CardContent>
      </Card>
    </div>
  );
}
