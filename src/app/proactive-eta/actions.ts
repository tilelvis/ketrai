"use server";

import { proactiveEtaCalculation } from "@/ai/flows/proactive-eta-calculation";
import type { ProactiveEtaCalculationInput } from "@/ai/flows/proactive-eta-calculation";

export async function runProactiveEta(data: ProactiveEtaCalculationInput) {
  try {
    const result = await proactiveEtaCalculation(data);
    return result;
  } catch (error) {
    console.error("Proactive ETA failed:", error);
    throw new Error("Failed to calculate ETA");
  }
}
