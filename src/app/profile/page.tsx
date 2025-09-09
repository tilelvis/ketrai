
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from "@/components/ui/card";
import { Separator } from "@/components/ui/separator";

export default function ProfilePage() {
  return (
    <div className="space-y-6">
      <div className="space-y-1">
        <h1 className="text-2xl font-bold tracking-tight font-headline">Profile</h1>
        <p className="text-muted-foreground">
          View and manage your profile settings.
        </p>
      </div>
      <Separator />
      <Card>
        <CardHeader>
          <CardTitle>User Profile</CardTitle>
          <CardDescription>This is a placeholder page for user profile.</CardDescription>
        </CardHeader>
        <CardContent>
            <p>User details and settings will be displayed here.</p>
        </CardContent>
      </Card>
    </div>
  );
}
