"use server";

import { crossCarrierRiskVisibility } from "@/ai/flows/cross-carrier-risk-visibility";
import type { CrossCarrierRiskVisibilityInput } from "@/ai/flows/cross-carrier-risk-visibility";


export async function runCrossCarrierVisibility(data: CrossCarrierRiskVisibilityInput) {
  try {
    const result = await crossCarrierRiskVisibility(data);
    return result;
  } catch (error) {
    console.error("Cross-Carrier Visibility failed:", error);
    throw new Error("Failed to generate visibility report");
  }
}
