
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { aiFlows } from "@/ai/flowRegistry";
import Link from "next/link";
import { Separator } from "@/components/ui/separator";

export default function HomePage() {
  return (
    <div className="space-y-6">
      <div className="space-y-1">
        <h1 className="text-2xl font-bold tracking-tight font-headline">Welcome to ChainFlow AI</h1>
        <p className="text-muted-foreground">
          Choose a tool from the sidebar to get started. Each junction is powered by Genkit AI 
          flows to help you optimize your supply chain:
        </p>
      </div>
      <Separator/>

      <div className="grid gap-4 md:grid-cols-2">
      {aiFlows.filter(f => f.slug !== '/').map(flow => (
        <Link href={flow.slug} key={flow.slug} className="block h-full">
            <Card className="hover:border-primary hover:bg-primary/5 h-full transition-colors">
            <CardHeader>
                <div className="flex items-center gap-3">
                <flow.icon className="h-6 w-6 text-primary" />
                <CardTitle className="text-base font-semibold">{flow.name}</CardTitle>
                </div>
            </CardHeader>
            <CardContent>
                <p className="text-sm text-muted-foreground">{flow.description}</p>
            </CardContent>
            </Card>
        </Link>
        ))}
      </div>
    </div>
  );
}
