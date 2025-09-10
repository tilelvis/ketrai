import { create } from "zustand";
import { db, auth, collection, onSnapshot, orderBy, query, where, addDoc, serverTimestamp, writeBatch, doc, deleteDoc } from "@/lib/firebase";

export type Notification = {
  id: string;
  type: "claim" | "system" | "eta" | "dispatch" | "cross-carrier" | "risk" | "info" | "success" | "warning" | "error";
  message: string;
  read: boolean;
  createdAt: any; // Firestore timestamp
  // Optional fields
  claimId?: string;
  severity?: "low" | "medium" | "high";
  category?: string;
};

type NotificationStore = {
  notifications: Notification[];
  subscribe: () => () => void; // Returns an unsubscribe function
  remove: (id: string) => Promise<void>;
  clear: () => Promise<void>;
};

export const useNotificationStore = create<NotificationStore>((set, get) => ({
  notifications: [],

  subscribe: () => {
    const user = auth.currentUser;
    if (!user) {
        console.log("No user for notification subscription.");
        return () => {};
    }

    const q = query(
      collection(db, "users", user.uid, "notifications"),
      orderBy("createdAt", "desc")
    );
    
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const list: Notification[] = [];
      snapshot.forEach(doc => {
          list.push({ id: doc.id, ...doc.data() } as Notification);
      });
      set({ notifications: list });
    }, (error) => {
      console.error("Error subscribing to notifications:", error);
    });
    
    return unsubscribe;
  },

  remove: async (id: string) => {
    const user = auth.currentUser;
    if (!user) return;
    try {
      await deleteDoc(doc(db, "users", user.uid, "notifications", id));
    } catch (error) {
      console.error("Error removing notification:", error);
    }
  },

  clear: async () => {
    const user = auth.currentUser;
    const { notifications } = get();
    if (!user || notifications.length === 0) return;
    
    const batch = writeBatch(db);
    notifications.forEach((n) => {
      const docRef = doc(db, "users", user.uid, "notifications", n.id);
      batch.delete(docRef);
    });

    try {
      await batch.commit();
    } catch (error) {
      console.error("Error clearing notifications:", error);
    }
  },
}));

// Note: The global `notify` helper in `src/lib/notify.ts` is now only for ephemeral UI toasts.
// All persistent notifications should be created by writing directly to the `users/{uid}/notifications` collection.
