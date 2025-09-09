/**
 * @fileOverview A central registry for all AI flows available in the application.
 * This allows for dynamic generation of navigation and easy registration of new flows.
 */

import { FilePenLine, Home, Route, ShieldAlert, Timer, User, Settings } from "lucide-react";

export const aiFlows = [
  { 
    name: "Dashboard", 
    slug: "/",
    file: "proactive-eta-calculation",
    icon: Home,
    description: "AI-Powered Workflows for supply chain orchestration.",
    roles: ['dispatcher', 'claims', 'support'],
  },
  {
    name: "Proactive ETA",
    slug: "/proactive-eta",
    file: "proactive-eta-calculation",
    icon: Timer,
    description: "Recalculate delivery ETAs in real-time using traffic and weather.",
    roles: ['dispatcher', 'support'],
  },
  { 
    name: "Smart Dispatch", 
    slug: "/smart-dispatch", 
    file: "smart-dispatch-recommendation",
    icon: Route,
    description: "Analyze route risks to find the optimal and safest path.",
    roles: ['dispatcher'],
  },
  { 
    name: "Automated Claim", 
    slug: "/automated-claim", 
    file: "automated-insurance-claim-draft",
    icon: FilePenLine,
    description: "Auto-draft insurance claims for damaged or lost packages.",
    roles: ['claims'],
  },
  { 
    name: "Risk Visibility", 
    slug: "/risk-visibility", 
    file: "cross-carrier-risk-visibility",
    icon: ShieldAlert,
    description: "Aggregate shipment data to identify and report on supply chain risks.",
    roles: ['dispatcher'],
  },
  {
    name: "Profile",
    slug: "/profile",
    file: "",
    icon: User,
    description: "User profile settings.",
    roles: ['dispatcher', 'claims', 'support'],
  },
  {
    name: "Settings",
    slug: "/settings",
    file: "",
    icon: Settings,
    description: "Application settings.",
    roles: ['dispatcher', 'claims', 'support'],
  },
];

export const getFlowBySlug = (slug: string) => {
    return aiFlows.find(flow => flow.slug === slug);
}
