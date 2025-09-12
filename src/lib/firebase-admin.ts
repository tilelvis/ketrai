import * as admin from 'firebase-admin';

if (!admin.apps.length) {
  try {
    admin.initializeApp({
      // When running in a Firebase environment (like Cloud Functions),
      // the SDK automatically discovers the configuration.
      // For local development, you'd need to set GOOGLE_APPLICATION_CREDENTIALS.
    });
  } catch (error) {
    console.error('Firebase admin initialization error', error);
  }
}

export const auth = admin.auth();
export const db = admin.firestore();
