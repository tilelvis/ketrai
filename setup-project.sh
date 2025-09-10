#!/bin/bash

# This script will create the directory structure and all the necessary files for the ketrai project.
# Run this script from an empty directory.

echo "Creating project directories..."

mkdir -p .github/workflows
mkdir -p src/ai/flows
mkdir -p src/app/admin/users
mkdir -p src/app/automated-claim
mkdir -p src/app/claims-history
mkdir -p src/app/invite/[token]
mkdir -p src/app/login
mkdir -p src/app/proactive-eta
mkdir -p src/app/profile
mkdir -p src/app/risk-visibility
mkdir -p src/app/settings
mkdir -p src/app/smart-dispatch
mkdir -p src/app/user-management
mkdir -p src/components/forms
mkdir -p src/components/results
mkdir -p src/components/ui
mkdir -p src/hooks
mkdir -p src/lib
mkdir -p src/store

echo "Creating project files..."

# Root files
cat << 'EOF' > .env

EOF

cat << 'EOF' > .github/workflows/main.yml
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
EOF

cat << 'EOF' > README.md
# ketrai

[![Ketrai CI](https://github.com/YOUR_USERNAME/YOUR_REPONAME/actions/workflows/main.yml/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPONAME/actions/workflows/main.yml)

This is a NextJS starter in Firebase Studio.

To get started, take a look at src/app/page.tsx.
EOF

cat << 'EOF' > apphosting.yaml
# Settings to manage and configure a Firebase App Hosting backend.
# https://firebase.google.com/docs/app-hosting/configure

runConfig:
  # Increase this value if you'd like to automatically spin up
  # more instances in response to increased traffic.
  maxInstances: 1
EOF

cat << 'EOF' > components.json
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
EOF

cat << 'EOF' > next.config.ts
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
EOF

cat << 'EOF' > package.json
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
EOF

cat << 'EOF' > tailwind.config.ts
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
EOF

cat << 'EOF' > tsconfig.json
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
EOF

# src/ai files
cat << 'EOF' > src/ai/dev.ts
import { config } from 'dotenv';
config();

// Dynamically import all flows from the registry
import { aiFlows } from './flowRegistry';
aiFlows.forEach(flow => {
    require(`@/ai/flows/${flow.file}.ts`);
});
EOF

cat << 'EOF' > src/ai/flowRegistry.ts
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
EOF

cat << 'EOF' > src/ai/genkit.ts
import {genkit} from 'genkit';
import {googleAI} from '@genkit-ai/googleai';

export const ai = genkit({
  plugins: [googleAI()],
  model: 'googleai/gemini-2.5-flash',
});
EOF

cat << 'EOF' > src/ai/flows/automated-insurance-claim-draft.ts
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
EOF

cat << 'EOF' > src/ai/flows/cross-carrier-risk-visibility.ts
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
EOF

cat << 'EOF' > src/ai/flows/proactive-eta-calculation.ts
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
EOF

cat << 'EOF' > src/ai/flows/smart-dispatch-recommendation.ts
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
EOF

# src/app files
cat << 'EOF' > src/app/globals.css
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
EOF

cat << 'EOF' > src/app/layout.tsx
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
EOF

cat << 'EOF' > src/app/page.tsx
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
EOF

cat << 'EOF' > src/app/admin/users/invite-form.tsx
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
EOF

cat << 'EOF' > src/app/admin/users/page.tsx
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
EOF

cat << 'EOF' > src/app/automated-claim/actions.ts
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
EOF

cat << 'EOF' > src/app/automated-claim/page.tsx
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
EOF

cat << 'EOF' > src/app/claims-history/page.tsx
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
EOF

cat << 'EOF' > src/app/invite/[token]/page.tsx
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
EOF

cat << 'EOF' > src/app/login/page.tsx
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
EOF

cat << 'EOF' > src/app/proactive-eta/actions.ts
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
EOF

cat << 'EOF' > src/app/proactive-eta/page.tsx
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
EOF

cat << 'EOF' > src/app/profile/page.tsx
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
EOF

cat << 'EOF' > src/app/risk-visibility/actions.ts
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
EOF

cat << 'EOF' > src/app/risk-visibility/page.tsx
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
EOF

cat << 'EOF' > src/app/settings/page.tsx
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
EOF

cat << 'EOF' > src/app/smart-dispatch/actions.ts
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
EOF

cat << 'EOF' > src/app/smart-dispatch/page.tsx
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
EOF

cat << 'EOF' > src/app/user-management/actions.ts
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
EOF

cat << 'EOF' > src/app/user-management/page.tsx
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
EOF

# src/components files
cat << 'EOF' > src/components/dashboard-layout.tsx
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
EOF

cat << 'EOF' > src/components/icons.tsx
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
EOF

cat << 'EOF' > src/components/notification-center.tsx
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
EOF

cat << 'EOF' > src/components/profile-menu.tsx
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
EOF

cat << 'EOF' > src/components/role-gate.tsx
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
EOF

cat << 'EOF' > src/components/theme-provider.tsx
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
EOF

# src/components/forms
cat << 'EOF' > src/components/forms/automated-claim-form.tsx
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
EOF

cat << 'EOF' > src/components/forms/cross-carrier-form.tsx
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
EOF

cat << 'EOF' > src/components/forms/proactive-eta-form.tsx
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
EOF

cat << 'EOF' > src/components/forms/smart-dispatch-form.tsx
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
EOF

# src/components/results
cat << 'EOF' > src/components/results/automated-claim-result.tsx
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
EOF

cat << 'EOF' > src/components/results/cross-carrier-result.tsx
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
EOF

cat << 'EOF' > src/components/results/proactive-eta-result.tsx
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
EOF

cat << 'EOF' > src/components/results/smart-dispatch-result.tsx
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
EOF

# src/components/ui
# This section will be very long, as it contains all the ShadCN components.
cat << 'EOF' > src/components/ui/accordion.tsx
"use client"

import * as React from "react"
import * as AccordionPrimitive from "@radix-ui/react-accordion"
import { ChevronDown } from "lucide-react"

import { cn } from "@/lib/utils"

const Accordion = AccordionPrimitive.Root

const AccordionItem = React.forwardRef<
  React.ElementRef<typeof AccordionPrimitive.Item>,
  React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Item>
>(({ className, ...props }, ref) => (
  <AccordionPrimitive.Item
    ref={ref}
    className={cn("border-b", className)}
    {...props}
  />
))
AccordionItem.displayName = "AccordionItem"

const AccordionTrigger = React.forwardRef<
  React.ElementRef<typeof AccordionPrimitive.Trigger>,
  React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Trigger>
>(({ className, children, ...props }, ref) => (
  <AccordionPrimitive.Header className="flex">
    <AccordionPrimitive.Trigger
      ref={ref}
      className={cn(
        "flex flex-1 items-center justify-between py-4 font-medium transition-all hover:underline [&[data-state=open]>svg]:rotate-180",
        className
      )}
      {...props}
    >
      {children}
      <ChevronDown className="h-4 w-4 shrink-0 transition-transform duration-200" />
    </AccordionPrimitive.Trigger>
  </AccordionPrimitive.Header>
))
AccordionTrigger.displayName = AccordionPrimitive.Trigger.displayName

const AccordionContent = React.forwardRef<
  React.ElementRef<typeof AccordionPrimitive.Content>,
  React.ComponentPropsWithoutRef<typeof AccordionPrimitive.Content>
>(({ className, children, ...props }, ref) => (
  <AccordionPrimitive.Content
    ref={ref}
    className="overflow-hidden text-sm transition-all data-[state=closed]:animate-accordion-up data-[state=open]:animate-accordion-down"
    {...props}
  >
    <div className={cn("pb-4 pt-0", className)}>{children}</div>
  </AccordionPrimitive.Content>
))

AccordionContent.displayName = AccordionPrimitive.Content.displayName

export { Accordion, AccordionItem, AccordionTrigger, AccordionContent }
EOF

cat << 'EOF' > src/components/ui/alert-dialog.tsx
"use client"

import * as React from "react"
import * as AlertDialogPrimitive from "@radix-ui/react-alert-dialog"

import { cn } from "@/lib/utils"
import { buttonVariants } from "@/components/ui/button"

const AlertDialog = AlertDialogPrimitive.Root

const AlertDialogTrigger = AlertDialogPrimitive.Trigger

const AlertDialogPortal = AlertDialogPrimitive.Portal

const AlertDialogOverlay = React.forwardRef<
  React.ElementRef<typeof AlertDialogPrimitive.Overlay>,
  React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Overlay>
>(({ className, ...props }, ref) => (
  <AlertDialogPrimitive.Overlay
    className={cn(
      "fixed inset-0 z-50 bg-black/80  data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
      className
    )}
    {...props}
    ref={ref}
  />
))
AlertDialogOverlay.displayName = AlertDialogPrimitive.Overlay.displayName

const AlertDialogContent = React.forwardRef<
  React.ElementRef<typeof AlertDialogPrimitive.Content>,
  React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Content>
>(({ className, ...props }, ref) => (
  <AlertDialogPortal>
    <AlertDialogOverlay />
    <AlertDialogPrimitive.Content
      ref={ref}
      className={cn(
        "fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg",
        className
      )}
      {...props}
    />
  </AlertDialogPortal>
))
AlertDialogContent.displayName = AlertDialogPrimitive.Content.displayName

const AlertDialogHeader = ({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) => (
  <div
    className={cn(
      "flex flex-col space-y-2 text-center sm:text-left",
      className
    )}
    {...props}
  />
)
AlertDialogHeader.displayName = "AlertDialogHeader"

const AlertDialogFooter = ({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) => (
  <div
    className={cn(
      "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
      className
    )}
    {...props}
  />
)
AlertDialogFooter.displayName = "AlertDialogFooter"

const AlertDialogTitle = React.forwardRef<
  React.ElementRef<typeof AlertDialogPrimitive.Title>,
  React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Title>
>(({ className, ...props }, ref) => (
  <AlertDialogPrimitive.Title
    ref={ref}
    className={cn("text-lg font-semibold", className)}
    {...props}
  />
))
AlertDialogTitle.displayName = AlertDialogPrimitive.Title.displayName

const AlertDialogDescription = React.forwardRef<
  React.ElementRef<typeof AlertDialogPrimitive.Description>,
  React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Description>
>(({ className, ...props }, ref) => (
  <AlertDialogPrimitive.Description
    ref={ref}
    className={cn("text-sm text-muted-foreground", className)}
    {...props}
  />
))
AlertDialogDescription.displayName =
  AlertDialogPrimitive.Description.displayName

const AlertDialogAction = React.forwardRef<
  React.ElementRef<typeof AlertDialogPrimitive.Action>,
  React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Action>
>(({ className, ...props }, ref) => (
  <AlertDialogPrimitive.Action
    ref={ref}
    className={cn(buttonVariants(), className)}
    {...props}
  />
))
AlertDialogAction.displayName = AlertDialogPrimitive.Action.displayName

const AlertDialogCancel = React.forwardRef<
  React.ElementRef<typeof AlertDialogPrimitive.Cancel>,
  React.ComponentPropsWithoutRef<typeof AlertDialogPrimitive.Cancel>
>(({ className, ...props }, ref) => (
  <AlertDialogPrimitive.Cancel
    ref={ref}
    className={cn(
      buttonVariants({ variant: "outline" }),
      "mt-2 sm:mt-0",
      className
    )}
    {...props}
  />
))
AlertDialogCancel.displayName = AlertDialogPrimitive.Cancel.displayName

export {
  AlertDialog,
  AlertDialogPortal,
  AlertDialogOverlay,
  AlertDialogTrigger,
  AlertDialogContent,
  AlertDialogHeader,
  AlertDialogFooter,
  AlertDialogTitle,
  AlertDialogDescription,
  AlertDialogAction,
  AlertDialogCancel,
}
EOF

cat << 'EOF' > src/components/ui/alert.tsx
import * as React from "react"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const alertVariants = cva(
  "relative w-full rounded-lg border p-4 [&>svg~*]:pl-7 [&>svg+div]:translate-y-[-3px] [&>svg]:absolute [&>svg]:left-4 [&>svg]:top-4 [&>svg]:text-foreground",
  {
    variants: {
      variant: {
        default: "bg-background text-foreground",
        destructive:
          "border-destructive/50 text-destructive dark:border-destructive [&>svg]:text-destructive",
      },
    },
    defaultVariants: {
      variant: "default",
    },
  }
)

const Alert = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement> & VariantProps<typeof alertVariants>
>(({ className, variant, ...props }, ref) => (
  <div
    ref={ref}
    role="alert"
    className={cn(alertVariants({ variant }), className)}
    {...props}
  />
))
Alert.displayName = "Alert"

const AlertTitle = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLHeadingElement>
>(({ className, ...props }, ref) => (
  <h5
    ref={ref}
    className={cn("mb-1 font-medium leading-none tracking-tight", className)}
    {...props}
  />
))
AlertTitle.displayName = "AlertTitle"

const AlertDescription = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLParagraphElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn("text-sm [&_p]:leading-relaxed", className)}
    {...props}
  />
))
AlertDescription.displayName = "AlertDescription"

export { Alert, AlertTitle, AlertDescription }
EOF

cat << 'EOF' > src/components/ui/avatar.tsx
"use client"

import * as React from "react"
import * as AvatarPrimitive from "@radix-ui/react-avatar"

import { cn } from "@/lib/utils"

const Avatar = React.forwardRef<
  React.ElementRef<typeof AvatarPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Root>
>(({ className, ...props }, ref) => (
  <AvatarPrimitive.Root
    ref={ref}
    className={cn(
      "relative flex h-10 w-10 shrink-0 overflow-hidden rounded-full",
      className
    )}
    {...props}
  />
))
Avatar.displayName = AvatarPrimitive.Root.displayName

const AvatarImage = React.forwardRef<
  React.ElementRef<typeof AvatarPrimitive.Image>,
  React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Image>
>(({ className, ...props }, ref) => (
  <AvatarPrimitive.Image
    ref={ref}
    className={cn("aspect-square h-full w-full", className)}
    {...props}
  />
))
AvatarImage.displayName = AvatarPrimitive.Image.displayName

const AvatarFallback = React.forwardRef<
  React.ElementRef<typeof AvatarPrimitive.Fallback>,
  React.ComponentPropsWithoutRef<typeof AvatarPrimitive.Fallback>
>(({ className, ...props }, ref) => (
  <AvatarPrimitive.Fallback
    ref={ref}
    className={cn(
      "flex h-full w-full items-center justify-center rounded-full bg-muted",
      className
    )}
    {...props}
  />
))
AvatarFallback.displayName = AvatarPrimitive.Fallback.displayName

export { Avatar, AvatarImage, AvatarFallback }
EOF

cat << 'EOF' > src/components/ui/badge.tsx
import * as React from "react"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const badgeVariants = cva(
  "inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2",
  {
    variants: {
      variant: {
        default:
          "border-transparent bg-primary text-primary-foreground hover:bg-primary/80",
        secondary:
          "border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80",
        destructive:
          "border-transparent bg-destructive text-destructive-foreground hover:bg-destructive/80",
        outline: "text-foreground",
      },
    },
    defaultVariants: {
      variant: "default",
    },
  }
)

export interface BadgeProps
  extends React.HTMLAttributes<HTMLDivElement>,
    VariantProps<typeof badgeVariants> {}

function Badge({ className, variant, ...props }: BadgeProps) {
  return (
    <div className={cn(badgeVariants({ variant }), className)} {...props} />
  )
}

export { Badge, badgeVariants }
EOF

cat << 'EOF' > src/components/ui/button.tsx
import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const buttonVariants = cva(
  "inline-flex items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        destructive:
          "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline:
          "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        secondary:
          "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button"
    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    )
  }
)
Button.displayName = "Button"

