
"use client";

import { Bell, X } from "lucide-react";
import { useNotificationStore, Notification } from "@/store/notifications";
import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { cn } from "@/lib/utils";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Separator } from "@/components/ui/separator";

function formatTimestamp(timestamp: any): string {
  if (!timestamp || !timestamp.toDate) {
    return new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  }
  return timestamp.toDate().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
}

const categories: Notification['category'][] = ["dispatch", "eta", "claims", "cross-carrier", "system"];

export function NotificationCenter() {
  const { notifications, remove, clear } = useNotificationStore();
  const [open, setOpen] = useState(false);
  const [filter, setFilter] = useState<string>("all");

  const typeColors = {
    error: "bg-red-600",
    warning: "bg-yellow-500",
    success: "bg-green-600",
    info: "bg-blue-600",
    risk: "bg-fuchsia-600",
  };

  const riskColors = {
    high: "bg-red-600",
    medium: "bg-yellow-500",
    low: "bg-blue-500",
  };
  
  const filtered =
    filter === "all"
      ? notifications
      : notifications.filter((n) => n.category === filter);

  return (
    <div className="relative">
      <button
        className="relative p-2 rounded-full hover:bg-muted"
        onClick={() => setOpen((o) => !o)}
      >
        <Bell className="h-5 w-5" />
        {notifications.length > 0 && (
          <motion.div
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            className="absolute -top-1 -right-1 flex h-5 w-5 items-center justify-center rounded-full bg-red-600 text-xs text-white"
          >
            {notifications.length}
          </motion.div>
        )}
      </button>

      <AnimatePresence>
        {open && (
          <motion.div
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            className="absolute right-0 mt-2 w-80 rounded-lg border bg-popover shadow-xl z-50 text-foreground"
          >
            <div className="flex items-center justify-between p-3 border-b">
              <h3 className="text-sm font-semibold">Notifications</h3>
              {notifications.length > 0 && (
                <button
                  onClick={clear}
                  className="text-xs text-muted-foreground hover:text-foreground"
                >
                  Clear all
                </button>
              )}
            </div>
            
            <div className="p-2 border-b">
              <Select value={filter} onValueChange={setFilter}>
                <SelectTrigger className="w-full h-8 text-xs">
                    <SelectValue placeholder="Filter by category..." />
                </SelectTrigger>
                <SelectContent>
                    <SelectItem value="all">All Categories</SelectItem>
                    <Separator className="my-1"/>
                    {categories.map((c) => (
                         <SelectItem key={c} value={c} className="capitalize">
                            {c}
                        </SelectItem>
                    ))}
                </SelectContent>
              </Select>
            </div>

            <div className="max-h-96 overflow-y-auto">
              {filtered.length === 0 ? (
                <p className="p-4 text-sm text-center text-muted-foreground">No new notifications</p>
              ) : (
                filtered.map((n: Notification) => (
                  <motion.div
                    key={n.id}
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    exit={{ opacity: 0, x: 20 }}
                    transition={{ duration: 0.2 }}
                    className="flex items-start gap-3 p-3 border-b last:border-none hover:bg-muted/50"
                  >
                    <div
                      className={cn("h-2 w-2 mt-1.5 rounded-full shrink-0", 
                        n.type === 'risk' && n.severity ? riskColors[n.severity] : typeColors[n.type]
                      )}
                    />
                    <div className="flex-1">
                      <p className="text-sm">{n.message}</p>
                      <span className="text-xs text-muted-foreground uppercase">
                        {n.category} &bull; {formatTimestamp(n.timestamp)}
                      </span>
                    </div>
                    <button onClick={() => remove(n.id)} className="p-1 text-muted-foreground hover:text-destructive rounded-full">
                      <X className="h-3 w-3" />
                    </button>
                  </motion.div>
                ))
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}
