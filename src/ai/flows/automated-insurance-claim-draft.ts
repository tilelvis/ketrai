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
      "Damage photo, as a data URI that must include a MIME type and use Base64 encoding. Expected format: 'data:<mimetype>;base64,<encoded_data>'"
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
  prompt: `You are an expert insurance claims assistant for a logistics company.

Create a complete insurance claim draft using the following information. Your primary goal is to generate a structured, accurate, and professional claim that can be reviewed and submitted with minimal changes.

**Input Data:**
- **Package Tracking History:** {{{packageTrackingHistory}}}
- **Product Details & Value:** {{{productDetails}}}
- **Photo Evidence of Damage:** {{#if damagePhotoDataUri}}{{media url=damagePhotoDataUri}}{{else}}No photo evidence was provided.{{/if}}

**Your Task:**

1.  **Analyze the Data:** Carefully review all provided information to understand the context of the claim (e.g., when it was damaged, what the item is).
2.  **Generate Claim Text:** Write a clear, professional, and comprehensive claim description in natural language. This text should summarize the incident and justify the claim.
3.  **Generate Claim JSON:** Create a structured JSON object representing the claim. It is critical that this JSON is well-formed.

**Output Format:**
You must provide both a natural language text description and a JSON object.
`,
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
    return output;
  }
);
