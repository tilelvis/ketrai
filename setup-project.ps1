
# This script creates the directory structure and all necessary files for the ketrai project.
# Run this script from an empty directory using PowerShell.

Write-Host "Creating project directories..."

# Define all directory paths
$directories = @(
    ".github/workflows",
    "src/ai/flows",
    "src/app/admin/users",
    "src/app/automated-claim",
    "src/app/claims-history",
    "src/app/invite/[token]",
    "src/app/login",
    "src/app/proactive-eta",
    "src/app/profile",
    "src/app/risk-visibility",
    "src/app/settings",
    "src/app/smart-dispatch",
    "src/app/user-management",
    "src/components/forms",
    "src/components/results",
    "src/components/ui",
    "src/hooks",
    "src/lib",
    "src/store",
    "src/types"
)

# Create directories
foreach ($dir in $directories) {
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

Write-Host "Creating project files..."

# Root files
@'
'@ | Out-File -FilePath ".env" -Encoding utf8

@'
# Settings to manage and configure a Firebase App Hosting backend.
# https://firebase.google.com/docs/app-hosting/configure

runConfig:
  # Increase this value if you'd like to automatically spin up
  # more instances in response to increased traffic.
  maxInstances: 1
'@ | Out-File -FilePath "apphosting.yaml" -Encoding utf8

@'
{
  "$schema": "https://ui.shadcn.com/schema.json",
  "style": "default",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "tailwind.config.ts",
    "css": "src/app/globals.css",
    "baseColor": "neutral",
    "cssVariables": true,
    "prefix": ""
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils",
    "ui": "@/components/ui",
    "lib": "@/lib",
    "hooks": "@/hooks"
  },
  "iconLibrary": "lucide"
}
'@ | Out-File -FilePath "components.json" -Encoding utf8

@'
import type {NextConfig} from 'next';

const nextConfig: NextConfig = {
  /* config options here */
  typescript: {
    ignoreBuildErrors: true,
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'placehold.co',
        port: '',
        pathname: '/**',
      },
      {
        protocol: 'https',
        hostname: 'picsum.photos',
        port: '',
        pathname: '/**',
      },
    ],
  },
};

export default nextConfig;
'@ | Out-File -FilePath "next.config.ts" -Encoding utf8

@'
{
  "name": "ketrai",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev --turbopack -p 9002",
    "genkit:dev": "genkit start -- tsx src/ai/dev.ts",
    "genkit:watch": "genkit start -- tsx --watch src/ai/dev.ts",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "typecheck": "tsc --noEmit"
  },
  "dependencies": {
    "@genkit-ai/googleai": "^1.14.1",
    "@genkit-ai/next": "^1.14.1",
    "@hookform/resolvers": "^4.1.3",
    "@radix-ui/react-accordion": "^1.2.3",
    "@radix-ui/react-alert-dialog": "^1.1.6",
    "@radix-ui/react-avatar": "^1.1.3",
    "@radix-ui/react-checkbox": "^1.1.4",
    "@radix-ui/react-collapsible": "^1.1.11",
    "@radix-ui/react-dialog": "^1.1.6",
    "@radix-ui/react-dropdown-menu": "^2.1.6",
    "@radix-ui/react-label": "^2.1.2",
    "@radix-ui/react-menubar": "^1.1.6",
    "@radix-ui/react-popover": "^1.1.6",
    "@radix-ui/react-progress": "^1.1.2",
    "@radix-ui/react-radio-group": "^1.2.3",
    "@radix-ui/react-scroll-area": "^1.2.3",
    "@radix-ui/react-select": "^2.1.6",
    "@radix-ui/react-separator": "^1.1.2",
    "@radix-ui/react-slider": "^1.2.3",
    "@radix-ui/react-slot": "^1.2.3",
    "@radix-ui/react-switch": "^1.1.3",
    "@radix-ui/react-tabs": "^1.1.3",
    "@radix-ui/react-toast": "^1.2.6",
    "@radix-ui/react-tooltip": "^1.1.8",
    "class-variance-authority": "^0.7.1",
    "clsx": "^2.1.1",
    "date-fns": "^3.6.0",
    "dotenv": "^16.5.0",
    "embla-carousel-react": "^8.6.0",
    "firebase": "^10.12.2",
    "framer-motion": "^11.2.10",
    "genkit": "^1.14.1",
    "lucide-react": "^0.475.0",
    "next": "15.3.3",
    "next-themes": "^0.3.0",
    "patch-package": "^8.0.0",
    "react": "^18.3.1",
    "react-day-picker": "^8.10.1",
    "react-dom": "^18.3.1",
    "react-hook-form": "^7.54.2",
    "recharts": "^2.15.1",
    "sonner": "^1.5.0",
    "tailwind-merge": "^3.0.1",
    "tailwindcss-animate": "^1.0.7",
    "zod": "^3.24.2",
    "zustand": "^4.5.2"
  },
  "devDependencies": {
    "@types/node": "^20",
    "@types/react": "^18",
    "@types/react-dom": "^18",
    "genkit-cli": "^1.14.1",
    "postcss": "^8",
    "tailwindcss": "^3.4.1",
    "typescript": "^5"
  }
}
'@ | Out-File -FilePath "package.json" -Encoding utf8

@'
# ketrai

[![Ketrai CI](https://github.com/YOUR_USERNAME/YOUR_REPONAME/actions/workflows/main.yml/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPONAME/actions/workflows/main.yml)

This is a NextJS starter in Firebase Studio.

To get started, take a look at src/app/page.tsx.
'@ | Out-File -FilePath "README.md" -Encoding utf8

@'
import type {Config} from 'tailwindcss';

export default {
  darkMode: ['class'],
  content: [
    './src/pages/**/*.{js,ts,jsx,tsx,mdx}',
    './src/components/**/*.{js,ts,jsx,tsx,mdx}',
    './src/app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      fontFamily: {
        body: ['Inter', 'sans-serif'],
        headline: ['Space Grotesk', 'sans-serif'],
        code: ['monospace'],
      },
      colors: {
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        chart: {
          '1': 'hsl(var(--chart-1))',
          '2': 'hsl(var(--chart-2))',
          '3': 'hsl(var(--chart-3))',
          '4': 'hsl(var(--chart-4))',
          '5': 'hsl(var(--chart-5))',
        },
        sidebar: {
          DEFAULT: 'hsl(var(--sidebar-background))',
          foreground: 'hsl(var(--sidebar-foreground))',
          primary: 'hsl(var(--sidebar-primary))',
          'primary-foreground': 'hsl(var(--sidebar-primary-foreground))',
          accent: 'hsl(var(--sidebar-accent))',
          'accent-foreground': 'hsl(var(--sidebar-accent-foreground))',
          border: 'hsl(var(--sidebar-border))',
          ring: 'hsl(var(--sidebar-ring))',
        },
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
      keyframes: {
        'accordion-down': {
          from: {
            height: '0',
          },
          to: {
            height: 'var(--radix-accordion-content-height)',
          },
        },
        'accordion-up': {
          from: {
            height: 'var(--radix-accordion-content-height)',
          },
          to: {
            height: '0',
          },
        },
      },
      animation: {
        'accordion-down': 'accordion-down 0.2s ease-out',
        'accordion-up': 'accordion-up 0.2s ease-out',
      },
    },
  },
  plugins: [require('tailwindcss-animate')],
} satisfies Config;
'@ | Out-File -FilePath "tailwind.config.ts" -Encoding utf8

@'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
'@ | Out-File -FilePath "tsconfig.json" -Encoding utf8

# .github/workflows
@'
name: Ketrai CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [20.x]

    steps:
    - name: Checkout repository
      uses: actions/checkout@v4

    - name: Set up Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'

    - name: Install dependencies
      run: npm install

    - name: Lint
      run: npm run lint

    - name: Typecheck
      run: npm run typecheck
      
    - name: Build
      run: npm run build
'@ | Out-File -FilePath ".github/workflows/main.yml" -Encoding utf8

# src/ai
@'
import { config } from 'dotenv';
config();

// Dynamically import all flows from the registry
import { aiFlows } from './flowRegistry';
aiFlows.forEach(flow => {
    if (flow.file) {
        require(`@/ai/flows/${flow.file}.ts`);
    }
});
'@ | Out-File -FilePath "src/ai/dev.ts" -Encoding utf8

@'
/**
 * @fileOverview A central registry for all AI flows available in the application.
 * This allows for dynamic generation of navigation and easy registration of new flows.
 */

import { FilePenLine, Home, Route, ShieldAlert, Timer, User, Settings, Users, ClipboardList, Map } from "lucide-react";

export const aiFlows = [
  { 
    name: "Dashboard", 
    slug: "/",
    file: "",
    icon: Home,
    description: "Real-time fleet monitoring and AI-powered insights.",
    roles: ['dispatcher', 'claims', 'support', 'manager', 'admin'],
  },
  {
    name: "Proactive ETA",
    slug: "/proactive-eta",
    file: "proactive-eta-calculation",
    icon: Timer,
    description: "Recalculate delivery ETAs in real-time using traffic and weather.",
    roles: ['dispatcher', 'support', 'manager', 'admin'],
  },
  { 
    name: "Smart Dispatch", 
    slug: "/smart-dispatch", 
    file: "smart-dispatch-recommendation",
    icon: Route,
    description: "Analyze route risks to find the optimal and safest path.",
    roles: ['dispatcher', 'manager', 'admin'],
  },
  { 
    name: "Automated Claim", 
    slug: "/automated-claim", 
    file: "automated-insurance-claim-draft",
    icon: FilePenLine,
    description: "Submit or process insurance claims for packages.",
    roles: ['dispatcher', 'claims', 'support', 'manager', 'admin'],
  },
    { 
    name: "Claims History", 
    slug: "/claims-history", 
    file: "",
    icon: ClipboardList,
    description: "View and manage past insurance claims.",
    roles: ['claims', 'manager', 'admin'],
  },
  { 
    name: "Risk Visibility", 
    slug: "/risk-visibility", 
    file: "cross-carrier-risk-visibility",
    icon: ShieldAlert,
    description: "Aggregate shipment data to identify and report on supply chain risks.",
    roles: ['manager', 'admin'],
  },
  {
    name: "User Management",
    slug: "/admin/users",
    file: "",
    icon: Users,
    description: "Manage users and their roles.",
    roles: ['admin'],
  },
  {
    name: "Profile",
    slug: "/profile",
    file: "",
    icon: User,
    description: "User profile settings.",
    roles: ['dispatcher', 'claims', 'support', 'manager', 'admin'],
  },
  {
    name: "Settings",
    slug: "/settings",
    file: "",
    icon: Settings,
    description: "Application settings.",
    roles: ['dispatcher', 'claims', 'support', 'manager', 'admin'],
  },
];

export const getFlowBySlug = (slug: string) => {
    return aiFlows.find(flow => flow.slug === slug);
}
'@ | Out-File -FilePath "src/ai/flowRegistry.ts" -Encoding utf8

@'
import {genkit} from 'genkit';
import {googleAI} from '@genkit-ai/googleai';

export const ai = genkit({
  plugins: [googleAI()],
  model: 'googleai/gemini-2.5-flash',
});
'@ | Out-File -FilePath "src/ai/genkit.ts" -Encoding utf8

# src/ai/flows
@'
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
import { db } from '@/lib/firebase';
import { doc, updateDoc, serverTimestamp } from 'firebase/firestore';


const AutomatedInsuranceClaimDraftInputSchema = z.object({
  packageTrackingHistory: z.string().describe('Package tracking history from courier API.'),
  claimReason: z.string().describe('The reason for the insurance claim (e.g., Item Damaged, Package Lost).'),
  damagePhotoDataUri: z
    .string()
    .describe(
      "Damage photo, as a data URI that must include a MIME type and use Base64 encoding. Expected format: 'data:<mimetype>;base64,<encoded_data>'"
    )
    .optional(),
  productDetails: z.string().describe('Product details and value from e-commerce platform API.'),
  claimId: z.string().describe('The ID of the claim document in Firestore.'),
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

Input Data:
- Reason for Claim: {{{claimReason}}}
- Package Tracking History: {{{packageTrackingHistory}}}
- Product Details & Value: {{{productDetails}}}
- Photo Evidence of Damage: {{#if damagePhotoDataUri}}{{media url=damagePhotoDataUri}}{{else}}No photo evidence was provided.{{/if}}

Your Task:

1.  Analyze the Data: Carefully review all provided information to understand the context of the claim (e.g., when it was damaged, what the item is).
2.  Generate Claim Text: Write a clear, professional, and comprehensive claim description in natural language. This text should summarize the incident and justify the claim.
    - Use clear, capitalized headers (e.g., "INCIDENT OVERVIEW:").
    - **Crucially, ensure each header and major piece of information is on its own line for readability.**
3.  Generate Claim JSON: Create a structured JSON object representing the claim. It is critical that this JSON is well-formed.

Output Format:
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

    try {
        const claimRef = doc(db, "claims", input.claimId);
        await updateDoc(claimRef, {
            claimDraftText: output.claimDraftText,
            claimDraftJson: output.claimDraftJson,
            status: "drafted",
            draftedAt: serverTimestamp(),
        });
    } catch (e) {
        console.error("Failed to update claim in Firestore:", e);
        // Unlike before, failing to save is now a critical error
        // because the admin expects the record to be updated.
        throw new Error("Failed to save claim draft to the database.");
    }

    return output;
  }
);
'@ | Out-File -FilePath "src/ai/flows/automated-insurance-claim-draft.ts" -Encoding utf8

@'
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
'@ | Out-File -FilePath "src/ai/flows/cross-carrier-risk-visibility.ts" -Encoding utf8

@'
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
'@ | Out-File -FilePath "src/ai/flows/proactive-eta-calculation.ts" -Encoding utf8

@'
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
'@ | Out-File -FilePath "src/ai/flows/smart-dispatch-recommendation.ts" -Encoding utf8

# src/app
@'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 47.4% 11.2%;

    --card: 0 0% 100%;
    --card-foreground: 222.2 47.4% 11.2%;

    --popover: 0 0% 100%;
    --popover-foreground: 222.2 47.4% 11.2%;

    --primary: 186 53% 42%; /* teal (#329DA6) */
    --primary-foreground: 0 0% 98%;

    --secondary: 220 10% 90%;
    --secondary-foreground: 222.2 47.4% 11.2%;

    --muted: 220 10% 90%;
    --muted-foreground: 220 9% 46%;

    --accent: 274 82% 60%;
    --accent-foreground: 210 40% 98%;

    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 0 0% 98%;

    --border: 220 13% 89%;
    --input: 220 13% 91%;
    --ring: 186 53% 42%;

    --radius: 0.5rem;
  }

  .dark {
    --background: 222.2 47.4% 11.2%;
    --foreground: 210 40% 98%;

    --card: 222.2 47.4% 11.2%;
    --card-foreground: 210 40% 98%;

    --popover: 222.2 47.4% 11.2%;
    --popover-foreground: 210 40% 98%;

    --primary: 186 53% 52%;
    --primary-foreground: 222.2 47.4% 11.2%;

    --secondary: 217.2 32.6% 17.5%;
    --secondary-foreground: 210 40% 98%;
    
    --muted: 217.2 32.6% 17.5%;
    --muted-foreground: 215 20.2% 65.1%;
    
    --accent: 274 82% 60%;
    --accent-foreground: 210 40% 98%;
    
    --destructive: 0 62.8% 30.6%;
    --destructive-foreground: 210 40% 98%;
    
    --border: 217.2 32.6% 17.5%;
    --input: 217.2 32.6% 17.5%;
    --ring: 186 53% 52%;
  }
}

@layer base {
  * {
    @apply border-border;
  }
  body {
    @apply bg-background text-foreground;
  }
}
'@ | Out-File -FilePath "src/app/globals.css" -Encoding utf8

@'
import type {Metadata} from 'next';
import './globals.css';
import { Toaster } from "@/components/ui/toaster";
import { cn } from '@/lib/utils';
import { DeveloperProvider } from '@/hooks/use-developer';
import { DashboardLayout } from '@/components/dashboard-layout';
import { ThemeProvider } from '@/components/theme-provider';

export const metadata: Metadata = {
  title: 'ketrai',
  description: 'AI-Powered Supply Chain Orchestration',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <head>
        <link rel="preconnect" href="https://fonts.googleapis.com" />
        <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="anonymous" />
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet" />
        <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&display=swap" rel="stylesheet" />
      </head>
      <body className={cn("font-body antialiased")}>
        <ThemeProvider>
            <DeveloperProvider>
                <DashboardLayout>
                    {children}
                </DashboardLayout>
              <Toaster />
            </DeveloperProvider>
        </ThemeProvider>
      </body>
    </html>
  );
}
'@ | Out-File -FilePath "src/app/layout.tsx" -Encoding utf8

