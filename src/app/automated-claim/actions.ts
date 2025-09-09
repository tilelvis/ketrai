"use server";

import { automatedInsuranceClaimDraft } from "@/ai/flows/automated-insurance-claim-draft";
import type { AutomatedInsuranceClaimDraftInput } from "@/ai/flows/automated-insurance-claim-draft";

export async function runAutomatedClaim(data: AutomatedInsuranceClaimDraftInput) {
  try {
    const result = await automatedInsuranceClaimDraft(data);
    return result;
  } catch (error) {
    console.error("Automated Claim failed:", error);
    throw new Error("Failed to generate insurance claim draft");
  }
}
