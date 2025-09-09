
"use client";

import { useEffect, useState } from "react";
import { useProfileStore } from "@/store/profile";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { doc, updateDoc } from "firebase/firestore";
import { db } from "@/lib/firebase";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { notify } from "@/lib/notify";
import { Loader2 } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";

const profileSchema = z.object({
  name: z.string().min(2, "Name must be at least 2 characters."),
  photoURL: z.string().url("Must be a valid URL.").optional().or(z.literal("")),
  theme: z.enum(["light", "dark", "system"]),
  role: z.enum(["dispatcher", "manager", "claims", "admin", "support"]),
});

type ProfileFormValues = z.infer<typeof profileSchema>;

export default function ProfilePage() {
  const { profile, setProfile } = useProfileStore();
  const [loading, setLoading] = useState(false);

  const form = useForm<ProfileFormValues>({
    resolver: zodResolver(profileSchema),
    defaultValues: {
      name: "",
      photoURL: "",
      theme: "system",
      role: "dispatcher",
    },
  });

  useEffect(() => {
    if (profile) {
      form.reset({
        name: profile.name,
        photoURL: profile.photoURL ?? "",
        theme: profile.theme,
        role: profile.role,
      });
    }
  }, [profile, form]);

  async function onSubmit(values: ProfileFormValues) {
    if (!profile) return;
    setLoading(true);
    notify.info("Updating profile...");

    try {
      const ref = doc(db, "users", profile.uid);
      await updateDoc(ref, values);

      setProfile({ ...profile, ...values });
      notify.success("Profile updated successfully!");
    } catch (err) {
      const message = err instanceof Error ? err.message : "An unknown error occurred.";
      notify.error(`Update failed: ${message}`);
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
            <CardContent className="space-y-6">
                <div className="flex items-center gap-4">
                    <Skeleton className="w-16 h-16 rounded-full" />
                    <div className="space-y-2 flex-1">
                        <Skeleton className="h-4 w-24" />
                        <Skeleton className="h-10 w-full" />
                    </div>
                </div>
                <div className="space-y-2">
                    <Skeleton className="h-4 w-16" />
                    <Skeleton className="h-10 w-full" />
                </div>
                 <div className="space-y-2">
                    <Skeleton className="h-4 w-16" />
                    <Skeleton className="h-10 w-full" />
                </div>
                <Skeleton className="h-10 w-32" />
            </CardContent>
        </Card>
      </div>
    )
  }

  return (
    <div className="space-y-6">
        <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight font-headline">Profile Settings</h1>
            <p className="text-muted-foreground">
                Manage your personal information and application preferences.
            </p>
        </div>
        <Separator />
        
        <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)}>
                <Card>
                    <CardHeader>
                        <CardTitle>Personal Information</CardTitle>
                        <CardDescription>Update your name and avatar.</CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-6">
                         <div className="flex items-center gap-4">
                            <Avatar className="w-16 h-16">
                                <AvatarImage src={form.watch("photoURL") ?? undefined} alt={form.watch("name")} />
                                <AvatarFallback>{form.watch("name")?.charAt(0).toUpperCase()}</AvatarFallback>
                            </Avatar>
                            <FormField
                                control={form.control}
                                name="photoURL"
                                render={({ field }) => (
                                    <FormItem className="flex-1">
                                    <FormLabel>Avatar URL</FormLabel>
                                    <FormControl>
                                        <Input placeholder="https://example.com/avatar.png" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                    </FormItem>
                                )}
                            />
                        </div>
                        <FormField
                            control={form.control}
                            name="name"
                            render={({ field }) => (
                                <FormItem>
                                <FormLabel>Name</FormLabel>
                                <FormControl>
                                    <Input placeholder="Your name" {...field} />
                                </FormControl>
                                <FormMessage />
                                </FormItem>
                            )}
                        />
                    </CardContent>
                </Card>

                 <Card className="mt-6">
                    <CardHeader>
                        <CardTitle>Preferences</CardTitle>
                        <CardDescription>Adjust your application settings.</CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-6">
                         <FormField
                            control={form.control}
                            name="theme"
                            render={({ field }) => (
                                <FormItem>
                                <FormLabel>Theme</FormLabel>
                                <Select onValueChange={field.onChange} value={field.value}>
                                    <FormControl>
                                    <SelectTrigger>
                                        <SelectValue placeholder="Select theme" />
                                    </SelectTrigger>
                                    </FormControl>
                                    <SelectContent>
                                        <SelectItem value="system">System</SelectItem>
                                        <SelectItem value="light">Light</SelectItem>
                                        <SelectItem value="dark">Dark</SelectItem>
                                    </SelectContent>
                                </Select>
                                <FormMessage />
                                </FormItem>
                            )}
                        />

                        {profile.role === "admin" && (
                            <FormField
                                control={form.control}
                                name="role"
                                render={({ field }) => (
                                <FormItem>
                                    <FormLabel>Role</FormLabel>
                                    <Select onValueChange={field.onChange} value={field.value}>
                                    <FormControl>
                                        <SelectTrigger>
                                        <SelectValue placeholder="Select role" />
                                        </SelectTrigger>
                                    </FormControl>
                                    <SelectContent>
                                        <SelectItem value="dispatcher">Dispatcher</SelectItem>
                                        <SelectItem value="manager">Manager</SelectItem>
                                        <SelectItem value="claims">Claims Officer</SelectItem>
                                        <SelectItem value="support">Support</SelectItem>
                                        <SelectItem value="admin">Admin</SelectItem>
                                    </SelectContent>
                                    </Select>
                                    <FormMessage />
                                </FormItem>
                                )}
                            />
                        )}
                    </CardContent>
                </Card>

                <Button type="submit" className="mt-6" disabled={loading}>
                    {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                    Save Changes
                </Button>
            </form>
        </Form>
    </div>
  );
}
