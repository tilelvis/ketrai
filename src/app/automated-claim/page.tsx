"use client";

import { useProfileStore } from "@/store/profile";
import ClaimsQueue from "./claims-queue";
import { AutomatedClaimForm } from "@/components/forms/automated-claim-form";
import ClaimsHistory from "../claims-history/page";
import { RoleGate } from "@/components/role-gate";

export default function AutomatedClaimPage() {
  const { profile } = useProfileStore();

  // Admins & Claims officers see the queue to process claims
  if (profile?.role === 'admin' || profile?.role === 'claims') {
    return <ClaimsQueue />;
  }
  
  // Managers see the full history
  if (profile?.role === 'manager') {
      return <ClaimsHistory />;
  }

  // Dispatchers & Support see the form to submit claims
  return (
    <RoleGate roles={['dispatcher', 'support']}>
      <AutomatedClaimForm />
    </RoleGate>
  );
}
