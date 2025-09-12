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
     await logEvent(
      "risk_analysis_requested",
      actor.uid,
      actor.role,
      { id: `risk-analysis-${Date.now()}`, collection: "risk-visibility" },
      { details: `Risk analysis requested for ${data.shipments.length} shipments.` }
    );

    const result = await crossCarrierRiskVisibility(data);

    await logEvent(
      "risk_analysis_result",
      "system",
      "system",
      { id: `risk-analysis-${Date.now()}`, collection: "risk-visibility" },
      { 
        details: `Generated risk report with ${result.groupedRisks.length} grouped risks.`,
        summary: result.summary,
      }
    );

    return result;
  } catch (error) {
    console.error("Cross-Carrier Visibility failed:", error);
     await logEvent(
      "risk_analysis_failed",
      actor.uid,
      actor.role,
      { id: `risk-analysis-${Date.now()}`, collection: "risk-visibility" },
      { error: error instanceof Error ? error.message : "Unknown error" }
    );
    throw new Error("Failed to generate visibility report");
  }
}
