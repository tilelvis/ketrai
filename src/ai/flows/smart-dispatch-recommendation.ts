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
  optimalRoute: z.string().describe('Recommended optimal route (geo-coordinates / route ID).'),
  riskIndexScores: z
    .record(z.string(), z.number())
    .describe('Risk index score for all routes.'),
  explanation: z.string().describe('Explanation of why the route is optimal.'),
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
  prompt: `For each route, calculate a risk index considering time delays, safety risks, and disruptions using the following data:

Routes: {{routes}}
Theft Hotspot Data: {{theftHotspotData}}
Real-time Traffic Data: {{realTimeTrafficData}}
Local Event Data: {{localEventData}}

Recommend the optimal route and explain why in one sentence.

Return the optimal route (routeId), risk index scores (a map of routeId to risk score), and explanation.
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
