'use server';
/**
 * @fileOverview A centralized utility for creating audit log entries in Firestore.
 */

import { db } from "./firebase";
import { collection, addDoc, serverTimestamp } from "firebase/firestore";
import type { Profile } from "@/store/profile";

type Target = {
    id: string;
    collection: string;
};

/**
 * Logs a significant event to the auditLogs collection in Firestore.
 * 
 * @param action - A string identifier for the action being performed (e.g., "claim_requested").
 * @param actorId - The UID of the user or system performing the action.
 * @param actorRole - The role of the actor.
 * @param target - An object containing the ID and collection name of the resource being affected.
 * @param context - An optional object for additional metadata.
 */
export async function logEvent(
    action: string, 
    actorId: string, 
    actorRole: Profile['role'], 
    target: Target, 
    context: Record<string, any> = {}
) {
  try {
    await addDoc(collection(db, "auditLogs"), {
        action,
        actorId,
        actorRole,
        targetCollection: target.collection,
        targetId: target.id,
        context,
        timestamp: serverTimestamp()
    });
  } catch (error) {
    console.error("Failed to log event:", error);
    // In a production app, you might want to send this to a dedicated error monitoring service.
  }
}