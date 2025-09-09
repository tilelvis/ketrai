// src/lib/firebase.ts
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyC3giyELU6K8NTgILioG4PA4HLGfXtkwFg",
  authDomain: "chainflow-ai.firebaseapp.com",
  projectId: "chainflow-ai",
  storageBucket: "chainflow-ai.firebasestorage.app",
  messagingSenderId: "193038732906",
  appId: "1:193038732906:web:c52be3703517673305c413",
};

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);
