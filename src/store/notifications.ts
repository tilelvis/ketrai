import { create } from "zustand";
import { db, auth, collection, onSnapshot, orderBy, query, writeBatch, doc, deleteDoc } from "@/lib/firebase";

export type Notification = {
  id: string;
  type: "claim" | "dispatch" | "system";
  message: string;
  read: boolean;
  createdAt: any; // Firestore timestamp
  claimId?: string;
  dispatchId?: string;
};

type NotificationStore = {
  notifications: Notification[];
  subscribe: () => () => void; // Returns an unsubscribe function
  remove: (id: string) => Promise<void>;
  clear: () => Promise<void>;
  markAsRead: (id: string) => Promise<void>;
  markAllAsRead: () => Promise<void>;
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
      const list: Notification[] = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() } as Notification));
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

  markAsRead: async (id: string) => {
     const user = auth.currentUser;
     if (!user) return;
     try {
       const docRef = doc(db, "users", user.uid, "notifications", id);
       await docRef.update({ read: true });
     } catch (error) {
       console.error("Error marking notification as read:", error);
     }
  },

  markAllAsRead: async () => {
    const user = auth.currentUser;
    const { notifications } = get();
    if (!user) return;

    const unread = notifications.filter(n => !n.read);
    if (unread.length === 0) return;

    const batch = writeBatch(db);
    unread.forEach((n) => {
      const docRef = doc(db, "users", user.uid, "notifications", n.id);
      batch.update(docRef, { read: true });
    });

    try {
      await batch.commit();
    } catch (error) {
      console.error("Error marking all notifications as read:", error);
    }
  }

}));