export { Button, buttonVariants }
EOF

cat << 'EOF' > src/components/ui/calendar.tsx
"use client"

import * as React from "react"
import { ChevronLeft, ChevronRight } from "lucide-react"
import { DayPicker } from "react-day-picker"

import { cn } from "@/lib/utils"
import { buttonVariants } from "@/components/ui/button"

export type CalendarProps = React.ComponentProps<typeof DayPicker>

function Calendar({
  className,
  classNames,
  showOutsideDays = true,
  ...props
}: CalendarProps) {
  return (
    <DayPicker
      showOutsideDays={showOutsideDays}
      className={cn("p-3", className)}
      classNames={{
        months: "flex flex-col sm:flex-row space-y-4 sm:space-x-4 sm:space-y-0",
        month: "space-y-4",
        caption: "flex justify-center pt-1 relative items-center",
        caption_label: "text-sm font-medium",
        nav: "space-x-1 flex items-center",
        nav_button: cn(
          buttonVariants({ variant: "outline" }),
          "h-7 w-7 bg-transparent p-0 opacity-50 hover:opacity-100"
        ),
        nav_button_previous: "absolute left-1",
        nav_button_next: "absolute right-1",
        table: "w-full border-collapse space-y-1",
        head_row: "flex",
        head_cell:
          "text-muted-foreground rounded-md w-9 font-normal text-[0.8rem]",
        row: "flex w-full mt-2",
        cell: "h-9 w-9 text-center text-sm p-0 relative [&:has([aria-selected].day-range-end)]:rounded-r-md [&:has([aria-selected].day-outside)]:bg-accent/50 [&:has([aria-selected])]:bg-accent first:[&:has([aria-selected])]:rounded-l-md last:[&:has([aria-selected])]:rounded-r-md focus-within:relative focus-within:z-20",
        day: cn(
          buttonVariants({ variant: "ghost" }),
          "h-9 w-9 p-0 font-normal aria-selected:opacity-100"
        ),
        day_range_end: "day-range-end",
        day_selected:
          "bg-primary text-primary-foreground hover:bg-primary hover:text-primary-foreground focus:bg-primary focus:text-primary-foreground",
        day_today: "bg-accent text-accent-foreground",
        day_outside:
          "day-outside text-muted-foreground aria-selected:bg-accent/50 aria-selected:text-muted-foreground",
        day_disabled: "text-muted-foreground opacity-50",
        day_range_middle:
          "aria-selected:bg-accent aria-selected:text-accent-foreground",
        day_hidden: "invisible",
        ...classNames,
      }}
      components={{
        IconLeft: ({ className, ...props }) => (
          <ChevronLeft className={cn("h-4 w-4", className)} {...props} />
        ),
        IconRight: ({ className, ...props }) => (
          <ChevronRight className={cn("h-4 w-4", className)} {...props} />
        ),
      }}
      {...props}
    />
  )
}
Calendar.displayName = "Calendar"

export { Calendar }
EOF

cat << 'EOF' > src/components/ui/card.tsx
import * as React from "react"

import { cn } from "@/lib/utils"

const Card = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn(
      "rounded-lg border bg-card text-card-foreground shadow-sm",
      className
    )}
    {...props}
  />
))
Card.displayName = "Card"

const CardHeader = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn("flex flex-col space-y-1.5 p-6", className)}
    {...props}
  />
))
CardHeader.displayName = "CardHeader"

const CardTitle = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn(
      "text-2xl font-semibold leading-none tracking-tight",
      className
    )}
    {...props}
  />
))
CardTitle.displayName = "CardTitle"

const CardDescription = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn("text-sm text-muted-foreground", className)}
    {...props}
  />
))
CardDescription.displayName = "CardDescription"

const CardContent = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div ref={ref} className={cn("p-6 pt-0", className)} {...props} />
))
CardContent.displayName = "CardContent"

const CardFooter = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    className={cn("flex items-center p-6 pt-0", className)}
    {...props}
  />
))
CardFooter.displayName = "CardFooter"

export { Card, CardHeader, CardFooter, CardTitle, CardDescription, CardContent }
EOF

cat << 'EOF' > src/components/ui/carousel.tsx
"use client"

import * as React from "react"
import useEmblaCarousel, {
  type UseEmblaCarouselType,
} from "embla-carousel-react"
import { ArrowLeft, ArrowRight } from "lucide-react"

import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"

type CarouselApi = UseEmblaCarouselType[1]
type UseCarouselParameters = Parameters<typeof useEmblaCarousel>
type CarouselOptions = UseCarouselParameters[0]
type CarouselPlugin = UseCarouselParameters[1]

type CarouselProps = {
  opts?: CarouselOptions
  plugins?: CarouselPlugin
  orientation?: "horizontal" | "vertical"
  setApi?: (api: CarouselApi) => void
}

type CarouselContextProps = {
  carouselRef: ReturnType<typeof useEmblaCarousel>[0]
  api: ReturnType<typeof useEmblaCarousel>[1]
  scrollPrev: () => void
  scrollNext: () => void
  canScrollPrev: boolean
  canScrollNext: boolean
} & CarouselProps

const CarouselContext = React.createContext<CarouselContextProps | null>(null)

function useCarousel() {
  const context = React.useContext(CarouselContext)

  if (!context) {
    throw new Error("useCarousel must be used within a <Carousel />")
  }

  return context
}

const Carousel = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement> & CarouselProps
>(
  (
    {
      orientation = "horizontal",
      opts,
      setApi,
      plugins,
      className,
      children,
      ...props
    },
    ref
  ) => {
    const [carouselRef, api] = useEmblaCarousel(
      {
        ...opts,
        axis: orientation === "horizontal" ? "x" : "y",
      },
      plugins
    )
    const [canScrollPrev, setCanScrollPrev] = React.useState(false)
    const [canScrollNext, setCanScrollNext] = React.useState(false)

    const onSelect = React.useCallback((api: CarouselApi) => {
      if (!api) {
        return
      }

      setCanScrollPrev(api.canScrollPrev())
      setCanScrollNext(api.canScrollNext())
    }, [])

    const scrollPrev = React.useCallback(() => {
      api?.scrollPrev()
    }, [api])

    const scrollNext = React.useCallback(() => {
      api?.scrollNext()
    }, [api])

    const handleKeyDown = React.useCallback(
      (event: React.KeyboardEvent<HTMLDivElement>) => {
        if (event.key === "ArrowLeft") {
          event.preventDefault()
          scrollPrev()
        } else if (event.key === "ArrowRight") {
          event.preventDefault()
          scrollNext()
        }
      },
      [scrollPrev, scrollNext]
    )

    React.useEffect(() => {
      if (!api || !setApi) {
        return
      }

      setApi(api)
    }, [api, setApi])

    React.useEffect(() => {
      if (!api) {
        return
      }

      onSelect(api)
      api.on("reInit", onSelect)
      api.on("select", onSelect)

      return () => {
        api?.off("select", onSelect)
      }
    }, [api, onSelect])

    return (
      <CarouselContext.Provider
        value={{
          carouselRef,
          api: api,
          opts,
          orientation:
            orientation || (opts?.axis === "y" ? "vertical" : "horizontal"),
          scrollPrev,
          scrollNext,
          canScrollPrev,
          canScrollNext,
        }}
      >
        <div
          ref={ref}
          onKeyDownCapture={handleKeyDown}
          className={cn("relative", className)}
          role="region"
          aria-roledescription="carousel"
          {...props}
        >
          {children}
        </div>
      </CarouselContext.Provider>
    )
  }
)
Carousel.displayName = "Carousel"

const CarouselContent = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => {
  const { carouselRef, orientation } = useCarousel()

  return (
    <div ref={carouselRef} className="overflow-hidden">
      <div
        ref={ref}
        className={cn(
          "flex",
          orientation === "horizontal" ? "-ml-4" : "-mt-4 flex-col",
          className
        )}
        {...props}
      />
    </div>
  )
})
CarouselContent.displayName = "CarouselContent"

const CarouselItem = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => {
  const { orientation } = useCarousel()

  return (
    <div
      ref={ref}
      role="group"
      aria-roledescription="slide"
      className={cn(
        "min-w-0 shrink-0 grow-0 basis-full",
        orientation === "horizontal" ? "pl-4" : "pt-4",
        className
      )}
      {...props}
    />
  )
})
CarouselItem.displayName = "CarouselItem"

const CarouselPrevious = React.forwardRef<
  HTMLButtonElement,
  React.ComponentProps<typeof Button>
>(({ className, variant = "outline", size = "icon", ...props }, ref) => {
  const { orientation, scrollPrev, canScrollPrev } = useCarousel()

  return (
    <Button
      ref={ref}
      variant={variant}
      size={size}
      className={cn(
        "absolute  h-8 w-8 rounded-full",
        orientation === "horizontal"
          ? "-left-12 top-1/2 -translate-y-1/2"
          : "-top-12 left-1/2 -translate-x-1/2 rotate-90",
        className
      )}
      disabled={!canScrollPrev}
      onClick={scrollPrev}
      {...props}
    >
      <ArrowLeft className="h-4 w-4" />
      <span className="sr-only">Previous slide</span>
    </Button>
  )
})
CarouselPrevious.displayName = "CarouselPrevious"

const CarouselNext = React.forwardRef<
  HTMLButtonElement,
  React.ComponentProps<typeof Button>
>(({ className, variant = "outline", size = "icon", ...props }, ref) => {
  const { orientation, scrollNext, canScrollNext } = useCarousel()

  return (
    <Button
      ref={ref}
      variant={variant}
      size={size}
      className={cn(
        "absolute h-8 w-8 rounded-full",
        orientation === "horizontal"
          ? "-right-12 top-1/2 -translate-y-1/2"
          : "-bottom-12 left-1/2 -translate-x-1/2 rotate-90",
        className
      )}
      disabled={!canScrollNext}
      onClick={scrollNext}
      {...props}
    >
      <ArrowRight className="h-4 w-4" />
      <span className="sr-only">Next slide</span>
    </Button>
  )
})
CarouselNext.displayName = "CarouselNext"

export {
  type CarouselApi,
  Carousel,
  CarouselContent,
  CarouselItem,
  CarouselPrevious,
  CarouselNext,
}
EOF

cat << 'EOF' > src/components/ui/chart.tsx
"use client"

import * as React from "react"
import * as RechartsPrimitive from "recharts"

import { cn } from "@/lib/utils"

// Format: { THEME_NAME: CSS_SELECTOR }
const THEMES = { light: "", dark: ".dark" } as const

export type ChartConfig = {
  [k in string]: {
    label?: React.ReactNode
    icon?: React.ComponentType
  } & (
    | { color?: string; theme?: never }
    | { color?: never; theme: Record<keyof typeof THEMES, string> }
  )
}

type ChartContextProps = {
  config: ChartConfig
}

const ChartContext = React.createContext<ChartContextProps | null>(null)

function useChart() {
  const context = React.useContext(ChartContext)

  if (!context) {
    throw new Error("useChart must be used within a <ChartContainer />")
  }

  return context
}

const ChartContainer = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div"> & {
    config: ChartConfig
    children: React.ComponentProps<
      typeof RechartsPrimitive.ResponsiveContainer
    >["children"]
  }
>(({ id, className, children, config, ...props }, ref) => {
  const uniqueId = React.useId()
  const chartId = `chart-${id || uniqueId.replace(/:/g, "")}`

  return (
    <ChartContext.Provider value={{ config }}>
      <div
        data-chart={chartId}
        ref={ref}
        className={cn(
          "flex aspect-video justify-center text-xs [&_.recharts-cartesian-axis-tick_text]:fill-muted-foreground [&_.recharts-cartesian-grid_line[stroke='#ccc']]:stroke-border/50 [&_.recharts-curve.recharts-tooltip-cursor]:stroke-border [&_.recharts-dot[stroke='#fff']]:stroke-transparent [&_.recharts-layer]:outline-none [&_.recharts-polar-grid_[stroke='#ccc']]:stroke-border [&_.recharts-radial-bar-background-sector]:fill-muted [&_.recharts-rectangle.recharts-tooltip-cursor]:fill-muted [&_.recharts-reference-line_[stroke='#ccc']]:stroke-border [&_.recharts-sector[stroke='#fff']]:stroke-transparent [&_.recharts-sector]:outline-none [&_.recharts-surface]:outline-none",
          className
        )}
        {...props}
      >
        <ChartStyle id={chartId} config={config} />
        <RechartsPrimitive.ResponsiveContainer>
          {children}
        </RechartsPrimitive.ResponsiveContainer>
      </div>
    </ChartContext.Provider>
  )
})
ChartContainer.displayName = "Chart"

const ChartStyle = ({ id, config }: { id: string; config: ChartConfig }) => {
  const colorConfig = Object.entries(config).filter(
    ([, config]) => config.theme || config.color
  )

  if (!colorConfig.length) {
    return null
  }

  return (
    <style
      dangerouslySetInnerHTML={{
        __html: Object.entries(THEMES)
          .map(
            ([theme, prefix]) => `
${prefix} [data-chart=${id}] {
${colorConfig
  .map(([key, itemConfig]) => {
    const color =
      itemConfig.theme?.[theme as keyof typeof itemConfig.theme] ||
      itemConfig.color
    return color ? `  --color-${key}: ${color};` : null
  })
  .join("\n")}
}
`
          )
          .join("\n"),
      }}
    />
  )
}

const ChartTooltip = RechartsPrimitive.Tooltip

const ChartTooltipContent = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<typeof RechartsPrimitive.Tooltip> &
    React.ComponentProps<"div"> & {
      hideLabel?: boolean
      hideIndicator?: boolean
      indicator?: "line" | "dot" | "dashed"
      nameKey?: string
      labelKey?: string
    }
