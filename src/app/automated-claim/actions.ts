
"use server";

import { automatedInsuranceClaimDraft } from "@/ai/flows/automated-insurance-claim-draft";
import type { AutomatedInsuranceClaimDraftInput } from "@/ai/flows/automated-insurance-claim-draft";
import { db } from "@/lib/firebase";
import { collection, addDoc, serverTimestamp } from "firebase/firestore";
import { z } from "zod";

const ClaimRequestSchema = z.object({
  packageTrackingHistory: z.string(),
  productDetails: z.string(),
  claimReason: z.string(),
  damagePhotoDataUri: z.string().optional(),
});

type ClaimRequestInput = z.infer<typeof ClaimRequestSchema>;

export async function submitClaimRequest(data: ClaimRequestInput) {
  try {
    // This now runs on the server with admin privileges,
    // but we should still enforce logic that a user must be authenticated.
    // The security rules will handle the role-based read/update logic.
    await addDoc(collection(db, "claims"), {
      ...data,
      status: "pending_review",
      createdAt: serverTimestamp(),
    });
    return { success: true };
  } catch (error) {
    console.error("Failed to submit claim request:", error);
    const message = error instanceof Error ? error.message : "An unknown error occurred.";
    // Ensure we return a structured error that the client can handle
    return { success: false, error: `Failed to submit claim request: ${message}` };
  }
}


export async function runAutomatedClaim(data: AutomatedInsuranceClaimDraftInput) {
  try {
    const result = await automatedInsuranceClaimDraft(data);
    return { success: true, result };
  } catch (error) {
    console.error("Automated Claim failed:", error);
    const message = error instanceof Error ? error.message : "An unknown error occurred.";
    return { success: false, error: `Failed to generate insurance claim draft: ${message}` };
  }
}
