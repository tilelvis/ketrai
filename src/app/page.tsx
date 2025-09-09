import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { DashboardLayout } from "@/components/dashboard-layout";
import { Timer, AlertCircle, Package, Truck, ShieldX } from "lucide-react";
import { ProactiveEtaForm } from "@/components/forms/proactive-eta-form";
import { Separator } from "@/components/ui/separator";

export default function Home() {
  return (
    <DashboardLayout>
      <div className="space-y-6">
        <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight font-headline">Dashboard</h1>
            <p className="text-muted-foreground">
                An overview of your supply chain operations.
            </p>
        </div>
        <Separator />
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">
                Live Shipments
              </CardTitle>
              <Truck className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">1,234</div>
              <p className="text-xs text-muted-foreground">
                +20.1% from last month
              </p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">
                ETA Alerts
              </CardTitle>
              <AlertCircle className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">+52</div>
              <p className="text-xs text-muted-foreground">
                in the last 24 hours
              </p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">Active Claims</CardTitle>
              <Package className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">42</div>
              <p className="text-xs text-muted-foreground">
                +19% from last month
              </p>
            </CardContent>
          </Card>
          <Card>
            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
              <CardTitle className="text-sm font-medium">
                At-Risk Routes
              </CardTitle>
              <ShieldX className="h-4 w-4 text-muted-foreground" />
            </CardHeader>
            <CardContent>
              <div className="text-2xl font-bold">12</div>
              <p className="text-xs text-muted-foreground">
                currently under review
              </p>
            </CardContent>
          </Card>
        </div>
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
