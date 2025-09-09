'use server';

/**
 * @fileOverview A proactive ETA calculation AI agent.
 *
 * - proactiveEtaCalculation - A function that handles the ETA calculation process.
 * - ProactiveEtaCalculationInput - The input type for the proactiveEtaCalculation function.
 * - ProactiveEtaCalculationOutput - The return type for the proactiveEtaCalculation function.
 */

import {ai} from '@/ai/genkit';
import {z} from 'genkit';

const ProactiveEtaCalculationInputSchema = z.object({
  route: z.string().describe("The planned delivery route."),
  plannedEta: z.string().describe("The original planned ETA in ISO datetime format."),
  traffic: z.string().describe("Current real-time traffic conditions."),
  weather: z.string().describe("Current real-time weather conditions."),
});
export type ProactiveEtaCalculationInput = z.infer<typeof ProactiveEtaCalculationInputSchema>;

const ProactiveEtaCalculationOutputSchema = z.object({
  recalculatedEta: z.string().describe('The updated estimated time of arrival (ETA) in ISO datetime format.'),
  riskLevel: z.enum(["low", "medium", "high"]).describe("The assessed risk of delay."),
  customerMessage: z.string().describe('A customer-friendly SMS notification text.'),
  explanation: z.string().describe("A brief explanation for the dispatcher about why the ETA was changed."),
});
export type ProactiveEtaCalculationOutput = z.infer<typeof ProactiveEtaCalculationOutputSchema>;

export async function proactiveEtaCalculation(
  input: ProactiveEtaCalculationInput
): Promise<ProactiveEtaCalculationOutput> {
  return proactiveEtaCalculationFlow(input);
}

const prompt = ai.definePrompt({
  name: 'proactiveEtaCalculationPrompt',
  input: {schema: ProactiveEtaCalculationInputSchema},
  output: {schema: ProactiveEtaCalculationOutputSchema},
  prompt: `You are a last-mile delivery assistant.

Context:
- Route: {{{route}}}
- Planned ETA: {{{plannedEta}}}
- Traffic: {{{traffic}}}
- Weather: {{{weather}}}

Task:
1. Recalculate a realistic ETA given the conditions.
2. Assess delay risk (low, medium, high).
3. Draft a concise, friendly SMS notification for the customer.
4. Provide a short explanation for dispatchers.

Output in JSON matching the schema.`,
});

const proactiveEtaCalculationFlow = ai.defineFlow(
  {
    name: 'proactiveEtaCalculationFlow',
    inputSchema: ProactiveEtaCalculationInputSchema,
    outputSchema: ProactiveEtaCalculationOutputSchema,
  },
  async input => {
    const {output} = await prompt(input);
    return output!;
  }
);
