import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { DashboardLayout } from "@/components/dashboard-layout";
import { Route } from "lucide-react";
import { SmartDispatchForm } from "@/components/forms/smart-dispatch-form";
import { Separator } from "@/components/ui/separator";

export default function SmartDispatchPage() {
  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight font-headline">Smart Dispatch Assessor</h1>
            <p className="text-muted-foreground">
              Analyze route risks to find the optimal and safest path.
            </p>
        </div>
        <Separator />
        <Card>
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
      </div>
    </DashboardLayout>
  );
}
