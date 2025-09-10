
import { create } from "zustand";
import { db, auth, addDoc, collection, deleteDoc, doc, onSnapshot, orderBy, query, serverTimestamp, writeBatch } from "@/lib/firebase";

export type Notification = {
  id: string;
  uid: string; // User ID of the recipient
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
    if (notifications.length === 0) return;
    
    const batch = writeBatch(db);
    notifications.forEach((n) => {
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
    const user = auth.currentUser;
    if (!user) return () => {};

    const q = query(collection(db, "notifications"), orderBy("timestamp", "desc"));
    
    const unsubscribe = onSnapshot(q, (snapshot) => {
      const list: Notification[] = [];
      snapshot.forEach(doc => {
          // In a real multi-tenant app, you'd filter by user.uid here in the query.
          // For this demo, we show all system notifications.
          list.push({ id: doc.id, ...doc.data() } as Notification);
      });
      set({ notifications: list });
    }, (error) => {
      console.error("Error subscribing to notifications:", error);
    });
    
    return unsubscribe;
  },
}));
