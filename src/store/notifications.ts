
import { create } from "zustand";
import { db } from "@/lib/firebase";
import {
  addDoc,
  collection,
  deleteDoc,
  doc,
  onSnapshot,
  orderBy,
  query,
  serverTimestamp,
} from "firebase/firestore";

export type Notification = {
  id: string;
  message: string;
  type: "success" | "warning" | "error" | "info" | "risk";
  severity?: "low" | "medium" | "high";
  timestamp: any; // Firestore timestamp object
};

type NotificationStore = {
  notifications: Notification[];
  add: (n: Omit<Notification, "id" | "timestamp">) => Promise<void>;
  remove: (id: string) => Promise<void>;
  clear: () => Promise<void>;
  subscribe: () => () => void; // Returns an unsubscribe function
};

export const useNotificationStore = create<NotificationStore>((set, get) => ({
  notifications: [],

  add: async (n) => {
    try {
      await addDoc(collection(db, "notifications"), {
        ...n,
        timestamp: serverTimestamp(),
      });
    } catch (error) {
      console.error("Error adding notification to Firestore:", error);
    }
  },

  remove: async (id) => {
    try {
      await deleteDoc(doc(db, "notifications", id));
    } catch (error) {
      console.error("Error removing notification from Firestore:", error);
    }
  },

  clear: async () => {
    // In a real app, this should be a batched write or a Cloud Function.
    // For this demo, we'll clear them one by one.
    console.warn("Clearing all notifications from Firestore.");
    const { notifications } = get();
    await Promise.all(notifications.map(n => deleteDoc(doc(db, "notifications", n.id))));
  },

  subscribe: () => {
    const q = query(collection(db, "notifications"), orderBy("timestamp", "desc"));
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const list: Notification[] = snapshot.docs.map((d) => ({
        id: d.id,
        ...(d.data() as Omit<Notification, "id">),
      }));
      set({ notifications: list });
    }, (error) => {
      console.error("Error subscribing to notifications:", error);
    });
    return unsubscribe;
  },
}));
