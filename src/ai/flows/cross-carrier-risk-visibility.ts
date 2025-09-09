'use server';

/**
 * @fileOverview This flow aggregates tracking data from multiple carriers, identifies at-risk shipments,
 * and generates a summarized report with critical alerts for proactive supply chain risk management.
 *
 * - crossCarrierRiskVisibility - A function that orchestrates the cross-carrier risk visibility process.
 * - CrossCarrierRiskVisibilityInput - The input type for the crossCarrierRiskVisibility function.
 * - CrossCarrierRiskVisibilityOutput - The return type for the crossCarrierRiskVisibility function,
 *   containing a dashboard-ready JSON report and alert notifications.
 */

import {ai} from '@/ai/genkit';
import {z} from 'genkit';

const CarrierInputSchema = z.object({
  carrier: z.string(),
  trackingNumber: z.string(),
  status: z.string(),
  location: z.string(),
  eta: z.string().optional(),
  riskFactors: z.array(z.string()).optional(),
});

const CrossCarrierRiskVisibilityInputSchema = z.object({
  shipments: z.array(CarrierInputSchema),
  alerts: z.array(z.string()).optional(), // e.g., ["Weather: Nairobi floods", "Port strike in Mombasa"]
});

export type CrossCarrierRiskVisibilityInput = z.infer<typeof CrossCarrierRiskVisibilityInputSchema>;

const CrossCarrierRiskVisibilityOutputSchema = z.object({
  summary: z.string().describe("A short, professional summary for a logistics manager."),
  groupedRisks: z.array(
    z.object({
      riskType: z.string().describe("The type of risk (e.g., Weather, Civil Unrest, Port Strike)."),
      shipments: z.array(z.string()).describe("Array of tracking numbers for affected shipments."),
      note: z.string().describe("A note explaining the risk."),
    })
  ),
});
export type CrossCarrierRiskVisibilityOutput = z.infer<typeof CrossCarrierRiskVisibilityOutputSchema>;

export async function crossCarrierRiskVisibility(
  input: CrossCarrierRiskVisibilityInput
): Promise<CrossCarrierRiskVisibilityOutput> {
  return crossCarrierRiskVisibilityFlow(input);
}

const prompt = ai.definePrompt({
  name: 'crossCarrierRiskVisibilityPrompt',
  input: {schema: CrossCarrierRiskVisibilityInputSchema},
  output: {schema: CrossCarrierRiskVisibilityOutputSchema},
  prompt: `You are a logistics visibility assistant.

You receive shipment data from multiple carriers:
{{{json shipments}}}

Additional alerts:
{{{json alerts}}}

Task:
1. Identify shipments at risk (cross-reference alerts + shipment risks).
2. Group affected shipments by risk type (e.g., Weather, Civil Unrest, Port Strike).
3. Write a short, professional summary for a logistics manager.
4. Output strictly following schema.`,
});

const crossCarrierRiskVisibilityFlow = ai.defineFlow(
  {
    name: 'crossCarrierRiskVisibilityFlow',
    inputSchema: CrossCarrierRiskVisibilityInputSchema,
    outputSchema: CrossCarrierRiskVisibilityOutputSchema,
  },
  async input => {
    const {output} = await prompt(input);
    if (!output) {
      throw new Error('No output from prompt');
    }
    return output;
  }
);
