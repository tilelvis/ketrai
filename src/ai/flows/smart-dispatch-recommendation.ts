// src/ai/flows/smart-dispatch-recommendation.ts
'use server';

/**
 * @fileOverview Analyzes multiple routes for a new pickup request, considering factors like theft hotspots, real-time traffic, and local events, and recommends the optimal route with a risk index score.
 *
 * - smartDispatchRecommendation - A function that handles the route analysis and recommendation process.
 * - SmartDispatchRecommendationInput - The input type for the smartDispatchRecommendation function.
 * - SmartDispatchRecommendationOutput - The return type for the smartDispatchRecommendation function.
 */

import {ai} from '@/ai/genkit';
import {z} from 'genkit';

const RouteSchema = z.object({
  routeId: z.string().describe('Unique identifier for the route.'),
  geoCoordinates: z.string().describe('Geo-coordinates representing the route.'),
  estimatedTime: z.string().describe('Estimated travel time for the route.'),
});

const SmartDispatchRecommendationInputSchema = z.object({
  routes: z.array(RouteSchema).describe('Array of route options to analyze.'),
  theftHotspotData: z.string().describe('Data on known theft hotspots.'),
  realTimeTrafficData: z.string().describe('Real-time traffic and accident data.'),
  localEventData: z.string().describe('Data on local events that may cause disruptions.'),
});
export type SmartDispatchRecommendationInput = z.infer<
  typeof SmartDispatchRecommendationInputSchema
>;

const SmartDispatchRecommendationOutputSchema = z.object({
  optimalRoute: z.string().describe('The routeId of the recommended optimal route.'),
  riskIndexScores: z
    .record(z.string(), z.number())
    .describe('A risk index score for each route, from 0 to 100. The key should be the routeId.'),
  explanation: z.string().describe('A concise, one-sentence explanation of why the recommended route is optimal, focusing on the most critical factors.'),
});
export type SmartDispatchRecommendationOutput = z.infer<
  typeof SmartDispatchRecommendationOutputSchema
>;

export async function smartDispatchRecommendation(
  input: SmartDispatchRecommendationInput
): Promise<SmartDispatchRecommendationOutput> {
  return smartDispatchRecommendationFlow(input);
}

const prompt = ai.definePrompt({
  name: 'smartDispatchRecommendationPrompt',
  input: {schema: SmartDispatchRecommendationInputSchema},
  output: {schema: SmartDispatchRecommendationOutputSchema},
  prompt: `You are a logistics expert. Analyze the provided routes and risk data to recommend the safest and most efficient dispatch option.

Analyze each route based on the following data:
- Routes: {{{json routes}}}
- Theft Hotspot Data: {{{theftHotspotData}}}
- Real-time Traffic Data: {{{realTimeTrafficData}}}
- Local Event Data: {{{localEventData}}}

Your task:
1. For each route, calculate a risk index score from 0 (lowest risk) to 100 (highest risk). Consider all factors: travel time, traffic delays, safety risks (theft), and potential disruptions from local events.
2. Identify the route with the lowest overall risk index as the "optimalRoute".
3. Provide a brief, one-sentence "explanation" justifying your choice. Highlight the most significant advantage of the optimal route (e.g., "it avoids the major traffic jam on FDR Drive" or "it bypasses the high-theft zone around 42nd St").

Return a JSON object with the optimal route's ID, a key-value map of all route IDs to their risk scores, and the explanation.
`,
});

const smartDispatchRecommendationFlow = ai.defineFlow(
  {
    name: 'smartDispatchRecommendationFlow',
    inputSchema: SmartDispatchRecommendationInputSchema,
    outputSchema: SmartDispatchRecommendationOutputSchema,
  },
  async input => {
    const {output} = await prompt(input);
    return output!;
  }
);
