'use server';

import { smartDispatchRecommendation } from '@/ai/flows/smart-dispatch-recommendation';
import type { SmartDispatchRecommendationInput } from '@/ai/flows/smart-dispatch-recommendation';
import { auth } from "@/lib/firebase";
import { logEvent } from "@/lib/audit-log";
import { useProfileStore } from "@/store/profile";

export async function runSmartDispatch(data: SmartDispatchRecommendationInput) {
  const user = auth.currentUser;
  if (!user) throw new Error("Not authenticated");

  const { profile } = useProfileStore.getState();
  const actorRole = profile?.role || "unknown";

  try {
    await logEvent(
      "dispatch_recommendation_requested",
      user.uid,
      actorRole,
      { id: `dispatch-req-${Date.now()}`, collection: "smart-dispatch" },
      { 
        details: `Recommendation requested from ${data.pickup} to ${data.dropoff}.`,
        pickup: data.pickup,
        dropoff: data.dropoff
      }
    );
    
    const result = await smartDispatchRecommendation(data);
    
    await logEvent(
      "dispatch_recommended",
      "system",
      "system",
      { id: `dispatch-rec-${Date.now()}`, collection: "smart-dispatch" },
      { 
        details: `Recommended route: ${result.recommendedRoute}`,
        recommendedRoute: result.recommendedRoute,
        explanation: result.explanation
      }
    );

    return result;
  } catch (error) {
    console.error('Smart Dispatch failed:', error);
    await logEvent(
      "dispatch_recommendation_failed",
      user.uid,
      actorRole,
      { id: `dispatch-req-${Date.now()}`, collection: "smart-dispatch" },
      { error: error instanceof Error ? error.message : "Unknown error" }
    );
    throw new Error('Failed to calculate dispatch recommendation');
  }
}
