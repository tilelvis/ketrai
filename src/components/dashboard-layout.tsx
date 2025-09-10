
"use client";

import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import { cn } from "@/lib/utils";
import { Logo } from "./icons";
import { aiFlows } from "@/ai/flowRegistry";
import { Home, Loader2, Users } from "lucide-react";
import { ThemeToggle } from "@/components/ui/theme-toggle";
import { NotificationCenter } from "@/components/notification-center";
import { useEffect, useState } from "react";
import { useNotificationStore } from "@/store/notifications";
import { onAuthStateChanged, auth, fetchUserProfile, db, doc, setDoc } from "@/lib/firebase";
import { useProfileStore } from "@/store/profile";
import { ProfileMenu } from "./profile-menu";

export function DashboardLayout({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const router = useRouter();
  const subscribe = useNotificationStore((s) => s.subscribe);
  const { setUser, setProfile, profile, user } = useProfileStore();
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let notificationUnsubscribe: (() => void) | null = null;

    const authUnsubscribe = onAuthStateChanged(auth, async (user) => {
      setUser(user);

      if (notificationUnsubscribe) {
        notificationUnsubscribe();
        notificationUnsubscribe = null;
      }

      if (user) {
        let profileData = await fetchUserProfile(user);
        if (!profileData) {
            console.log("Profile not found for existing user, creating one now.");
            const newProfile = {
              uid: user.uid,
              email: user.email,
              name: user.displayName ?? user.email?.split('@')[0] ?? "New User",
              role: "dispatcher",
              theme: "system",
              status: "active",
              createdAt: new Date().toISOString(),
              photoURL: user.photoURL ?? "",
            };
            await setDoc(doc(db, "users", user.uid), newProfile);
            profileData = newProfile;
        }

        setProfile(profileData as any);
        notificationUnsubscribe = subscribe();
      } else {
        setProfile(null);
        if (pathname !== '/login' && !pathname.startsWith('/invite')) {
            router.push('/login');
        }
      }
      setLoading(false);
    });

    return () => {
      authUnsubscribe();
      if (notificationUnsubscribe) {
        notificationUnsubscribe();
      }
    };
  }, [subscribe, setProfile, setUser, router, pathname]);

  const mainNavItems = aiFlows.filter(f => 
      f.slug !== "/" && 
      f.slug !== "/profile" && 
      f.slug !== "/settings" &&
      f.slug !== "/admin/users" &&
      profile?.role && f.roles.includes(profile.role)
  );

  const bottomNavItems = aiFlows.filter((f) => 
    (f.slug === "/profile" || f.slug === "/settings") &&
    profile?.role && f.roles.includes(profile.role)
  );

  if (pathname === '/login' || pathname.startsWith('/invite')) {
     if (loading) {
         return (
             <div className="flex h-screen w-full items-center justify-center">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
            </div>
         )
     }
    return <>{children}</>;
  }

  if (loading) {
    return (
        <div className="flex h-screen w-full items-center justify-center">
            <Loader2 className="h-8 w-8 animate-spin text-primary" />
        </div>
    )
  }

  return (
    <div className="flex min-h-screen bg-background/50">
      <aside className="w-64 flex-col fixed inset-y-0 z-10 hidden border-r bg-card p-6 md:flex">
        <div className="flex items-center gap-2 mb-8">
          <Logo className="size-8 text-primary" />
          <h1 className="text-xl font-semibold font-headline">ChainFlow AI</h1>
        </div>
        <nav className="space-y-2 flex-1">
          <Link
            href="/"
            className={cn(
              "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors hover:bg-muted",
              pathname === "/"
                ? "bg-primary/10 text-primary"
                : "text-muted-foreground hover:text-foreground"
            )}
          >
            <Home className="h-4 w-4" />
            Dashboard
          </Link>
          {mainNavItems.map((item) => (
            <Link
              key={item.slug}
              href={item.slug}
              className={cn(
                "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors hover:bg-muted",
                pathname.startsWith(item.slug)
                  ? "bg-primary/10 text-primary"
                  : "text-muted-foreground hover:text-foreground"
              )}
            >
              <item.icon className="h-4 w-4" />
              {item.name}
            </Link>
          ))}
          {profile?.role === 'admin' && (
             <div className="pt-4">
                <h2 className="px-3 text-xs font-semibold text-muted-foreground tracking-wider uppercase mb-1">Admin</h2>
                <Link
                    href="/admin/users"
                    className={cn(
                        "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors hover:bg-muted",
                        pathname.startsWith("/admin/users")
                        ? "bg-primary/10 text-primary"
                        : "text-muted-foreground hover:text-foreground"
                    )}
                    >
                    <Users className="h-4 w-4" />
                    User Management
                </Link>
            </div>
          )}
        </nav>
        <div className="mt-auto">
          <nav className="space-y-2">
            {bottomNavItems
              .map((item) => (
                <Link
                  key={item.slug}
                  href={item.slug}
                  className={cn(
                    "flex items-center gap-3 rounded-md px-3 py-2 text-sm font-medium transition-colors hover:bg-muted",
                    pathname.startsWith(item.slug)
                      ? "bg-primary/10 text-primary"
                      : "text-muted-foreground hover:text-foreground"
                  )}
                >
                  <item.icon className="h-4 w-4" />
                  {item.name}
                </Link>
              ))}
          </nav>
        </div>
      </aside>

      <div className="flex-1 flex flex-col md:pl-64">
        <header className="flex h-16 items-center justify-end border-b bg-card px-6 sticky top-0 z-20">
          <div className="flex items-center gap-4">
            <NotificationCenter />
            <ThemeToggle />
            <ProfileMenu />
          </div>
        </header>
        <main className="flex-1 p-8">
            <div className="max-w-4xl mx-auto">
                {children}
            </div>
        </main>
      </div>
    </div>
  );
}
