"use server";

import { proactiveEtaCalculation } from "@/ai/flows/proactive-eta-calculation";
import type { ProactiveEtaCalculationInput } from "@/ai/flows/proactive-eta-calculation";
import { logEvent } from "@/lib/audit-log";
import type { Profile } from "@/store/profile";

type Actor = {
    uid: string;
    role: Profile['role'];
}

export async function runProactiveEta(data: ProactiveEtaCalculationInput, actor: Actor) {
  if (!actor || !actor.uid) throw new Error("Not authenticated");

  try {
    await logEvent({
      action: "eta_requested",
      actorId: actor.uid,
      actorRole: actor.role,
      targetCollection: "proactive-eta",
      targetId: `eta-${Date.now()}`,
      context: { details: `ETA calculation requested for route: ${data.route}` }
    });

    const result = await proactiveEtaCalculation(data);

    await logEvent({
      action: "eta_result_generated",
      actorId: "system",
      actorRole: "system",
      targetCollection: "proactive-eta",
      targetId: `eta-${Date.now()}`,
      context: { 
        details: `Generated ETA with risk level: ${result.riskLevel}`,
        recalculatedEta: result.recalculatedEta,
        riskLevel: result.riskLevel
      }
    });

    return result;
  } catch (error) {
    console.error("Proactive ETA failed:", error);
    await logEvent({
      action: "eta_calculation_failed",
      actorId: actor.uid,
      actorRole: actor.role,
      targetCollection: "proactive-eta",
      targetId: `eta-${Date.now()}`,
      context: { error: error instanceof Error ? error.message : "Unknown error" }
    });
    throw new Error("Failed to calculate ETA");
  }
}
