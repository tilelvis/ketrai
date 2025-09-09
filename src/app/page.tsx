
"use client";

import { useEffect, useState } from "react";
import { db } from "@/lib/firebase";
import { collection, onSnapshot, query } from "firebase/firestore";
import type { Vehicle } from "@/types/vehicle";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table";
import { Badge } from "@/components/ui/badge";
import { seedMockVehicles, updateMockVehicleLocations } from "@/lib/mock-vehicles";
import { Loader2, MapPin, PlayCircle, Bot, Wind, TrafficCone } from "lucide-react";
import { Skeleton } from "@/components/ui/skeleton";
import Image from "next/image";
import { toast } from "sonner";
import { Separator } from "@/components/ui/separator";

function VehicleMapPlaceholder() {
  return (
    <Card className="overflow-hidden">
      <CardHeader>
        <CardTitle>Fleet Monitor</CardTitle>
        <CardDescription>Real-time positions of all active vehicles.</CardDescription>
      </CardHeader>
      <CardContent className="p-0">
        <div className="relative h-96 w-full bg-muted">
          <Image src="https://picsum.photos/1200/400" layout="fill" objectFit="cover" alt="Map of Kenya" data-ai-hint="map kenya" />
          <div className="absolute inset-0 bg-gradient-to-t from-background to-transparent" />
          <div className="absolute inset-0 flex items-center justify-center">
            <div className="text-center p-4 bg-background/80 rounded-lg backdrop-blur-sm">
                <MapPin className="h-10 w-10 text-primary mx-auto" />
                <h3 className="mt-2 text-lg font-semibold">Live Map Placeholder</h3>
                <p className="mt-1 text-sm text-muted-foreground">Vehicle locations would be displayed here.</p>
            </div>
          </div>
        </div>
      </CardContent>
    </Card>
  )
}

export default function DashboardPage() {
  const [vehicles, setVehicles] = useState<Vehicle[]>([]);
  const [loading, setLoading] = useState(true);
  const [isSeeding, setIsSeeding] = useState(false);
  const [isUpdating, setIsUpdating] = useState(false);
  const [updateIntervalId, setUpdateIntervalId] = useState<NodeJS.Timeout | null>(null);

  useEffect(() => {
    const q = query(collection(db, "vehicles"));
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const vehicleData: Vehicle[] = snapshot.docs.map(doc => doc.data() as Vehicle);
      setVehicles(vehicleData);
      setLoading(false);
    }, (error) => {
      console.error("Error fetching vehicles:", error);
      toast.error("Failed to fetch vehicle data.");
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  async function handleSeedData() {
    setIsSeeding(true);
    toast.info("Seeding mock vehicle data...");
    const result = await seedMockVehicles();
    if (result.success) {
      toast.success("Mock data seeded successfully!");
    } else {
      toast.error("Failed to seed mock data.");
    }
    setIsSeeding(false);
  }

  function handleToggleUpdates() {
    if (updateIntervalId) {
      clearInterval(updateIntervalId);
      setUpdateIntervalId(null);
      toast.info("Live updates stopped.");
    } else {
      toast.info("Starting live vehicle updates...");
      updateMockVehicleLocations(); // Initial update
      const intervalId = setInterval(updateMockVehicleLocations, 5000);
      setUpdateIntervalId(intervalId);
    }
  }

  const getStatusVariant = (status: Vehicle['status']) => {
    switch (status) {
        case 'in_transit': return 'default';
        case 'loading': return 'secondary';
        case 'idle': return 'outline';
        case 'delivered': return 'default';
        case 'delayed': return 'destructive';
        default: return 'outline';
    }
  };

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div className="space-y-1">
            <h1 className="text-2xl font-bold tracking-tight font-headline">Live Fleet Dashboard</h1>
            <p className="text-muted-foreground">
            Monitor vehicle locations and statuses in real-time.
            </p>
        </div>
        <div className="flex gap-2">
            <Button onClick={handleSeedData} disabled={isSeeding} variant="outline">
                {isSeeding ? <Loader2 className="mr-2 animate-spin" /> : <Bot className="mr-2" />}
                Seed Mock Data
            </Button>
            <Button onClick={handleToggleUpdates} disabled={isUpdating}>
                 {updateIntervalId ? <Loader2 className="mr-2 animate-spin" /> : <PlayCircle className="mr-2" />}
                {updateIntervalId ? 'Stop Updates' : 'Start Updates'}
            </Button>
        </div>
      </div>
      <Separator />

      <VehicleMapPlaceholder />

      <Card>
        <CardHeader>
          <CardTitle>Vehicle Status</CardTitle>
          <CardDescription>Detailed list of all vehicles and their current operational status.</CardDescription>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Vehicle ID</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Location (Lat, Lng)</TableHead>
                <TableHead>ETA</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {loading ? (
                [...Array(3)].map((_, i) => (
                  <TableRow key={i}>
                    <TableCell><Skeleton className="h-4 w-24" /></TableCell>
                    <TableCell><Skeleton className="h-6 w-20 rounded-full" /></TableCell>
                    <TableCell><Skeleton className="h-4 w-32" /></TableCell>
                    <TableCell><Skeleton className="h-4 w-40" /></TableCell>
                  </TableRow>
                ))
              ) : vehicles.length === 0 ? (
                 <TableRow>
                    <TableCell colSpan={4} className="text-center h-24 text-muted-foreground">
                        No vehicle data found. Try seeding mock data to get started.
                    </TableCell>
                </TableRow>
              ) : (
                vehicles.map((v) => (
                  <TableRow key={v.id}>
                    <TableCell className="font-medium">{v.id}</TableCell>
                    <TableCell>
                        <Badge variant={getStatusVariant(v.status)} className="capitalize">
                            {v.status.replace("_", " ")}
                        </Badge>
                    </TableCell>
                    <TableCell className="font-mono text-xs">
                      {v.lastLocation.lat.toFixed(4)}, {v.lastLocation.lng.toFixed(4)}
                    </TableCell>
                    <TableCell>
                      {new Date(v.eta).toLocaleString()}
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
      
       <Card>
        <CardHeader>
            <CardTitle>AI Insights</CardTitle>
            <CardDescription>Genkit flows can be triggered by Firestore updates to provide proactive insights.</CardDescription>
        </CardHeader>
        <CardContent className="grid md:grid-cols-2 gap-4 text-sm">
            <div className="flex items-start gap-3 p-3 rounded-md bg-secondary/50">
                <TrafficCone className="h-5 w-5 text-amber-600 mt-1"/>
                <div>
                    <h4 className="font-semibold">Traffic Analysis</h4>
                    <p className="text-muted-foreground">A flow could call the Google Maps API, detect a delay for vehicle <span className="font-semibold text-foreground">KDA 123B</span>, and recalculate the ETA.</p>
                </div>
            </div>
             <div className="flex items-start gap-3 p-3 rounded-md bg-secondary/50">
                <Wind className="h-5 w-5 text-blue-500 mt-1"/>
                <div>
                    <h4 className="font-semibold">Weather Alerts</h4>
                    <p className="text-muted-foreground">An update could trigger a weather API call, warning that vehicle <span className="font-semibold text-foreground">KDB 456C</span> is heading towards a storm.</p>
                </div>
            </div>
        </CardContent>
       </Card>

    </div>
  );
}
