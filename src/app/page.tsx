
"use client";

import Link from "next/link";
import { useProfileStore } from "@/store/profile";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { aiFlows, getFlowBySlug } from "@/ai/flowRegistry";
import { ArrowRight } from "lucide-react";

export default function DashboardPage() {
  const { profile } = useProfileStore();

  const accessibleFlows = aiFlows.filter(f =>
    f.slug !== "/" &&
    f.slug !== "/profile" &&
    f.slug !== "/settings" &&
    f.slug !== "/admin/users" &&
    profile?.role && f.roles.includes(profile.role)
  );

  return (
    <div className="space-y-6">
      <div className="space-y-1">
        <h1 className="text-2xl font-bold tracking-tight font-headline">
          Welcome back, {profile?.name || "User"}!
        </h1>
        <p className="text-muted-foreground">
          Here are the AI-powered tools available to you. Select a flow to get started.
        </p>
      </div>
      <Separator />

      <div className="grid gap-4 md:grid-cols-2">
        {accessibleFlows.map((flow) => {
          const Icon = flow.icon;
          return (
            <Link href={flow.slug} key={flow.slug} className="group">
              <Card className="h-full transition-all group-hover:border-primary group-hover:shadow-md">
                <CardHeader className="flex flex-row items-center justify-between">
                  <div className="space-y-1">
                    <CardTitle className="text-lg font-headline">{flow.name}</CardTitle>
                    <CardDescription>{flow.description}</CardDescription>
                  </div>
                  <Icon className="h-8 w-8 text-muted-foreground transition-colors group-hover:text-primary" />
                </CardHeader>
                 <CardContent>
                    <div className="text-sm font-medium text-primary flex items-center gap-1">
                        Go to {flow.name}
                        <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-1" />
                    </div>
                </CardContent>
              </Card>
            </Link>
          );
        })}
      </div>
       {accessibleFlows.length === 0 && (
            <Card>
                <CardContent className="p-6 text-center text-muted-foreground">
                    <p>No flows are available for your role.</p>
                    <p className="text-xs mt-2">Please contact an administrator if you believe this is an error.</p>
                </CardContent>
            </Card>
       )}
    </div>
  );
}
