
import { create } from "zustand";

export type Notification = {
  id: string;
  message: string;
  type: "success" | "warning" | "error" | "info" | "risk";
  severity?: "low" | "medium" | "high";
  timestamp: number;
};

type NotificationStore = {
  notifications: Notification[];
  add: (n: Omit<Notification, "id" | "timestamp">) => void;
  remove: (id: string) => void;
  clear: () => void;
};

export const useNotificationStore = create<NotificationStore>((set) => ({
  notifications: [],
  add: (n) =>
    set((state) => ({
      notifications: [
        {
          id: crypto.randomUUID(),
          timestamp: Date.now(),
          ...n,
        },
        ...state.notifications,
      ].slice(0, 20), // keep last 20
    })),
  remove: (id) =>
    set((state) => ({
      notifications: state.notifications.filter((n) => n.id !== id),
    })),
  clear: () => set({ notifications: [] }),
}));