>(
  (
    {
      active,
      payload,
      className,
      indicator = "dot",
      hideLabel = false,
      hideIndicator = false,
      label,
      labelFormatter,
      labelClassName,
      formatter,
      color,
      nameKey,
      labelKey,
    },
    ref
  ) => {
    const { config } = useChart()

    const tooltipLabel = React.useMemo(() => {
      if (hideLabel || !payload?.length) {
        return null
      }

      const [item] = payload
      const key = `${labelKey || item.dataKey || item.name || "value"}`
      const itemConfig = getPayloadConfigFromPayload(config, item, key)
      const value =
        !labelKey && typeof label === "string"
          ? config[label as keyof typeof config]?.label || label
          : itemConfig?.label

      if (labelFormatter) {
        return (
          <div className={cn("font-medium", labelClassName)}>
            {labelFormatter(value, payload)}
          </div>
        )
      }

      if (!value) {
        return null
      }

      return <div className={cn("font-medium", labelClassName)}>{value}</div>
    }, [
      label,
      labelFormatter,
      payload,
      hideLabel,
      labelClassName,
      config,
      labelKey,
    ])

    if (!active || !payload?.length) {
      return null
    }

    const nestLabel = payload.length === 1 && indicator !== "dot"

    return (
      <div
        ref={ref}
        className={cn(
          "grid min-w-[8rem] items-start gap-1.5 rounded-lg border border-border/50 bg-background px-2.5 py-1.5 text-xs shadow-xl",
          className
        )}
      >
        {!nestLabel ? tooltipLabel : null}
        <div className="grid gap-1.5">
          {payload.map((item, index) => {
            const key = `${nameKey || item.name || item.dataKey || "value"}`
            const itemConfig = getPayloadConfigFromPayload(config, item, key)
            const indicatorColor = color || item.payload.fill || item.color

            return (
              <div
                key={item.dataKey}
                className={cn(
                  "flex w-full flex-wrap items-stretch gap-2 [&>svg]:h-2.5 [&>svg]:w-2.5 [&>svg]:text-muted-foreground",
                  indicator === "dot" && "items-center"
                )}
              >
                {formatter && item?.value !== undefined && item.name ? (
                  formatter(item.value, item.name, item, index, item.payload)
                ) : (
                  <>
                    {itemConfig?.icon ? (
                      <itemConfig.icon />
                    ) : (
                      !hideIndicator && (
                        <div
                          className={cn(
                            "shrink-0 rounded-[2px] border-[--color-border] bg-[--color-bg]",
                            {
                              "h-2.5 w-2.5": indicator === "dot",
                              "w-1": indicator === "line",
                              "w-0 border-[1.5px] border-dashed bg-transparent":
                                indicator === "dashed",
                              "my-0.5": nestLabel && indicator === "dashed",
                            }
                          )}
                          style={
                            {
                              "--color-bg": indicatorColor,
                              "--color-border": indicatorColor,
                            } as React.CSSProperties
                          }
                        />
                      )
                    )}
                    <div
                      className={cn(
                        "flex flex-1 justify-between leading-none",
                        nestLabel ? "items-end" : "items-center"
                      )}
                    >
                      <div className="grid gap-1.5">
                        {nestLabel ? tooltipLabel : null}
                        <span className="text-muted-foreground">
                          {itemConfig?.label || item.name}
                        </span>
                      </div>
                      {item.value && (
                        <span className="font-mono font-medium tabular-nums text-foreground">
                          {item.value.toLocaleString()}
                        </span>
                      )}
                    </div>
                  </>
                )}
              </div>
            )
          })}
        </div>
      </div>
    )
  }
)
ChartTooltipContent.displayName = "ChartTooltip"

const ChartLegend = RechartsPrimitive.Legend

const ChartLegendContent = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div"> &
    Pick<RechartsPrimitive.LegendProps, "payload" | "verticalAlign"> & {
      hideIcon?: boolean
      nameKey?: string
    }
>(
  (
    { className, hideIcon = false, payload, verticalAlign = "bottom", nameKey },
    ref
  ) => {
    const { config } = useChart()

    if (!payload?.length) {
      return null
    }

    return (
      <div
        ref={ref}
        className={cn(
          "flex items-center justify-center gap-4",
          verticalAlign === "top" ? "pb-3" : "pt-3",
          className
        )}
      >
        {payload.map((item) => {
          const key = `${nameKey || item.dataKey || "value"}`
          const itemConfig = getPayloadConfigFromPayload(config, item, key)

          return (
            <div
              key={item.value}
              className={cn(
                "flex items-center gap-1.5 [&>svg]:h-3 [&>svg]:w-3 [&>svg]:text-muted-foreground"
              )}
            >
              {itemConfig?.icon && !hideIcon ? (
                <itemConfig.icon />
              ) : (
                <div
                  className="h-2 w-2 shrink-0 rounded-[2px]"
                  style={{
                    backgroundColor: item.color,
                  }}
                />
              )}
              {itemConfig?.label}
            </div>
          )
        })}
      </div>
    )
  }
)
ChartLegendContent.displayName = "ChartLegend"

// Helper to extract item config from a payload.
function getPayloadConfigFromPayload(
  config: ChartConfig,
  payload: unknown,
  key: string
) {
  if (typeof payload !== "object" || payload === null) {
    return undefined
  }

  const payloadPayload =
    "payload" in payload &&
    typeof payload.payload === "object" &&
    payload.payload !== null
      ? payload.payload
      : undefined

  let configLabelKey: string = key

  if (
    key in payload &&
    typeof payload[key as keyof typeof payload] === "string"
  ) {
    configLabelKey = payload[key as keyof typeof payload] as string
  } else if (
    payloadPayload &&
    key in payloadPayload &&
    typeof payloadPayload[key as keyof typeof payloadPayload] === "string"
  ) {
    configLabelKey = payloadPayload[
      key as keyof typeof payloadPayload
    ] as string
  }

  return configLabelKey in config
    ? config[configLabelKey]
    : config[key as keyof typeof config]
}

export {
  ChartContainer,
  ChartTooltip,
  ChartTooltipContent,
  ChartLegend,
  ChartLegendContent,
  ChartStyle,
}
EOF

cat << 'EOF' > src/components/ui/checkbox.tsx
"use client"

import * as React from "react"
import * as CheckboxPrimitive from "@radix-ui/react-checkbox"
import { Check } from "lucide-react"

import { cn } from "@/lib/utils"

const Checkbox = React.forwardRef<
  React.ElementRef<typeof CheckboxPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof CheckboxPrimitive.Root>
>(({ className, ...props }, ref) => (
  <CheckboxPrimitive.Root
    ref={ref}
    className={cn(
      "peer h-4 w-4 shrink-0 rounded-sm border border-primary ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=checked]:text-primary-foreground",
      className
    )}
    {...props}
  >
    <CheckboxPrimitive.Indicator
      className={cn("flex items-center justify-center text-current")}
    >
      <Check className="h-4 w-4" />
    </CheckboxPrimitive.Indicator>
  </CheckboxPrimitive.Root>
))
Checkbox.displayName = CheckboxPrimitive.Root.displayName

export { Checkbox }
EOF

cat << 'EOF' > src/components/ui/collapsible.tsx
"use client"

import * as CollapsiblePrimitive from "@radix-ui/react-collapsible"

const Collapsible = CollapsiblePrimitive.Root

const CollapsibleTrigger = CollapsiblePrimitive.CollapsibleTrigger

const CollapsibleContent = CollapsiblePrimitive.CollapsibleContent

export { Collapsible, CollapsibleTrigger, CollapsibleContent }
EOF

cat << 'EOF' > src/components/ui/dialog.tsx
"use client"

import * as React from "react"
import * as DialogPrimitive from "@radix-ui/react-dialog"
import { X } from "lucide-react"

import { cn } from "@/lib/utils"

const Dialog = DialogPrimitive.Root

const DialogTrigger = DialogPrimitive.Trigger

const DialogPortal = DialogPrimitive.Portal

const DialogClose = DialogPrimitive.Close

const DialogOverlay = React.forwardRef<
  React.ElementRef<typeof DialogPrimitive.Overlay>,
  React.ComponentPropsWithoutRef<typeof DialogPrimitive.Overlay>
>(({ className, ...props }, ref) => (
  <DialogPrimitive.Overlay
    ref={ref}
    className={cn(
      "fixed inset-0 z-50 bg-black/80 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
      className
    )}
    {...props}
  />
))
DialogOverlay.displayName = DialogPrimitive.Overlay.displayName

const DialogContent = React.forwardRef<
  React.ElementRef<typeof DialogPrimitive.Content>,
  React.ComponentPropsWithoutRef<typeof DialogPrimitive.Content>
>(({ className, children, ...props }, ref) => (
  <DialogPortal>
    <DialogOverlay />
    <DialogPrimitive.Content
      ref={ref}
      className={cn(
        "fixed left-[50%] top-[50%] z-50 grid w-full max-w-lg translate-x-[-50%] translate-y-[-50%] gap-4 border bg-background p-6 shadow-lg duration-200 data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[state=closed]:slide-out-to-left-1/2 data-[state=closed]:slide-out-to-top-[48%] data-[state=open]:slide-in-from-left-1/2 data-[state=open]:slide-in-from-top-[48%] sm:rounded-lg",
        className
      )}
      {...props}
    >
      {children}
      <DialogPrimitive.Close className="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-accent data-[state=open]:text-muted-foreground">
        <X className="h-4 w-4" />
        <span className="sr-only">Close</span>
      </DialogPrimitive.Close>
    </DialogPrimitive.Content>
  </DialogPortal>
))
DialogContent.displayName = DialogPrimitive.Content.displayName

