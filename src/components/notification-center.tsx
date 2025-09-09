
"use client";

import { Bell, X } from "lucide-react";
import { useNotificationStore } from "@/store/notifications";
import { useState } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { cn } from "@/lib/utils";

export function NotificationCenter() {
  const { notifications, remove, clear } = useNotificationStore();
  const [open, setOpen] = useState(false);

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
  }

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
            className="absolute -top-1 -right-1 flex h-4 w-4 items-center justify-center rounded-full bg-red-600 text-xs text-white"
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
            className="absolute right-0 mt-2 w-80 rounded-lg border bg-popover shadow-xl z-50"
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

            <div className="max-h-96 overflow-y-auto">
              {notifications.length === 0 ? (
                <p className="p-4 text-sm text-center text-muted-foreground">No new notifications</p>
              ) : (
                notifications.map((n) => (
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
                      <span className="text-xs text-muted-foreground">
                        {new Date(n.timestamp).toLocaleTimeString()}
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
