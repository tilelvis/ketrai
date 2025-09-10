"use client";

import { useEffect, useState } from "react";
import { useProfileStore } from "@/store/profile";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { doc, updateDoc } from "firebase/firestore";
import { db } from "@/lib/firebase";
import { Button } from "@/components/ui/button";
import { Switch } from "@/components/ui/switch";
import { Form, FormControl, FormDescription, FormField, FormItem, FormLabel } from "@/components/ui/form";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { toast } from "sonner";
import { Loader2, BellRing } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";

const settingsSchema = z.object({
  notifications: z.object({
    inApp: z.boolean(),
    email: z.boolean(),
  }),
});

type SettingsFormValues = z.infer<typeof settingsSchema>;

export default function SettingsPage() {
  const { profile, setProfile } = useProfileStore();
  const [loading, setLoading] = useState(false);

  const form = useForm<SettingsFormValues>({
    resolver: zodResolver(settingsSchema),
    defaultValues: {
      notifications: {
        inApp: true,
        email: false,
      },
    },
  });

  useEffect(() => {
    if (profile?.preferences) {
      form.reset({
        notifications: profile.preferences.notifications,
      });
    }
  }, [profile, form]);

  async function onSubmit(values: SettingsFormValues) {
    if (!profile) return;
    setLoading(true);
    toast.info("Saving your preferences...");

    try {
      const userRef = doc(db, "users", profile.uid);
      await updateDoc(userRef, {
        "preferences.notifications": values.notifications,
      });

      // Update the profile in the global store
      const updatedProfile = {
        ...profile,
        preferences: {
            ...profile.preferences,
            notifications: values.notifications
        }
      };
      setProfile(updatedProfile as any); // Update with new preferences

      toast.success("Preferences saved successfully!");
    } catch (err) {
      const message = err instanceof Error ? err.message : "An unknown error occurred.";
      toast.error(`Failed to save preferences: ${message}`);
    } finally {
      setLoading(false);
    }
  }
  
  if (!profile) {
      return (
         <div className="space-y-6">
            <div className="space-y-1">
                <Skeleton className="h-8 w-48" />
                <Skeleton className="h-4 w-72" />
            </div>
            <Separator />
            <Card>
                <CardHeader>
                    <Skeleton className="h-6 w-32" />
                    <Skeleton className="h-4 w-64" />
                </CardHeader>
                <CardContent className="space-y-6 pt-6">
                    <Skeleton className="h-10 w-full" />
                    <Skeleton className="h-10 w-full" />
                    <Skeleton className="h-10 w-32 mt-4" />
                </CardContent>
            </Card>
         </div>
      )
  }

  return (
    <div className="space-y-6">
      <div className="space-y-1">
        <h1 className="text-2xl font-bold tracking-tight font-headline">Settings</h1>
        <p className="text-muted-foreground">Manage your account and notification preferences.</p>
      </div>
      <Separator />

      <Form {...form}>
        <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-8">
          <Card>
            <CardHeader>
              <CardTitle className="flex items-center gap-2">
                <BellRing className="h-5 w-5 text-primary" />
                Notifications
              </CardTitle>
              <CardDescription>
                Choose how you want to be notified about important events.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <FormField
                control={form.control}
                name="notifications.inApp"
                render={({ field }) => (
                  <FormItem className="flex flex-row items-center justify-between rounded-lg border p-4">
                    <div className="space-y-0.5">
                      <FormLabel className="text-base">In-App Notifications</FormLabel>
                      <FormDescription>
                        Receive real-time alerts in the top-right corner of the app.
                      </FormDescription>
                    </div>
                    <FormControl>
                      <Switch checked={field.value} onCheckedChange={field.onChange} />
                    </FormControl>
                  </FormItem>
                )}
              />
              <FormField
                control={form.control}
                name="notifications.email"
                render={({ field }) => (
                  <FormItem className="flex flex-row items-center justify-between rounded-lg border p-4">
                    <div className="space-y-0.5">
                      <FormLabel className="text-base">Email Notifications</FormLabel>
                      <FormDescription>
                        Receive email summaries for critical alerts. (Coming soon)
                      </FormDescription>
                    </div>
                    <FormControl>
                       <Switch checked={field.value} onCheckedChange={field.onChange} disabled />
                    </FormControl>
                  </FormItem>
                )}
              />
            </CardContent>
          </Card>

          <Button type="submit" disabled={loading}>
            {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
            Save Preferences
          </Button>
        </form>
      </Form>
    </div>
  );
}
