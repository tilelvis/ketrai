"use server";

import { crossCarrierRiskVisibility } from "@/ai/flows/cross-carrier-risk-visibility";
import type { CrossCarrierRiskVisibilityInput } from "@/ai/flows/cross-carrier-risk-visibility";
import { logEvent } from "@/lib/audit-log";
import type { Profile } from "@/store/profile";

type Actor = {
    uid: string;
    role: Profile['role'];
}

export async function runCrossCarrierVisibility(data: CrossCarrierRiskVisibilityInput, actor: Actor) {
  if (!actor || !actor.uid) throw new Error("Not authenticated");

  try {
     await logEvent({
      action: "risk_analysis_requested",
      actorId: actor.uid,
      actorRole: actor.role,
      targetCollection: "risk-visibility",
      targetId: `risk-analysis-${Date.now()}`,
      context: { details: `Risk analysis requested for ${data.shipments.length} shipments.` }
    });

    const result = await crossCarrierRiskVisibility(data);

    await logEvent({
      action: "risk_analysis_result",
      actorId: "system",
      actorRole: "system",
      targetCollection: "risk-visibility",
      targetId: `risk-analysis-${Date.now()}`,
      context: { 
        details: `Generated risk report with ${result.groupedRisks.length} grouped risks.`,
        summary: result.summary,
      }
    });

    return result;
  } catch (error) {
    console.error("Cross-Carrier Visibility failed:", error);
     await logEvent({
      action: "risk_analysis_failed",
      actorId: actor.uid,
      actorRole: actor.role,
      targetCollection: "risk-visibility",
      targetId: `risk-analysis-${Date.now()}`,
      context: { error: error instanceof Error ? error.message : "Unknown error" }
    });
    throw new Error("Failed to generate visibility report");
  }
}
