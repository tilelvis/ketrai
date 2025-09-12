"use server";

import { crossCarrierRiskVisibility } from "@/ai/flows/cross-carrier-risk-visibility";
import type { CrossCarrierRiskVisibilityInput } from "@/ai/flows/cross-carrier-risk-visibility";
import { auth } from "@/lib/firebase";
import { logEvent } from "@/lib/audit-log";
import { useProfileStore } from "@/store/profile";

export async function runCrossCarrierVisibility(data: CrossCarrierRiskVisibilityInput) {
  const user = auth.currentUser;
  if (!user) throw new Error("Not authenticated");

  const { profile } = useProfileStore.getState();
  const actorRole = profile?.role || "unknown";

  try {
     await logEvent(
      "risk_analysis_requested",
      user.uid,
      actorRole,
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
      user.uid,
      actorRole,
      { id: `risk-analysis-${Date.now()}`, collection: "risk-visibility" },
      { error: error instanceof Error ? error.message : "Unknown error" }
    );
    throw new Error("Failed to generate visibility report");
  }
}