const DialogHeader = ({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) => (
  <div
    className={cn(
      "flex flex-col space-y-1.5 text-center sm:text-left",
      className
    )}
    {...props}
  />
)
DialogHeader.displayName = "DialogHeader"

const DialogFooter = ({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) => (
  <div
    className={cn(
      "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
      className
    )}
    {...props}
  />
)
DialogFooter.displayName = "DialogFooter"

const DialogTitle = React.forwardRef<
  React.ElementRef<typeof DialogPrimitive.Title>,
  React.ComponentPropsWithoutRef<typeof DialogPrimitive.Title>
>(({ className, ...props }, ref) => (
  <DialogPrimitive.Title
    ref={ref}
    className={cn(
      "text-lg font-semibold leading-none tracking-tight",
      className
    )}
    {...props}
  />
))
DialogTitle.displayName = DialogPrimitive.Title.displayName

const DialogDescription = React.forwardRef<
  React.ElementRef<typeof DialogPrimitive.Description>,
  React.ComponentPropsWithoutRef<typeof DialogPrimitive.Description>
>(({ className, ...props }, ref) => (
  <DialogPrimitive.Description
    ref={ref}
    className={cn("text-sm text-muted-foreground", className)}
    {...props}
  />
))
DialogDescription.displayName = DialogPrimitive.Description.displayName

export {
  Dialog,
  DialogPortal,
  DialogOverlay,
  DialogClose,
  DialogTrigger,
  DialogContent,
  DialogHeader,
  DialogFooter,
  DialogTitle,
  DialogDescription,
}
EOF

cat << 'EOF' > src/components/ui/dropdown-menu.tsx
"use client"

import * as React from "react"
import * as DropdownMenuPrimitive from "@radix-ui/react-dropdown-menu"
import { Check, ChevronRight, Circle } from "lucide-react"

import { cn } from "@/lib/utils"

const DropdownMenu = DropdownMenuPrimitive.Root

const DropdownMenuTrigger = DropdownMenuPrimitive.Trigger

const DropdownMenuGroup = DropdownMenuPrimitive.Group

const DropdownMenuPortal = DropdownMenuPrimitive.Portal

const DropdownMenuSub = DropdownMenuPrimitive.Sub

const DropdownMenuRadioGroup = DropdownMenuPrimitive.RadioGroup

const DropdownMenuSubTrigger = React.forwardRef<
  React.ElementRef<typeof DropdownMenuPrimitive.SubTrigger>,
  React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.SubTrigger> & {
    inset?: boolean
  }
>(({ className, inset, children, ...props }, ref) => (
  <DropdownMenuPrimitive.SubTrigger
    ref={ref}
    className={cn(
      "flex cursor-default gap-2 select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent data-[state=open]:bg-accent [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
      inset && "pl-8",
      className
    )}
    {...props}
  >
    {children}
    <ChevronRight className="ml-auto" />
  </DropdownMenuPrimitive.SubTrigger>
))
DropdownMenuSubTrigger.displayName =
  DropdownMenuPrimitive.SubTrigger.displayName

const DropdownMenuSubContent = React.forwardRef<
  React.ElementRef<typeof DropdownMenuPrimitive.SubContent>,
  React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.SubContent>
>(({ className, ...props }, ref) => (
  <DropdownMenuPrimitive.SubContent
    ref={ref}
    className={cn(
      "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-lg data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
      className
    )}
    {...props}
  />
))
DropdownMenuSubContent.displayName =
  DropdownMenuPrimitive.SubContent.displayName

const DropdownMenuContent = React.forwardRef<
  React.ElementRef<typeof DropdownMenuPrimitive.Content>,
  React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.Content>
>(({ className, sideOffset = 4, ...props }, ref) => (
  <DropdownMenuPrimitive.Portal>
    <DropdownMenuPrimitive.Content
      ref={ref}
      sideOffset={sideOffset}
      className={cn(
        "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
        className
      )}
      {...props}
    />
  </DropdownMenuPrimitive.Portal>
))
DropdownMenuContent.displayName = DropdownMenuPrimitive.Content.displayName

const DropdownMenuItem = React.forwardRef<
  React.ElementRef<typeof DropdownMenuPrimitive.Item>,
  React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.Item> & {
    inset?: boolean
  }
>(({ className, inset, ...props }, ref) => (
  <DropdownMenuPrimitive.Item
    ref={ref}
    className={cn(
      "relative flex cursor-default select-none items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 [&_svg]:pointer-events-none [&_svg]:size-4 [&_svg]:shrink-0",
      inset && "pl-8",
      className
    )}
    {...props}
  />
))
DropdownMenuItem.displayName = DropdownMenuPrimitive.Item.displayName

const DropdownMenuCheckboxItem = React.forwardRef<
  React.ElementRef<typeof DropdownMenuPrimitive.CheckboxItem>,
  React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.CheckboxItem>
>(({ className, children, checked, ...props }, ref) => (
  <DropdownMenuPrimitive.CheckboxItem
    ref={ref}
    className={cn(
      "relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
      className
    )}
    checked={checked}
    {...props}
  >
    <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
      <DropdownMenuPrimitive.ItemIndicator>
        <Check className="h-4 w-4" />
      </DropdownMenuPrimitive.ItemIndicator>
    </span>
    {children}
  </DropdownMenuPrimitive.CheckboxItem>
))
DropdownMenuCheckboxItem.displayName =
  DropdownMenuPrimitive.CheckboxItem.displayName

const DropdownMenuRadioItem = React.forwardRef<
  React.ElementRef<typeof DropdownMenuPrimitive.RadioItem>,
  React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.RadioItem>
>(({ className, children, ...props }, ref) => (
  <DropdownMenuPrimitive.RadioItem
    ref={ref}
    className={cn(
      "relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none transition-colors focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
      className
    )}
    {...props}
  >
    <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
      <DropdownMenuPrimitive.ItemIndicator>
        <Circle className="h-2 w-2 fill-current" />
      </DropdownMenuPrimitive.ItemIndicator>
    </span>
    {children}
  </DropdownMenuPrimitive.RadioItem>
))
DropdownMenuRadioItem.displayName = DropdownMenuPrimitive.RadioItem.displayName

const DropdownMenuLabel = React.forwardRef<
  React.ElementRef<typeof DropdownMenuPrimitive.Label>,
  React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.Label> & {
    inset?: boolean
  }
>(({ className, inset, ...props }, ref) => (
  <DropdownMenuPrimitive.Label
    ref={ref}
    className={cn(
      "px-2 py-1.5 text-sm font-semibold",
      inset && "pl-8",
      className
    )}
    {...props}
  />
))
DropdownMenuLabel.displayName = DropdownMenuPrimitive.Label.displayName

const DropdownMenuSeparator = React.forwardRef<
  React.ElementRef<typeof DropdownMenuPrimitive.Separator>,
  React.ComponentPropsWithoutRef<typeof DropdownMenuPrimitive.Separator>
>(({ className, ...props }, ref) => (
  <DropdownMenuPrimitive.Separator
    ref={ref}
    className={cn("-mx-1 my-1 h-px bg-muted", className)}
    {...props}
  />
))
DropdownMenuSeparator.displayName = DropdownMenuPrimitive.Separator.displayName

const DropdownMenuShortcut = ({
  className,
  ...props
}: React.HTMLAttributes<HTMLSpanElement>) => {
  return (
    <span
      className={cn("ml-auto text-xs tracking-widest opacity-60", className)}
      {...props}
    />
  )
}
DropdownMenuShortcut.displayName = "DropdownMenuShortcut"

export {
  DropdownMenu,
  DropdownMenuTrigger,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuCheckboxItem,
  DropdownMenuRadioItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuShortcut,
  DropdownMenuGroup,
  DropdownMenuPortal,
  DropdownMenuSub,
  DropdownMenuSubContent,
  DropdownMenuSubTrigger,
  DropdownMenuRadioGroup,
}
EOF

cat << 'EOF' > src/components/ui/form.tsx
"use client"

import * as React from "react"
import * as LabelPrimitive from "@radix-ui/react-label"
import { Slot } from "@radix-ui/react-slot"
import {
  Controller,
  FormProvider,
  useFormContext,
  type ControllerProps,
  type FieldPath,
  type FieldValues,
} from "react-hook-form"

import { cn } from "@/lib/utils"
import { Label } from "@/components/ui/label"

const Form = FormProvider

type FormFieldContextValue<
  TFieldValues extends FieldValues = FieldValues,
  TName extends FieldPath<TFieldValues> = FieldPath<TFieldValues>
> = {
  name: TName
}

const FormFieldContext = React.createContext<FormFieldContextValue>(
  {} as FormFieldContextValue
)

const FormField = <
  TFieldValues extends FieldValues = FieldValues,
  TName extends FieldPath<TFieldValues> = FieldPath<TFieldValues>
>({
  ...props
}: ControllerProps<TFieldValues, TName>) => {
  return (
    <FormFieldContext.Provider value={{ name: props.name }}>
      <Controller {...props} />
    </FormFieldContext.Provider>
  )
}

const useFormField = () => {
  const fieldContext = React.useContext(FormFieldContext)
  const itemContext = React.useContext(FormItemContext)
  const { getFieldState, formState } = useFormContext()

  const fieldState = getFieldState(fieldContext.name, formState)

  if (!fieldContext) {
    throw new Error("useFormField should be used within <FormField>")
  }

  const { id } = itemContext

  return {
    id,
    name: fieldContext.name,
    formItemId: `${id}-form-item`,
    formDescriptionId: `${id}-form-item-description`,
    formMessageId: `${id}-form-item-message`,
    ...fieldState,
  }
}

type FormItemContextValue = {
  id: string
}

const FormItemContext = React.createContext<FormItemContextValue>(
  {} as FormItemContextValue
)

const FormItem = React.forwardRef<
  HTMLDivElement,
  React.HTMLAttributes<HTMLDivElement>
>(({ className, ...props }, ref) => {
  const id = React.useId()

  return (
    <FormItemContext.Provider value={{ id }}>
      <div ref={ref} className={cn("space-y-2", className)} {...props} />
    </FormItemContext.Provider>
  )
})
FormItem.displayName = "FormItem"

const FormLabel = React.forwardRef<
  React.ElementRef<typeof LabelPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof LabelPrimitive.Root>
>(({ className, ...props }, ref) => {
  const { error, formItemId } = useFormField()

  return (
    <Label
      ref={ref}
      className={cn(error && "text-destructive", className)}
      htmlFor={formItemId}
      {...props}
    />
  )
})
FormLabel.displayName = "FormLabel"

const FormControl = React.forwardRef<
  React.ElementRef<typeof Slot>,
  React.ComponentPropsWithoutRef<typeof Slot>
>(({ ...props }, ref) => {
  const { error, formItemId, formDescriptionId, formMessageId } = useFormField()

  return (
    <Slot
      ref={ref}
      id={formItemId}
      aria-describedby={
        !error
          ? `${formDescriptionId}`
          : `${formDescriptionId} ${formMessageId}`
      }
      aria-invalid={!!error}
      {...props}
    />
  )
})
FormControl.displayName = "FormControl"

const FormDescription = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLParagraphElement>
>(({ className, ...props }, ref) => {
  const { formDescriptionId } = useFormField()

  return (
    <p
      ref={ref}
      id={formDescriptionId}
      className={cn("text-sm text-muted-foreground", className)}
      {...props}
    />
  )
})
FormDescription.displayName = "FormDescription"

const FormMessage = React.forwardRef<
  HTMLParagraphElement,
  React.HTMLAttributes<HTMLParagraphElement>
>(({ className, children, ...props }, ref) => {
  const { error, formMessageId } = useFormField()
  const body = error ? String(error?.message ?? "") : children

  if (!body) {
    return null
  }

  return (
    <p
      ref={ref}
      id={formMessageId}
      className={cn("text-sm font-medium text-destructive", className)}
      {...props}
    >
      {body}
    </p>
  )
})
FormMessage.displayName = "FormMessage"

export {
  useFormField,
  Form,
  FormItem,
  FormLabel,
  FormControl,
  FormDescription,
  FormMessage,
  FormField,
}
EOF

cat << 'EOF' > src/components/ui/input.tsx
import * as React from "react"

import { cn } from "@/lib/utils"

const Input = React.forwardRef<HTMLInputElement, React.ComponentProps<"input">>(
  ({ className, type, ...props }, ref) => {
    return (
      <input
        type={type}
        className={cn(
          "flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm",
          className
        )}
        ref={ref}
        {...props}
      />
    )
  }
)
Input.displayName = "Input"

export { Input }
EOF

cat << 'EOF' > src/components/ui/label.tsx
"use client"

import * as React from "react"
import * as LabelPrimitive from "@radix-ui/react-label"
import { cva, type VariantProps } from "class-variance-authority"

import { cn } from "@/lib/utils"

const labelVariants = cva(
  "text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70"
)

const Label = React.forwardRef<
  React.ElementRef<typeof LabelPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof LabelPrimitive.Root> &
    VariantProps<typeof labelVariants>
>(({ className, ...props }, ref) => (
  <LabelPrimitive.Root
    ref={ref}
    className={cn(labelVariants(), className)}
    {...props}
  />
))
Label.displayName = LabelPrimitive.Root.displayName

export { Label }
EOF

cat << 'EOF' > src/components/ui/menubar.tsx
"use client"

import * as React from "react"
import * as MenubarPrimitive from "@radix-ui/react-menubar"
import { Check, ChevronRight, Circle } from "lucide-react"

import { cn } from "@/lib/utils"

function MenubarMenu({
  ...props
}: React.ComponentProps<typeof MenubarPrimitive.Menu>) {
  return <MenubarPrimitive.Menu {...props} />
}

function MenubarGroup({
  ...props
}: React.ComponentProps<typeof MenubarPrimitive.Group>) {
  return <MenubarPrimitive.Group {...props} />
}

function MenubarPortal({
  ...props
}: React.ComponentProps<typeof MenubarPrimitive.Portal>) {
  return <MenubarPrimitive.Portal {...props} />
}

function MenubarRadioGroup({
  ...props
}: React.ComponentProps<typeof MenubarPrimitive.RadioGroup>) {
  return <MenubarPrimitive.RadioGroup {...props} />
}

function MenubarSub({
  ...props
}: React.ComponentProps<typeof MenubarPrimitive.Sub>) {
  return <MenubarPrimitive.Sub data-slot="menubar-sub" {...props} />
}

const Menubar = React.forwardRef<
  React.ElementRef<typeof MenubarPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof MenubarPrimitive.Root>
>(({ className, ...props }, ref) => (
  <MenubarPrimitive.Root
    ref={ref}
    className={cn(
      "flex h-10 items-center space-x-1 rounded-md border bg-background p-1",
      className
    )}
    {...props}
  />
))
Menubar.displayName = MenubarPrimitive.Root.displayName

const MenubarTrigger = React.forwardRef<
  React.ElementRef<typeof MenubarPrimitive.Trigger>,
  React.ComponentPropsWithoutRef<typeof MenubarPrimitive.Trigger>
>(({ className, ...props }, ref) => (
  <MenubarPrimitive.Trigger
    ref={ref}
    className={cn(
      "flex cursor-default select-none items-center rounded-sm px-3 py-1.5 text-sm font-medium outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground",
      className
    )}
    {...props}
  />
))
MenubarTrigger.displayName = MenubarPrimitive.Trigger.displayName

const MenubarSubTrigger = React.forwardRef<
  React.ElementRef<typeof MenubarPrimitive.SubTrigger>,
  React.ComponentPropsWithoutRef<typeof MenubarPrimitive.SubTrigger> & {
    inset?: boolean
  }
>(({ className, inset, children, ...props }, ref) => (
  <MenubarPrimitive.SubTrigger
    ref={ref}
    className={cn(
      "flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[state=open]:bg-accent data-[state=open]:text-accent-foreground",
      inset && "pl-8",
      className
    )}
    {...props}
  >
    {children}
    <ChevronRight className="ml-auto h-4 w-4" />
  </MenubarPrimitive.SubTrigger>
))
MenubarSubTrigger.displayName = MenubarPrimitive.SubTrigger.displayName

const MenubarSubContent = React.forwardRef<
  React.ElementRef<typeof MenubarPrimitive.SubContent>,
  React.ComponentPropsWithoutRef<typeof MenubarPrimitive.SubContent>
>(({ className, ...props }, ref) => (
  <MenubarPrimitive.SubContent
    ref={ref}
    className={cn(
      "z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
      className
    )}
    {...props}
  />
))
MenubarSubContent.displayName = MenubarPrimitive.SubContent.displayName

const MenubarContent = React.forwardRef<
  React.ElementRef<typeof MenubarPrimitive.Content>,
  React.ComponentPropsWithoutRef<typeof MenubarPrimitive.Content>
>(
  (
    { className, align = "start", alignOffset = -4, sideOffset = 8, ...props },
    ref
  ) => (
    <MenubarPrimitive.Portal>
      <MenubarPrimitive.Content
        ref={ref}
        align={align}
        alignOffset={alignOffset}
        sideOffset={sideOffset}
        className={cn(
          "z-50 min-w-[12rem] overflow-hidden rounded-md border bg-popover p-1 text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
          className
        )}
        {...props}
      />
    </MenubarPrimitive.Portal>
  )
)
MenubarContent.displayName = MenubarPrimitive.Content.displayName

const MenubarItem = React.forwardRef<
  React.ElementRef<typeof MenubarPrimitive.Item>,
  React.ComponentPropsWithoutRef<typeof MenubarPrimitive.Item> & {
    inset?: boolean
  }
>(({ className, inset, ...props }, ref) => (
  <MenubarPrimitive.Item
    ref={ref}
    className={cn(
      "relative flex cursor-default select-none items-center rounded-sm px-2 py-1.5 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
      inset && "pl-8",
      className
    )}
    {...props}
  />
))
MenubarItem.displayName = MenubarPrimitive.Item.displayName

const MenubarCheckboxItem = React.forwardRef<
  React.ElementRef<typeof MenubarPrimitive.CheckboxItem>,
  React.ComponentPropsWithoutRef<typeof MenubarPrimitive.CheckboxItem>
>(({ className, children, checked, ...props }, ref) => (
  <MenubarPrimitive.CheckboxItem
    ref={ref}
    className={cn(
      "relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
      className
    )}
    checked={checked}
    {...props}
  >
    <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
      <MenubarPrimitive.ItemIndicator>
        <Check className="h-4 w-4" />
      </MenubarPrimitive.ItemIndicator>
    </span>
    {children}
  </MenubarPrimitive.CheckboxItem>
))
MenubarCheckboxItem.displayName = MenubarPrimitive.CheckboxItem.displayName

const MenubarRadioItem = React.forwardRef<
  React.ElementRef<typeof MenubarPrimitive.RadioItem>,
  React.ComponentPropsWithoutRef<typeof MenubarPrimitive.RadioItem>
>(({ className, children, ...props }, ref) => (
  <MenubarPrimitive.RadioItem
    ref={ref}
    className={cn(
      "relative flex cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
      className
    )}
    {...props}
  >
    <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
      <MenubarPrimitive.ItemIndicator>
        <Circle className="h-2 w-2 fill-current" />
      </MenubarPrimitive.ItemIndicator>
    </span>
    {children}
  </MenubarPrimitive.RadioItem>
))
MenubarRadioItem.displayName = MenubarPrimitive.RadioItem.displayName

const MenubarLabel = React.forwardRef<
  React.ElementRef<typeof MenubarPrimitive.Label>,
  React.ComponentPropsWithoutRef<typeof MenubarPrimitive.Label> & {
    inset?: boolean
  }
>(({ className, inset, ...props }, ref) => (
  <MenubarPrimitive.Label
    ref={ref}
    className={cn(
      "px-2 py-1.5 text-sm font-semibold",
      inset && "pl-8",
      className
    )}
    {...props}
  />
))
MenubarLabel.displayName = MenubarPrimitive.Label.displayName

const MenubarSeparator = React.forwardRef<
  React.ElementRef<typeof MenubarPrimitive.Separator>,
  React.ComponentPropsWithoutRef<typeof MenubarPrimitive.Separator>
>(({ className, ...props }, ref) => (
  <MenubarPrimitive.Separator
    ref={ref}
    className={cn("-mx-1 my-1 h-px bg-muted", className)}
    {...props}
  />
))
MenubarSeparator.displayName = MenubarPrimitive.Separator.displayName

const MenubarShortcut = ({
  className,
  ...props
}: React.HTMLAttributes<HTMLSpanElement>) => {
  return (
    <span
      className={cn(
        "ml-auto text-xs tracking-widest text-muted-foreground",
        className
      )}
      {...props}
    />
  )
}
MenubarShortcut.displayname = "MenubarShortcut"

export {
  Menubar,
  MenubarMenu,
  MenubarTrigger,
  MenubarContent,
  MenubarItem,
  MenubarSeparator,
  MenubarLabel,
  MenubarCheckboxItem,
  MenubarRadioGroup,
  MenubarRadioItem,
  MenubarPortal,
  MenubarSubContent,
  MenubarSubTrigger,
  MenubarGroup,
  MenubarSub,
  MenubarShortcut,
}
EOF

cat << 'EOF' > src/components/ui/popover.tsx
"use client"

import * as React from "react"
import * as PopoverPrimitive from "@radix-ui/react-popover"

import { cn } from "@/lib/utils"

const Popover = PopoverPrimitive.Root

const PopoverTrigger = PopoverPrimitive.Trigger

const PopoverContent = React.forwardRef<
  React.ElementRef<typeof PopoverPrimitive.Content>,
  React.ComponentPropsWithoutRef<typeof PopoverPrimitive.Content>
>(({ className, align = "center", sideOffset = 4, ...props }, ref) => (
  <PopoverPrimitive.Portal>
    <PopoverPrimitive.Content
      ref={ref}
      align={align}
      sideOffset={sideOffset}
      className={cn(
        "z-50 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-md outline-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
        className
      )}
      {...props}
    />
  </PopoverPrimitive.Portal>
))
PopoverContent.displayName = PopoverPrimitive.Content.displayName

export { Popover, PopoverTrigger, PopoverContent }
EOF

cat << 'EOF' > src/components/ui/progress.tsx
"use client"

import * as React from "react"
import * as ProgressPrimitive from "@radix-ui/react-progress"

import { cn } from "@/lib/utils"

const Progress = React.forwardRef<
  React.ElementRef<typeof ProgressPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof ProgressPrimitive.Root>
>(({ className, value, ...props }, ref) => (
  <ProgressPrimitive.Root
    ref={ref}
    className={cn(
      "relative h-4 w-full overflow-hidden rounded-full bg-secondary",
      className
    )}
    {...props}
  >
    <ProgressPrimitive.Indicator
      className="h-full w-full flex-1 bg-primary transition-all"
      style={{ transform: `translateX(-${100 - (value || 0)}%)` }}
    />
  </ProgressPrimitive.Root>
))
Progress.displayName = ProgressPrimitive.Root.displayName

export { Progress }
EOF

cat << 'EOF' > src/components/ui/radio-group.tsx
"use client"

import * as React from "react"
import * as RadioGroupPrimitive from "@radix-ui/react-radio-group"
import { Circle } from "lucide-react"

import { cn } from "@/lib/utils"

const RadioGroup = React.forwardRef<
  React.ElementRef<typeof RadioGroupPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof RadioGroupPrimitive.Root>
>(({ className, ...props }, ref) => {
  return (
    <RadioGroupPrimitive.Root
      className={cn("grid gap-2", className)}
      {...props}
      ref={ref}
    />
  )
})
RadioGroup.displayName = RadioGroupPrimitive.Root.displayName

const RadioGroupItem = React.forwardRef<
  React.ElementRef<typeof RadioGroupPrimitive.Item>,
  React.ComponentPropsWithoutRef<typeof RadioGroupPrimitive.Item>
>(({ className, ...props }, ref) => {
  return (
    <RadioGroupPrimitive.Item
      ref={ref}
      className={cn(
        "aspect-square h-4 w-4 rounded-full border border-primary text-primary ring-offset-background focus:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50",
        className
      )}
      {...props}
    >
      <RadioGroupPrimitive.Indicator className="flex items-center justify-center">
        <Circle className="h-2.5 w-2.5 fill-current text-current" />
      </RadioGroupPrimitive.Indicator>
    </RadioGroupPrimitive.Item>
  )
})
RadioGroupItem.displayName = RadioGroupPrimitive.Item.displayName

export { RadioGroup, RadioGroupItem }
EOF

cat << 'EOF' > src/components/ui/scroll-area.tsx
"use client"

import * as React from "react"
import * as ScrollAreaPrimitive from "@radix-ui/react-scroll-area"

import { cn } from "@/lib/utils"

const ScrollArea = React.forwardRef<
  React.ElementRef<typeof ScrollAreaPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof ScrollAreaPrimitive.Root>
>(({ className, children, ...props }, ref) => (
  <ScrollAreaPrimitive.Root
    ref={ref}
    className={cn("relative overflow-hidden", className)}
    {...props}
  >
    <ScrollAreaPrimitive.Viewport className="h-full w-full rounded-[inherit]">
      {children}
    </ScrollAreaPrimitive.Viewport>
    <ScrollBar />
    <ScrollAreaPrimitive.Corner />
  </ScrollAreaPrimitive.Root>
))
ScrollArea.displayName = ScrollAreaPrimitive.Root.displayName

const ScrollBar = React.forwardRef<
  React.ElementRef<typeof ScrollAreaPrimitive.ScrollAreaScrollbar>,
  React.ComponentPropsWithoutRef<typeof ScrollAreaPrimitive.ScrollAreaScrollbar>
>(({ className, orientation = "vertical", ...props }, ref) => (
  <ScrollAreaPrimitive.ScrollAreaScrollbar
    ref={ref}
    orientation={orientation}
    className={cn(
      "flex touch-none select-none transition-colors",
      orientation === "vertical" &&
        "h-full w-2.5 border-l border-l-transparent p-[1px]",
      orientation === "horizontal" &&
        "h-2.5 flex-col border-t border-t-transparent p-[1px]",
      className
    )}
    {...props}
  >
    <ScrollAreaPrimitive.ScrollAreaThumb className="relative flex-1 rounded-full bg-border" />
  </ScrollAreaPrimitive.ScrollAreaScrollbar>
))
ScrollBar.displayName = ScrollAreaPrimitive.ScrollAreaScrollbar.displayName

export { ScrollArea, ScrollBar }
EOF

cat << 'EOF' > src/components/ui/select.tsx
"use client"

import * as React from "react"
import * as SelectPrimitive from "@radix-ui/react-select"
import { Check, ChevronDown, ChevronUp } from "lucide-react"

import { cn } from "@/lib/utils"

const Select = SelectPrimitive.Root

const SelectGroup = SelectPrimitive.Group

const SelectValue = SelectPrimitive.Value

const SelectTrigger = React.forwardRef<
  React.ElementRef<typeof SelectPrimitive.Trigger>,
  React.ComponentPropsWithoutRef<typeof SelectPrimitive.Trigger>
>(({ className, children, ...props }, ref) => (
  <SelectPrimitive.Trigger
    ref={ref}
    className={cn(
      "flex h-10 w-full items-center justify-between rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 [&>span]:line-clamp-1",
      className
    )}
    {...props}
  >
    {children}
    <SelectPrimitive.Icon asChild>
      <ChevronDown className="h-4 w-4 opacity-50" />
    </SelectPrimitive.Icon>
  </SelectPrimitive.Trigger>
))
SelectTrigger.displayName = SelectPrimitive.Trigger.displayName

const SelectScrollUpButton = React.forwardRef<
  React.ElementRef<typeof SelectPrimitive.ScrollUpButton>,
  React.ComponentPropsWithoutRef<typeof SelectPrimitive.ScrollUpButton>
>(({ className, ...props }, ref) => (
  <SelectPrimitive.ScrollUpButton
    ref={ref}
    className={cn(
      "flex cursor-default items-center justify-center py-1",
      className
    )}
    {...props}
  >
    <ChevronUp className="h-4 w-4" />
  </SelectPrimitive.ScrollUpButton>
))
SelectScrollUpButton.displayName = SelectPrimitive.ScrollUpButton.displayName

const SelectScrollDownButton = React.forwardRef<
  React.ElementRef<typeof SelectPrimitive.ScrollDownButton>,
  React.ComponentPropsWithoutRef<typeof SelectPrimitive.ScrollDownButton>
>(({ className, ...props }, ref) => (
  <SelectPrimitive.ScrollDownButton
    ref={ref}
    className={cn(
      "flex cursor-default items-center justify-center py-1",
      className
    )}
    {...props}
  >
    <ChevronDown className="h-4 w-4" />
  </SelectPrimitive.ScrollDownButton>
))
SelectScrollDownButton.displayName =
  SelectPrimitive.ScrollDownButton.displayName

const SelectContent = React.forwardRef<
  React.ElementRef<typeof SelectPrimitive.Content>,
  React.ComponentPropsWithoutRef<typeof SelectPrimitive.Content>
>(({ className, children, position = "popper", ...props }, ref) => (
  <SelectPrimitive.Portal>
    <SelectPrimitive.Content
      ref={ref}
      className={cn(
        "relative z-50 max-h-96 min-w-[8rem] overflow-hidden rounded-md border bg-popover text-popover-foreground shadow-md data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0 data-[state=closed]:zoom-out-95 data-[state=open]:zoom-in-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
        position === "popper" &&
          "data-[side=bottom]:translate-y-1 data-[side=left]:-translate-x-1 data-[side=right]:translate-x-1 data-[side=top]:-translate-y-1",
        className
      )}
      position={position}
      {...props}
    >
      <SelectScrollUpButton />
      <SelectPrimitive.Viewport
        className={cn(
          "p-1",
          position === "popper" &&
            "h-[var(--radix-select-trigger-height)] w-full min-w-[var(--radix-select-trigger-width)]"
        )}
      >
        {children}
      </SelectPrimitive.Viewport>
      <SelectScrollDownButton />
    </SelectPrimitive.Content>
  </SelectPrimitive.Portal>
))
SelectContent.displayName = SelectPrimitive.Content.displayName

const SelectLabel = React.forwardRef<
  React.ElementRef<typeof SelectPrimitive.Label>,
  React.ComponentPropsWithoutRef<typeof SelectPrimitive.Label>
>(({ className, ...props }, ref) => (
  <SelectPrimitive.Label
    ref={ref}
    className={cn("py-1.5 pl-8 pr-2 text-sm font-semibold", className)}
    {...props}
  />
))
SelectLabel.displayName = SelectPrimitive.Label.displayName

const SelectItem = React.forwardRef<
  React.ElementRef<typeof SelectPrimitive.Item>,
  React.ComponentPropsWithoutRef<typeof SelectPrimitive.Item>
>(({ className, children, ...props }, ref) => (
  <SelectPrimitive.Item
    ref={ref}
    className={cn(
      "relative flex w-full cursor-default select-none items-center rounded-sm py-1.5 pl-8 pr-2 text-sm outline-none focus:bg-accent focus:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50",
      className
    )}
    {...props}
  >
    <span className="absolute left-2 flex h-3.5 w-3.5 items-center justify-center">
      <SelectPrimitive.ItemIndicator>
        <Check className="h-4 w-4" />
      </SelectPrimitive.ItemIndicator>
    </span>

    <SelectPrimitive.ItemText>{children}</SelectPrimitive.ItemText>
  </SelectPrimitive.Item>
))
SelectItem.displayName = SelectPrimitive.Item.displayName

const SelectSeparator = React.forwardRef<
  React.ElementRef<typeof SelectPrimitive.Separator>,
  React.ComponentPropsWithoutRef<typeof SelectPrimitive.Separator>
>(({ className, ...props }, ref) => (
  <SelectPrimitive.Separator
    ref={ref}
    className={cn("-mx-1 my-1 h-px bg-muted", className)}
    {...props}
  />
))
SelectSeparator.displayName = SelectPrimitive.Separator.displayName

export {
  Select,
  SelectGroup,
  SelectValue,
  SelectTrigger,
  SelectContent,
  SelectLabel,
  SelectItem,
  SelectSeparator,
  SelectScrollUpButton,
  SelectScrollDownButton,
}
EOF

cat << 'EOF' > src/components/ui/separator.tsx
"use client"

import * as React from "react"
import * as SeparatorPrimitive from "@radix-ui/react-separator"

import { cn } from "@/lib/utils"

const Separator = React.forwardRef<
  React.ElementRef<typeof SeparatorPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof SeparatorPrimitive.Root>
>(
  (
    { className, orientation = "horizontal", decorative = true, ...props },
    ref
  ) => (
    <SeparatorPrimitive.Root
      ref={ref}
      decorative={decorative}
      orientation={orientation}
      className={cn(
        "shrink-0 bg-border",
        orientation === "horizontal" ? "h-[1px] w-full" : "h-full w-[1px]",
        className
      )}
      {...props}
    />
  )
)
Separator.displayName = SeparatorPrimitive.Root.displayName

export { Separator }
EOF

cat << 'EOF' > src/components/ui/sheet.tsx
"use client"

import * as React from "react"
import * as SheetPrimitive from "@radix-ui/react-dialog"
import { cva, type VariantProps } from "class-variance-authority"
import { X } from "lucide-react"

import { cn } from "@/lib/utils"

const Sheet = SheetPrimitive.Root

const SheetTrigger = SheetPrimitive.Trigger

const SheetClose = SheetPrimitive.Close

const SheetPortal = SheetPrimitive.Portal

const SheetOverlay = React.forwardRef<
  React.ElementRef<typeof SheetPrimitive.Overlay>,
  React.ComponentPropsWithoutRef<typeof SheetPrimitive.Overlay>
>(({ className, ...props }, ref) => (
  <SheetPrimitive.Overlay
    className={cn(
      "fixed inset-0 z-50 bg-black/80  data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=open]:fade-in-0",
      className
    )}
    {...props}
    ref={ref}
  />
))
SheetOverlay.displayName = SheetPrimitive.Overlay.displayName

const sheetVariants = cva(
  "fixed z-50 gap-4 bg-background p-6 shadow-lg transition ease-in-out data-[state=open]:animate-in data-[state=closed]:animate-out data-[state=closed]:duration-300 data-[state=open]:duration-500",
  {
    variants: {
      side: {
        top: "inset-x-0 top-0 border-b data-[state=closed]:slide-out-to-top data-[state=open]:slide-in-from-top",
        bottom:
          "inset-x-0 bottom-0 border-t data-[state=closed]:slide-out-to-bottom data-[state=open]:slide-in-from-bottom",
        left: "inset-y-0 left-0 h-full w-3/4 border-r data-[state=closed]:slide-out-to-left data-[state=open]:slide-in-from-left sm:max-w-sm",
        right:
          "inset-y-0 right-0 h-full w-3/4  border-l data-[state=closed]:slide-out-to-right data-[state=open]:slide-in-from-right sm:max-w-sm",
      },
    },
    defaultVariants: {
      side: "right",
    },
  }
)

interface SheetContentProps
  extends React.ComponentPropsWithoutRef<typeof SheetPrimitive.Content>,
    VariantProps<typeof sheetVariants> {}

const SheetContent = React.forwardRef<
  React.ElementRef<typeof SheetPrimitive.Content>,
  SheetContentProps
>(({ side = "right", className, children, ...props }, ref) => (
  <SheetPortal>
    <SheetOverlay />
    <SheetPrimitive.Content
      ref={ref}
      className={cn(sheetVariants({ side }), className)}
      {...props}
    >
      {children}
      <SheetPrimitive.Close className="absolute right-4 top-4 rounded-sm opacity-70 ring-offset-background transition-opacity hover:opacity-100 focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none data-[state=open]:bg-secondary">
        <X className="h-4 w-4" />
        <span className="sr-only">Close</span>
      </SheetPrimitive.Close>
    </SheetPrimitive.Content>
  </SheetPortal>
))
SheetContent.displayName = SheetPrimitive.Content.displayName

const SheetHeader = ({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) => (
  <div
    className={cn(
      "flex flex-col space-y-2 text-center sm:text-left",
      className
    )}
    {...props}
  />
)
SheetHeader.displayName = "SheetHeader"

const SheetFooter = ({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) => (
  <div
    className={cn(
      "flex flex-col-reverse sm:flex-row sm:justify-end sm:space-x-2",
      className
    )}
    {...props}
  />
)
SheetFooter.displayName = "SheetFooter"

const SheetTitle = React.forwardRef<
  React.ElementRef<typeof SheetPrimitive.Title>,
  React.ComponentPropsWithoutRef<typeof SheetPrimitive.Title>
>(({ className, ...props }, ref) => (
  <SheetPrimitive.Title
    ref={ref}
    className={cn("text-lg font-semibold text-foreground", className)}
    {...props}
  />
))
SheetTitle.displayName = SheetPrimitive.Title.displayName

const SheetDescription = React.forwardRef<
  React.ElementRef<typeof SheetPrimitive.Description>,
  React.ComponentPropsWithoutRef<typeof SheetPrimitive.Description>
>(({ className, ...props }, ref) => (
  <SheetPrimitive.Description
    ref={ref}
    className={cn("text-sm text-muted-foreground", className)}
    {...props}
  />
))
SheetDescription.displayName = SheetPrimitive.Description.displayName

export {
  Sheet,
  SheetPortal,
  SheetOverlay,
  SheetTrigger,
  SheetClose,
  SheetContent,
  SheetHeader,
  SheetFooter,
  SheetTitle,
  SheetDescription,
}
EOF

cat << 'EOF' > src/components/ui/sidebar.tsx
"use client"

import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { VariantProps, cva } from "class-variance-authority"
import { PanelLeft } from "lucide-react"

import { useIsMobile } from "@/hooks/use-mobile"
import { cn } from "@/lib/utils"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Separator } from "@/components/ui/separator"
import { Sheet, SheetContent } from "@/components/ui/sheet"
import { Skeleton } from "@/components/ui/skeleton"
import {
  Tooltip,
  TooltipContent,
  TooltipProvider,
  TooltipTrigger,
} from "@/components/ui/tooltip"

const SIDEBAR_COOKIE_NAME = "sidebar_state"
const SIDEBAR_COOKIE_MAX_AGE = 60 * 60 * 24 * 7
const SIDEBAR_WIDTH = "16rem"
const SIDEBAR_WIDTH_MOBILE = "18rem"
const SIDEBAR_WIDTH_ICON = "3rem"
const SIDEBAR_KEYBOARD_SHORTCUT = "b"

type SidebarContext = {
  state: "expanded" | "collapsed"
  open: boolean
  setOpen: (open: boolean) => void
  openMobile: boolean
  setOpenMobile: (open: boolean) => void
  isMobile: boolean
  toggleSidebar: () => void
}

const SidebarContext = React.createContext<SidebarContext | null>(null)

function useSidebar() {
  const context = React.useContext(SidebarContext)
  if (!context) {
    throw new Error("useSidebar must be used within a SidebarProvider.")
  }

  return context
}

const SidebarProvider = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div"> & {
    defaultOpen?: boolean
    open?: boolean
    onOpenChange?: (open: boolean) => void
  }
>(
  (
    {
      defaultOpen = true,
      open: openProp,
      onOpenChange: setOpenProp,
      className,
      style,
      children,
      ...props
    },
    ref
  ) => {
    const isMobile = useIsMobile()
    const [openMobile, setOpenMobile] = React.useState(false)

    // This is the internal state of the sidebar.
    // We use openProp and setOpenProp for control from outside the component.
    const [_open, _setOpen] = React.useState(defaultOpen)
    const open = openProp ?? _open
    const setOpen = React.useCallback(
      (value: boolean | ((value: boolean) => boolean)) => {
        const openState = typeof value === "function" ? value(open) : value
        if (setOpenProp) {
          setOpenProp(openState)
        } else {
          _setOpen(openState)
        }

        // This sets the cookie to keep the sidebar state.
        document.cookie = `${SIDEBAR_COOKIE_NAME}=${openState}; path=/; max-age=${SIDEBAR_COOKIE_MAX_AGE}`
      },
      [setOpenProp, open]
    )

    // Helper to toggle the sidebar.
    const toggleSidebar = React.useCallback(() => {
      return isMobile
        ? setOpenMobile((open) => !open)
        : setOpen((open) => !open)
    }, [isMobile, setOpen, setOpenMobile])

    // Adds a keyboard shortcut to toggle the sidebar.
    React.useEffect(() => {
      const handleKeyDown = (event: KeyboardEvent) => {
        if (
          event.key === SIDEBAR_KEYBOARD_SHORTCUT &&
          (event.metaKey || event.ctrlKey)
        ) {
          event.preventDefault()
          toggleSidebar()
        }
      }

      window.addEventListener("keydown", handleKeyDown)
      return () => window.removeEventListener("keydown", handleKeyDown)
    }, [toggleSidebar])

    // We add a state so that we can do data-state="expanded" or "collapsed".
    // This makes it easier to style the sidebar with Tailwind classes.
    const state = open ? "expanded" : "collapsed"

    const contextValue = React.useMemo<SidebarContext>(
      () => ({
        state,
        open,
        setOpen,
        isMobile,
        openMobile,
        setOpenMobile,
        toggleSidebar,
      }),
      [state, open, setOpen, isMobile, openMobile, setOpenMobile, toggleSidebar]
    )

    return (
      <SidebarContext.Provider value={contextValue}>
        <TooltipProvider delayDuration={0}>
          <div
            style={
              {
                "--sidebar-width": SIDEBAR_WIDTH,
                "--sidebar-width-icon": SIDEBAR_WIDTH_ICON,
                ...style,
              } as React.CSSProperties
            }
            className={cn(
              "group/sidebar-wrapper flex min-h-svh w-full has-[[data-variant=inset]]:bg-sidebar",
              className
            )}
            ref={ref}
            {...props}
          >
            {children}
          </div>
        </TooltipProvider>
      </SidebarContext.Provider>
    )
  }
)
SidebarProvider.displayName = "SidebarProvider"

const Sidebar = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div"> & {
    side?: "left" | "right"
    variant?: "sidebar" | "floating" | "inset"
    collapsible?: "offcanvas" | "icon" | "none"
  }
>(
  (
    {
      side = "left",
      variant = "sidebar",
      collapsible = "offcanvas",
      className,
      children,
      ...props
    },
    ref
  ) => {
    const { isMobile, state, openMobile, setOpenMobile } = useSidebar()

    if (collapsible === "none") {
      return (
        <div
          className={cn(
            "flex h-full w-[--sidebar-width] flex-col bg-sidebar text-sidebar-foreground",
            className
          )}
          ref={ref}
          {...props}
        >
          {children}
        </div>
      )
    }

    if (isMobile) {
      return (
        <Sheet open={openMobile} onOpenChange={setOpenMobile} {...props}>
          <SheetContent
            data-sidebar="sidebar"
            data-mobile="true"
            className="w-[--sidebar-width] bg-sidebar p-0 text-sidebar-foreground [&>button]:hidden"
            style={
              {
                "--sidebar-width": SIDEBAR_WIDTH_MOBILE,
              } as React.CSSProperties
            }
            side={side}
          >
            <div className="flex h-full w-full flex-col">{children}</div>
          </SheetContent>
        </Sheet>
      )
    }

    return (
      <div
        ref={ref}
        className="group peer hidden md:block text-sidebar-foreground"
        data-state={state}
        data-collapsible={state === "collapsed" ? collapsible : ""}
        data-variant={variant}
        data-side={side}
      >
        {/* This is what handles the sidebar gap on desktop */}
        <div
          className={cn(
            "duration-200 relative h-svh w-[--sidebar-width] bg-transparent transition-[width] ease-linear",
            "group-data-[collapsible=offcanvas]:w-0",
            "group-data-[side=right]:rotate-180",
            variant === "floating" || variant === "inset"
              ? "group-data-[collapsible=icon]:w-[calc(var(--sidebar-width-icon)_+_theme(spacing.4))]"
              : "group-data-[collapsible=icon]:w-[--sidebar-width-icon]"
          )}
        />
        <div
          className={cn(
            "duration-200 fixed inset-y-0 z-10 hidden h-svh w-[--sidebar-width] transition-[left,right,width] ease-linear md:flex",
            side === "left"
              ? "left-0 group-data-[collapsible=offcanvas]:left-[calc(var(--sidebar-width)*-1)]"
              : "right-0 group-data-[collapsible=offcanvas]:right-[calc(var(--sidebar-width)*-1)]",
            // Adjust the padding for floating and inset variants.
            variant === "floating" || variant === "inset"
              ? "p-2 group-data-[collapsible=icon]:w-[calc(var(--sidebar-width-icon)_+_theme(spacing.4)_+2px)]"
              : "group-data-[collapsible=icon]:w-[--sidebar-width-icon] group-data-[side=left]:border-r group-data-[side=right]:border-l",
            className
          )}
          {...props}
        >
          <div
            data-sidebar="sidebar"
            className="flex h-full w-full flex-col bg-sidebar group-data-[variant=floating]:rounded-lg group-data-[variant=floating]:border group-data-[variant=floating]:border-sidebar-border group-data-[variant=floating]:shadow"
          >
            {children}
          </div>
        </div>
      </div>
    )
  }
)
Sidebar.displayName = "Sidebar"

const SidebarTrigger = React.forwardRef<
  React.ElementRef<typeof Button>,
  React.ComponentProps<typeof Button>
>(({ className, onClick, ...props }, ref) => {
  const { toggleSidebar } = useSidebar()

  return (
    <Button
      ref={ref}
      data-sidebar="trigger"
      variant="ghost"
      size="icon"
      className={cn("h-7 w-7", className)}
      onClick={(event) => {
        onClick?.(event)
        toggleSidebar()
      }}
      {...props}
    >
      <PanelLeft />
      <span className="sr-only">Toggle Sidebar</span>
    </Button>
  )
})
SidebarTrigger.displayName = "SidebarTrigger"

const SidebarRail = React.forwardRef<
  HTMLButtonElement,
  React.ComponentProps<"button">
>(({ className, ...props }, ref) => {
  const { toggleSidebar } = useSidebar()

  return (
    <button
      ref={ref}
      data-sidebar="rail"
      aria-label="Toggle Sidebar"
      tabIndex={-1}
      onClick={toggleSidebar}
      title="Toggle Sidebar"
      className={cn(
        "absolute inset-y-0 z-20 hidden w-4 -translate-x-1/2 transition-all ease-linear after:absolute after:inset-y-0 after:left-1/2 after:w-[2px] hover:after:bg-sidebar-border group-data-[side=left]:-right-4 group-data-[side=right]:left-0 sm:flex",
        "[[data-side=left]_&]:cursor-w-resize [[data-side=right]_&]:cursor-e-resize",
        "[[data-side=left][data-state=collapsed]_&]:cursor-e-resize [[data-side=right][data-state=collapsed]_&]:cursor-w-resize",
        "group-data-[collapsible=offcanvas]:translate-x-0 group-data-[collapsible=offcanvas]:after:left-full group-data-[collapsible=offcanvas]:hover:bg-sidebar",
        "[[data-side=left][data-collapsible=offcanvas]_&]:-right-2",
        "[[data-side=right][data-collapsible=offcanvas]_&]:-left-2",
        className
      )}
      {...props}
    />
  )
})
SidebarRail.displayName = "SidebarRail"

const SidebarInset = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"main">
>(({ className, ...props }, ref) => {
  return (
    <main
      ref={ref}
      className={cn(
        "relative flex min-h-svh flex-1 flex-col bg-background",
        "peer-data-[variant=inset]:min-h-[calc(100svh-theme(spacing.4))] md:peer-data-[variant=inset]:m-2 md:peer-data-[state=collapsed]:peer-data-[variant=inset]:ml-2 md:peer-data-[variant=inset]:ml-0 md:peer-data-[variant=inset]:rounded-xl md:peer-data-[variant=inset]:shadow",
        className
      )}
      {...props}
    />
  )
})
SidebarInset.displayName = "SidebarInset"

const SidebarInput = React.forwardRef<
  React.ElementRef<typeof Input>,
  React.ComponentProps<typeof Input>
>(({ className, ...props }, ref) => {
  return (
    <Input
      ref={ref}
      data-sidebar="input"
      className={cn(
        "h-8 w-full bg-background shadow-none focus-visible:ring-2 focus-visible:ring-sidebar-ring",
        className
      )}
      {...props}
    />
  )
})
SidebarInput.displayName = "SidebarInput"

const SidebarHeader = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div">
>(({ className, ...props }, ref) => {
  return (
    <div
      ref={ref}
      data-sidebar="header"
      className={cn("flex flex-col gap-2 p-2", className)}
      {...props}
    />
  )
})
SidebarHeader.displayName = "SidebarHeader"

const SidebarFooter = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div">
>(({ className, ...props }, ref) => {
  return (
    <div
      ref={ref}
      data-sidebar="footer"
      className={cn("flex flex-col gap-2 p-2", className)}
      {...props}
    />
  )
})
SidebarFooter.displayName = "SidebarFooter"

const SidebarSeparator = React.forwardRef<
  React.ElementRef<typeof Separator>,
  React.ComponentProps<typeof Separator>
>(({ className, ...props }, ref) => {
  return (
    <Separator
      ref={ref}
      data-sidebar="separator"
      className={cn("mx-2 w-auto bg-sidebar-border", className)}
      {...props}
    />
  )
})
SidebarSeparator.displayName = "SidebarSeparator"

const SidebarContent = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div">
>(({ className, ...props }, ref) => {
  return (
    <div
      ref={ref}
      data-sidebar="content"
      className={cn(
        "flex min-h-0 flex-1 flex-col gap-2 overflow-auto group-data-[collapsible=icon]:overflow-hidden",
        className
      )}
      {...props}
    />
  )
})
SidebarContent.displayName = "SidebarContent"

const SidebarGroup = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div">
>(({ className, ...props }, ref) => {
  return (
    <div
      ref={ref}
      data-sidebar="group"
      className={cn("relative flex w-full min-w-0 flex-col p-2", className)}
      {...props}
    />
  )
})
SidebarGroup.displayName = "SidebarGroup"

const SidebarGroupLabel = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div"> & { asChild?: boolean }
>(({ className, asChild = false, ...props }, ref) => {
  const Comp = asChild ? Slot : "div"

  return (
    <Comp
      ref={ref}
      data-sidebar="group-label"
      className={cn(
        "duration-200 flex h-8 shrink-0 items-center rounded-md px-2 text-xs font-medium text-sidebar-foreground/70 outline-none ring-sidebar-ring transition-[margin,opa] ease-linear focus-visible:ring-2 [&>svg]:size-4 [&>svg]:shrink-0",
        "group-data-[collapsible=icon]:-mt-8 group-data-[collapsible=icon]:opacity-0",
        className
      )}
      {...props}
    />
  )
})
SidebarGroupLabel.displayName = "SidebarGroupLabel"

const SidebarGroupAction = React.forwardRef<
  HTMLButtonElement,
  React.ComponentProps<"button"> & { asChild?: boolean }
>(({ className, asChild = false, ...props }, ref) => {
  const Comp = asChild ? Slot : "button"

  return (
    <Comp
      ref={ref}
      data-sidebar="group-action"
      className={cn(
        "absolute right-3 top-3.5 flex aspect-square w-5 items-center justify-center rounded-md p-0 text-sidebar-foreground outline-none ring-sidebar-ring transition-transform hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 [&>svg]:size-4 [&>svg]:shrink-0",
        // Increases the hit area of the button on mobile.
        "after:absolute after:-inset-2 after:md:hidden",
        "group-data-[collapsible=icon]:hidden",
        className
      )}
      {...props}
    />
  )
})
SidebarGroupAction.displayName = "SidebarGroupAction"

const SidebarGroupContent = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div">
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    data-sidebar="group-content"
    className={cn("w-full text-sm", className)}
    {...props}
  />
))
SidebarGroupContent.displayName = "SidebarGroupContent"

