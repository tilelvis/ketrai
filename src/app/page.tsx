import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { DashboardLayout } from "@/components/dashboard-layout";
import { FilePenLine, Route, ShieldAlert, Timer } from "lucide-react";
import { ProactiveEtaForm } from "@/components/forms/proactive-eta-form";
import { SmartDispatchForm } from "@/components/forms/smart-dispatch-form";
import { AutomatedClaimForm } from "@/components/forms/automated-claim-form";
import { RiskVisibilityReport } from "@/components/forms/risk-visibility-report";
import { Separator } from "@/components/ui/separator";

export default function Home() {
  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight font-headline">AI-Powered Workflows</h1>
            <p className="text-muted-foreground">
                Interact with your Genkit flows for supply chain orchestration.
            </p>
        </div>
        <Separator />
        <div className="grid gap-6 lg:grid-cols-2">
          <Card className="col-span-1">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-lg font-medium font-headline">Proactive ETA Calculator</CardTitle>
              <Timer className="h-5 w-5 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <CardDescription className="mb-4">
                Recalculate ETAs based on real-time traffic and weather data.
              </CardDescription>
              <ProactiveEtaForm />
            </CardContent>
          </Card>

          <Card className="col-span-1">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-lg font-medium font-headline">Smart Dispatch Assessor</CardTitle>
              <Route className="h-5 w-5 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <CardDescription className="mb-4">
                Analyze route risks to find the optimal and safest path.
              </CardDescription>
              <SmartDispatchForm />
            </CardContent>
          </Card>

          <Card className="col-span-1">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-lg font-medium font-headline">Automated Insurance Claim</CardTitle>
              <FilePenLine className="h-5 w-5 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <CardDescription className="mb-4">
                Auto-draft insurance claims for damaged or lost packages.
              </CardDescription>
              <AutomatedClaimForm />
            </CardContent>
          </Card>

          <Card className="col-span-1">
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-lg font-medium font-headline">Cross-Carrier Risk Visibility</CardTitle>
              <ShieldAlert className="h-5 w-5 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <CardDescription className="mb-4">
                Aggregate shipment data to identify and report on supply chain risks.
              </CardDescription>
              <RiskVisibilityReport />
            </CardContent>
          </Card>
        </div>
      </div>
    </DashboardLayout>
  );
}
