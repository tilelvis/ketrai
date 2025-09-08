'use server';

/**
 * @fileOverview This file defines the Automated Insurance Claim Draft flow.
 *
 * - automatedInsuranceClaimDraft - A function that orchestrates the claim drafting process.
 * - AutomatedInsuranceClaimDraftInput - The input type for the automatedInsuranceClaimDraft function.
 * - AutomatedInsuranceClaimDraftOutput - The return type for the automatedInsuranceClaimDraft function.
 */

import {ai} from '@/ai/genkit';
import {z} from 'genkit';

const AutomatedInsuranceClaimDraftInputSchema = z.object({
  packageTrackingHistory: z.string().describe('Package tracking history from courier API.'),
  damagePhotoDataUri: z
    .string()
    .describe(
      "Damage photo, as a data URI that must include a MIME type and use Base64 encoding. Expected format: 'data:<mimetype>;base64,<encoded_data>'."
    )
    .optional(),
  productDetails: z.string().describe('Product details and value from e-commerce platform API.'),
});
export type AutomatedInsuranceClaimDraftInput = z.infer<
  typeof AutomatedInsuranceClaimDraftInputSchema
>;

const AutomatedInsuranceClaimDraftOutputSchema = z.object({
  claimDraftJson: z.string().describe('Draft insurance claim in JSON format.'),
  claimDraftText: z.string().describe('Draft insurance claim in natural language format.'),
});
export type AutomatedInsuranceClaimDraftOutput = z.infer<
  typeof AutomatedInsuranceClaimDraftOutputSchema
>;

export async function automatedInsuranceClaimDraft(
  input: AutomatedInsuranceClaimDraftInput
): Promise<AutomatedInsuranceClaimDraftOutput> {
  return automatedInsuranceClaimDraftFlow(input);
}

const prompt = ai.definePrompt({
  name: 'automatedInsuranceClaimDraftPrompt',
  input: {schema: AutomatedInsuranceClaimDraftInputSchema},
  output: {schema: AutomatedInsuranceClaimDraftOutputSchema},
  prompt: `Create a complete insurance claim draft using the following data:

* Tracking history: {{{packageTrackingHistory}}}
* Item description & value: {{{productDetails}}}
* Evidence (photos, notes): {{#if damagePhotoDataUri}}{{media url=damagePhotoDataUri}}{{else}}No photo provided{{/if}}

Format the claim in clear, structured text and JSON. The JSON output should be enclosed in a \`\`\`json... \`\`\` block.`,
});

const automatedInsuranceClaimDraftFlow = ai.defineFlow(
  {
    name: 'automatedInsuranceClaimDraftFlow',
    inputSchema: AutomatedInsuranceClaimDraftInputSchema,
    outputSchema: AutomatedInsuranceClaimDraftOutputSchema,
  },
  async input => {
    const {output} = await prompt(input);
    if (!output) {
      throw new Error('No output from prompt');
    }

    // Extract JSON from the markdown block
    const jsonMatch = output.claimDraftJson.match(/```json\n([\s\S]*)\n```/);
    const claimDraftJson = jsonMatch ? jsonMatch[1] : output.claimDraftJson;

    return {
      ...output,
      claimDraftJson,
    };
  }
);
