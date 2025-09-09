'use server';

import { smartDispatchRecommendation } from '@/ai/flows/smart-dispatch-recommendation';
import type { SmartDispatchRecommendationInput } from '@/ai/flows/smart-dispatch-recommendation';

export async function runSmartDispatch(data: SmartDispatchRecommendationInput) {
  try {
    const result = await smartDispatchRecommendation(data);
    return result;
  } catch (error) {
    console.error('Smart Dispatch failed:', error);
    throw new Error('Failed to calculate dispatch recommendation');
  }
}
