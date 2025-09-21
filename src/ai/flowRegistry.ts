/**
 * @fileOverview A central registry for all AI flows available in the application.
 * This allows for dynamic generation of navigation and easy registration of new flows.
 */

import { FilePenLine, Home, Route, ShieldAlert, Timer, User, Settings, Users, ClipboardList, ScrollText } from "lucide-react";

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
    name: "Audit Log",
    slug: "/admin/audit-log",
    file: "",
    icon: ScrollText,
    description: "View a complete log of all system and user events.",
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
