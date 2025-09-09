
"use client";

import { useProfileStore } from "@/store/profile";
import type { Profile } from "@/store/profile";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { TriangleAlert } from "lucide-react";

export function RoleGate({
  roles,
  children,
}: {
  roles: Array<Profile['role']>;
  children: React.ReactNode;
}) {
  const { profile } = useProfileStore();

  if (!profile || !roles.includes(profile.role)) {
    return (
        <Card className="border-amber-500/30 bg-amber-500/10">
            <CardHeader>
                <CardTitle className="flex items-center gap-2 text-amber-900 dark:text-amber-300">
                    <TriangleAlert className="h-5 w-5"/>
                    Access Denied
                </CardTitle>
            </CardHeader>
            <CardContent>
                <p className="text-sm text-amber-800 dark:text-amber-400">
                    You do not have the required permissions to view this page. 
                    Please contact your administrator if you believe this is an error.
                </p>
            </CardContent>
        </Card>
    );
  }

  return <>{children}</>;
}
