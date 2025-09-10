
"use client";

import { useState } from "react";
import { runProactiveEta } from "@/app/proactive-eta/actions";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Loader2 } from "lucide-react";
import { notify } from "@/lib/notify";
import type { ProactiveEtaCalculationOutput } from "@/ai/flows/proactive-eta-calculation";

export function ProactiveEtaForm({
  onComplete,
}: {
  onComplete: (result: ProactiveEtaCalculationOutput) => void;
}) {
  const [route, setRoute] = useState("Route from Nairobi CBD to a customer in Ruaka.");
  const [plannedEta, setPlannedEta] = useState(new Date(Date.now() + 2 * 60 * 60 * 1000).toISOString());
  const [traffic, setTraffic] = useState("Heavy traffic on Waiyaki Way, accident near ABC Place.");
  const [weather, setWeather] = useState("Heavy rainfall and thunderstorms expected in the afternoon.");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    notify.info("Recalculating ETA...", "eta");

    try {
      const result = await runProactiveEta({ route, plannedEta, traffic, weather });

      if (result.riskLevel === "high") {
        notify.risk(`High risk of delay for route: ${route}`, "high", "eta");
      } else if (result.riskLevel === "medium") {
        notify.risk(`Medium risk of delay for route: ${route}`, "medium", "eta");
      } else {
        notify.success("ETA recalculated successfully!", "eta");
      }
      onComplete(result);

    } catch (err) {
        notify.error(err instanceof Error ? err.message : "An unknown error occurred.", "eta");
    } finally {
        setLoading(false);
    }
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <div>
        <label htmlFor="route" className="text-sm font-medium">Planned Route</label>
        <Input
            id="route"
            placeholder="Planned Route"
            value={route}
            onChange={(e) => setRoute(e.target.value)}
            required
        />
      </div>
       <div>
        <label htmlFor="eta" className="text-sm font-medium">Planned ETA</label>
        <Input
            id="eta"
            placeholder="Planned ETA (ISO format e.g. 2025-09-09T16:30:00Z)"
            value={plannedEta}
            onChange={(e) => setPlannedEta(e.target.value)}
            required
        />
       </div>
      <div>
        <label htmlFor="traffic" className="text-sm font-medium">Traffic Conditions</label>
        <Textarea
            id="traffic"
            placeholder="Traffic conditions"
            value={traffic}
            onChange={(e) => setTraffic(e.target.value)}
            required
        />
      </div>
      <div>
        <label htmlFor="weather" className="text-sm font-medium">Weather Conditions</label>
        <Textarea
            id="weather"
            placeholder="Weather conditions"
            value={weather}
            onChange={(e) => setWeather(e.target.value)}
            required
        />
      </div>
      <Button type="submit" disabled={loading} className="w-full">
        {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        {loading ? "Calculating..." : "Recalculate ETA"}
      </Button>
    </form>
  );
}
