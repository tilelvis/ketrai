"use client";

import { useState } from "react";
import { runProactiveEta } from "@/app/proactive-eta/actions";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Loader2 } from "lucide-react";

export function ProactiveEtaForm({
  onComplete,
}: {
  onComplete: (result: any) => void;
}) {
  const [route, setRoute] = useState("Route from warehouse A to customer address at 123 Main St.");
  const [plannedEta, setPlannedEta] = useState("2024-08-15T15:00:00Z");
  const [traffic, setTraffic] = useState("Moderate congestion on I-5, accident near exit 4.");
  const [weather, setWeather] = useState("Light rain, 15 mph winds.");
  const [loading, setLoading] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    const result = await runProactiveEta({ route, plannedEta, traffic, weather });
    onComplete(result);
    setLoading(false);
  }

  return (
    <form onSubmit={handleSubmit} className="space-y-4">
      <Input
        placeholder="Planned Route"
        value={route}
        onChange={(e) => setRoute(e.target.value)}
        required
      />
      <Input
        placeholder="Planned ETA (ISO format e.g. 2025-09-09T16:30:00Z)"
        value={plannedEta}
        onChange={(e) => setPlannedEta(e.target.value)}
        required
      />
      <Textarea
        placeholder="Traffic conditions"
        value={traffic}
        onChange={(e) => setTraffic(e.target.value)}
        required
      />
      <Textarea
        placeholder="Weather conditions"
        value={weather}
        onChange={(e) => setWeather(e.target.value)}
        required
      />
      <Button type="submit" disabled={loading} className="w-full">
        {loading && <Loader2 className="mr-2 h-4 w-4 animate-spin" />}
        {loading ? "Calculating..." : "Recalculate ETA"}
      </Button>
    </form>
  );
}
