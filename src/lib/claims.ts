import { auth, db } from "./firebase";
import {
  doc,
  addDoc,
  updateDoc,
  getDoc,
  collection,
  serverTimestamp,
} from "firebase/firestore";

type RaiseClaimInput = {
    type: string;
    description: string;
}

/**
 * Raise a new claim (user side)
 */
export async function raiseClaim({ type, description }: RaiseClaimInput) {
  const user = auth.currentUser;
  if (!user) throw new Error("Not authenticated");

  // Create claim
  const claimRef = await addDoc(collection(db, "claims"), {
    requesterId: user.uid,
    status: "requested",
    type,
    description,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  // Log claim history
  await addDoc(collection(db, `claims/${claimRef.id}/history`), {
    action: "requested",
    by: user.uid,
    timestamp: serverTimestamp(),
    details: "Claim submitted by user",
  });

  return claimRef.id;
}

/**
 * Approve a claim (admin side)
 */
export async function approveClaim(claimId: string) {
  const admin = auth.currentUser;
  if (!admin) throw new Error("Not authenticated");

  const claimRef = doc(db, "claims", claimId);
  const claimSnap = await getDoc(claimRef);
  if (!claimSnap.exists()) throw new Error("Claim not found");

  const claimData = claimSnap.data();

  // Update claim status
  await updateDoc(claimRef, {
    status: "approved",
    adminId: admin.uid,
    updatedAt: serverTimestamp(),
  });

  // Log history
  await addDoc(collection(db, `claims/${claimId}/history`), {
    action: "approved",
    by: admin.uid,
    timestamp: serverTimestamp(),
    details: "Claim approved by admin",
  });

  // Notify requester
  await addDoc(collection(db, `users/${claimData.requesterId}/notifications`), {
    type: "claim",
    claimId,
    message: `Your claim #${claimId.substring(0,6)} has been approved ✅`,
    read: false,
    createdAt: serverTimestamp(),
  });
}

/**
 * Reject a claim (admin side)
 */
export async function rejectClaim(claimId: string, reason = "No reason provided") {
  const admin = auth.currentUser;
  if (!admin) throw new Error("Not authenticated");

  const claimRef = doc(db, "claims", claimId);
  const claimSnap = await getDoc(claimRef);
  if (!claimSnap.exists()) throw new Error("Claim not found");

  const claimData = claimSnap.data();

  // Update claim status
  await updateDoc(claimRef, {
    status: "rejected",
    adminId: admin.uid,
    updatedAt: serverTimestamp(),
  });

  // Log history
  await addDoc(collection(db, `claims/${claimId}/history`), {
    action: "rejected",
    by: admin.uid,
    timestamp: serverTimestamp(),
    details: `Claim rejected: ${reason}`,
  });

  // Notify requester
  await addDoc(collection(db, `users/${claimData.requesterId}/notifications`), {
    type: "claim",
    claimId,
    message: `Your claim #${claimId.substring(0,6)} was rejected ❌ (${reason})`,
    read: false,
    createdAt: serverTimestamp(),
  });
}
