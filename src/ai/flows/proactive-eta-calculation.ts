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
  courierSystemUpdate: z
    .string()
    .describe('The update from the courier system, should be \'Out for Delivery\'.'),
  plannedRoute: z.string().describe('The planned route from Google Maps.'),
  travelTime: z.string().describe('The travel time from Google Maps.'),
  trafficData: z.string().describe('Real-time traffic data from traffic API.'),
  weatherData: z.string().describe('Weather forecast for the delivery area from weather API.'),
  scheduledTime: z.string().describe('The scheduled delivery time.'),
});
export type ProactiveEtaCalculationInput = z.infer<typeof ProactiveEtaCalculationInputSchema>;

const ProactiveEtaCalculationOutputSchema = z.object({
  updatedEta: z.string().describe('The updated estimated time of arrival (ETA).'),
  smsText: z.string().describe('Customer-friendly SMS notification text.'),
  developerInfo: z.object({
    prompt: z.string(),
    rawOutput: z.string(),
  }).optional(),
});
export type ProactiveEtaCalculationOutput = z.infer<typeof ProactiveEtaCalculationOutputSchema>;

export async function proactiveEtaCalculation(
  input: ProactiveEtaCalculationInput
): Promise<ProactiveEtaCalculationOutput> {
  return proactiveEtaCalculationFlow(input);
}

const proactiveEtaCalculationPrompt = ai.definePrompt({
  name: 'proactiveEtaCalculationPrompt',
  input: {schema: ProactiveEtaCalculationInputSchema},
  output: {schema: z.object({
    updatedEta: z.string().describe('The updated estimated time of arrival (ETA).'),
    smsText: z.string().describe('Customer-friendly SMS notification text.'),
  })},
  prompt: `Given the planned route: {{{plannedRoute}}}, current traffic: {{{trafficData}}}, and weather forecast: {{{weatherData}}}, analyze the risk of delay for a delivery scheduled at {{{scheduledTime}}}. Recalculate a realistic ETA. Draft a concise, friendly SMS notification for the customer. Updated ETA (timestamp) Customer-friendly SMS text`,
});

const proactiveEtaCalculationFlow = ai.defineFlow(
  {
    name: 'proactiveEtaCalculationFlow',
    inputSchema: ProactiveEtaCalculationInputSchema,
    outputSchema: ProactiveEtaCalculationOutputSchema,
  },
  async input => {
    const {output, history} = await proactiveEtaCalculationPrompt(input);
    
    // Extract the raw prompt and output from the history for debugging.
    const prompt = history?.[0]?.request?.messages?.[0]?.content[0].text || "Prompt not available";
    const rawOutput = history?.[0]?.response?.candidates?.[0]?.message?.content[0].text || "Output not available";
    
    return {
        ...output!,
        developerInfo: {
            prompt,
            rawOutput
        }
    };
  }
);
