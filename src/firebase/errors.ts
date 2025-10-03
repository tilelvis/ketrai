/**
 * @fileOverview Defines custom error types for the application, specifically
 * for providing richer context for Firestore Security Rule violations.
 */

import { auth } from "@/lib/firebase";

/**
 * Represents the context of a Firestore operation that was denied by security rules.
 * This information is used to construct a detailed error message for debugging.
 */
export type SecurityRuleContext = {
  path: string;
  operation: "get" | "list" | "create" | "update" | "delete";
  requestResourceData?: any;
};

/**
 * A custom error class designed to provide detailed, actionable context when a
 * Firestore security rule is violated.
 *
 * Instead of a generic "Missing or insufficient permissions" error, this class
 * constructs a JSON object that mirrors the information available within the
 * security rules environment (e.g., `request.auth`, `request.resource`, `request.path`).
 *
 * This allows developers to see exactly what data was sent and what rule likely
 * caused the denial, dramatically speeding up the debugging process.
 */
export class FirestorePermissionError extends Error {
  public readonly context: SecurityRuleContext;

  constructor(context: SecurityRuleContext) {
    const denialContext = {
      auth: auth.currentUser
        ? {
            uid: auth.currentUser.uid,
            token: (auth.currentUser as any).stsTokenManager.accessToken,
          }
        : null,
      method: context.operation,
      path: `/databases/(default)/documents/${context.path}`,
      request:
        context.requestResourceData ? { resource: { data: context.requestResourceData } } : {},
    };

    const message = `FirestoreError: Missing or insufficient permissions: The following request was denied by Firestore Security Rules:\n${JSON.stringify(denialContext, null, 2)}`;
    
    super(message);
    this.name = "FirestorePermissionError";
    this.context = context;

    // This is to ensure the stack trace is captured correctly in V8 environments.
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, FirestorePermissionError);
    }
  }
}
