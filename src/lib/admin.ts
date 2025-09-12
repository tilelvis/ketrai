/**
 * @fileOverview Server-side admin actions, intended to be called from Cloud Functions.
 */
'use server';

import { auth } from './firebase-admin';
import type { Profile } from '@/store/profile';

/**
 * Sets a custom claim for a user's role. This is the source of truth for security rules.
 * THIS MUST ONLY BE CALLED FROM A SECURE, ADMIN-ONLY CLOUD FUNCTION.
 * @param uid The user's ID.
 * @param role The role to assign.
 */
export async function setUserRole(uid: string, role: Profile['role']) {
  if (!uid || !role) {
    throw new Error('User ID and role are required.');
  }
  try {
    // Set custom user claims on the auth token.
    await auth.setCustomUserClaims(uid, { role });
    console.log(`Successfully set custom claim for user ${uid} to '${role}'.`);
    // The user will get the new role on their ID token the next time they refresh it.
    return { success: true, message: `Role '${role}' assigned to user ${uid}.` };
  } catch (error) {
    console.error(`Error setting custom claim for user ${uid}:`, error);
    const message = error instanceof Error ? error.message : 'An unknown error occurred.';
    return { success: false, error: `Failed to set role: ${message}` };
  }
}