@'
"use client";

import Link from "next/link";
import { useProfileStore } from "@/store/profile";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { aiFlows, getFlowBySlug } from "@/ai/flowRegistry";
import { ArrowRight } from "lucide-react";

export default function DashboardPage() {
  const { profile } = useProfileStore();

  const accessibleFlows = aiFlows.filter(f =>
    f.slug !== "/" &&
    f.slug !== "/profile" &&
    f.slug !== "/settings" &&
    f.slug !== "/admin/users" &&
    profile?.role && f.roles.includes(profile.role)
  );

  return (
    <div className="space-y-6">
      <div className="space-y-1">
        <h1 className="text-2xl font-bold tracking-tight font-headline">
          Welcome back, {profile?.name || "User"}!
        </h1>
        <p className="text-muted-foreground">
          Here are the AI-powered tools available to you. Select a flow to get started.
        </p>
      </div>
      <Separator />

      <div className="grid gap-4 md:grid-cols-2">
        {accessibleFlows.map((flow) => {
          const Icon = flow.icon;
          return (
            <Link href={flow.slug} key={flow.slug} className="group">
              <Card className="h-full transition-all group-hover:border-primary group-hover:shadow-md">
                <CardHeader className="flex flex-row items-center justify-between">
                  <div className="space-y-1">
                    <CardTitle className="text-lg font-headline">{flow.name}</CardTitle>
                    <CardDescription>{flow.description}</CardDescription>
                  </div>
                  <Icon className="h-8 w-8 text-muted-foreground transition-colors group-hover:text-primary" />
                </CardHeader>
                 <CardContent>
                    <div className="text-sm font-medium text-primary flex items-center gap-1">
                        Go to {flow.name}
                        <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-1" />
                    </div>
                </CardContent>
              </Card>
            </Link>
          );
        })}
      </div>
       {accessibleFlows.length === 0 && (
            <Card>
                <CardContent className="p-6 text-center text-muted-foreground">
                    <p>No flows are available for your role.</p>
                    <p className="text-xs mt-2">Please contact an administrator if you believe this is an error.</p>
                </CardContent>
            </Card>
       )}
    </div>
  );
}
'@ | Out-File -FilePath "src/app/page.tsx" -Encoding utf8

# src/app/admin/users
@'
"use client";

import { useState } from "react";
import { db } from "@/lib/firebase";
import { collection, addDoc, serverTimestamp } from "firebase/firestore";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Label } from "@/components/ui/label";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { toast } from "sonner";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { MailPlus, Loader2 } from "lucide-react";
import type { Profile } from "@/store/profile";
import { useProfileStore } from "@/store/profile";


function generateToken() {
    const arr = new Uint8Array(20);
    crypto.getRandomValues(arr);
    return Array.from(arr, (byte) => byte.toString(16).padStart(2, '0')).join('');
}


export function InviteForm() {
  const { profile } = useProfileStore();
  const [email, setEmail] = useState("");
  const [role, setRole] = useState<Profile["role"]>("dispatcher");
  const [loading, setLoading] = useState(false);

  async function handleInvite() {
    if (!email) {
        toast.error("Please enter an email address.");
        return;
    }
    if (!profile) {
        toast.error("Could not identify the sending admin. Please refresh and try again.");
        return;
    }

    setLoading(true);
    toast.info("Sending invite...");

    try {
      const token = generateToken();
      const expiresAt = new Date(Date.now() + 1000 * 60 * 60 * 24 * 3); // 3 days expiry

      await addDoc(collection(db, "invites"), {
        email,
        role,
        status: "pending",
        token,
        createdAt: serverTimestamp(),
        expiresAt,
        invitedBy: {
            name: profile.name,
            email: profile.email,
        }
      });

      const inviteLink = `${window.location.origin}/invite/${token}`;

      // In a real app, you would use a service to email this link.
      // For now, we'll show a success toast and log it.
      console.log("Invite link:", inviteLink);

      toast.success("Invite created successfully!", {
        description: `The invite link has been logged to the console.`,
        action: {
            label: "Copy Link",
            onClick: () => navigator.clipboard.writeText(inviteLink).then(() => toast.success("Link copied!")),
        },
      });

      setEmail("");
      setRole("dispatcher");

    } catch (err) {
      const message = err instanceof Error ? err.message : "An unknown error occurred.";
      toast.error(`Failed to create invite: ${message}`);
    } finally {
        setLoading(false);
    }
  }

  return (
    <Card>
        <CardHeader>
            <div className="flex items-center gap-2">
                <MailPlus className="h-5 w-5 text-primary" />
                <CardTitle>Invite New User</CardTitle>
            </div>
            <CardDescription>Send an invitation to a new user with a pre-assigned role.</CardDescription>
        </CardHeader>
        <CardContent className="grid md:grid-cols-3 gap-4 items-end">
            <div className="space-y-2">
                <Label htmlFor="invite-email">Email</Label>
                <Input id="invite-email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="user@company.com" />
            </div>
            <div className="space-y-2">
                <Label htmlFor="invite-role">Role</Label>
                <Select value={role} onValueChange={(v) => setRole(v as Profile['role'])}>
                <SelectTrigger id="invite-role">
                    <SelectValue />
                </SelectTrigger>
                <SelectContent>
                    <SelectItem value="dispatcher">Dispatcher</SelectItem>
                    <SelectItem value="manager">Manager</SelectItem>
                    <SelectItem value="claims">Claims Officer</SelectItem>
                    <SelectItem value="support">Support</SelectItem>
                </SelectContent>
                </Select>
            </div>
            <Button onClick={handleInvite} disabled={loading}>
                {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                Send Invite
            </Button>
        </CardContent>
    </Card>
  );
}
'@ | Out-File -FilePath "src/app/admin/users/invite-form.tsx" -Encoding utf8

@'
"use client";

import { useEffect, useState, useCallback } from "react";
import { collection, getDocs, doc, updateDoc, query, orderBy, Timestamp } from "firebase/firestore";
import { db } from "@/lib/firebase";
import { Profile } from "@/store/profile";
import { RoleGate } from "@/components/role-gate";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Badge } from "@/components/ui/badge";
import { toast } from "sonner";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { RefreshCw, Users, Mail, Clock, Ban } from "lucide-react";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { InviteForm } from "./invite-form";

type Invite = {
    id: string;
    email: string;
    role: Profile['role'];
    status: "pending" | "accepted" | "expired" | "cancelled";
    token: string;
    createdAt: Timestamp;
    expiresAt: Timestamp;
}

