
import { auth, db } from "./firebase";
import {
  doc,
  addDoc,
  updateDoc,
  getDoc,
  collection,
  serverTimestamp,
  writeBatch,
} from "firebase/firestore";
import { logEvent } from "./audit-log";
import type { Profile } from "@/store/profile";

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

  const { role } = (await getDoc(doc(db, "users", user.uid))).data() as Profile;

  const batch = writeBatch(db);

  // 1. Create claim
  const claimRef = doc(collection(db, "claims"));
  batch.set(claimRef, {
    requesterId: user.uid,
    status: "requested",
    type,
    description,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  // 2. Log claim history
  const historyRef = doc(collection(db, `claims/${claimRef.id}/history`));
  batch.set(historyRef, {
    action: "requested",
    by: user.uid,
    timestamp: serverTimestamp(),
    details: "Claim submitted by user",
  });
  
  await batch.commit();

  // 3. Log to global audit log
  await logEvent(
    "claim_requested",
    user.uid,
    role,
    { id: claimRef.id, collection: "claims" },
    { details: `User raised a claim of type: ${type}` }
  );

  return claimRef.id;
}

/**
 * Approve a claim (admin side)
 */
export async function approveClaim(claimId: string) {
  const admin = auth.currentUser;
  if (!admin) throw new Error("Not authenticated");
  const { role } = (await getDoc(doc(db, "users", admin.uid))).data() as Profile;


  const claimRef = doc(db, "claims", claimId);
  const claimSnap = await getDoc(claimRef);
  if (!claimSnap.exists()) throw new Error("Claim not found");

  const claimData = claimSnap.data();

  const batch = writeBatch(db);

  // 1. Update claim status
  batch.update(claimRef, {
    status: "approved",
    adminId: admin.uid,
    updatedAt: serverTimestamp(),
  });

  // 2. Log history
  const historyRef = doc(collection(db, `claims/${claimId}/history`));
  batch.set(historyRef, {
    action: "approved",
    by: admin.uid,
    timestamp: serverTimestamp(),
    details: "Claim approved by admin",
  });

  // 3. Notify requester
  const notifRef = doc(collection(db, `users/${claimData.requesterId}/notifications`));
  batch.set(notifRef, {
    type: "claim",
    claimId,
    message: `Your claim #${claimId.substring(0,6)} has been approved ✅`,
    read: false,
    createdAt: serverTimestamp(),
  });
  
  await batch.commit();
  
  // 4. Log to global audit log
  await logEvent(
    "claim_approved",
    admin.uid,
    role,
    { id: claimId, collection: "claims" },
    { details: `Claim approved for requester ${claimData.requesterId}` }
  );
}

/**
 * Reject a claim (admin side)
 */
export async function rejectClaim(claimId: string, reason = "No reason provided") {
  const admin = auth.currentUser;
  if (!admin) throw new Error("Not authenticated");
  const { role } = (await getDoc(doc(db, "users", admin.uid))).data() as Profile;

  const claimRef = doc(db, "claims", claimId);
  const claimSnap = await getDoc(claimRef);
  if (!claimSnap.exists()) throw new Error("Claim not found");

  const claimData = claimSnap.data();

  const batch = writeBatch(db);

  // 1. Update claim status
  batch.update(claimRef, {
    status: "rejected",
    adminId: admin.uid,
    updatedAt: serverTimestamp(),
  });

  // 2. Log history
  const historyRef = doc(collection(db, `claims/${claimId}/history`));
  batch.set(historyRef, {
    action: "rejected",
    by: admin.uid,
    timestamp: serverTimestamp(),
    details: `Claim rejected: ${reason}`,
  });

  // 3. Notify requester
  const notifRef = doc(collection(db, `users/${claimData.requesterId}/notifications`));
  batch.set(notifRef, {
    type: "claim",
    claimId,
    message: `Your claim #${claimId.substring(0,6)} was rejected ❌ (${reason})`,
    read: false,
    createdAt: serverTimestamp(),
  });
  
  await batch.commit();
  
  // 4. Log to global audit log
  await logEvent(
    "claim_rejected",
    admin.uid,
    role,
    { id: claimId, collection: "claims" },
    { reason, requesterId: claimData.requesterId }
  );
}
