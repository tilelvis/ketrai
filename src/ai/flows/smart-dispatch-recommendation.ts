'use server';

/**
 * @fileOverview Analyzes pickup and dropoff locations to recommend an optimal dispatch route.
 *
 * - smartDispatchRecommendation - A function that handles the route analysis and recommendation process.
 * - SmartDispatchRecommendationInput - The input type for the smartDispatchRecommendation function.
 * - SmartDispatchRecommendationOutput - The return type for the smartDispatchRecommendation function.
 */

import {ai} from '@/ai/genkit';
import {z} from 'genkit';

// Input schema: pickup and dropoff locations
const SmartDispatchRecommendationInputSchema = z.object({
  pickup: z.string().describe('The pickup location.'),
  dropoff: z.string().describe('The dropoff location.'),
});
export type SmartDispatchRecommendationInput = z.infer<
  typeof SmartDispatchRecommendationInputSchema
>;

// Output schema: recommended route and risk scores
const SmartDispatchRecommendationOutputSchema = z.object({
  recommendedRoute: z.string().describe('The name of the recommended route (e.g., "Route 1").'),
  explanation: z.string().describe('A brief explanation for the recommendation.'),
  routes: z.array(
    z.object({
      name: z.string().describe('The name of the route.'),
      riskIndex: z.number().describe('A risk score from 0 (safe) to 100 (risky).'),
      etaMinutes: z.number().describe('Estimated time of arrival in minutes.'),
      issues: z.array(z.string()).describe('A list of potential issues like traffic or theft hotspots.'),
    })
  ),
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
  prompt: `You are a logistics AI assistant.
You are given pickup and dropoff locations.

1. Propose 2-3 possible routes.
2. For each route, assign:
   - Estimated time (minutes)
   - Risk Index (0 = safe, 100 = very risky)
   - Issues (e.g., traffic, theft hotspots, closures)
3. Recommend the best route and explain why briefly.

Pickup: {{{pickup}}}
Dropoff: {{{dropoff}}}

Return structured JSON that matches the schema.
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
