/**
 * @fileOverview A central registry for all AI flows available in the application.
 * This allows for dynamic generation of navigation and easy registration of new flows.
 */

import { FilePenLine, Home, Route, ShieldAlert, Timer, User, Settings, Users } from "lucide-react";

export const aiFlows = [
  { 
    name: "Dashboard", 
    slug: "/",
    file: "proactive-eta-calculation",
    icon: Home,
    description: "AI-Powered Workflows for supply chain orchestration.",
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
    description: "Auto-draft insurance claims for damaged or lost packages.",
    roles: ['claims', 'manager', 'admin'],
  },
  { 
    name: "Risk Visibility", 
    slug: "/risk-visibility", 
    file: "cross-carrier-risk-visibility",
    icon: ShieldAlert,
    description: "Aggregate shipment data to identify and report on supply chain risks.",
    roles: ['dispatcher', 'manager', 'admin'],
  },
  {
    name: "User Management",
    slug: "/user-management",
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
