
"use client";

import { useState } from "react";
import { runCrossCarrierVisibility } from "@/app/risk-visibility/actions";
import type { CrossCarrierRiskVisibilityOutput } from "@/ai/flows/cross-carrier-risk-visibility";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../ui/card";
import { PlusCircle, ShieldAlert, XCircle, Loader2 } from "lucide-react";

export function CrossCarrierForm({ onComplete }: { onComplete: (result: CrossCarrierRiskVisibilityOutput) => void }) {
  const [shipments, setShipments] = useState<any[]>([
    { carrier: "DHL", trackingNumber: "DHL12345", status: "In Transit", location: "Nairobi, KE", eta: "2024-08-01" },
    { carrier: "UPS", trackingNumber: "UPS67890", status: "Delayed", location: "Mombasa, KE", eta: "2024-08-02" },
  ]);
  const [alerts, setAlerts] = useState("Port strike in Mombasa\nWeather: Nairobi floods");
  const [loading, setLoading] = useState(false);

  function addShipment() {
    setShipments([
      ...shipments,
      { carrier: "", trackingNumber: "", status: "", location: "", eta: "" },
    ]);
  }

  function removeShipment(index: number) {
    const updated = shipments.filter((_, i) => i !== index);
    setShipments(updated);
  }

  function updateShipment(index: number, field: string, value: string) {
    const updated = [...shipments];
    updated[index][field] = value;
    setShipments(updated);
  }

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    const result = await runCrossCarrierVisibility({
      shipments,
      alerts: alerts.split("\n").filter(Boolean),
    });
    onComplete(result);
    setLoading(false);
  }

  return (
    <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
            <CardTitle className="text-lg font-medium font-headline">Risk Analysis Inputs</CardTitle>
            <ShieldAlert className="h-5 w-5 text-muted-foreground" />
        </CardHeader>
        <CardContent>
            <CardDescription className="mb-4">
                Add shipments from multiple carriers and any global alerts to generate a unified risk report.
            </CardDescription>
            <form onSubmit={handleSubmit} className="space-y-6">
                <div className="space-y-4">
                    <h3 className="text-sm font-medium text-muted-foreground">Shipments</h3>
                    {shipments.map((s, i) => (
                    <div key={i} className="relative border p-4 rounded-md space-y-3 bg-secondary/30">
                        <div className="grid md:grid-cols-2 gap-3">
                            <Input
                                placeholder="Carrier"
                                value={s.carrier}
                                onChange={(e) => updateShipment(i, "carrier", e.target.value)}
                            />
                            <Input
                                placeholder="Tracking Number"
                                value={s.trackingNumber}
                                onChange={(e) => updateShipment(i, "trackingNumber", e.target.value)}
                            />
                             <Input
                                placeholder="Status"
                                value={s.status}
                                onChange={(e) => updateShipment(i, "status", e.target.value)}
                            />
                            <Input
                                placeholder="Location"
                                value={s.location}
                                onChange={(e) => updateShipment(i, "location", e.target.value)}
                            />
                        </div>
                        <Input
                            placeholder="ETA (optional)"
                            value={s.eta}
                            onChange={(e) => updateShipment(i, "eta", e.target.value)}
                        />
                        <button type="button" onClick={() => removeShipment(i)} className="absolute -top-2 -right-2 text-muted-foreground hover:text-destructive">
                            <XCircle size={18} />
                        </button>
                    </div>
                    ))}
                    <Button type="button" variant="outline" size="sm" onClick={addShipment}>
                        <PlusCircle className="mr-2" /> Add Shipment
                    </Button>
                </div>

                <div>
                    <h3 className="text-sm font-medium text-muted-foreground mb-2">Global Alerts</h3>
                    <Textarea
                        placeholder="Enter global alerts (one per line, e.g., Weather: Heavy storms)"
                        value={alerts}
                        onChange={(e) => setAlerts(e.target.value)}
                        rows={3}
                    />
                </div>

                <Button type="submit" disabled={loading} className="w-full">
                    {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
                    {loading ? "Analyzing..." : "Generate Report"}
                </Button>
            </form>
        </CardContent>
    </Card>
  );
}
