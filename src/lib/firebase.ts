import { initializeApp, getApps, getApp } from "firebase/app";
import { getAuth, onAuthStateChanged, User } from "firebase/auth";
import { getFirestore, doc, getDoc, setDoc, collection, getDocs, updateDoc, serverTimestamp, writeBatch, deleteDoc, query, orderBy, onSnapshot, where, Timestamp, addDoc } from "firebase/firestore";

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
  if (!user) return null;
  const ref = doc(db, "users", user.uid);
  const snap = await getDoc(ref);

  if (!snap.exists()) {
    console.log(`Profile for ${user.uid} does not exist. Creating one.`);
    const newProfile = {
      uid: user.uid,
      email: user.email,
      name: user.displayName ?? user.email?.split('@')[0] ?? "New User",
      role: "dispatcher",
      theme: "system",
      status: "active",
      photoURL: user.photoURL ?? "",
      preferences: {
        notifications: {
          inApp: true,
          email: false,
        }
      }
    };
    await setDoc(ref, newProfile);
    return newProfile;
  }

  const profileData = snap.data();
  // Ensure preferences object exists for older users
  if (!profileData.preferences) {
    profileData.preferences = {
      notifications: { inApp: true, email: false }
    };
    // Optionally, update the document in Firestore
    await updateDoc(ref, { preferences: profileData.preferences });
  }


  return profileData;
}

export { onAuthStateChanged, setDoc, doc, collection, getDocs, updateDoc, serverTimestamp, writeBatch, deleteDoc, query, orderBy, onSnapshot, where, Timestamp, addDoc };
