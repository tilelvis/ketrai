import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { DashboardLayout } from "@/components/dashboard-layout";
import { ShieldAlert } from "lucide-react";
import { RiskVisibilityReport } from "@/components/forms/risk-visibility-report";
import { Separator } from "@/components/ui/separator";

export default function RiskVisibilityPage() {
  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight font-headline">Cross-Carrier Risk Visibility</h1>
            <p className="text-muted-foreground">
              Aggregate shipment data to identify and report on supply chain risks.
            </p>
        </div>
        <Separator />
        <Card>
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
    </DashboardLayout>
  );
}
