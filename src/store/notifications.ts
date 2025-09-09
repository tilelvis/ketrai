

import { create } from "zustand";
import { db, auth } from "@/lib/firebase";
import {
  addDoc,
  collection,
  deleteDoc,
  doc,
  onSnapshot,
  orderBy,
  query,
  serverTimestamp,
  writeBatch,
} from "firebase/firestore";

export type Notification = {
  id: string;
  uid: string; // User ID of the creator
  message: string;
  type: "success" | "warning" | "error" | "info" | "risk";
  category: "dispatch" | "eta" | "claims" | "cross-carrier" | "system";
  severity?: "low" | "medium" | "high";
  timestamp: any; // Firestore timestamp object
};

type NotificationStore = {
  notifications: Notification[];
  add: (n: Omit<Notification, "id" | "timestamp" | "uid">) => Promise<void>;
  remove: (id: string) => Promise<void>;
  clear: () => Promise<void>;
  subscribe: () => () => void; // Returns an unsubscribe function
};

export const useNotificationStore = create<NotificationStore>((set, get) => ({
  notifications: [],

  add: async (n) => {
    const user = auth.currentUser;
    if (!user) {
        console.error("Cannot add notification. User not authenticated.");
        return;
    }
    try {
      await addDoc(collection(db, "notifications"), {
        ...n,
        uid: user.uid,
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
    const { notifications } = get();
    const user = auth.currentUser;

    if (!user || notifications.length === 0) return;

    // Filter for notifications that have a UID and belong to the current user.
    // This prevents trying to delete old notifications that are missing a UID.
    const userNotifications = notifications.filter(n => n.uid && n.uid === user.uid);
    if (userNotifications.length === 0) {
      console.warn("No notifications found for the current user to clear.");
      return;
    }
    
    const batch = writeBatch(db);
    userNotifications.forEach((n) => {
      const docRef = doc(db, "notifications", n.id);
      batch.delete(docRef);
    });

    try {
      await batch.commit();
    } catch (error) {
      console.error("Error clearing notifications with a batch write:", error);
    }
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
