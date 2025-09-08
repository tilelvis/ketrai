import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { DashboardLayout } from "@/components/dashboard-layout";
import { FilePenLine } from "lucide-react";
import { AutomatedClaimForm } from "@/components/forms/automated-claim-form";
import { Separator } from "@/components/ui/separator";

export default function AutomatedClaimPage() {
  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight font-headline">Automated Insurance Claim</h1>
            <p className="text-muted-foreground">
                Auto-draft insurance claims for damaged or lost packages.
            </p>
        </div>
        <Separator />
        <Card>
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
      </div>
    </DashboardLayout>
  );
}