const SidebarMenu = React.forwardRef<
  HTMLUListElement,
  React.ComponentProps<"ul">
>(({ className, ...props }, ref) => (
  <ul
    ref={ref}
    data-sidebar="menu"
    className={cn("flex w-full min-w-0 flex-col gap-1", className)}
    {...props}
  />
))
SidebarMenu.displayName = "SidebarMenu"

const SidebarMenuItem = React.forwardRef<
  HTMLLIElement,
  React.ComponentProps<"li">
>(({ className, ...props }, ref) => (
  <li
    ref={ref}
    data-sidebar="menu-item"
    className={cn("group/menu-item relative", className)}
    {...props}
  />
))
SidebarMenuItem.displayName = "SidebarMenuItem"

const sidebarMenuButtonVariants = cva(
  "peer/menu-button flex w-full items-center gap-2 overflow-hidden rounded-md p-2 text-left text-sm outline-none ring-sidebar-ring transition-[width,height,padding] hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 active:bg-sidebar-accent active:text-sidebar-accent-foreground disabled:pointer-events-none disabled:opacity-50 group-has-[[data-sidebar=menu-action]]/menu-item:pr-8 aria-disabled:pointer-events-none aria-disabled:opacity-50 data-[active=true]:bg-sidebar-accent data-[active=true]:font-medium data-[active=true]:text-sidebar-accent-foreground data-[state=open]:hover:bg-sidebar-accent data-[state=open]:hover:text-sidebar-accent-foreground group-data-[collapsible=icon]:!size-8 group-data-[collapsible=icon]:!p-2 [&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0",
  {
    variants: {
      variant: {
        default: "hover:bg-sidebar-accent hover:text-sidebar-accent-foreground",
        outline:
          "bg-background shadow-[0_0_0_1px_hsl(var(--sidebar-border))] hover:bg-sidebar-accent hover:text-sidebar-accent-foreground hover:shadow-[0_0_0_1px_hsl(var(--sidebar-accent))]",
      },
      size: {
        default: "h-8 text-sm",
        sm: "h-7 text-xs",
        lg: "h-12 text-sm group-data-[collapsible=icon]:!p-0",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

const SidebarMenuButton = React.forwardRef<
  HTMLButtonElement,
  React.ComponentProps<"button"> & {
    asChild?: boolean
    isActive?: boolean
    tooltip?: string | React.ComponentProps<typeof TooltipContent>
  } & VariantProps<typeof sidebarMenuButtonVariants>
>(
  (
    {
      asChild = false,
      isActive = false,
      variant = "default",
      size = "default",
      tooltip,
      className,
      ...props
    },
    ref
  ) => {
    const Comp = asChild ? Slot : "button"
    const { isMobile, state } = useSidebar()

    const button = (
      <Comp
        ref={ref}
        data-sidebar="menu-button"
        data-size={size}
        data-active={isActive}
        className={cn(sidebarMenuButtonVariants({ variant, size }), className)}
        {...props}
      />
    )

    if (!tooltip) {
      return button
    }

    if (typeof tooltip === "string") {
      tooltip = {
        children: tooltip,
      }
    }

    return (
      <Tooltip>
        <TooltipTrigger asChild>{button}</TooltipTrigger>
        <TooltipContent
          side="right"
          align="center"
          hidden={state !== "collapsed" || isMobile}
          {...tooltip}
        />
      </Tooltip>
    )
  }
)
SidebarMenuButton.displayName = "SidebarMenuButton"

const SidebarMenuAction = React.forwardRef<
  HTMLButtonElement,
  React.ComponentProps<"button"> & {
    asChild?: boolean
    showOnHover?: boolean
  }
>(({ className, asChild = false, showOnHover = false, ...props }, ref) => {
  const Comp = asChild ? Slot : "button"

  return (
    <Comp
      ref={ref}
      data-sidebar="menu-action"
      className={cn(
        "absolute right-1 top-1.5 flex aspect-square w-5 items-center justify-center rounded-md p-0 text-sidebar-foreground outline-none ring-sidebar-ring transition-transform hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 peer-hover/menu-button:text-sidebar-accent-foreground [&>svg]:size-4 [&>svg]:shrink-0",
        // Increases the hit area of the button on mobile.
        "after:absolute after:-inset-2 after:md:hidden",
        "peer-data-[size=sm]/menu-button:top-1",
        "peer-data-[size=default]/menu-button:top-1.5",
        "peer-data-[size=lg]/menu-button:top-2.5",
        "group-data-[collapsible=icon]:hidden",
        showOnHover &&
          "group-focus-within/menu-item:opacity-100 group-hover/menu-item:opacity-100 data-[state=open]:opacity-100 peer-data-[active=true]/menu-button:text-sidebar-accent-foreground md:opacity-0",
        className
      )}
      {...props}
    />
  )
})
SidebarMenuAction.displayName = "SidebarMenuAction"

const SidebarMenuBadge = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div">
>(({ className, ...props }, ref) => (
  <div
    ref={ref}
    data-sidebar="menu-badge"
    className={cn(
      "absolute right-1 flex h-5 min-w-5 items-center justify-center rounded-md px-1 text-xs font-medium tabular-nums text-sidebar-foreground select-none pointer-events-none",
      "peer-hover/menu-button:text-sidebar-accent-foreground peer-data-[active=true]/menu-button:text-sidebar-accent-foreground",
      "peer-data-[size=sm]/menu-button:top-1",
      "peer-data-[size=default]/menu-button:top-1.5",
      "peer-data-[size=lg]/menu-button:top-2.5",
      "group-data-[collapsible=icon]:hidden",
      className
    )}
    {...props}
  />
))
SidebarMenuBadge.displayName = "SidebarMenuBadge"

const SidebarMenuSkeleton = React.forwardRef<
  HTMLDivElement,
  React.ComponentProps<"div"> & {
    showIcon?: boolean
  }
>(({ className, showIcon = false, ...props }, ref) => {
  // Random width between 50 to 90%.
  const width = React.useMemo(() => {
    return `${Math.floor(Math.random() * 40) + 50}%`
  }, [])

  return (
    <div
      ref={ref}
      data-sidebar="menu-skeleton"
      className={cn("rounded-md h-8 flex gap-2 px-2 items-center", className)}
      {...props}
    >
      {showIcon && (
        <Skeleton
          className="size-4 rounded-md"
          data-sidebar="menu-skeleton-icon"
        />
      )}
      <Skeleton
        className="h-4 flex-1 max-w-[--skeleton-width]"
        data-sidebar="menu-skeleton-text"
        style={
          {
            "--skeleton-width": width,
          } as React.CSSProperties
        }
      />
    </div>
  )
})
SidebarMenuSkeleton.displayName = "SidebarMenuSkeleton"

const SidebarMenuSub = React.forwardRef<
  HTMLUListElement,
  React.ComponentProps<"ul">
>(({ className, ...props }, ref) => (
  <ul
    ref={ref}
    data-sidebar="menu-sub"
    className={cn(
      "mx-3.5 flex min-w-0 translate-x-px flex-col gap-1 border-l border-sidebar-border px-2.5 py-0.5",
      "group-data-[collapsible=icon]:hidden",
      className
    )}
    {...props}
  />
))
SidebarMenuSub.displayName = "SidebarMenuSub"

const SidebarMenuSubItem = React.forwardRef<
  HTMLLIElement,
  React.ComponentProps<"li">
>(({ ...props }, ref) => <li ref={ref} {...props} />)
SidebarMenuSubItem.displayName = "SidebarMenuSubItem"

const SidebarMenuSubButton = React.forwardRef<
  HTMLAnchorElement,
  React.ComponentProps<"a"> & {
    asChild?: boolean
    size?: "sm" | "md"
    isActive?: boolean
  }
>(({ asChild = false, size = "md", isActive, className, ...props }, ref) => {
  const Comp = asChild ? Slot : "a"

  return (
    <Comp
      ref={ref}
      data-sidebar="menu-sub-button"
      data-size={size}
      data-active={isActive}
      className={cn(
        "flex h-7 min-w-0 -translate-x-px items-center gap-2 overflow-hidden rounded-md px-2 text-sidebar-foreground outline-none ring-sidebar-ring hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 active:bg-sidebar-accent active:text-sidebar-accent-foreground disabled:pointer-events-none disabled:opacity-50 aria-disabled:pointer-events-none aria-disabled:opacity-50 [&>span:last-child]:truncate [&>svg]:size-4 [&>svg]:shrink-0 [&>svg]:text-sidebar-accent-foreground",
        "data-[active=true]:bg-sidebar-accent data-[active=true]:text-sidebar-accent-foreground",
        size === "sm" && "text-xs",
        size === "md" && "text-sm",
        "group-data-[collapsible=icon]:hidden",
        className
      )}
      {...props}
    />
  )
})
SidebarMenuSubButton.displayName = "SidebarMenuSubButton"

export {
  Sidebar,
  SidebarContent,
  SidebarFooter,
  SidebarGroup,
  SidebarGroupAction,
  SidebarGroupContent,
  SidebarGroupLabel,
  SidebarHeader,
  SidebarInput,
  SidebarInset,
  SidebarMenu,
  SidebarMenuAction,
  SidebarMenuBadge,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarMenuSkeleton,
  SidebarMenuSub,
  SidebarMenuSubButton,
  SidebarMenuSubItem,
  SidebarProvider,
  SidebarRail,
  SidebarSeparator,
  SidebarTrigger,
  useSidebar,
}
EOF

cat << 'EOF' > src/components/ui/skeleton.tsx
import { cn } from "@/lib/utils"

function Skeleton({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn("animate-pulse rounded-md bg-muted", className)}
      {...props}
    />
  )
}

export { Skeleton }
EOF

cat << 'EOF' > src/components/ui/slider.tsx
"use client"

import * as React from "react"
import * as SliderPrimitive from "@radix-ui/react-slider"

import { cn } from "@/lib/utils"

const Slider = React.forwardRef<
  React.ElementRef<typeof SliderPrimitive.Root>,
  React.ComponentPropsWithoutRef<typeof SliderPrimitive.Root>
>(({ className, ...props }, ref) => (
  <SliderPrimitive.Root
    ref={ref}
    className={cn(
      "relative flex w-full touch-none select-none items-center",
      className
    )}
    {...props}
  >
    <SliderPrimitive.Track className="relative h-2 w-full grow overflow-hidden rounded-full bg-secondary">
      <SliderPrimitive.Range className="absolute h-full bg-primary" />
    </SliderPrimitive.Track>
    <SliderPrimitive.Thumb className="block h-5 w-5 rounded-full border-2 border-primary bg-background ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50" />
  </SliderPrimitive.Root>
))
Slider.displayName = SliderPrimitive.Root.displayName

export { Slider }
EOF

cat << 'EOF' > src/components/ui/switch.tsx
"use client"

import * as React from "react"
import * as SwitchPrimitives from "@radix-ui/react-switch"

import { cn } from "@/lib/utils"

const Switch = React.forwardRef<
  React.ElementRef<typeof SwitchPrimitives.Root>,
  React.ComponentPropsWithoutRef<typeof SwitchPrimitives.Root>
>(({ className, ...props }, ref) => (
  <SwitchPrimitives.Root
    className={cn(
      "peer inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:bg-primary data-[state=unchecked]:bg-input",
      className
    )}
    {...props}
    ref={ref}
  >
    <SwitchPrimitives.Thumb
      className={cn(
        "pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform data-[state=checked]:translate-x-5 data-[state=unchecked]:translate-x-0"
      )}
    />
  </SwitchPrimitives.Root>
))
Switch.displayName = SwitchPrimitives.Root.displayName

export { Switch }
EOF

cat << 'EOF' > src/components/ui/table.tsx
import * as React from "react"

import { cn } from "@/lib/utils"

const Table = React.forwardRef<
  HTMLTableElement,
  React.HTMLAttributes<HTMLTableElement>
>(({ className, ...props }, ref) => (
  <div className="relative w-full overflow-auto">
    <table
      ref={ref}
      className={cn("w-full caption-bottom text-sm", className)}
      {...props}
    />
  </div>
))
Table.displayName = "Table"

const TableHeader = React.forwardRef<
  HTMLTableSectionElement,
  React.HTMLAttributes<HTMLTableSectionElement>
>(({ className, ...props }, ref) => (
  <thead ref={ref} className={cn("[&_tr]:border-b", className)} {...props} />
))
TableHeader.displayName = "TableHeader"

const TableBody = React.forwardRef<
  HTMLTableSectionElement,
  React.HTMLAttributes<HTMLTableSectionElement>
>(({ className, ...props }, ref) => (
  <tbody
    ref={ref}
    className={cn("[&_tr:last-child]:border-0", className)}
    {...props}
  />
))
TableBody.displayName = "TableBody"

const TableFooter = React.forwardRef<
  HTMLTableSectionElement,
  React.HTMLAttributes<HTMLTableSectionElement>
>(({ className, ...props }, ref) => (
  <tfoot
    ref={ref}
    className={cn(
      "border-t bg-muted/50 font-medium [&>tr]:last:border-b-0",
      className
    )}
    {...props}
  />
))
TableFooter.displayName = "TableFooter"

const TableRow = React.forwardRef<
  HTMLTableRowElement,
  React.HTMLAttributes<HTMLTableRowElement>
>(({ className, ...props }, ref) => (
  <tr
    ref={ref}
    className={cn(
      "border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted",
      className
    )}
    {...props}
  />
))
TableRow.displayName = "TableRow"

const TableHead = React.forwardRef<
  HTMLTableCellElement,
  React.ThHTMLAttributes<HTMLTableCellElement>
>(({ className, ...props }, ref) => (
  <th
    ref={ref}
    className={cn(
      "h-12 px-4 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0",
      className
    )}
    {...props}
  />
))
TableHead.displayName = "TableHead"

const TableCell = React.forwardRef<
  HTMLTableCellElement,
  React.TdHTMLAttributes<HTMLTableCellElement>
>(({ className, ...props }, ref) => (
  <td
    ref={ref}
    className={cn("p-4 align-middle [&:has([role=checkbox])]:pr-0", className)}
    {...props}
  />
))
TableCell.displayName = "TableCell"

const TableCaption = React.forwardRef<
  HTMLTableCaptionElement,
  React.HTMLAttributes<HTMLTableCaptionElement>
>(({ className, ...props }, ref) => (
  <caption
    ref={ref}
    className={cn("mt-4 text-sm text-muted-foreground", className)}
    {...props}
  />
))
TableCaption.displayName = "TableCaption"

export {
  Table,
  TableHeader,
  TableBody,
  TableFooter,
  TableHead,
  TableRow,
  TableCell,
  TableCaption,
}
EOF

cat << 'EOF' > src/components/ui/tabs.tsx
"use client"

import * as React from "react"
import * as TabsPrimitive from "@radix-ui/react-tabs"

import { cn } from "@/lib/utils"

const Tabs = TabsPrimitive.Root

const TabsList = React.forwardRef<
  React.ElementRef<typeof TabsPrimitive.List>,
  React.ComponentPropsWithoutRef<typeof TabsPrimitive.List>
>(({ className, ...props }, ref) => (
  <TabsPrimitive.List
    ref={ref}
    className={cn(
      "inline-flex h-10 items-center justify-center rounded-md bg-muted p-1 text-muted-foreground",
      className
    )}
    {...props}
  />
))
TabsList.displayName = TabsPrimitive.List.displayName

const TabsTrigger = React.forwardRef<
  React.ElementRef<typeof TabsPrimitive.Trigger>,
  React.ComponentPropsWithoutRef<typeof TabsPrimitive.Trigger>
>(({ className, ...props }, ref) => (
  <TabsPrimitive.Trigger
    ref={ref}
    className={cn(
      "inline-flex items-center justify-center whitespace-nowrap rounded-sm px-3 py-1.5 text-sm font-medium ring-offset-background transition-all focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 data-[state=active]:bg-background data-[state=active]:text-foreground data-[state=active]:shadow-sm",
      className
    )}
    {...props}
  />
))
TabsTrigger.displayName = TabsPrimitive.Trigger.displayName

const TabsContent = React.forwardRef<
  React.ElementRef<typeof TabsPrimitive.Content>,
  React.ComponentPropsWithoutRef<typeof TabsPrimitive.Content>
>(({ className, ...props }, ref) => (
  <TabsPrimitive.Content
    ref={ref}
    className={cn(
      "mt-2 ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2",
      className
    )}
    {...props}
  />
))
TabsContent.displayName = TabsPrimitive.Content.displayName

export { Tabs, TabsList, TabsTrigger, TabsContent }
EOF

cat << 'EOF' > src/components/ui/textarea.tsx
import * as React from 'react';

import {cn} from '@/lib/utils';

const Textarea = React.forwardRef<HTMLTextAreaElement, React.ComponentProps<'textarea'>>(
  ({className, ...props}, ref) => {
    return (
      <textarea
        className={cn(
          'flex min-h-[80px] w-full rounded-md border border-input bg-background px-3 py-2 text-base ring-offset-background placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 md:text-sm',
          className
        )}
        ref={ref}
        {...props}
      />
    );
  }
);
Textarea.displayName = 'Textarea';

export {Textarea};
EOF

cat << 'EOF' > src/components/ui/theme-toggle.tsx
"use client";

import { useTheme } from "next-themes";
import { Moon, Sun } from "lucide-react";
import { Button } from "@/components/ui/button";
import { useEffect, useState } from "react";

export function ThemeToggle() {
  const { theme, setTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return (
      <Button variant="ghost" size="icon" className="rounded-full">
        <Sun className="h-5 w-5" />
      </Button>
    );
  }

  return (
    <Button
      variant="ghost"
      size="icon"
      onClick={() => setTheme(theme === "dark" ? "light" : "dark")}
      className="rounded-full"
    >
      {theme === "dark" ? <Sun className="h-5 w-5" /> : <Moon className="h-5 w-5" />}
    </Button>
  );
}
EOF

cat << 'EOF' > src/components/ui/toast.tsx
"use client"

import * as React from "react"
import * as ToastPrimitives from "@radix-ui/react-toast"
import { cva, type VariantProps } from "class-variance-authority"
import { X } from "lucide-react"

import { cn } from "@/lib/utils"

const ToastProvider = ToastPrimitives.Provider

const ToastViewport = React.forwardRef<
  React.ElementRef<typeof ToastPrimitives.Viewport>,
  React.ComponentPropsWithoutRef<typeof ToastPrimitives.Viewport>
>(({ className, ...props }, ref) => (
  <ToastPrimitives.Viewport
    ref={ref}
    className={cn(
      "fixed top-0 z-[100] flex max-h-screen w-full flex-col-reverse p-4 sm:bottom-0 sm:right-0 sm:top-auto sm:flex-col md:max-w-[420px]",
      className
    )}
    {...props}
  />
))
ToastViewport.displayName = ToastPrimitives.Viewport.displayName

const toastVariants = cva(
  "group pointer-events-auto relative flex w-full items-center justify-between space-x-4 overflow-hidden rounded-md border p-6 pr-8 shadow-lg transition-all data-[swipe=cancel]:translate-x-0 data-[swipe=end]:translate-x-[var(--radix-toast-swipe-end-x)] data-[swipe=move]:translate-x-[var(--radix-toast-swipe-move-x)] data-[swipe=move]:transition-none data-[state=open]:animate-in data-[state=closed]:animate-out data-[swipe=end]:animate-out data-[state=closed]:fade-out-80 data-[state=closed]:slide-out-to-right-full data-[state=open]:slide-in-from-top-full data-[state=open]:sm:slide-in-from-bottom-full",
  {
    variants: {
      variant: {
        default: "border bg-background text-foreground",
        destructive:
          "destructive group border-destructive bg-destructive text-destructive-foreground",
      },
    },
    defaultVariants: {
      variant: "default",
    },
  }
)

const Toast = React.forwardRef<
  React.ElementRef<typeof ToastPrimitives.Root>,
  React.ComponentPropsWithoutRef<typeof ToastPrimitives.Root> &
    VariantProps<typeof toastVariants>
>(({ className, variant, ...props }, ref) => {
  return (
    <ToastPrimitives.Root
      ref={ref}
      className={cn(toastVariants({ variant }), className)}
      {...props}
    />
  )
})
Toast.displayName = ToastPrimitives.Root.displayName

const ToastAction = React.forwardRef<
  React.ElementRef<typeof ToastPrimitives.Action>,
  React.ComponentPropsWithoutRef<typeof ToastPrimitives.Action>
>(({ className, ...props }, ref) => (
  <ToastPrimitives.Action
    ref={ref}
    className={cn(
      "inline-flex h-8 shrink-0 items-center justify-center rounded-md border bg-transparent px-3 text-sm font-medium ring-offset-background transition-colors hover:bg-secondary focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 group-[.destructive]:border-muted/40 group-[.destructive]:hover:border-destructive/30 group-[.destructive]:hover:bg-destructive group-[.destructive]:hover:text-destructive-foreground group-[.destructive]:focus:ring-destructive",
      className
    )}
    {...props}
  />
))
ToastAction.displayName = ToastPrimitives.Action.displayName

const ToastClose = React.forwardRef<
  React.ElementRef<typeof ToastPrimitives.Close>,
  React.ComponentPropsWithoutRef<typeof ToastPrimitives.Close>
>(({ className, ...props }, ref) => (
  <ToastPrimitives.Close
    ref={ref}
    className={cn(
      "absolute right-2 top-2 rounded-md p-1 text-foreground/50 opacity-0 transition-opacity hover:text-foreground focus:opacity-100 focus:outline-none focus:ring-2 group-hover:opacity-100 group-[.destructive]:text-red-300 group-[.destructive]:hover:text-red-50 group-[.destructive]:focus:ring-red-400 group-[.destructive]:focus:ring-offset-red-600",
      className
    )}
    toast-close=""
    {...props}
  >
    <X className="h-4 w-4" />
  </ToastPrimitives.Close>
))
ToastClose.displayName = ToastPrimitives.Close.displayName

const ToastTitle = React.forwardRef<
  React.ElementRef<typeof ToastPrimitives.Title>,
  React.ComponentPropsWithoutRef<typeof ToastPrimitives.Title>
>(({ className, ...props }, ref) => (
  <ToastPrimitives.Title
    ref={ref}
    className={cn("text-sm font-semibold", className)}
    {...props}
  />
))
ToastTitle.displayName = ToastPrimitives.Title.displayName

const ToastDescription = React.forwardRef<
  React.ElementRef<typeof ToastPrimitives.Description>,
  React.ComponentPropsWithoutRef<typeof ToastPrimitives.Description>
>(({ className, ...props }, ref) => (
  <ToastPrimitives.Description
    ref={ref}
    className={cn("text-sm opacity-90", className)}
    {...props}
  />
))
ToastDescription.displayName = ToastPrimitives.Description.displayName

type ToastProps = React.ComponentPropsWithoutRef<typeof Toast>

type ToastActionElement = React.ReactElement<typeof ToastAction>

export {
  type ToastProps,
  type ToastActionElement,
  ToastProvider,
  ToastViewport,
  Toast,
  ToastTitle,
  ToastDescription,
  ToastClose,
  ToastAction,
}
EOF

cat << 'EOF' > src/components/ui/toaster.tsx
"use client";

import { Toaster as Sonner } from "sonner";

export function Toaster() {
  return (
    <Sonner
      position="top-right"
      richColors
      toastOptions={{
        style: {
          borderRadius: "0.5rem",
          fontSize: "0.9rem",
        },
      }}
    />
  );
}
EOF

cat << 'EOF' > src/components/ui/tooltip.tsx
"use client"

import * as React from "react"
import * as TooltipPrimitive from "@radix-ui/react-tooltip"

import { cn } from "@/lib/utils"

const TooltipProvider = TooltipPrimitive.Provider

const Tooltip = TooltipPrimitive.Root

const TooltipTrigger = TooltipPrimitive.Trigger

const TooltipContent = React.forwardRef<
  React.ElementRef<typeof TooltipPrimitive.Content>,
  React.ComponentPropsWithoutRef<typeof TooltipPrimitive.Content>
>(({ className, sideOffset = 4, ...props }, ref) => (
  <TooltipPrimitive.Content
    ref={ref}
    sideOffset={sideOffset}
    className={cn(
      "z-50 overflow-hidden rounded-md border bg-popover px-3 py-1.5 text-sm text-popover-foreground shadow-md animate-in fade-in-0 zoom-in-95 data-[state=closed]:animate-out data-[state=closed]:fade-out-0 data-[state=closed]:zoom-out-95 data-[side=bottom]:slide-in-from-top-2 data-[side=left]:slide-in-from-right-2 data-[side=right]:slide-in-from-left-2 data-[side=top]:slide-in-from-bottom-2",
      className
    )}
    {...props}
  />
))
TooltipContent.displayName = TooltipPrimitive.Content.displayName

export { Tooltip, TooltipTrigger, TooltipContent, TooltipProvider }
EOF

# src/hooks files
cat << 'EOF' > src/hooks/use-developer.tsx
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
EOF

cat << 'EOF' > src/hooks/use-mobile.tsx
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
EOF

cat << 'EOF' > src/hooks/use-toast.ts
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
EOF

# src/lib files
cat << 'EOF' > src/lib/firebase.ts
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
EOF

cat << 'EOF' > src/lib/mock-vehicles.ts
// This file is no longer in use and can be safely deleted.
// It is being kept to avoid breaking file references in the project.
// The fleet management feature has been removed.
export {};
EOF

cat << 'EOF' > src/lib/notify.ts
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
EOF

cat << 'EOF' > src/lib/utils.ts
import { clsx, type ClassValue } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
EOF

# src/store files
cat << 'EOF' > src/store/notifications.ts
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

    const q = query(collection(db, "notifications"), orderBy("timestamp", "desc"));
    
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const list: Notification[] = [];
      snapshot.forEach(doc => {
          // In a real multi-tenant app, you'd filter by user.uid here in the query.
          // For this demo, we show all system notifications.
          list.push({ id: doc.id, ...doc.data() } as Notification);
      });
      set({ notifications: list });
    }, (error) => {
      console.error("Error subscribing to notifications:", error);
    });
    
    return unsubscribe;
  },
}));
EOF

cat << 'EOF' > src/store/profile.ts
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
EOF

# src/types files
cat << 'EOF' > src/types/vehicle.ts
// This file is no longer in use and can be safely deleted.
// It is being kept to avoid breaking file references in the project.
// The fleet management feature has been removed.
export {};
EOF

echo "Project setup complete!"
echo "Next steps:"
echo "1. Run 'npm install' to install dependencies."
echo "2. Run 'npm run dev' to start the development server."
