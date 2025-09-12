/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/document";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as logger from "firebase-functions/logger";
import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { getFirestore } from "firebase-admin/firestore";

// Initialize Firebase Admin SDK
initializeApp();

// Callable function to set a user's role
export const setRole = onCall(async (request) => {
  // 1. Verify the caller is an admin.
  if (request.auth?.token.role !== "admin") {
    logger.error("Request to set role without admin privileges.", {
      uid: request.auth?.uid,
    });
    throw new HttpsError(
      "permission-denied",
      "You must be an admin to set user roles."
    );
  }

  const { uid, role } = request.data;

  if (typeof uid !== "string" || typeof role !== "string") {
    throw new HttpsError(
      "invalid-argument",
      "The function must be called with 'uid' and 'role' arguments."
    );
  }

  try {
    // 2. Set the custom claim on the target user.
    await getAuth().setCustomUserClaims(uid, { role });

    // 3. Update the user's document in Firestore to match.
    await getFirestore().collection("users").doc(uid).update({ role });
    
    logger.info(`Successfully set role '${role}' for user ${uid}`, {
      adminId: request.auth?.uid,
    });
    
    return { success: true, message: `Role '${role}' assigned successfully.` };

  } catch (error) {
    logger.error(`Error setting role for user ${uid}:`, error);
    throw new HttpsError("internal", "An internal error occurred while setting the role.");
  }
});
