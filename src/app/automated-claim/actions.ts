"use server";

import { automatedInsuranceClaimDraft } from "@/ai/flows/automated-insurance-claim-draft";
import type { AutomatedInsuranceClaimDraftInput } from "@/ai/flows/automated-insurance-claim-draft";
import { db, doc, serverTimestamp, writeBatch } from "@/lib/firebase";
import { logEvent } from "@/lib/audit-log";
import type { Profile } from "@/store/profile";


export async function runAutomatedClaim(input: AutomatedInsuranceClaimDraftInput, actor: { uid: string; role: Profile['role'] }) {
  try {
    const result = await automatedInsuranceClaimDraft(input);

    const batch = writeBatch(db);
    const claimRef = doc(db, "claims", input.claimId);
    
    batch.update(claimRef, {
        status: "inReview", 
        updatedAt: serverTimestamp(),
        adminId: actor.uid,
    });
    
    await batch.commit();

    await logEvent({
        action: "claim_drafted_by_ai",
        actorId: actor.uid,
        actorRole: actor.role,
        targetCollection: "claims",
        targetId: input.claimId,
        context: { details: `AI draft generated for claim.` }
    });

    return { success: true, result };
  } catch (error) {
    console.error("Automated Claim failed:", error);
    const message = error instanceof Error ? error.message : "An unknown error occurred.";
    return { success: false, error: `Failed to generate insurance claim draft: ${message}` };
  }
}
