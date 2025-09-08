import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { DashboardLayout } from "@/components/dashboard-layout";
import { Timer } from "lucide-react";
import { ProactiveEtaForm } from "@/components/forms/proactive-eta-form";
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
          <Card>
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
      </div>
    </DashboardLayout>
  );
}
