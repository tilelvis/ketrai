
import { initializeApp, getApps, getApp } from "firebase/app";
import { getAuth, onAuthStateChanged, User } from "firebase/auth";
import { getFirestore, doc, getDoc, setDoc } from "firebase/firestore";

const firebaseConfig = {
  "projectId": "chainflow-ai",
  "appId": "1:193038732906:web:c52be3703517673305c413",
  "storageBucket": "chainflow-ai.firebasestorage.app",
  "apiKey": "AIzaSyC3giyELU6K8NTgILioG4PA4HLGfXtkwFg",
  "authDomain": "chainflow-ai.firebaseapp.com",
  "messagingSenderId": "193038732906"
};

const app = !getApps().length ? initializeApp(firebaseConfig) : getApp();
export const db = getFirestore(app);
export const auth = getAuth(app);

export async function fetchUserProfile(user: User) {
  const ref = doc(db, "users", user.uid);
  const snap = await getDoc(ref);

  if (!snap.exists()) {
    // create default profile
    const profile = {
      uid: user.uid,
      email: user.email,
      name: user.displayName ?? "New User",
      role: "dispatcher",
      theme: "system",
      createdAt: Date.now(),
      photoURL: user.photoURL
    };
    await setDoc(ref, profile);
    return profile;
  }

  return snap.data();
}

export { onAuthStateChanged };
