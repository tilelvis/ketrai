"use client";

import { useEffect } from "react";
import { errorEmitter } from "@/firebase/error-emitter";
import { FirestorePermissionError } from "@/firebase/errors";

/**
 * A client-side component that listens for custom Firestore permission errors
 * and throws them so they can be caught by Next.js's development error overlay.
 * This provides rich, contextual error messages for debugging security rules.
 *
 * In a production environment, this could be extended to log these detailed
 * errors to a monitoring service.
 */
export function FirebaseErrorListener() {
  useEffect(() => {
    const handlePermissionError = (error: FirestorePermissionError) => {
      // In development, we throw the error to leverage the Next.js error overlay.
      if (process.env.NODE_ENV === "development") {
        throw error;
      }
      // In production, you might want to log to a service like Sentry or LogRocket.
      console.error("Firestore Permission Error:", error.message, error.context);
    };

    errorEmitter.on("permission-error", handlePermissionError);

    return () => {
      errorEmitter.off("permission-error", handlePermissionError);
    };
  }, []);

  return null; // This component does not render anything.
}
