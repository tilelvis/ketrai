"use server";

import { proactiveEtaCalculation } from "@/ai/flows/proactive-eta-calculation";
import type { ProactiveEtaCalculationInput } from "@/ai/flows/proactive-eta-calculation";
import { auth } from "@/lib/firebase";
import { logEvent } from "@/lib/audit-log";
import { useProfileStore } from "@/store/profile";

export async function runProactiveEta(data: ProactiveEtaCalculationInput) {
  const user = auth.currentUser;
  if (!user) throw new Error("Not authenticated");

  // It's not ideal to get profile from client-side store on server, 
  // but for this architecture it's a pragmatic way to get the role.
  const { profile } = useProfileStore.getState();
  const actorRole = profile?.role || "unknown";

  try {
    // Log the request action
    await logEvent(
      "eta_requested",
      user.uid,
      actorRole,
      { id: `eta-${Date.now()}`, collection: "proactive-eta" },
      { details: `ETA calculation requested for route: ${data.route}` }
    );

    const result = await proactiveEtaCalculation(data);

    // Log the result action
    await logEvent(
      "eta_result_generated",
      "system", // The system generated the result
      "system",
      { id: `eta-${Date.now()}`, collection: "proactive-eta" },
      { 
        details: `Generated ETA with risk level: ${result.riskLevel}`,
        recalculatedEta: result.recalculatedEta,
        riskLevel: result.riskLevel
      }
    );

    return result;
  } catch (error) {
    console.error("Proactive ETA failed:", error);
     await logEvent(
      "eta_calculation_failed",
      user.uid,
      actorRole,
      { id: `eta-${Date.now()}`, collection: "proactive-eta" },
      { error: error instanceof Error ? error.message : "Unknown error" }
    );
    throw new Error("Failed to calculate ETA");
  }
}
