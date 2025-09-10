"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

import { submitClaimRequest } from "@/app/automated-claim/actions";

import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, FilePenLine } from "lucide-react";
import { toast } from "sonner";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../ui/select";
import { useProfileStore } from "@/store/profile";


const formSchema = z.object({
  claimReason: z.string({ required_error: "Please select a reason for the claim."}),
  packageTrackingHistory: z.string().min(1, "Tracking history is required."),
  productDetails: z.string().min(1, "Product details are required."),
  damagePhotoDataUri: z.string().optional(),
});

export function AutomatedClaimForm() {
  const [loading, setLoading] = useState(false);
  const { profile } = useProfileStore();

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      claimReason: "Item Damaged in Transit",
      packageTrackingHistory: "2024-07-28: Departed from Nairobi warehouse.\n2024-07-29: In transit via A104 highway.\n2024-07-30: Arrived at Mombasa distribution center, item reported as damaged upon inspection.",
      productDetails: "Item: Box of Kenyan Tea, Value: KES 5,000, SKU: KT-EXP-01",
      damagePhotoDataUri: "",
    },
  });
  
  async function onSubmit(values: z.infer<typeof formSchema>) {
    if (!profile || !profile.email) {
        toast.error("You must be logged in to submit a claim.");
        return;
    }
    setLoading(true);
    toast.info("Submitting claim request...");
    
    const result = await submitClaimRequest({
        ...values,
        requester: {
            uid: profile.uid,
            name: profile.name,
            email: profile.email
        }
    });

    if (result.success) {
      toast.success("Claim request submitted successfully!");
      form.reset(); // Clear the form for the next submission
    } else {
      toast.error(result.error);
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
              Provide the package history, item details, and reason for the claim.
            </CardDescription>
            <Form {...form}>
              <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
                 <FormField
                  control={form.control}
                  name="claimReason"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Reason for Claim</FormLabel>
                        <Select onValueChange={field.onChange} defaultValue={field.value}>
                           <FormControl>
                                <SelectTrigger>
                                    <SelectValue placeholder="Select a reason" />
                                </SelectTrigger>
                           </FormControl>
                            <SelectContent>
                                <SelectItem value="Item Damaged in Transit">Item Damaged in Transit</SelectItem>
                                <SelectItem value="Package Lost">Package Lost</SelectItem>
                                <SelectItem value="Incorrect Item Delivered">Incorrect Item Delivered</SelectItem>
                                <SelectItem value="Theft or Vandalism">Theft or Vandalism</SelectItem>
                            </SelectContent>
                        </Select>
                      <FormMessage />
                    </FormItem>
                  )}
                />
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
                  Submit Request
                </Button>
              </form>
            </Form>
        </CardContent>
      </Card>
    </div>
  );
}