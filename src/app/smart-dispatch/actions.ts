'use server';

import { smartDispatchRecommendation } from '@/ai/flows/smart-dispatch-recommendation';
import type { SmartDispatchRecommendationInput } from '@/ai/flows/smart-dispatch-recommendation';
import { logEvent } from "@/lib/audit-log";
import type { Profile } from "@/store/profile";

type Actor = {
    uid: string;
    role: Profile['role'];
}

export async function runSmartDispatch(data: SmartDispatchRecommendationInput, actor: Actor) {
  if (!actor || !actor.uid) throw new Error("Not authenticated");

  try {
    await logEvent({
      action: "dispatch_recommendation_requested",
      actorId: actor.uid,
      actorRole: actor.role,
      targetCollection: "smart-dispatch",
      targetId: `dispatch-req-${Date.now()}`,
      context: { 
        details: `Recommendation requested from ${data.pickup} to ${data.dropoff}.`,
        pickup: data.pickup,
        dropoff: data.dropoff
      }
    });
    
    const result = await smartDispatchRecommendation(data);
    
    await logEvent({
      action: "dispatch_recommended",
      actorId: "system",
      actorRole: "system",
      targetCollection: "smart-dispatch",
      targetId: `dispatch-rec-${Date.now()}`,
      context: { 
        details: `Recommended route: ${result.recommendedRoute}`,
        recommendedRoute: result.recommendedRoute,
        explanation: result.explanation
      }
    });

    return result;
  } catch (error) {
    console.error('Smart Dispatch failed:', error);
    await logEvent({
      action: "dispatch_recommendation_failed",
      actorId: actor.uid,
      actorRole: actor.role,
      targetCollection: "smart-dispatch",
      targetId: `dispatch-req-${Date.now()}`,
      context: { error: error instanceof Error ? error.message : "Unknown error" }
    });
    throw new Error('Failed to calculate dispatch recommendation');
  }
}
