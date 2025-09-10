
"use client";

import { useState } from "react";
import { AutomatedClaimForm } from "@/components/forms/automated-claim-form";
import { Separator } from "@/components/ui/separator";
import { useProfileStore } from "@/store/profile";
import { RoleGate } from "@/components/role-gate";
import ClaimsHistoryPage from "../claims-history/page";
import ClaimsQueue from "./claims-queue";

export default function AutomatedClaimPage() {
  const { profile } = useProfileStore();

  // Admins & Claims Officers see the processing queue
  if (profile?.role === 'admin' || profile?.role === 'claims') {
    return <ClaimsQueue />;
  }
  
  // Other roles (dispatcher, support) see the submission flow and their own history
  return (
    <RoleGate roles={['dispatcher', 'support']}>
        <div className="space-y-6">
            <div className="space-y-1">
                <h1 className="text-2xl font-bold tracking-tight font-headline">Automated Claim Request</h1>
                <p className="text-muted-foreground">
                    Submit package details to request an insurance claim draft. An admin will review and process your request.
                </p>
            </div>
            <Separator />
            
            <AutomatedClaimForm />

            <Separator />

            {/* Show a simplified history for the user's own claims */}
            <div className="pt-6">
                 <ClaimsHistoryPage isPersonalView={true} />
            </div>
        </div>
    </RoleGate>
  );
}
