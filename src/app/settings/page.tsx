
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";

export default function SettingsPage() {
  return (
    <div className="space-y-6">
       <div className="space-y-1">
        <h1 className="text-2xl font-bold tracking-tight font-headline">Settings</h1>
        <p className="text-muted-foreground">
            Configure application settings.
        </p>
      </div>
      <Separator />
      <Card>
        <CardHeader>
          <CardTitle>Application Settings</CardTitle>
          <CardDescription>This is a placeholder page for application settings.</CardDescription>
        </CardHeader>
        <CardContent>
            <p>Application-wide settings and preferences will be available here.</p>
        </CardContent>
      </Card>
    </div>
  );
}
