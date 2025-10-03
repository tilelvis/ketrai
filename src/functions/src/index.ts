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

// Callable function to get all users
export const getUsers = onCall(async (request) => {
  // 1. Verify the caller is an admin.
  if (request.auth?.token.role !== "admin") {
    logger.error("Request to get users without admin privileges.", {
      uid: request.auth?.uid,
    });
    throw new HttpsError(
      "permission-denied",
      "You must be an admin to list users."
    );
  }

  try {
    const auth = getAuth();
    const firestore = getFirestore();
    
    // Get all users from Firebase Authentication
    const userRecords = await auth.listUsers();

    // Fetch corresponding profile from Firestore for each user
    const userProfiles = await Promise.all(
        userRecords.users.map(async (user) => {
            const userDoc = await firestore.collection("users").doc(user.uid).get();
            const existingProfile = userDoc.exists ? userDoc.data() : {};

            // Combine Auth data with Firestore data
            return {
                uid: user.uid,
                email: user.email,
                name: user.displayName || user.email?.split('@')[0],
                photoURL: user.photoURL || '',
                role: 'dispatcher', // Default role
                status: 'inactive', // Default status
                ...existingProfile, // Firestore data overrides defaults
            }
        })
    );

    return { users: userProfiles };

  } catch (error) {
     logger.error("Error fetching all users:", error);
     const message = error instanceof Error ? error.message : "An internal error occurred while fetching users.";
     throw new HttpsError("internal", message);
  }
});


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
    const message = error instanceof Error ? error.message : "An internal error occurred while setting the role.";
    throw new HttpsError("internal", message);
  }
});
