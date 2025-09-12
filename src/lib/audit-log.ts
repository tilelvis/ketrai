'use server';
/**
 * @fileOverview A centralized, robust utility for creating audit log entries.
 */

import { db } from "./firebase";
import { collection, addDoc, serverTimestamp } from "firebase/firestore";
import type { Profile } from "@/store/profile";

type LogPayload = {
    action: string;
    actorId: string;
    actorRole: Profile['role'] | 'unknown' | 'system';
    targetCollection: string;
    targetId: string;
    context: Record<string, any>;
};

/**
 * Logs a significant event to the auditLogs collection in Firestore.
 * Includes detailed error logging and a fallback mechanism.
 * 
 * @param payload - An object containing all necessary log information.
 */
export async function logEvent(payload: LogPayload) {
  try {
    const docRef = await addDoc(collection(db, "auditLogs"), {
      ...payload,
      timestamp: serverTimestamp(),
    });
    console.log("audit logged:", docRef.id, payload.action);
    return docRef.id;
  } catch (err) {
    console.error("FAILED audit log write:", err, payload);

    // Optional: fallback write to a 'failedAuditLogs' collection
    // so ops can be retried later by an admin or scheduled job.
    try {
      await addDoc(collection(db, "failedAuditLogs"), {
        ...payload,
        error: String(err),
        createdAt: serverTimestamp(),
      });
    } catch (e) {
      console.error("Failed to write fallback audit:", e);
    }

    // Do not re-throw the error to prevent the primary user action from failing
    // just because the audit log write failed. The fallback has been recorded.
  }
}