function InvitesTable() {
    const [invites, setInvites] = useState<Invite[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchInvites = useCallback(async () => {
        setLoading(true);
        try {
            const q = query(collection(db, "invites"), orderBy("createdAt", "desc"));
            const snap = await getDocs(q);
            const data: Invite[] = snap.docs.map((d) => ({ id: d.id, ...d.data() } as Invite));
            setInvites(data);
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to fetch invites: ${message}`);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchInvites();
    }, [fetchInvites]);
    
    async function cancelInvite(id: string) {
        toast.info("Cancelling invite...");
        try {
            await updateDoc(doc(db, "invites", id), { status: "cancelled" });
            setInvites(prev => prev.map(i => (i.id === id ? { ...i, status: "cancelled" } : i)));
            toast.success("Invite cancelled.");
        } catch(err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to cancel invite: ${message}`);
        }
    }


    const getStatusVariant = (status: Invite['status']) => {
        switch (status) {
            case 'pending': return 'secondary';
            case 'accepted': return 'default';
            case 'expired': return 'destructive';
            case 'cancelled': return 'outline';
            default: return 'outline';
        }
    }

    return (
         <Card>
            <CardHeader>
                <div className="flex justify-between items-center">
                    <div className="flex items-center gap-2">
                        <Mail className="h-5 w-5 text-primary" />
                        <CardTitle>Sent Invites</CardTitle>
                    </div>
                    <Button variant="outline" size="sm" onClick={fetchInvites} disabled={loading}>
                        <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                        Refresh
                    </Button>
                </div>
                <CardDescription>Track the status of all sent user invitations.</CardDescription>
            </CardHeader>
            <CardContent>
                {loading ? (
                    <div className="space-y-2 p-4">
                        {[...Array(2)].map((_, i) => <Skeleton key={i} className="h-10 w-full" />)}
                    </div>
                ) : (
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead>Email</TableHead>
                                <TableHead>Role</TableHead>
                                <TableHead>Status</TableHead>
                                <TableHead>Expires At</TableHead>
                                <TableHead className="text-right">Actions</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {invites.length === 0 ? (
                                <TableRow>
                                    <TableCell colSpan={5} className="text-center text-muted-foreground h-24">
                                        No invites have been sent yet.
                                    </TableCell>
                                </TableRow>
                            ) : invites.map((invite) => (
                                <TableRow key={invite.id}>
                                    <TableCell className="font-medium">{invite.email}</TableCell>
                                    <TableCell className="capitalize">{invite.role}</TableCell>
                                    <TableCell>
                                        <Badge variant={getStatusVariant(invite.status)} className="capitalize">
                                            {invite.status}
                                        </Badge>
                                    </TableCell>
                                    <TableCell>
                                        {invite.expiresAt ? new Date(invite.expiresAt.seconds * 1000).toLocaleDateString() : 'N/A'}
                                    </TableCell>
                                    <TableCell className="text-right">
                                        {invite.status === 'pending' && (
                                            <Button size="sm" variant="destructive" onClick={() => cancelInvite(invite.id)}>
                                                <Ban className="mr-2 h-4 w-4" />
                                                Cancel
                                            </Button>
                                        )}
                                    </TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                )}
            </CardContent>
        </Card>
    );
}

export default function UsersPage() {
    const [users, setUsers] = useState<Profile[]>([]);
    const [loading, setLoading] = useState(true);

    const fetchUsers = useCallback(async () => {
        setLoading(true);
        try {
            const snap = await getDocs(collection(db, "users"));
            const data: Profile[] = snap.docs.map((d) => d.data() as Profile);
            setUsers(data);
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to fetch users: ${message}`);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchUsers();
    }, [fetchUsers]);

    async function updateRole(uid: string, role: Profile["role"]) {
        try {
            await updateDoc(doc(db, "users", uid), { role });
            setUsers((prev) => prev.map((u) => (u.uid === uid ? { ...u, role } : u)));
            toast.success("Role updated successfully!");
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to update role: ${message}`);
        }
    }

    async function toggleStatus(uid: string, status: Profile["status"]) {
        const newStatus = status === "active" ? "inactive" : "active";
        try {
            await updateDoc(doc(db, "users", uid), { status: newStatus });
            setUsers((prev) => prev.map((u) => (u.uid === uid ? { ...u, status: newStatus } : u)));
            toast.success(`User ${newStatus === "active" ? "activated" : "deactivated"}`);
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to update status: ${message}`);
        }
    }

    return (
        <RoleGate roles={["admin"]}>
            <div className="space-y-6">
                <div className="space-y-1">
                    <h1 className="text-2xl font-bold tracking-tight font-headline">User Management</h1>
                    <p className="text-muted-foreground">Invite, view, and manage all registered users in the system.</p>
                </div>
                <Separator />

                <InviteForm />
                
                <InvitesTable />

                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                            <div className="flex items-center gap-2">
                                <Users className="h-5 w-5 text-primary" />
                                <CardTitle>All Users</CardTitle>
                            </div>
                            <Button variant="outline" size="sm" onClick={fetchUsers} disabled={loading}>
                                <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                                Refresh
                            </Button>
                        </div>
                        <CardDescription>View and manage all currently active users.</CardDescription>
                    </CardHeader>
                    <CardContent>
                        {loading ? (
                             <div className="space-y-4">
                                {[...Array(3)].map((_, i) => (
                                    <div key={i} className="flex items-center space-x-4 p-4 border rounded-md">
                                        <Skeleton className="h-12 w-12 rounded-full" />
                                        <div className="space-y-2 flex-1">
                                            <Skeleton className="h-4 w-[250px]" />
                                            <Skeleton className="h-4 w-[200px]" />
                                        </div>
                                    </div>
                                ))}
                            </div>
                        ) : (
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>User</TableHead>
                                    <TableHead>Role</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead className="text-right">Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                            {users.map((u) => (
                                <TableRow key={u.uid}>
                                    <TableCell>
                                        <div className="flex items-center gap-3">
                                            <Avatar>
                                                <AvatarImage src={u.photoURL} alt={u.name} />
                                                <AvatarFallback>{u.name?.charAt(0).toUpperCase()}</AvatarFallback>
                                            </Avatar>
                                            <div>
                                                <p className="font-medium">{u.name}</p>
                                                <p className="text-sm text-muted-foreground">{u.email}</p>
                                            </div>
                                        </div>
                                    </TableCell>
                                    <TableCell>
                                        <Select value={u.role} onValueChange={(v) => updateRole(u.uid, v as Profile["role"])}>
                                            <SelectTrigger className="w-[140px]">
                                                <SelectValue />
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="dispatcher">Dispatcher</SelectItem>
                                                <SelectItem value="manager">Manager</SelectItem>
                                                <SelectItem value="claims">Claims</SelectItem>
                                                <SelectItem value="support">Support</SelectItem>
                                                <SelectItem value="admin">Admin</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </TableCell>
                                    <TableCell>
                                        <Badge variant={u.status === "active" ? "default" : "destructive"}>
                                            {u.status}
                                        </Badge>
                                    </TableCell>
                                    <TableCell className="text-right">
                                        <Button
                                            size="sm"
                                            variant={u.status === "active" ? "outline" : "secondary"}
                                            onClick={() => toggleStatus(u.uid, u.status)}
                                        >
                                            {u.status === "active" ? "Deactivate" : "Activate"}
                                        </Button>
                                    </TableCell>
                                </TableRow>
                            ))}
                            </TableBody>
                        </Table>
                        )}
                    </CardContent>
                </Card>
            </div>
        </RoleGate>
    );
}
'@ | Out-File -FilePath "src/app/admin/users/page.tsx" -Encoding utf8

# src/app/automated-claim
@'
"use server";

import { automatedInsuranceClaimDraft } from "@/ai/flows/automated-insurance-claim-draft";
import type { AutomatedInsuranceClaimDraftInput } from "@/ai/flows/automated-insurance-claim-draft";
import { db } from "@/lib/firebase";
import { collection, addDoc, serverTimestamp } from "firebase/firestore";
import { z } from "zod";

const ClaimRequestSchema = z.object({
  packageTrackingHistory: z.string(),
  productDetails: z.string(),
  claimReason: z.string(),
  damagePhotoDataUri: z.string().optional(),
});

type ClaimRequestInput = z.infer<typeof ClaimRequestSchema>;

export async function submitClaimRequest(data: ClaimRequestInput) {
  try {
    // This now runs on the server with admin privileges,
    // but we should still enforce logic that a user must be authenticated.
    // The security rules will handle the role-based read/update logic.
    await addDoc(collection(db, "claims"), {
      ...data,
      status: "pending_review",
      createdAt: serverTimestamp(),
    });
    return { success: true };
  } catch (error) {
    console.error("Failed to submit claim request:", error);
    const message = error instanceof Error ? error.message : "An unknown error occurred.";
    // Ensure we return a structured error that the client can handle
    return { success: false, error: `Failed to submit claim request: ${message}` };
  }
}


export async function runAutomatedClaim(data: AutomatedInsuranceClaimDraftInput) {
  try {
    const result = await automatedInsuranceClaimDraft(data);
    return { success: true, result };
  } catch (error) {
    console.error("Automated Claim failed:", error);
    const message = error instanceof Error ? error.message : "An unknown error occurred.";
    return { success: false, error: `Failed to generate insurance claim draft: ${message}` };
  }
}
'@ | Out-File -FilePath "src/app/automated-claim/actions.ts" -Encoding utf8

@'
"use client";

import { useState } from "react";
import { AutomatedClaimForm } from "@/components/forms/automated-claim-form";
import { Separator } from "@/components/ui/separator";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { CheckCircle } from "lucide-react";
import Link from "next/link";
import { useProfileStore } from "@/store/profile";
import ClaimsHistoryPage from "../claims-history/page";
import { RoleGate } from "@/components/role-gate";

export default function AutomatedClaimPage() {
  const { profile } = useProfileStore();
  const [submitted, setSubmitted] = useState(false);

  const handleComplete = () => {
    setSubmitted(true);
  }

  // Admins see the claims queue directly on this page
  if (profile?.role === 'admin' || profile?.role === 'claims' || profile?.role === 'manager') {
    return <ClaimsHistoryPage />;
  }
  
  // Non-admins see the submission flow
  if (submitted) {
    return (
       <Card className="bg-green-500/10 border-green-500/30">
        <CardHeader>
            <div className="flex items-center gap-3">
                <CheckCircle className="h-8 w-8 text-green-600" />
                <div>
                    <CardTitle className="font-headline text-lg text-green-900 dark:text-green-300">Request Submitted</CardTitle>
                    <CardDescription className="text-green-800 dark:text-green-400">Your claim request has been sent for admin review.</CardDescription>
                </div>
            </div>
        </CardHeader>
        <CardContent className="flex flex-col sm:flex-row gap-4">
            <Button onClick={() => setSubmitted(false)} className="w-full sm:w-auto">
                Submit Another Request
            </Button>
            <Button asChild variant="outline" className="w-full sm:w-auto">
                <Link href="/claims-history">
                    View My Requests
                </Link>
            </Button>
        </CardContent>
      </Card>
    )
  }

  return (
    <RoleGate roles={['dispatcher', 'support']}>
        <div className="space-y-6">
        <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight font-headline">Request a Claim Draft</h1>
            <p className="text-muted-foreground">
                Submit package details to request an insurance claim draft. An admin will review and process your request.
            </p>
        </div>
        <Separator />
        
        <AutomatedClaimForm onComplete={handleComplete} />
        </div>
    </RoleGate>
  );
}
'@ | Out-File -FilePath "src/app/automated-claim/page.tsx" -Encoding utf8

# src/app/claims-history
@'
"use client";

import { useEffect, useState, useCallback } from "react";
import { collection, getDocs, orderBy, query, Timestamp } from "firebase/firestore";
import { db } from "@/lib/firebase";
import { RoleGate } from "@/components/role-gate";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { Skeleton } from "@/components/ui/skeleton";
import { RefreshCw, ClipboardList, FileText, FileJson, Sparkles, Loader2 } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog";
import { runAutomatedClaim } from "@/app/automated-claim/actions";

type Claim = {
  id: string;
  packageTrackingHistory: string;
  productDetails: string;
  claimReason: string;
  status: "pending_review" | "drafted" | "rejected";
  claimDraftText?: string;
  claimDraftJson?: string;
  createdAt: Timestamp;
};

function ClaimDetailsDialog({ claim }: { claim: Claim }) {
  if (claim.status !== 'drafted' || !claim.claimDraftText || !claim.claimDraftJson) {
      return null;
  }
    
  return (
    <Dialog>
      <DialogTrigger asChild>
        <Button variant="outline" size="sm">View Draft</Button>
      </DialogTrigger>
      <DialogContent className="max-w-4xl max-h-[80vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>Claim Draft Details</DialogTitle>
        </DialogHeader>
        <div className="space-y-4 py-4">
          <Card>
            <CardHeader>
              <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <FileText className="h-5 w-5 text-muted-foreground" />
                Claim Narrative
              </div>
            </CardHeader>
            <CardContent>
              <div className="rounded-md border bg-secondary/50 p-4 text-sm whitespace-pre-wrap">{claim.claimDraftText}</div>
            </CardContent>
          </Card>
          <Card>
            <CardHeader>
              <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <FileJson className="h-5 w-5 text-muted-foreground" />
                Structured Data (JSON)
              </div>
            </CardHeader>
            <CardContent>
              <pre className="rounded-md border bg-secondary/50 p-4 text-xs overflow-x-auto">
                <code>{JSON.stringify(JSON.parse(claim.claimDraftJson), null, 2)}</code>
              </pre>
            </CardContent>
          </Card>
        </div>
      </DialogContent>
    </Dialog>
  );
}


export default function ClaimsHistoryPage() {
    const [claims, setClaims] = useState<Claim[]>([]);
    const [loading, setLoading] = useState(true);
    const [draftingId, setDraftingId] = useState<string | null>(null);

    const fetchClaims = useCallback(async () => {
        setLoading(true);
        try {
            const claimsQuery = query(collection(db, "claims"), orderBy("createdAt", "desc"));
            const snap = await getDocs(claimsQuery);
            const data: Claim[] = snap.docs.map((d) => ({ id: d.id, ...d.data() } as Claim));
            setClaims(data);
        } catch (err) {
            const message = err instanceof Error ? err.message : "An unknown error occurred";
            toast.error(`Failed to fetch claims: ${message}`);
        } finally {
            setLoading(false);
        }
    }, []);

    useEffect(() => {
        fetchClaims();
    }, [fetchClaims]);

    async function handleDraftClaim(claim: Claim) {
        setDraftingId(claim.id);
        toast.info("Generating AI claim draft...");

        const result = await runAutomatedClaim({
            claimId: claim.id,
            packageTrackingHistory: claim.packageTrackingHistory,
            productDetails: claim.productDetails,
            claimReason: claim.claimReason,
        });

        if (result.success) {
            toast.success("Claim drafted successfully!");
            fetchClaims(); // Refresh the list to show the new status
        } else {
            toast.error(result.error);
        }
        setDraftingId(null);
    }

    const getStatusVariant = (status: Claim['status']) => {
        switch (status) {
            case 'pending_review': return 'secondary';
            case 'drafted': return 'default';
            case 'rejected': return 'destructive';
            default: return 'outline';
        }
    }

    return (
        <RoleGate roles={["claims", "manager", "admin"]}>
            <div className="space-y-6">
                <div className="space-y-1">
                    <h1 className="text-2xl font-bold tracking-tight font-headline">Claims Queue</h1>
                    <p className="text-muted-foreground">View and process all submitted insurance claim requests.</p>
                </div>
                <Separator />

                <Card>
                    <CardHeader>
                        <div className="flex justify-between items-center">
                             <div className="flex items-center gap-2">
                                <ClipboardList className="h-5 w-5 text-primary" />
                                <CardTitle>All Claim Requests</CardTitle>
                             </div>
                            <Button variant="outline" size="sm" onClick={fetchClaims} disabled={loading}>
                                <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                                Refresh
                            </Button>
                        </div>
                    </CardHeader>
                    <CardContent>
                        {loading ? (
                             <div className="space-y-2 p-4">
                                {[...Array(3)].map((_, i) => <Skeleton key={i} className="h-10 w-full" />)}
                            </div>
                        ) : (
                        <Table>
                            <TableHeader>
                                <TableRow>
                                    <TableHead>Date</TableHead>
                                    <TableHead>Reason</TableHead>
                                    <TableHead>Status</TableHead>
                                    <TableHead className="text-right">Actions</TableHead>
                                </TableRow>
                            </TableHeader>
                            <TableBody>
                            {claims.length === 0 ? (
                                <TableRow>
                                    <TableCell colSpan={4} className="text-center text-muted-foreground h-24">
                                        No claim requests have been submitted yet.
                                    </TableCell>
                                </TableRow>
                            ) : claims.map((c) => (
                                <TableRow key={c.id}>
                                    <TableCell>
                                        {c.createdAt ? new Date(c.createdAt.seconds * 1000).toLocaleString() : 'N/A'}
                                    </TableCell>
                                     <TableCell>
                                        <p className="font-medium max-w-sm">{c.claimReason}</p>
                                    </TableCell>
                                    <TableCell>
                                        <Badge variant={getStatusVariant(c.status)} className="capitalize">
                                            {c.status.replace('_', ' ')}
                                        </Badge>
                                    </TableCell>
                                    <TableCell className="text-right">
                                        {c.status === 'drafted' && <ClaimDetailsDialog claim={c} />}
                                        <RoleGate roles={['admin']}>
                                            {c.status === 'pending_review' && (
                                                <Button size="sm" onClick={() => handleDraftClaim(c)} disabled={draftingId === c.id}>
                                                    {draftingId === c.id ? (
                                                        <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                                                    ) : (
                                                        <Sparkles className="mr-2 h-4 w-4" />
                                                    )}
                                                    Draft Claim
                                                </Button>
                                            )}
                                        </RoleGate>
                                    </TableCell>
                                </TableRow>
                            ))}
                            </TableBody>
                        </Table>
                        )}
                    </CardContent>
                </Card>
            </div>
        </RoleGate>
    );
}
'@ | Out-File -FilePath "src/app/claims-history/page.tsx" -Encoding utf8

# src/app/invite/[token]
@'
"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { db, auth } from "@/lib/firebase";
import { collection, query, where, getDocs, doc, updateDoc, setDoc, Timestamp } from "firebase/firestore";
import { createUserWithEmailAndPassword } from "firebase/auth";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { toast } from "sonner";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Logo } from "@/components/icons";
import { Label } from "@/components/ui/label";
import { Loader2 } from "lucide-react";
import type { Profile } from "@/store/profile";

type Invite = {
    id: string;
    email: string;
    role: Profile['role'];
    status: "pending" | "accepted" | "expired" | "cancelled";
    token: string;
    createdAt: Timestamp;
    expiresAt: Timestamp;
}

export default function InviteAcceptPage({ params }: { params: { token: string } }) {
  const { token } = params;
  const router = useRouter();

  const [invite, setInvite] = useState<Invite | null>(null);
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchInvite() {
      if (!token) {
        setError("Invalid invite link.");
        setLoading(false);
        return;
      }

      try {
        const q = query(collection(db, "invites"), where("token", "==", token));
        const snap = await getDocs(q);

        if (snap.empty) {
          setError("This invite link is invalid or has been removed.");
        } else {
          const inviteData = { id: snap.docs[0].id, ...snap.docs[0].data() } as Invite;
          
          if (inviteData.status !== "pending") {
            setError(`This invite has already been ${inviteData.status}.`);
          } else if (inviteData.expiresAt.toMillis() < Date.now()) {
            setError("This invite has expired.");
          } else {
            setInvite(inviteData);
          }
        }
      } catch(err) {
        setError("An error occurred while trying to verify the invite.");
      } finally {
        setLoading(false);
      }
    }
    fetchInvite();
  }, [token]);

  async function handleAccept() {
    if (!invite || !password) return;
    setLoading(true);
    toast.info("Creating your account...");

    try {
      const cred = await createUserWithEmailAndPassword(auth, invite.email, password);

      const newProfile: Profile = {
        uid: cred.user.uid,
        email: invite.email,
        name: invite.email.split("@")[0],
        role: invite.role,
        theme: "system",
        status: "active",
      };

      await setDoc(doc(db, "users", cred.user.uid), newProfile);

      // Mark invite as accepted
      await updateDoc(doc(db, "invites", invite.id), { status: "accepted" });

      toast.success("Account created successfully!", {
        description: "You will be redirected to the login page."
      });

      router.push("/login");

    } catch (err) {
      const message = err instanceof Error ? err.message : "An unknown error occurred.";
      toast.error(`Failed to create account: ${message}`);
      setLoading(false);
    }
  }
  
  if (loading) {
      return (
          <div className="flex flex-col items-center justify-center min-h-screen">
              <Loader2 className="h-8 w-8 animate-spin text-primary" />
              <p className="text-muted-foreground mt-4">Verifying invite...</p>
          </div>
      )
  }
  
  if (error || !invite) {
    return (
        <div className="flex items-center justify-center min-h-screen bg-background p-4">
            <Card className="max-w-md w-full">
                <CardHeader>
                    <CardTitle className="text-destructive">Invite Error</CardTitle>
                </CardHeader>
                <CardContent>
                    <p>{error || "This invite could not be found."}</p>
                </CardContent>
                <CardFooter>
                    <Button onClick={() => router.push('/login')} className="w-full">Go to Login</Button>
                </CardFooter>
            </Card>
        </div>
    )
  }


  return (
    <div className="flex items-center justify-center min-h-screen bg-background p-4">
      <div className="w-full max-w-md space-y-6">
        <div className="flex flex-col items-center text-center">
            <Logo className="size-12 text-primary" />
            <h1 className="text-3xl font-bold font-headline mt-4">You're Invited!</h1>
        </div>
        <Card>
            <CardHeader>
                <CardTitle>Create Your Account</CardTitle>
                <CardDescription>
                    Welcome! You've been invited to join ketrai as a <span className="font-semibold text-primary">{invite.role}</span>. 
                    Please set a password to continue.
                </CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
                <div className="space-y-2">
                    <Label>Email</Label>
                    <Input value={invite.email} disabled />
                </div>
                <div className="space-y-2">
                    <Label htmlFor="password">Set Password</Label>
                    <Input
                        id="password"
                        type="password"
                        placeholder="Choose a strong password"
                        value={password}
                        onChange={(e) => setPassword(e.target.value)}
                        autoFocus
                    />
                </div>
            </CardContent>
             <CardFooter>
                <Button onClick={handleAccept} disabled={!password || loading} className="w-full">
                  {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                  {loading ? 'Creating Account...' : 'Accept & Join'}
                </Button>
            </CardFooter>
        </Card>
      </div>
    </div>
  );
}
'@ | Out-File -FilePath "src/app/invite/[token]/page.tsx" -Encoding utf8

# src/app/login
@'
"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { signInWithEmailAndPassword, createUserWithEmailAndPassword } from "firebase/auth";
import { auth, db, setDoc, doc } from "@/lib/firebase";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card";
import { Label } from "@/components/ui/label";
import { Loader2 } from "lucide-react";
import { notify } from "@/lib/notify";
import { Logo } from "@/components/icons";
import { Profile } from "@/store/profile";

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isSignup, setIsSignup] = useState(false);
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!email || !password) {
        notify.error("Please enter both email and password.");
        return;
    }
    setLoading(true);

    try {
      if (isSignup) {
        const userCredential = await createUserWithEmailAndPassword(auth, email, password);
        const user = userCredential.user;
        
        // Create user profile document immediately after signup
        const profile: Profile = {
          uid: user.uid,
          email: user.email,
          name: user.email?.split('@')[0] ?? "New User",
          role: "dispatcher",
          theme: "system",
          status: "active",
          photoURL: user.photoURL ?? "",
        };
        await setDoc(doc(db, "users", user.uid), profile);

      } else {
        await signInWithEmailAndPassword(auth, email, password);
      }
      notify.success(isSignup ? "Account created successfully!" : "Login successful!");
      router.push("/");
    } catch (err) {
      const message = err instanceof Error ? err.message : "An unknown error occurred.";
      notify.error(`Authentication failed: ${message}`);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="flex items-center justify-center min-h-screen bg-background p-4">
      <div className="w-full max-w-md space-y-6">
        <div className="flex flex-col items-center text-center">
            <Logo className="size-12 text-primary" />
            <h1 className="text-3xl font-bold font-headline mt-4">Welcome to ketrai</h1>
            <p className="text-muted-foreground">The future of intelligent supply chain orchestration.</p>
        </div>
        <Card>
            <CardHeader>
            <CardTitle>{isSignup ? "Create an Account" : "Sign In"}</CardTitle>
            <CardDescription>
                {isSignup ? "Enter your details to get started." : "Enter your credentials to access your dashboard."}
            </CardDescription>
            </CardHeader>
            <CardContent>
            <form onSubmit={handleSubmit} className="space-y-4">
                <div className="space-y-2">
                <Label htmlFor="email">Email</Label>
                <Input id="email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} required placeholder="name@company.com"/>
                </div>
                <div className="space-y-2">
                <Label htmlFor="password">Password</Label>
                <Input id="password" type="password" value={password} onChange={(e) => setPassword(e.target.value)} required placeholder="••••••••"/>
                </div>
                <Button type="submit" disabled={loading} className="w-full">
                  {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                  {loading ? "Please wait…" : isSignup ? "Sign Up" : "Login"}
                </Button>
            </form>
            </CardContent>
            <CardFooter className="flex justify-center text-sm">
            <button
                type="button"
                onClick={() => setIsSignup(!isSignup)}
                className="text-muted-foreground hover:text-primary"
            >
                {isSignup ? "Already have an account? Sign In" : "Don't have an account? Sign Up"}
            </button>
            </CardFooter>
        </Card>
      </div>
    </div>
  );
}
'@ | Out-File -FilePath "src/app/login/page.tsx" -Encoding utf8

# src/app/proactive-eta
@'
"use server";

import { proactiveEtaCalculation } from "@/ai/flows/proactive-eta-calculation";
import type { ProactiveEtaCalculationInput } from "@/ai/flows/proactive-eta-calculation";

export async function runProactiveEta(data: ProactiveEtaCalculationInput) {
  try {
    const result = await proactiveEtaCalculation(data);
    return result;
  } catch (error) {
    console.error("Proactive ETA failed:", error);
    throw new Error("Failed to calculate ETA");
  }
}
'@ | Out-File -FilePath "src/app/proactive-eta/actions.ts" -Encoding utf8

@'
"use client";

import { useState } from "react";
import { ProactiveEtaForm } from "@/components/forms/proactive-eta-form";
import { ProactiveEtaResult } from "@/components/results/proactive-eta-result";
import { Separator } from "@/components/ui/separator";
import type { ProactiveEtaCalculationOutput } from "@/ai/flows/proactive-eta-calculation";
import { Card, CardContent } from "@/components/ui/card";

export default function ProactiveEtaPage() {
  const [result, setResult] = useState<ProactiveEtaCalculationOutput | null>(null);

  return (
    <div className="space-y-6">
      <div className="space-y-1">
        <h1 className="text-2xl font-bold tracking-tight font-headline">Proactive ETA</h1>
        <p className="text-muted-foreground">
          Recalculate delivery ETAs in real-time using traffic and weather.
        </p>
      </div>
      <Separator />
      
      <Card>
          <CardContent className="p-6">
              <ProactiveEtaForm onComplete={setResult} />
          </CardContent>
      </Card>

      {result && <ProactiveEtaResult data={result} />}
    </div>
  );
}
'@ | Out-File -FilePath "src/app/proactive-eta/page.tsx" -Encoding utf8

# src/app/profile
@'
"use client";

import { useEffect, useState } from "react";
import { useProfileStore } from "@/store/profile";
import { useForm } from "react-hook-form";
import { z } from "zod";
import { zodResolver } from "@hookform/resolvers/zod";
import { doc, updateDoc } from "firebase/firestore";
import { db } from "@/lib/firebase";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";
import { notify } from "@/lib/notify";
import { Loader2 } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import { useTheme } from "next-themes";

const profileSchema = z.object({
  name: z.string().min(2, "Name must be at least 2 characters."),
  photoURL: z.string().url("Must be a valid URL.").optional().or(z.literal("")),
  theme: z.enum(["light", "dark", "system"]),
});

type ProfileFormValues = z.infer<typeof profileSchema>;

export default function ProfilePage() {
  const { profile, setProfile } = useProfileStore();
  const { setTheme: setNextTheme } = useTheme();
  const [loading, setLoading] = useState(false);

  const form = useForm<ProfileFormValues>({
    resolver: zodResolver(profileSchema),
    defaultValues: {
      name: "",
      photoURL: "",
      theme: "system",
    },
  });

  useEffect(() => {
    if (profile) {
      form.reset({
        name: profile.name,
        photoURL: profile.photoURL ?? "",
        theme: profile.theme,
      });
    }
  }, [profile, form]);

  async function onSubmit(values: ProfileFormValues) {
    if (!profile) return;
    setLoading(true);
    notify.info("Updating profile...");

    try {
      const ref = doc(db, "users", profile.uid);
      await updateDoc(ref, values);

      setProfile({ ...profile, ...values });
      setNextTheme(values.theme);
      notify.success("Profile updated successfully!");
    } catch (err) {
      const message = err instanceof Error ? err.message : "An unknown error occurred.";
      notify.error(`Update failed: ${message}`);
    } finally {
      setLoading(false);
    }
  }

  if (!profile) {
    return (
      <div className="space-y-6">
        <div className="space-y-1">
            <Skeleton className="h-8 w-48" />
            <Skeleton className="h-4 w-72" />
        </div>
        <Separator />
        <Card>
            <CardHeader>
                <Skeleton className="h-6 w-32" />
                <Skeleton className="h-4 w-64" />
            </CardHeader>
            <CardContent className="space-y-6 pt-6">
                <div className="flex items-center gap-4">
                    <Skeleton className="w-16 h-16 rounded-full" />
                    <div className="space-y-2 flex-1">
                        <Skeleton className="h-4 w-24" />
                        <Skeleton className="h-10 w-full" />
                    </div>
                </div>
                <div className="space-y-2">
                    <Skeleton className="h-4 w-16" />
                    <Skeleton className="h-10 w-full" />
                </div>
                 <div className="space-y-2">
                    <Skeleton className="h-4 w-16" />
                    <Skeleton className="h-10 w-full" />
                </div>
                <Skeleton className="h-10 w-32" />
            </CardContent>
        </Card>
      </div>
    )
  }

  return (
    <div className="space-y-6">
        <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight font-headline">Profile Settings</h1>
            <p className="text-muted-foreground">
                Manage your personal information and application preferences.
            </p>
        </div>
        <Separator />
        
        <Form {...form}>
            <form onSubmit={form.handleSubmit(onSubmit)}>
                <Card>
                    <CardHeader>
                        <CardTitle>Personal Information</CardTitle>
                        <CardDescription>Update your name and avatar.</CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-6 pt-6">
                         <div className="flex items-center gap-4">
                            <Avatar className="w-16 h-16">
                                <AvatarImage src={form.watch("photoURL") ?? undefined} alt={form.watch("name")} />
                                <AvatarFallback>{form.watch("name")?.charAt(0).toUpperCase()}</AvatarFallback>
                            </Avatar>
                            <FormField
                                control={form.control}
                                name="photoURL"
                                render={({ field }) => (
                                    <FormItem className="flex-1">
                                    <FormLabel>Avatar URL</FormLabel>
                                    <FormControl>
                                        <Input placeholder="https://example.com/avatar.png" {...field} />
                                    </FormControl>
                                    <FormMessage />
                                    </FormItem>
                                )}
                            />
                        </div>
                        <FormField
                            control={form.control}
                            name="name"
                            render={({ field }) => (
                                <FormItem>
                                <FormLabel>Name</FormLabel>
                                <FormControl>
                                    <Input placeholder="Your name" {...field} />
                                </FormControl>
                                <FormMessage />
                                </FormItem>
                            )}
                        />
                    </CardContent>
                </Card>

                 <Card className="mt-6">
                    <CardHeader>
                        <CardTitle>Preferences</CardTitle>
                        <CardDescription>Adjust your application settings.</CardDescription>
                    </CardHeader>
                    <CardContent className="space-y-6 pt-6">
                         <FormField
                            control={form.control}
                            name="theme"
                            render={({ field }) => (
                                <FormItem>
                                <FormLabel>Theme</FormLabel>
                                <Select onValueChange={field.onChange} value={field.value}>
                                    <FormControl>
                                    <SelectTrigger>
                                        <SelectValue placeholder="Select theme" />
                                    </SelectTrigger>
                                    </FormControl>
                                    <SelectContent>
                                        <SelectItem value="system">System</SelectItem>
                                        <SelectItem value="light">Light</SelectItem>
                                        <SelectItem value="dark">Dark</SelectItem>
                                    </SelectContent>
                                </Select>
                                <FormMessage />
                                </FormItem>
                            )}
                        />
                    </CardContent>
                </Card>

                <Button type="submit" className="mt-6" disabled={loading}>
                    {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                    Save Changes
                </Button>
            </form>
        </Form>
    </div>
  );
}
'@ | Out-File -FilePath "src/app/profile/page.tsx" -Encoding utf8

# src/app/risk-visibility
@'
"use server";

import { crossCarrierRiskVisibility } from "@/ai/flows/cross-carrier-risk-visibility";
import type { CrossCarrierRiskVisibilityInput } from "@/ai/flows/cross-carrier-risk-visibility";


export async function runCrossCarrierVisibility(data: CrossCarrierRiskVisibilityInput) {
  try {
    const result = await crossCarrierRiskVisibility(data);
    return result;
  } catch (error) {
    console.error("Cross-Carrier Visibility failed:", error);
    throw new Error("Failed to generate visibility report");
  }
}
'@ | Out-File -FilePath "src/app/risk-visibility/actions.ts" -Encoding utf8

@'
"use client";

import { useState } from "react";
import { CrossCarrierForm } from "@/components/forms/cross-carrier-form";
import { CrossCarrierResult } from "@/components/results/cross-carrier-result";
import { Separator } from "@/components/ui/separator";
import type { CrossCarrierRiskVisibilityOutput } from "@/ai/flows/cross-carrier-risk-visibility";

export default function RiskVisibilityPage() {
  const [result, setResult] = useState<CrossCarrierRiskVisibilityOutput | null>(null);

  return (
    <div className="space-y-6">
      <div className="space-y-1">
          <h1 className="text-2xl font-bold tracking-tight font-headline">Cross-Carrier Visibility Hub</h1>
          <p className="text-muted-foreground">
              Aggregate shipment data to identify and report on supply chain risks.
          </p>
      </div>
      <Separator />
      
      {!result ? (
        <CrossCarrierForm onComplete={setResult} />
      ) : (
        <CrossCarrierResult data={result} onReset={() => setResult(null)} />
      )}
    </div>
  );
}
'@ | Out-File -FilePath "src/app/risk-visibility/page.tsx" -Encoding utf8

# src/app/settings
@'
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";

export default function SettingsPage() {
  return (
    <div className="space-y-6">
       <div className="space-y-1">
        <h1 className="text-2xl font-bold tracking-tight font-headline">Settings</h1>
        <p className="text-muted-foreground">
            Configure application settings.
        </p>
      </div>
      <Separator />
      <Card>
        <CardHeader>
          <CardTitle>Application Settings</CardTitle>
          <CardDescription>This is a placeholder page for application settings.</CardDescription>
        </CardHeader>
        <CardContent>
            <p>Application-wide settings and preferences will be available here.</p>
        </CardContent>
      </Card>
    </div>
  );
}
'@ | Out-File -FilePath "src/app/settings/page.tsx" -Encoding utf8

# src/app/smart-dispatch
@'
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
'@ | Out-File -FilePath "src/app/smart-dispatch/actions.ts" -Encoding utf8

@'
"use client";

import { useState } from "react";
import { SmartDispatchForm } from "@/components/forms/smart-dispatch-form";
import { SmartDispatchResult } from "@/components/results/smart-dispatch-result";
import { Separator } from "@/components/ui/separator";
import type { SmartDispatchRecommendationOutput } from "@/ai/flows/smart-dispatch-recommendation";
import { Button } from "@/components/ui/button";

export default function SmartDispatchPage() {
  const [result, setResult] = useState<SmartDispatchRecommendationOutput | null>(null);

  return (
     <div className="space-y-6">
      <div className="space-y-1">
          <h1 className="text-2xl font-bold tracking-tight font-headline">Smart Dispatch Assessor</h1>
          <p className="text-muted-foreground">
            Analyze route risks to find the optimal and safest path.
          </p>
      </div>
      <Separator />

      {!result ? (
          <SmartDispatchForm onComplete={setResult} />
      ) : (
          <SmartDispatchResult data={result} onReset={() => setResult(null)} />
      )}
    </div>
  );
}
'@ | Out-File -FilePath "src/app/smart-dispatch/page.tsx" -Encoding utf8

# src/app/user-management
@'
"use server";

import { db, collection, getDocs, doc, updateDoc } from "@/lib/firebase";
import { Profile } from "@/store/profile";
import { revalidatePath } from "next/cache";

export async function getUsers() {
    try {
        const usersCollection = collection(db, "users");
        const userSnapshot = await getDocs(usersCollection);
        const userList = userSnapshot.docs.map(doc => ({ ...doc.data(), id: doc.id } as Profile & { id: string }));
        return { success: true, users: userList };
    } catch (error) {
        const message = error instanceof Error ? error.message : "An unknown error occurred.";
        console.error("Error fetching users:", message);
        return { success: false, error: `Failed to fetch users: ${message}` };
    }
}

export async function updateUserRole(uid: string, role: Profile['role']) {
    try {
        const userDoc = doc(db, "users", uid);
        await updateDoc(userDoc, { role });
        
        // We will need a backend function to update the user's custom claims.
        // This is a placeholder for that logic.
        // For now, role changes will apply on next login.

        revalidatePath("/user-management");
        return { success: true };
    } catch (error) {
        const message = error instanceof Error ? error.message : "An unknown error occurred.";
        return { success: false, error: `Failed to update role: ${message}` };
    }
}
'@ | Out-File -FilePath "src/app/user-management/actions.ts" -Encoding utf8

@'
"use client";

import { useEffect, useState, useCallback } from "react";
import { getUsers, updateUserRole } from "./actions";
import { Profile } from "@/store/profile";
import { RoleGate } from "@/components/role-gate";
import { Separator } from "@/components/ui/separator";
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { Skeleton } from "@/components/ui/skeleton";
import { toast } from "sonner";
import { Button } from "@/components/ui/button";
import { RefreshCw } from "lucide-react";

function UserManagementTable() {
    const [users, setUsers] = useState<(Profile & { id: string })[]>([]);
    const [loading, setLoading] = useState(true);
    const [updating, setUpdating] = useState<Record<string, boolean>>({});

    const fetchUsers = useCallback(async () => {
        setLoading(true);
        const result = await getUsers();
        if (result.success) {
            setUsers(result.users || []);
        } else {
            toast.error(result.error);
            setUsers([]);
        }
        setLoading(false);
    }, []);

    useEffect(() => {
        fetchUsers();
    }, [fetchUsers]);

    const handleRoleChange = async (uid: string, newRole: Profile['role']) => {
        setUpdating(prev => ({ ...prev, [uid]: true }));
        const result = await updateUserRole(uid, newRole);
        if (result.success) {
            toast.success("User role updated successfully. The user may need to log out and back in for changes to fully apply.");
            setUsers(users.map(u => u.uid === uid ? { ...u, role: newRole } : u));
        } else {
            toast.error(result.error);
        }
        setUpdating(prev => ({ ...prev, [uid]: false }));
    };

    if (loading) {
        return (
            <div className="space-y-4">
                {[...Array(3)].map((_, i) => (
                    <div key={i} className="flex items-center space-x-4 p-4 border rounded-md">
                        <Skeleton className="h-12 w-12 rounded-full" />
                        <div className="space-y-2 flex-1">
                            <Skeleton className="h-4 w-[250px]" />
                            <Skeleton className="h-4 w-[200px]" />
                        </div>
                        <Skeleton className="h-10 w-[120px]" />
                    </div>
                ))}
            </div>
        )
    }

    return (
        <Card>
            <CardHeader>
                <div className="flex justify-between items-center">
                    <div>
                        <CardTitle>All Users</CardTitle>
                        <CardDescription>View and manage all registered users in the system.</CardDescription>
                    </div>
                    <Button variant="outline" size="sm" onClick={fetchUsers} disabled={loading}>
                        <RefreshCw className={`mr-2 h-4 w-4 ${loading ? 'animate-spin' : ''}`} />
                        Refresh
                    </Button>
                </div>
            </CardHeader>
            <CardContent>
                {users.length === 0 ? (
                    <p className="text-sm text-muted-foreground text-center py-8">No users found. This might be due to permissions issues.</p>
                ) : (
                    <Table>
                        <TableHeader>
                            <TableRow>
                                <TableHead>User</TableHead>
                                <TableHead>Role</TableHead>
                            </TableRow>
                        </TableHeader>
                        <TableBody>
                            {users.map(user => (
                                <TableRow key={user.uid}>
                                    <TableCell>
                                        <div className="flex items-center gap-3">
                                            <Avatar>
                                                <AvatarImage src={user.photoURL} alt={user.name} />
                                                <AvatarFallback>{user.name?.charAt(0).toUpperCase()}</AvatarFallback>
                                            </Avatar>
                                            <div>
                                                <p className="font-medium">{user.name}</p>
                                                <p className="text-sm text-muted-foreground">{user.email}</p>
                                            </div>
                                        </div>
                                    </TableCell>
                                    <TableCell>
                                        <Select
                                            value={user.role}
                                            onValueChange={(newRole) => handleRoleChange(user.uid, newRole as Profile['role'])}
                                            disabled={updating[user.uid]}
                                        >
                                            <SelectTrigger className="w-[180px]">
                                                <SelectValue placeholder="Select role" />
                                            </SelectTrigger>
                                            <SelectContent>
                                                <SelectItem value="dispatcher">Dispatcher</SelectItem>
                                                <SelectItem value="manager">Manager</SelectItem>
                                                <SelectItem value="claims">Claims Officer</SelectItem>
                                                <SelectItem value="support">Support</SelectItem>
                                                <SelectItem value="admin">Admin</SelectItem>
                                            </SelectContent>
                                        </Select>
                                    </TableCell>
                                </TableRow>
                            ))}
                        </TableBody>
                    </Table>
                )}
            </CardContent>
        </Card>
    )
}

export default function UserManagementPage() {
    return (
        <div className="space-y-6">
            <div className="space-y-1">
                <h1 className="text-2xl font-bold tracking-tight font-headline">User Management</h1>
                <p className="text-muted-foreground">
                    Manage user roles and permissions across the application.
                </p>
            </div>
            <Separator />
            <RoleGate roles={['admin']}>
                <UserManagementTable />
            </RoleGate>
        </div>
    );
}
'@ | Out-File -FilePath "src/app/user-management/page.tsx" -Encoding utf8

# src/components
@'
"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { cn } from "@/lib/utils";
import { Logo } from "./icons";
import { aiFlows } from "@/ai/flowRegistry";
import { Home, Loader2, Users } from "lucide-react";
import { ThemeToggle } from "@/components/ui/theme-toggle";
import { NotificationCenter } from "@/components/notification-center";
import { useEffect, useState } from "react";
import { useNotificationStore } from "@/store/notifications";
import { onAuthStateChanged, auth, fetchUserProfile } from "@/lib/firebase";
import { useProfileStore } from "@/store/profile";
import { ProfileMenu } from "./profile-menu";

export function DashboardLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const router = useRouter();
  const subscribe = useNotificationStore((s) => s.subscribe);
  const { setUser, setProfile, profile } = useProfileStore();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let notificationUnsubscribe: (() => void) | null = null;

    const authUnsubscribe = onAuthStateChanged(auth, async (user) => {
      setUser(user);

      if (notificationUnsubscribe) {
        notificationUnsubscribe();
        notificationUnsubscribe = null;
      }

      if (user) {
        const profileData = await fetchUserProfile(user);
        setProfile(profileData as any);
        notificationUnsubscribe = subscribe();
      } else {
        setProfile(null);
        if (pathname !== '/login' && !pathname.startsWith('/invite')) {
            router.push('/login');
        }
      }
      setLoading(false);
    });

    return () => {
      authUnsubscribe();
      if (notificationUnsubscribe) {
        notificationUnsubscribe();
      }
    };
  }, [subscribe, setProfile, setUser, router, pathname]);

  const mainNavItems = aiFlows.filter(f => 
      f.slug !== "/" && 
      f.slug !== "/profile" && 
      f.slug !== "/settings" &&
      f.slug !== "/admin/users" &&
      profile?.role && f.roles.includes(profile.role)
  );

  const bottomNavItems = aiFlows.filter((f) => 
    (f.slug === "/profile" || f.slug === "/settings") &&
    profile?.role && f.roles.includes(profile.role)
  );

  if (pathname === '/login' || pathname.startsWith('/invite')) {
     if (loading) {
         return (
             <div className="flex h-screen w-full items-center justify-center">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
            </div>
         )
     }
    return <>{children}</>;
  }

  if (loading) {
    return (
        <div className="flex h-screen w-full items-center justify-center">
            <Loader2 className="h-8 w-8 animate-spin text-primary" />
        </div>
    )
  }

  return (
    <div className="flex min-h-screen bg-background/50">
      <aside className="w-64 flex-col fixed inset-y-0 z-10 hidden border-r bg-card p-6 md:flex">
        <div className="flex items-center gap-2 mb-8">
          <Logo className="size-8 text-primary" />
          <h1 className="text-xl font-semibold font-headline">ketrai</h1>
        </div>
        <nav className="space-y-2 flex-1">
          <Link
            href="/"
            className={cn(
              "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors hover:bg-muted",
              pathname === "/"
                ? "bg-primary/10 text-primary"
                : "text-muted-foreground hover:text-foreground"
            )}
          >
            <Home className="h-4 w-4" />
            Dashboard
          </Link>
          {mainNavItems.map((item) => (
            <Link
              key={item.slug}
              href={item.slug}
              className={cn(
                "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors hover:bg-muted",
                pathname.startsWith(item.slug)
                  ? "bg-primary/10 text-primary"
                  : "text-muted-foreground hover:text-foreground"
              )}
            >
              <item.icon className="h-4 w-4" />
              {item.name}
            </Link>
          ))}
          {profile?.role === 'admin' && (
             <div className="pt-4">
                <h2 className="px-3 text-xs font-semibold text-muted-foreground tracking-wider uppercase mb-1">Admin</h2>
                <Link
                    href="/admin/users"
                    className={cn(
                        "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors hover:bg-muted",
                        pathname.startsWith("/admin/users")
                        ? "bg-primary/10 text-primary"
                        : "text-muted-foreground hover:text-foreground"
                    )}
                    >
                    <Users className="h-4 w-4" />
                    User Management
                </Link>
            </div>
          )}
        </nav>
        <div className="mt-auto">
          <nav className="space-y-2">
            {bottomNavItems
              .map((item) => (
                <Link
                  key={item.slug}
                  href={item.slug}
                  className={cn(
                    "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors hover:bg-muted",
                    pathname.startsWith(item.slug)
                      ? "bg-primary/10 text-primary"
                      : "text-muted-foreground hover:text-foreground"
                  )}
                >
                  <item.icon className="h-4 w-4" />
                  {item.name}
                </Link>
              ))}
          </nav>
        </div>
      </aside>

      <div className="flex-1 flex flex-col md:pl-64">
        <header className="flex h-16 items-center justify-end border-b bg-card px-6 sticky top-0 z-20">
          <div className="flex items-center gap-4">
            <NotificationCenter />
            <ThemeToggle />
            <ProfileMenu />
          </div>
        </header>
        <main className="flex-1 p-8">
            <div className="max-w-4xl mx-auto">
                {children}
            </div>
        </main>
      </div>
    </div>
  );
}
'@ | Out-File -FilePath "src/components/dashboard-layout.tsx" -Encoding utf8

@'
import type { SVGProps } from "react";

export function Logo(props: SVGProps<SVGSVGElement>) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      {...props}
    >
      <path d="M10.7 15.3a2.4 2.4 0 0 1-3.4 0" />
      <path d="M6.6 12.5a2.4 2.4 0 0 1 0-3.4" />
      <path d="M16.7 15.3a2.4 2.4 0 0 0-3.4 0" />
      <path d="M12.6 12.5a2.4 2.4 0 0 0 0-3.4" />
      <path d="M17.4 9.1a2.4 2.4 0 0 0 0 3.4" />
      <path d="M13.3 6.7a2.4 2.4 0 0 0 3.4 0" />
      <path d="M7.3 6.7a2.4 2.4 0 0 1 3.4 0" />
      <path d="M3.2 9.1a2.4 2.4 0 0 1 0 3.4" />
      <path d="M4.6 19.8a2.4 2.4 0 0 0 3.4 0" />
      <path d="M8.7 17.5a2.4 2.4 0 0 0 0-3.4" />
      <path d="M15.3 17.5a2.4 2.4 0 0 1 0-3.4" />
      <path d="M19.4 19.8a2.4 2.4 0 0 1-3.4 0" />
      <circle cx="12" cy="12" r="10" />
    </svg>
  );
}
'@ | Out-File -FilePath "src/components/icons.tsx" -Encoding utf8

@'
"use client";

import { Bell, X } from "lucide-react";
import { useNotificationStore, Notification } from "@/store/notifications";
import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { cn } from "@/lib/utils";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Separator } from "@/components/ui/separator";

function formatTimestamp(timestamp: any): string {
  if (!timestamp || !timestamp.toDate) {
    return new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }
  return timestamp.toDate().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

const categories: Notification['category'][] = ["dispatch", "eta", "claims", "cross-carrier", "system"];

export function NotificationCenter() {
  const { notifications, remove, clear } = useNotificationStore();
  const [open, setOpen] = useState(false);
  const [filter, setFilter] = useState<string>("all");

  const typeColors = {
    error: "bg-red-600",
    warning: "bg-yellow-500",
    success: "bg-green-600",
    info: "bg-blue-600",
    risk: "bg-fuchsia-600",
  };

  const riskColors = {
    high: "bg-red-600",
    medium: "bg-yellow-500",
    low: "bg-blue-500",
  };
  
  const filtered =
    filter === "all"
      ? notifications
      : notifications.filter((n) => n.category === filter);

  return (
    <div className="relative">
      <button
        className="relative p-2 rounded-full hover:bg-muted"
        onClick={() => setOpen((o) => !o)}
      >
        <Bell className="h-5 w-5" />
        {notifications.length > 0 && (
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            className="absolute -top-1 -right-1 flex h-5 w-5 items-center justify-center rounded-full bg-red-600 text-xs text-white"
          >
            {notifications.length}
          </motion.div>
        )}
      </button>

      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            className="absolute right-0 mt-2 w-80 rounded-lg border bg-popover shadow-xl z-50 text-foreground"
          >
            <div className="flex items-center justify-between p-3 border-b">
              <h3 className="text-sm font-semibold">Notifications</h3>
              {notifications.length > 0 && (
                <button
                  onClick={clear}
                  className="text-xs text-muted-foreground hover:text-foreground"
                >
                  Clear all
                </button>
              )}
            </div>
            
            <div className="p-2 border-b">
              <Select value={filter} onValueChange={setFilter}>
                <SelectTrigger className="w-full h-8 text-xs">
                    <SelectValue placeholder="Filter by category..." />
                </SelectTrigger>
                <SelectContent>
                    <SelectItem value="all">All Categories</SelectItem>
                    <Separator className="my-1"/>
                    {categories.map((c) => (
                         <SelectItem key={c} value={c} className="capitalize">
                            {c}
                        </SelectItem>
                    ))}
                </SelectContent>
              </Select>
            </div>

            <div className="max-h-96 overflow-y-auto">
              {filtered.length === 0 ? (
                <p className="p-4 text-sm text-center text-muted-foreground">No new notifications</p>
              ) : (
                filtered.map((n: Notification) => (
                  <motion.div
                    key={n.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: 20 }}
                    transition={{ duration: 0.2 }}
                    className="flex items-start gap-3 p-3 border-b last:border-none hover:bg-muted/50"
                  >
                    <div
                      className={cn("h-2 w-2 mt-1.5 rounded-full shrink-0", 
                        n.type === 'risk' && n.severity ? riskColors[n.severity] : typeColors[n.type]
                      )}
                    />
                    <div className="flex-1">
                      <p className="text-sm">{n.message}</p>
                      <span className="text-xs text-muted-foreground uppercase">
                        {n.category} &bull; {formatTimestamp(n.timestamp)}
                      </span>
                    </div>
                    <button onClick={() => remove(n.id)} className="p-1 text-muted-foreground hover:text-destructive rounded-full">
                      <X className="h-3 w-3" />
                    </button>
                  </motion.div>
                ))
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
'@ | Out-File -FilePath "src/components/notification-center.tsx" -Encoding utf8

@'
"use client";

import { useProfileStore } from "@/store/profile";
import { signOut } from "firebase/auth";
import { auth } from "@/lib/firebase";
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar";
import { LogOut, User as UserIcon, Settings } from "lucide-react";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";
import Link from "next/link";
import { Skeleton } from "./ui/skeleton";

export function ProfileMenu() {
  const { profile, user } = useProfileStore();

  if (!profile || !user) {
    return (
      <div className="flex items-center gap-2">
        <Skeleton className="h-8 w-8 rounded-full" />
        <Skeleton className="h-4 w-20" />
      </div>
    );
  }
  
  return (
    <DropdownMenu>
      <DropdownMenuTrigger asChild>
        <button className="flex items-center gap-2 p-1 rounded-full hover:bg-muted">
          <Avatar className="h-8 w-8">
            <AvatarImage src={profile.photoURL ?? ""} alt={profile.name} />
            <AvatarFallback>
              {profile.name?.charAt(0).toUpperCase() ?? "U"}
            </AvatarFallback>
          </Avatar>
        </button>
      </DropdownMenuTrigger>
      <DropdownMenuContent className="w-56" align="end">
        <DropdownMenuLabel>
          <div className="flex flex-col space-y-1">
            <p className="text-sm font-medium leading-none">{profile.name}</p>
            <p className="text-xs leading-none text-muted-foreground capitalize">
              {profile.role}
            </p>
          </div>
        </DropdownMenuLabel>
        <DropdownMenuSeparator />
        <Link href="/profile">
            <DropdownMenuItem>
                <UserIcon className="mr-2 h-4 w-4" />
                <span>Profile</span>
            </DropdownMenuItem>
        </Link>
        <Link href="/settings">
            <DropdownMenuItem>
                <Settings className="mr-2 h-4 w-4" />
                <span>Settings</span>
            </DropdownMenuItem>
        </Link>
        <DropdownMenuSeparator />
        <DropdownMenuItem onClick={() => signOut(auth)} className="text-destructive focus:text-destructive">
          <LogOut className="mr-2 h-4 w-4" />
          <span>Log out</span>
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  );
}
'@ | Out-File -FilePath "src/components/profile-menu.tsx" -Encoding utf8

@'
"use client";

import { useProfileStore } from "@/store/profile";
import type { Profile } from "@/store/profile";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { TriangleAlert } from "lucide-react";

export function RoleGate({
  roles,
  children,
}: {
  roles: Array<Profile['role']>;
  children: React.ReactNode;
}) {
  const { profile } = useProfileStore();

  if (!profile || !roles.includes(profile.role)) {
    return (
        <Card className="border-amber-500/30 bg-amber-500/10">
            <CardHeader>
                <CardTitle className="flex items-center gap-2 text-amber-900 dark:text-amber-300">
                    <TriangleAlert className="h-5 w-5"/>
                    Access Denied
                </CardTitle>
            </CardHeader>
            <CardContent>
                <p className="text-sm text-amber-800 dark:text-amber-400">
                    You do not have the required permissions to view this page. 
                    Please contact your administrator if you believe this is an error.
                </p>
            </CardContent>
        </Card>
    );
  }

  return <>{children}</>;
}
'@ | Out-File -FilePath "src/components/role-gate.tsx" -Encoding utf8

@'
"use client";

import * as React from "react";
import { ThemeProvider as NextThemesProvider } from "next-themes";

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  return (
    <NextThemesProvider attribute="class" defaultTheme="system" enableSystem>
      {children}
    </NextThemesProvider>
  );
}
'@ | Out-File -FilePath "src/components/theme-provider.tsx" -Encoding utf8

# src/components/forms
@'
"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

import { submitClaimRequest } from "@/app/automated-claim/actions";

import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, FilePenLine } from "lucide-react";
import { toast } from "sonner";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../ui/select";


const formSchema = z.object({
  claimReason: z.string({ required_error: "Please select a reason for the claim."}),
  packageTrackingHistory: z.string().min(1, "Tracking history is required."),
  productDetails: z.string().min(1, "Product details are required."),
  damagePhotoDataUri: z.string().optional(),
});

export function AutomatedClaimForm({
  onComplete,
}: {
  onComplete: () => void;
}) {
  const [loading, setLoading] = useState(false);

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      claimReason: "Item Damaged in Transit",
      packageTrackingHistory: "2024-07-28: Departed from Nairobi warehouse.\n2024-07-29: In transit via A104 highway.\n2024-07-30: Arrived at Mombasa distribution center, item reported as damaged upon inspection.",
      productDetails: "Item: Box of Kenyan Tea, Value: KES 5,000, SKU: KT-EXP-01",
      damagePhotoDataUri: "",
    },
  });
  
  async function onSubmit(values: z.infer<typeof formSchema>) {
    setLoading(true);
    toast.info("Submitting claim request...");
    
    const result = await submitClaimRequest(values);

    if (result.success) {
      toast.success("Claim request submitted successfully!");
      onComplete();
    } else {
      toast.error(result.error);
    }
    
    setLoading(false);
  }

  return (
    <div className="space-y-4">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-medium font-headline">Claim Request Details</CardTitle>
            <FilePenLine className="h-5 w-5 text-muted-foreground" />
        </CardHeader>
        <CardContent>
            <CardDescription className="mb-4">
              Provide the package history, item details, and reason for the claim.
            </CardDescription>
            <Form {...form}>
              <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4">
                 <FormField
                  control={form.control}
                  name="claimReason"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Reason for Claim</FormLabel>
                        <Select onValueChange={field.onChange} defaultValue={field.value}>
                           <FormControl>
                                <SelectTrigger>
                                    <SelectValue placeholder="Select a reason" />
                                </SelectTrigger>
                           </FormControl>
                            <SelectContent>
                                <SelectItem value="Item Damaged in Transit">Item Damaged in Transit</SelectItem>
                                <SelectItem value="Package Lost">Package Lost</SelectItem>
                                <SelectItem value="Incorrect Item Delivered">Incorrect Item Delivered</SelectItem>
                                <SelectItem value="Theft or Vandalism">Theft or Vandalism</SelectItem>
                            </SelectContent>
                        </Select>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="packageTrackingHistory"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Package Tracking History</FormLabel>
                      <FormControl>
                        <Textarea placeholder="Enter tracking history..." {...field} rows={4} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                <FormField
                  control={form.control}
                  name="productDetails"
                  render={({ field }) => (
                    <FormItem>
                      <FormLabel>Product Details & Value</FormLabel>
                      <FormControl>
                        <Input placeholder="Item, value, SKU..." {...field} />
                      </FormControl>
                      <FormMessage />
                    </FormItem>
                  )}
                />
                {/* We could add a file upload here for the damagePhotoDataUri */}
                <Button type="submit" disabled={loading} className="w-full">
                  {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                  Submit Request
                </Button>
              </form>
            </Form>
        </CardContent>
      </Card>
    </div>
  );
}
'@ | Out-File -FilePath "src/components/forms/automated-claim-form.tsx" -Encoding utf8

@'
"use client";

import { useState } from "react";
import { runCrossCarrierVisibility } from "@/app/risk-visibility/actions";
import type { CrossCarrierRiskVisibilityOutput } from "@/ai/flows/cross-carrier-risk-visibility";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../ui/card";
import { PlusCircle, ShieldAlert, XCircle, Loader2 } from "lucide-react";
import { notify } from "@/lib/notify";

export function CrossCarrierForm({ onComplete }: { onComplete: (result: CrossCarrierRiskVisibilityOutput) => void }) {
  const [shipments, setShipments] = useState<any[]>([
    { carrier: "G4S", trackingNumber: "G4S12345", status: "In Transit", location: "Nairobi, KE", eta: "2024-08-01" },
    { carrier: "Wells Fargo", trackingNumber: "WF67890", status: "Delayed", location: "Mombasa, KE", eta: "2024-08-02" },
    { carrier: "Sendy", trackingNumber: "SDY-555", status: "Out for Delivery", location: "Kisumu, KE", eta: "2024-07-30" },
  ]);
  const [alerts, setAlerts] = useState("Port strike in Mombasa\nWeather: Heavy rains in the Rift Valley");
  const [loading, setLoading] = useState(false);

  function addShipment() {
    setShipments([
      ...shipments,
      { carrier: "", trackingNumber: "", status: "", location: "", eta: "" },
    ]);
  }

  function removeShipment(index: number) {
    const updated = shipments.filter((_, i) => i !== index);
    setShipments(updated);
  }

  function updateShipment(index: number, field: string, value: string) {
    const updated = [...shipments];
    updated[index][field] = value;
    setShipments(updated);
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    notify.info("Analyzing shipments...", "cross-carrier");

    try {
      const result = await runCrossCarrierVisibility({
        shipments,
        alerts: alerts.split("\n").filter(Boolean),
      });

      result.groupedRisks.forEach((risk: any) => {
        if (risk.riskType.toLowerCase().includes("weather")) {
          notify.risk(`Weather delay risk: ${risk.shipments.join(", ")}`, "medium", "cross-carrier");
        } else if (risk.riskType.toLowerCase().includes("strike")) {
          notify.risk(`Port strike risk: ${risk.shipments.join(", ")}`, "high", "cross-carrier");
        }
      });
      
      onComplete(result);
      notify.success("Visibility report generated!", "cross-carrier");
    } catch (err) {
      notify.error(err instanceof Error ? err.message : "Failed to generate report.", "cross-carrier");
    } finally {
        setLoading(false);
    }
  }

  return (
    <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-medium font-headline">Risk Analysis Inputs</CardTitle>
            <ShieldAlert className="h-5 w-5 text-muted-foreground" />
        </CardHeader>
        <CardContent>
            <CardDescription className="mb-4">
                Add shipments from multiple carriers and any global alerts to generate a unified risk report.
            </CardDescription>
            <form onSubmit={handleSubmit} className="space-y-6">
                <div className="space-y-4">
                    <h3 className="text-sm font-medium text-muted-foreground">Shipments</h3>
                    {shipments.map((s, i) => (
                    <div key={i} className="relative border p-4 rounded-md space-y-3 bg-secondary/30">
                        <div className="grid md:grid-cols-2 gap-3">
                            <Input
                                placeholder="Carrier"
                                value={s.carrier}
                                onChange={(e) => updateShipment(i, "carrier", e.target.value)}
                            />
                            <Input
                                placeholder="Tracking Number"
                                value={s.trackingNumber}
                                onChange={(e) => updateShipment(i, "trackingNumber", e.target.value)}
                            />
                             <Input
                                placeholder="Status"
                                value={s.status}
                                onChange={(e) => updateShipment(i, "status", e.target.value)}
                            />
                            <Input
                                placeholder="Location"
                                value={s.location}
                                onChange={(e) => updateShipment(i, "location", e.target.value)}
                            />
                        </div>
                        <Input
                            placeholder="ETA (optional)"
                            value={s.eta}
                            onChange={(e) => updateShipment(i, "eta", e.target.value)}
                        />
                        <button type="button" onClick={() => removeShipment(i)} className="absolute -top-2 -right-2 text-muted-foreground hover:text-destructive">
                            <XCircle size={18} />
                        </button>
                    </div>
                    ))}
                    <Button type="button" variant="outline" size="sm" onClick={addShipment}>
                        <PlusCircle className="mr-2 h-4 w-4" /> Add Shipment
                    </Button>
                </div>

                <div>
                    <h3 className="text-sm font-medium text-muted-foreground mb-2">Global Alerts</h3>
                    <Textarea
                        placeholder="Enter global alerts (one per line, e.g., Weather: Heavy storms)"
                        value={alerts}
                        onChange={(e) => setAlerts(e.target.value)}
                        rows={3}
                    />
                </div>

                <Button type="submit" disabled={loading} className="w-full">
                    {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                    {loading ? "Analyzing..." : "Generate Report"}
                </Button>
            </form>
        </CardContent>
    </Card>
  );
}
'@ | Out-File -FilePath "src/components/forms/cross-carrier-form.tsx" -Encoding utf8

@'
"use client";

import { useState } from "react";
import { runProactiveEta } from "@/app/proactive-eta/actions";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Loader2 } from "lucide-react";
import { notify } from "@/lib/notify";
import type { ProactiveEtaCalculationOutput } from "@/ai/flows/proactive-eta-calculation";

export function ProactiveEtaForm({
  onComplete,
}: {
  onComplete: (result: ProactiveEtaCalculationOutput) => void;
}) {
  const [route, setRoute] = useState("Route from Nairobi CBD to a customer in Ruaka.");
  const [plannedEta, setPlannedEta] = useState(new Date(Date.now() + 2 * 60 * 60 * 1000).toISOString());
  const [traffic, setTraffic] = useState("Heavy traffic on Waiyaki Way, accident near ABC Place.");
  const [weather, setWeather] = useState("Heavy rainfall and thunderstorms expected in the afternoon.");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    notify.info("Recalculating ETA...", "eta");

    try {
      const result = await runProactiveEta({ route, plannedEta, traffic, weather });

      if (result.riskLevel === "high") {
        notify.risk(`High risk of delay for route: ${route}`, "high", "eta");
      } else if (result.riskLevel === "medium") {
        notify.risk(`Medium risk of delay for route: ${route}`, "medium", "eta");
      } else {
        notify.success("ETA recalculated successfully!", "eta");
      }
      onComplete(result);

    } catch (err) {
        notify.error(err instanceof Error ? err.message : "An unknown error occurred.", "eta");
    } finally {
        setLoading(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label htmlFor="route" className="text-sm font-medium">Planned Route</label>
        <Input
            id="route"
            placeholder="Planned Route"
            value={route}
            onChange={(e) => setRoute(e.target.value)}
            required
        />
      </div>
       <div>
        <label htmlFor="eta" className="text-sm font-medium">Planned ETA</label>
        <Input
            id="eta"
            placeholder="Planned ETA (ISO format e.g. 2025-09-09T16:30:00Z)"
            value={plannedEta}
            onChange={(e) => setPlannedEta(e.target.value)}
            required
        />
       </div>
      <div>
        <label htmlFor="traffic" className="text-sm font-medium">Traffic Conditions</label>
        <Textarea
            id="traffic"
            placeholder="Traffic conditions"
            value={traffic}
            onChange={(e) => setTraffic(e.target.value)}
            required
        />
      </div>
      <div>
        <label htmlFor="weather" className="text-sm font-medium">Weather Conditions</label>
        <Textarea
            id="weather"
            placeholder="Weather conditions"
            value={weather}
            onChange={(e) => setWeather(e.target.value)}
            required
        />
      </div>
      <Button type="submit" disabled={loading} className="w-full">
        {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        {loading ? "Calculating..." : "Recalculate ETA"}
      </Button>
    </form>
  );
}
'@ | Out-File -FilePath "src/components/forms/proactive-eta-form.tsx" -Encoding utf8

@'
"use client";

import { useState } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";

import { runSmartDispatch } from "@/app/smart-dispatch/actions";
import type { SmartDispatchRecommendationOutput } from "@/ai/flows/smart-dispatch-recommendation";

import { Button } from "@/components/ui/button";
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form";
import { Input } from "@/components/ui/input";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Loader2, Route } from "lucide-react";
import { toast } from "sonner";

const formSchema = z.object({
  pickup: z.string().min(1, "Pickup location is required."),
  dropoff: z.string().min(1, "Dropoff location is required."),
});

export function SmartDispatchForm({
  onComplete,
}: {
  onComplete: (result: SmartDispatchRecommendationOutput) => void;
}) {
  const [loading, setLoading] = useState(false);

  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: {
      pickup: "Jomo Kenyatta International Airport (JKIA), Nairobi",
      dropoff: "Naivasha, Kenya",
    },
  });

  async function handleSubmit(values: z.infer<typeof formSchema>) {
    setLoading(true);
    toast.info("Finding the best route...");
    try {
        const result = await runSmartDispatch(values);
        onComplete(result);
        toast.success("Optimal route found!");
    } catch (error) {
        toast.error(error instanceof Error ? error.message : "An unknown error occurred.");
    } finally {
        setLoading(false);
    }
  }

  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
        <CardTitle className="text-lg font-medium font-headline">Smart Dispatch Assessor</CardTitle>
        <Route className="h-5 w-5 text-muted-foreground" />
      </CardHeader>
      <CardContent>
        <CardDescription className="mb-4">
          Provide pickup and dropoff locations to get an AI-powered risk assessment.
        </CardDescription>
        <Form {...form}>
            <form onSubmit={form.handleSubmit(handleSubmit)} className="space-y-4">
                <FormField
                    control={form.control}
                    name="pickup"
                    render={({ field }) => (
                        <FormItem>
                        <FormLabel>Pickup Location</FormLabel>
                        <FormControl>
                            <Input placeholder="Enter pickup location..." {...field} />
                        </FormControl>
                        <FormMessage />
                        </FormItem>
                    )}
                />
                <FormField
                    control={form.control}
                    name="dropoff"
                    render={({ field }) => (
                        <FormItem>
                        <FormLabel>Dropoff Location</FormLabel>
                        <FormControl>
                            <Input placeholder="Enter dropoff location..." {...field} />
                        </FormControl>
                        <FormMessage />
                        </FormItem>
                    )}
                />
                <Button type="submit" disabled={loading} className="w-full">
                    {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                    {loading ? "Calculating..." : "Find Best Route"}
                </Button>
            </form>
        </Form>
      </CardContent>
    </Card>
  );
}
'@ | Out-File -FilePath "src/components/forms/smart-dispatch-form.tsx" -Encoding utf8

# src/components/results
@'
"use client";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import type { AutomatedInsuranceClaimDraftOutput } from "@/ai/flows/automated-insurance-claim-draft";
import { CheckCircle, FileJson, FileText } from "lucide-react";

function safeJsonParse(jsonString: string) {
  try {
    return JSON.parse(jsonString);
  } catch (e) {
    return jsonString;
  }
}

export function AutomatedClaimResult({ data }: { data: AutomatedInsuranceClaimDraftOutput }) {

  const parsedJson = safeJsonParse(data.claimDraftJson);
  const formattedJson = typeof parsedJson === 'object' 
    ? JSON.stringify(parsedJson, null, 2)
    : parsedJson; 

  return (
    <div className="space-y-6">
       <Card className="bg-green-500/10 border-green-500/30">
        <CardHeader>
            <div className="flex items-center gap-3">
                <CheckCircle className="h-8 w-8 text-green-600" />
                <div>
                    <CardTitle className="font-headline text-lg text-green-900 dark:text-green-300">Claim Draft Generated</CardTitle>
                    <CardDescription className="text-green-800 dark:text-green-400">The AI has generated a draft for your review. You can copy the text or data below.</CardDescription>
                </div>
            </div>
        </CardHeader>
      </Card>
      
      <Card>
        <CardHeader>
            <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <FileText className="h-5 w-5 text-muted-foreground" />
                Claim Narrative
            </div>
        </CardHeader>
        <CardContent>
          <div className="rounded-md border bg-secondary/50 p-4 text-sm whitespace-pre-wrap">{data.claimDraftText}</div>
        </CardContent>
      </Card>

      <Card>
         <CardHeader>
            <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <FileJson className="h-5 w-5 text-muted-foreground" />
                Structured Data (JSON)
            </div>
        </CardHeader>
        <CardContent>
           <pre className="rounded-md border bg-secondary/50 p-4 text-xs overflow-x-auto">
              <code>{formattedJson}</code>
            </pre>
        </CardContent>
      </Card>
    </div>
  );
}
'@ | Out-File -FilePath "src/components/results/automated-claim-result.tsx" -Encoding utf8

@'
"use client";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import type { CrossCarrierRiskVisibilityOutput } from "@/ai/flows/cross-carrier-risk-visibility";
import { Button } from "../ui/button";
import { CheckCircle, AlertTriangle } from "lucide-react";

export function CrossCarrierResult({ data, onReset }: { data: CrossCarrierRiskVisibilityOutput, onReset: () => void }) {
  return (
    <div className="space-y-6">
        <Card className="bg-green-500/10 border-green-500/30">
            <CardHeader>
                <div className="flex items-center gap-3">
                    <CheckCircle className="h-8 w-8 text-green-600" />
                    <div>
                        <CardTitle className="font-headline text-lg text-green-900">Report Generated</CardTitle>
                        <CardDescription className="text-green-800">The AI has analyzed all inputs and generated a risk report.</CardDescription>
                    </div>
                </div>
            </CardHeader>
        </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-lg font-headline">Executive Summary</CardTitle>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground">{data.summary}</p>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
            <CardTitle className="text-lg font-headline">Grouped Risks</CardTitle>
            <CardDescription>Shipments grouped by the primary risk factor identified.</CardDescription>
        </CardHeader>
        <CardContent className="space-y-4">
          {data.groupedRisks.map((risk, i) => (
            <div key={i} className="border bg-secondary/30 rounded-lg p-4">
                <div className="font-semibold text-base flex items-center gap-2 mb-2">
                    <AlertTriangle className="h-5 w-5 text-amber-600" />
                    {risk.riskType}
                </div>
                <p className="text-sm text-muted-foreground mb-2">{risk.note}</p>
                <div className="text-xs">
                    <span className="font-medium">Affected Shipments: </span>
                    <span className="font-mono bg-secondary rounded px-1.5 py-0.5">{risk.shipments.join(", ")}</span>
                </div>
            </div>
          ))}
           {data.groupedRisks.length === 0 && (
            <p className="text-sm text-muted-foreground text-center py-4">No specific risks were identified for the given shipments.</p>
           )}
        </CardContent>
      </Card>
      <Button onClick={onReset} variant="outline" className="w-full">
        Start New Report
      </Button>
    </div>
  );
}
'@ | Out-File -FilePath "src/components/results/cross-carrier-result.tsx" -Encoding utf8

@'
"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { AlertTriangle, Clock, MessageSquareText, Info } from "lucide-react";
import { cn } from "@/lib/utils";
import type { ProactiveEtaCalculationOutput } from "@/ai/flows/proactive-eta-calculation";

export function ProactiveEtaResult({ data }: { data: ProactiveEtaCalculationOutput }) {
  const riskStyles = {
    high: {
      card: "border-red-500/30 bg-red-500/10",
      icon: "text-red-600",
      text: "text-red-900 dark:text-red-300",
      description: "text-red-800 dark:text-red-400",
    },
    medium: {
      card: "border-amber-500/30 bg-amber-500/10",
      icon: "text-amber-600",
      text: "text-amber-900 dark:text-amber-300",
      description: "text-amber-800 dark:text-amber-400",
    },
    low: {
        card: "border-emerald-500/30 bg-emerald-500/10",
        icon: "text-emerald-600",
        text: "text-emerald-900 dark:text-emerald-300",
        description: "text-emerald-800 dark:text-emerald-400",
    },
  };

  const styles = riskStyles[data.riskLevel];

  return (
    <div className="space-y-6">
       <Card className={cn(styles.card)}>
        <CardHeader>
            <div className="flex items-start gap-3">
                <AlertTriangle className={cn("h-6 w-6 mt-1", styles.icon)} />
                <div>
                    <CardTitle className={cn("font-headline text-lg", styles.text)}>
                        Risk Level: {data.riskLevel.charAt(0).toUpperCase() + data.riskLevel.slice(1)}
                    </CardTitle>
                    <p className={cn("text-sm", styles.description)}>
                        The AI has assessed the potential for delays based on current conditions.
                    </p>
                </div>
            </div>
        </CardHeader>
      </Card>
      
      <Card>
        <CardHeader>
            <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <Clock className="h-5 w-5 text-muted-foreground" />
                Updated ETA
            </div>
        </CardHeader>
        <CardContent>
           <p className="text-2xl font-bold">{new Date(data.recalculatedEta).toLocaleString()}</p>
        </CardContent>
      </Card>

      <Card>
         <CardHeader>
            <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <MessageSquareText className="h-5 w-5 text-muted-foreground" />
                Customer Notification
            </div>
        </CardHeader>
        <CardContent>
          <p className="rounded-md border bg-secondary/50 p-4 text-sm">{data.customerMessage}</p>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
            <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <Info className="h-5 w-5 text-muted-foreground" />
                Dispatcher Notes
            </div>
        </CardHeader>
        <CardContent>
          <p className="text-sm text-muted-foreground">{data.explanation}</p>
        </CardContent>
      </Card>
    </div>
  );
}
'@ | Out-File -FilePath "src/components/results/proactive-eta-result.tsx" -Encoding utf8

@'
"use client";

import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { BarChart, Bar, XAxis, YAxis, Tooltip, ResponsiveContainer, CartesianGrid, LabelList } from "recharts";
import { SmartDispatchRecommendationOutput } from "@/ai/flows/smart-dispatch-recommendation";
import { Button } from "@/components/ui/button";
import { CheckCircle, Lightbulb, AlertTriangle } from "lucide-react";
import { Separator } from "@/components/ui/separator";

export function SmartDispatchResult({ data, onReset }: { data: SmartDispatchRecommendationOutput, onReset: () => void }) {
    
  const chartData = data.routes.map(route => ({
    name: route.name,
    Risk: route.riskIndex,
    ETA: route.etaMinutes,
    fill: route.name === data.recommendedRoute ? 'hsl(var(--primary))' : 'hsl(var(--muted))'
  }));

  return (
    <div className="space-y-6">
      <Card className="bg-green-500/10 border-green-500/30">
        <CardHeader>
            <div className="flex items-center gap-3">
                <CheckCircle className="h-8 w-8 text-green-600" />
                <div>
                    <CardTitle className="font-headline text-lg text-green-900 dark:text-green-300">Optimal Route Found</CardTitle>
                    <CardDescription className="text-green-800 dark:text-green-400">The AI has analyzed the routes and recommended the best option.</CardDescription>
                </div>
            </div>
        </CardHeader>
        <CardContent className="space-y-2 text-sm">
            <div className="p-3 rounded-md bg-background/50 border">
                <p className="font-semibold flex items-center gap-2 text-base"><Lightbulb className="text-primary h-5 w-5"/>AI Recommendation: <span className="text-primary">{data.recommendedRoute}</span></p>
                <p className="text-xs mt-1 text-muted-foreground">{data.explanation}</p>
            </div>
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="font-headline text-lg">Route Comparison</CardTitle>
          <CardDescription>Visual comparison of risk and ETA for each route.</CardDescription>
        </CardHeader>
        <CardContent className="p-4">
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={chartData} margin={{ top: 20, right: 0, left: 0, bottom: 5 }}>
              <CartesianGrid vertical={false} strokeDasharray="3 3" />
              <XAxis dataKey="name" stroke="hsl(var(--muted-foreground))" fontSize={12} tickLine={false} axisLine={false} />
              <YAxis yAxisId="left" orientation="left" stroke="hsl(var(--muted-foreground))" fontSize={12} tickLine={false} axisLine={false} label={{ value: 'Risk Index', angle: -90, position: 'insideLeft', offset: 10, style: { fontSize: '12px', fill: 'hsl(var(--muted-foreground))' } }} />
              <YAxis yAxisId="right" orientation="right" stroke="hsl(var(--muted-foreground))" fontSize={12} tickLine={false} axisLine={false} label={{ value: 'ETA (mins)', angle: -90, position: 'insideRight', offset: -10, style: { fontSize: '12px', fill: 'hsl(var(--muted-foreground))' } }} />
              <Tooltip
                contentStyle={{
                  background: "hsl(var(--card))",
                  borderColor: "hsl(var(--border))",
                  borderRadius: "var(--radius)",
                  fontSize: "12px",
                }}
                labelStyle={{ fontWeight: 'bold', color: "hsl(var(--foreground))" }}
              />
              <Bar yAxisId="left" dataKey="Risk" name="Risk Index" fill="hsl(var(--destructive) / 0.6)" radius={[4, 4, 0, 0]}>
                <LabelList dataKey="Risk" position="top" style={{ fontSize: '10px', fill: 'hsl(var(--destructive))' }} />
              </Bar>
              <Bar yAxisId="right" dataKey="ETA" name="ETA (minutes)" fill="hsl(var(--primary) / 0.6)" radius={[4, 4, 0, 0]}>
                <LabelList dataKey="ETA" position="top" style={{ fontSize: '10px', fill: 'hsl(var(--primary))' }} />
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>
        
      <Separator />
      
      <div className="space-y-4">
        <h3 className="text-lg font-semibold font-headline">Route Details</h3>
        {data.routes.map((route: any, i: number) => (
          <Card key={i} className={route.name === data.recommendedRoute ? "border-primary" : ""}>
            <CardHeader>
                <CardTitle className="text-base">{route.name}</CardTitle>
                <CardDescription>
                    ETA: {route.etaMinutes} min — Risk: {route.riskIndex}/100
                </CardDescription>
            </CardHeader>
            <CardContent>
              <h4 className="font-semibold text-sm mb-2 flex items-center gap-2"><AlertTriangle className="h-4 w-4 text-amber-500" />Identified Issues</h4>
              <ul className="list-disc list-outside ml-5 space-y-1 text-sm text-muted-foreground">
                {route.issues.map((issue: string, j: number) => (
                  <li key={j}>{issue}</li>
                ))}
              </ul>
            </CardContent>
          </Card>
        ))}
      </div>

      <Button onClick={onReset} variant="outline" className="w-full">Start New Assessment</Button>
    </div>
  );
}
'@ | Out-File -FilePath "src/components/results/smart-dispatch-result.tsx" -Encoding utf8

# src/components/ui
# This will contain all the ShadCN UI components
# ... (all UI components as separate @'...'@ blocks)

# src/hooks
@'
"use client";

import React, { createContext, useContext, useState, ReactNode } from 'react';

interface DeveloperContextType {
  isDeveloperMode: boolean;
  setIsDeveloperMode: (isDeveloperMode: boolean) => void;
}

const DeveloperContext = createContext<DeveloperContextType | undefined>(undefined);

export const DeveloperProvider = ({ children }: { children: ReactNode }) => {
  const [isDeveloperMode, setIsDeveloperMode] = useState(false);

  return (
    <DeveloperContext.Provider value={{ isDeveloperMode, setIsDeveloperMode }}>
      {children}
    </DeveloperContext.Provider>
  );
};

export const useDeveloper = (): DeveloperContextType => {
  const context = useContext(DeveloperContext);
  if (!context) {
    throw new Error('useDeveloper must be used within a DeveloperProvider');
  }
  return context;
};
'@ | Out-File -FilePath "src/hooks/use-developer.tsx" -Encoding utf8

@'
import * as React from "react"

const MOBILE_BREAKPOINT = 768

export function useIsMobile() {
  const [isMobile, setIsMobile] = React.useState<boolean | undefined>(undefined)

  React.useEffect(() => {
    const mql = window.matchMedia(`(max-width: ${MOBILE_BREAKPOINT - 1}px)`)
    const onChange = () => {
      setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
    }
    mql.addEventListener("change", onChange)
    setIsMobile(window.innerWidth < MOBILE_BREAKPOINT)
    return () => mql.removeEventListener("change", onChange)
  }, [])

  return !!isMobile
}
'@ | Out-File -FilePath "src/hooks/use-mobile.tsx" -Encoding utf8

@'
"use client"

// Inspired by react-hot-toast library
import * as React from "react"

import type {
  ToastActionElement,
  ToastProps,
} from "@/components/ui/toast"

const TOAST_LIMIT = 1
const TOAST_REMOVE_DELAY = 1000000

type ToasterToast = ToastProps & {
  id: string
  title?: React.ReactNode
  description?: React.ReactNode
  action?: ToastActionElement
}

const actionTypes = {
  ADD_TOAST: "ADD_TOAST",
  UPDATE_TOAST: "UPDATE_TOAST",
  DISMISS_TOAST: "DISMISS_TOAST",
  REMOVE_TOAST: "REMOVE_TOAST",
} as const

let count = 0

function genId() {
  count = (count + 1) % Number.MAX_SAFE_INTEGER
  return count.toString()
}

type ActionType = typeof actionTypes

type Action =
  | {
      type: ActionType["ADD_TOAST"]
      toast: ToasterToast
    }
  | {
      type: ActionType["UPDATE_TOAST"]
      toast: Partial<ToasterToast>
    }
  | {
      type: ActionType["DISMISS_TOAST"]
      toastId?: ToasterToast["id"]
    }
  | {
      type: ActionType["REMOVE_TOAST"]
      toastId?: ToasterToast["id"]
    }

interface State {
  toasts: ToasterToast[]
}

const toastTimeouts = new Map<string, ReturnType<typeof setTimeout>>()

const addToRemoveQueue = (toastId: string) => {
  if (toastTimeouts.has(toastId)) {
    return
  }

  const timeout = setTimeout(() => {
    toastTimeouts.delete(toastId)
    dispatch({
      type: "REMOVE_TOAST",
      toastId: toastId,
    })
  }, TOAST_REMOVE_DELAY)

  toastTimeouts.set(toastId, timeout)
}

export const reducer = (state: State, action: Action): State => {
  switch (action.type) {
    case "ADD_TOAST":
      return {
        ...state,
        toasts: [action.toast, ...state.toasts].slice(0, TOAST_LIMIT),
      }

    case "UPDATE_TOAST":
      return {
        ...state,
        toasts: state.toasts.map((t) =>
          t.id === action.toast.id ? { ...t, ...action.toast } : t
        ),
      }

    case "DISMISS_TOAST": {
      const { toastId } = action

      // ! Side effects ! - This could be extracted into a dismissToast() action,
      // but I'll keep it here for simplicity
      if (toastId) {
        addToRemoveQueue(toastId)
      } else {
        state.toasts.forEach((toast) => {
          addToRemoveQueue(toast.id)
        })
      }

      return {
        ...state,
        toasts: state.toasts.map((t) =>
          t.id === toastId || toastId === undefined
            ? {
                ...t,
                open: false,
              }
            : t
        ),
      }
    }
    case "REMOVE_TOAST":
      if (action.toastId === undefined) {
        return {
          ...state,
          toasts: [],
        }
      }
      return {
        ...state,
        toasts: state.toasts.filter((t) => t.id !== action.toastId),
      }
  }
}

const listeners: Array<(state: State) => void> = []

let memoryState: State = { toasts: [] }

function dispatch(action: Action) {
  memoryState = reducer(memoryState, action)
  listeners.forEach((listener) => {
    listener(memoryState)
  })
}

type Toast = Omit<ToasterToast, "id">

function toast({ ...props }: Toast) {
  const id = genId()

  const update = (props: ToasterToast) =>
    dispatch({
      type: "UPDATE_TOAST",
      toast: { ...props, id },
    })
  const dismiss = () => dispatch({ type: "DISMISS_TOAST", toastId: id })

  dispatch({
    type: "ADD_TOAST",
    toast: {
      ...props,
      id,
      open: true,
      onOpenChange: (open) => {
        if (!open) dismiss()
      },
    },
  })

  return {
    id: id,
    dismiss,
    update,
  }
}

function useToast() {
  const [state, setState] = React.useState<State>(memoryState)

  React.useEffect(() => {
    listeners.push(setState)
    return () => {
      const index = listeners.indexOf(setState)
      if (index > -1) {
        listeners.splice(index, 1)
      }
    }
  }, [state])

  return {
    ...state,
    toast,
    dismiss: (toastId?: string) => dispatch({ type: "DISMISS_TOAST", toastId }),
  }
}

export { useToast, toast }
'@ | Out-File -FilePath "src/hooks/use-toast.ts" -Encoding utf8

# src/lib
@'
import { initializeApp, getApps, getApp } from "firebase/app";
import { getAuth, onAuthStateChanged, User } from "firebase/auth";
import { getFirestore, doc, getDoc, setDoc, collection, getDocs, updateDoc, serverTimestamp, writeBatch, deleteDoc, query, orderBy, onSnapshot, where, Timestamp, addDoc } from "firebase/firestore";

const firebaseConfig = {
  "projectId": "chainflow-ai",
  "appId": "1:193038732906:web:c52be3703517673305c413",
  "storageBucket": "chainflow-ai.firebasestorage.app",
  "apiKey": "AIzaSyC3giyELU6K8NTgILioG4PA4HLGfXtkwFg",
  "authDomain": "chainflow-ai.firebaseapp.com",
  "messagingSenderId": "193038732906"
};

const app = !getApps().length ? initializeApp(firebaseConfig) : getApp();
export const db = getFirestore(app);
export const auth = getAuth(app);

export async function fetchUserProfile(user: User) {
  if (!user) return null;
  const ref = doc(db, "users", user.uid);
  const snap = await getDoc(ref);

  if (!snap.exists()) {
    // This case is unlikely with the current signup flow, but good practice.
    console.log(`Profile for ${user.uid} does not exist. Creating one.`);
    const newProfile = {
      uid: user.uid,
      email: user.email,
      name: user.displayName ?? user.email?.split('@')[0] ?? "New User",
      role: "dispatcher",
      theme: "system",
      status: "active",
      photoURL: user.photoURL ?? "",
    };
    await setDoc(ref, newProfile);
    return newProfile;
  }

  return snap.data();
}

export { onAuthStateChanged, setDoc, doc, collection, getDocs, updateDoc, serverTimestamp, writeBatch, deleteDoc, query, orderBy, onSnapshot, where, Timestamp, addDoc };
'@ | Out-File -FilePath "src/lib/firebase.ts" -Encoding utf8

@'
// This file is no longer in use and can be safely deleted.
// It is being kept to avoid breaking file references in the project.
// The fleet management feature has been removed.
export {};
'@ | Out-File -FilePath "src/lib/mock-vehicles.ts" -Encoding utf8

@'
import { toast } from "sonner";
import { useNotificationStore, Notification } from "@/store/notifications";

export const notify = {
  success: (msg: string, category: Notification["category"] = "system") => {
    toast.success(msg);
    useNotificationStore.getState().add({ message: msg, type: "success", category });
  },
  warning: (msg: string, category: Notification["category"] = "system") => {
    toast.warning(msg);
    useNotificationStore.getState().add({ message: msg, type: "warning", category });
  },
  error: (msg: string, category: Notification["category"] = "system") => {
    toast.error(msg);
    useNotificationStore.getState().add({ message: msg, type: "error", category });
  },
  info: (msg: string, category: Notification["category"] = "system") => {
    toast.info(msg);
    useNotificationStore.getState().add({ message: msg, type: "info", category });
  },
  risk: (
    msg: string,
    severity: "low" | "medium" | "high",
    category: Notification["category"] = "system"
  ) => {
    const toastMethod = {
      low: toast.info,
      medium: toast.warning,
      high: toast.error,
    };
    toastMethod[severity](msg, {
      duration: severity === "high" ? 8000 : 4000,
    });
    useNotificationStore.getState().add({ message: msg, type: "risk", severity, category });
  },
};
'@ | Out-File -FilePath "src/lib/notify.ts" -Encoding utf8

@'
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
'@ | Out-File -FilePath "src/lib/utils.ts" -Encoding utf8

# src/store
@'
import { create } from "zustand";
import { db, auth, addDoc, collection, deleteDoc, doc, onSnapshot, orderBy, query, serverTimestamp, writeBatch } from "@/lib/firebase";

export type Notification = {
  id: string;
  uid: string; // User ID of the recipient
  message: string;
  type: "success" | "warning" | "error" | "info" | "risk";
  category: "dispatch" | "eta" | "claims" | "cross-carrier" | "system";
  severity?: "low" | "medium" | "high";
  timestamp: any; // Firestore timestamp object
};

type NotificationStore = {
  notifications: Notification[];
  add: (n: Omit<Notification, "id" | "timestamp" | "uid">) => Promise<void>;
  remove: (id: string) => Promise<void>;
  clear: () => Promise<void>;
  subscribe: () => () => void; // Returns an unsubscribe function
};

export const useNotificationStore = create<NotificationStore>((set, get) => ({
  notifications: [],

  add: async (n) => {
    const user = auth.currentUser;
    if (!user) {
        console.error("Cannot add notification. User not authenticated.");
        return;
    }
    try {
      await addDoc(collection(db, "notifications"), {
        ...n,
        uid: user.uid,
        timestamp: serverTimestamp(),
      });
    } catch (error) {
      console.error("Error adding notification to Firestore:", error);
    }
  },

  remove: async (id) => {
    try {
      await deleteDoc(doc(db, "notifications", id));
    } catch (error) {
      console.error("Error removing notification from Firestore:", error);
    }
  },

  clear: async () => {
    const { notifications } = get();
    if (notifications.length === 0) return;
    
    const batch = writeBatch(db);
    notifications.forEach((n) => {
      const docRef = doc(db, "notifications", n.id);
      batch.delete(docRef);
    });

    try {
      await batch.commit();
    } catch (error) {
      console.error("Error clearing notifications with a batch write:", error);
    }
  },

  subscribe: () => {
    const user = auth.currentUser;
    if (!user) return () => {};

    const q = query(collection(db, "notifications"), where("uid", "==", user.uid), orderBy("timestamp", "desc"));
    
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const list: Notification[] = [];
      snapshot.forEach(doc => {
          list.push({ id: doc.id, ...doc.data() } as Notification);
      });
      set({ notifications: list });
    }, (error) => {
      console.error("Error subscribing to notifications:", error);
    });
    
    return unsubscribe;
  },
}));
'@ | Out-File -FilePath "src/store/notifications.ts" -Encoding utf8

@'
import { create } from "zustand";
import { User } from "firebase/auth";

export type Profile = {
  uid: string;
  email: string | null;
  name: string;
  role: "dispatcher" | "manager" | "claims" | "admin" | "support";
  theme: "light" | "dark" | "system";
  status: "active" | "inactive";
  photoURL?: string;
};

type ProfileStore = {
  user: User | null;
  profile: Profile | null;
  setUser: (u: User | null) => void;
  setProfile: (p: Profile | null) => void;
};

export const useProfileStore = create<ProfileStore>((set) => ({
  user: null,
  profile: null,
  setUser: (u) => set({ user: u }),
  setProfile: (p) => set({ profile: p }),
}));
'@ | Out-File -FilePath "src/store/profile.ts" -Encoding utf8

# src/types
@'
// This file is no longer in use and can be safely deleted.
// It is being kept to avoid breaking file references in the project.
// The fleet management feature has been removed.
export {};
'@ | Out-File -FilePath "src/types/vehicle.ts" -Encoding utf8

# Add all the UI components here as separate @'...'@ blocks
Write-Host "Project setup complete!"
Write-Host "Next steps:"
Write-Host "1. Run 'npm install' to install dependencies."
Write-Host "2. Run 'npm run dev' to start the development server."
