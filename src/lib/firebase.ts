import { initializeApp, getApps, getApp } from "firebase/app";
import { getAuth, onAuthStateChanged, User } from "firebase/auth";
import { getFirestore, doc, getDoc, setDoc, collection, getDocs, updateDoc, serverTimestamp, writeBatch, deleteDoc, query, orderBy, onSnapshot, where, Timestamp, addDoc } from "firebase/firestore";
import { errorEmitter } from "@/firebase/error-emitter";
import { FirestorePermissionError, type SecurityRuleContext } from "@/firebase/errors";

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID,
};

const app = !getApps().length ? initializeApp(firebaseConfig) : getApp();
export const db = getFirestore(app);
export const auth = getAuth(app);

export async function fetchUserProfile(user: User) {
  if (!user) return null;
  const ref = doc(db, "users", user.uid);
  const snap = await getDoc(ref);

  const defaultPreferences = {
    theme: "system",
    locale: "en-US",
    notifications: {
        inApp: true,
        email: false,
    },
    dashboardLayout: "grid",
  };

  if (!snap.exists()) {
    console.log(`Profile for ${user.uid} does not exist. Creating one.`);
    const newProfile = {
      uid: user.uid,
      email: user.email,
      name: user.displayName ?? user.email?.split('@')[0] ?? "New User",
      role: "dispatcher", // Default role for new signups
      status: "active",
      photoURL: user.photoURL ?? "",
      preferences: defaultPreferences
    };
    
    // Use non-blocking write with contextual error handling
    setDoc(ref, newProfile)
      .catch((serverError) => {
        const permissionError = new FirestorePermissionError({
          path: ref.path,
          operation: 'create',
          requestResourceData: newProfile,
        } satisfies SecurityRuleContext);
        errorEmitter.emit('permission-error', permissionError);
      });
    
    return newProfile;
  }

  const profileData = snap.data();
  // Ensure preferences object exists for older users
  if (!profileData.preferences) {
    profileData.preferences = defaultPreferences;
    
    // Non-blocking update with contextual error handling
    updateDoc(ref, { preferences: profileData.preferences })
      .catch((serverError) => {
        const permissionError = new FirestorePermissionError({
          path: ref.path,
          operation: 'update',
          requestResourceData: { preferences: profileData.preferences },
        } satisfies SecurityRuleContext);
        errorEmitter.emit('permission-error', permissionError);
      });
  }

  return profileData;
}

export { onAuthStateChanged, setDoc, doc, collection, getDocs, updateDoc, serverTimestamp, writeBatch, deleteDoc, query, orderBy, onSnapshot, where, Timestamp, addDoc };
