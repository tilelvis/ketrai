import { auth, db } from "./firebase";
import {
  doc,
  collection,
  serverTimestamp,
  writeBatch,
  getDoc,
} from "firebase/firestore";
import { logEvent } from "./audit-log";
import type { Profile } from "@/store/profile";

type RaiseClaimInput = {
    type: string;
    packageId: string;
    description: string;
}

/**
 * Raise a new claim (user side)
 */
export async function raiseClaim(claimData: RaiseClaimInput) {
  const user = auth.currentUser;
  if (!user) throw new Error("Not authenticated");

  const userProfileSnap = await getDoc(doc(db, "users", user.uid));
  if (!userProfileSnap.exists()) throw new Error("User profile not found.");
  const userProfile = userProfileSnap.data() as Profile;

  const batch = writeBatch(db);

  // 1. Create claim document
  const claimRef = doc(collection(db, "claims"));
  batch.set(claimRef, {
    ...claimData,
    requesterId: user.uid,
    status: "requested",
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  // 2. Create history entry
  const historyRef = doc(collection(claimRef, "history"));
    batch.set(historyRef, {
    action: 'requested',
    by: user.uid,
    timestamp: serverTimestamp(),
    details: 'Claim submitted by user',
    requesterId: user.uid // Add requesterId here to satisfy security rules on create
  });

  await batch.commit();
  
  // 3. Log event to the audit log (after batch commit)
  await logEvent({
    action: "claim_requested",
    actorId: user.uid,
    actorRole: userProfile.role,
    targetCollection: "claims",
    targetId: claimRef.id,
    context: { type: claimData.type, packageId: claimData.packageId }
  });

  return claimRef.id;
}


/**
 * Approve a claim (admin side)
 */
export async function approveClaim(claimId: string) {
  const admin = auth.currentUser;
  if (!admin) throw new Error("Not authenticated");
  
  const adminProfileSnap = await getDoc(doc(db, "users", admin.uid));
  if (!adminProfileSnap.exists()) throw new Error("Admin profile not found.");
  const adminProfile = adminProfileSnap.data() as Profile;

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

  // 2. Create a history entry
  const historyRef = doc(collection(claimRef, "history"));
  batch.set(historyRef, {
    action: "approved",
    by: admin.uid,
    timestamp: serverTimestamp(),
    details: "Claim approved by admin."
  });

  // 3. Create a notification for the user
  const notificationRef = doc(collection(db, "users", claimData.requesterId, "notifications"));
  batch.set(notificationRef, {
    type: "claim",
    claimId,
    message: `Your claim for package ${claimData.packageId} has been approved.`,
    read: false,
    createdAt: serverTimestamp(),
  });
  
  await batch.commit();

  // 4. Log event to the audit log
  await logEvent({
    action: "claim_approved",
    actorId: admin.uid,
    actorRole: adminProfile.role,
    targetCollection: "claims",
    targetId: claimId,
    context: { requesterId: claimData.requesterId }
  });
}

/**
 * Reject a claim (admin side)
 */
export async function rejectClaim(claimId: string, reason: string) {
  const admin = auth.currentUser;
  if (!admin) throw new Error("Not authenticated");
  const adminProfileSnap = await getDoc(doc(db, "users", admin.uid));
  if (!adminProfileSnap.exists()) throw new Error("Admin profile not found.");
  const adminProfile = adminProfileSnap.data() as Profile;

  const claimRef = doc(db, "claims", claimId);
  const claimSnap = await getDoc(claimRef);
  if (!claimSnap.exists()) throw new Error("Claim not found");
  const claimData = claimSnap.data();

  const batch = writeBatch(db);

  // 1. Update claim status
  batch.update(claimRef, {
    status: "rejected",
    adminId: admin.uid,
    rejectionReason: reason,
    updatedAt: serverTimestamp(),
  });

  // 2. Create a history entry
  const historyRef = doc(collection(claimRef, "history"));
  batch.set(historyRef, {
    action: "rejected",
    by: admin.uid,
    timestamp: serverTimestamp(),
    details: `Claim rejected. Reason: ${reason}`
  });

  // 3. Create a notification for the user
  const notificationRef = doc(collection(db, "users", claimData.requesterId, "notifications"));
  batch.set(notificationRef, {
    type: "claim",
    claimId,
    message: `Your claim for package ${claimData.packageId} was rejected. Reason: ${reason}`,
    read: false,
    createdAt: serverTimestamp(),
  });

  await batch.commit();
  
  // 4. Log event to the audit log
  await logEvent({
    action: "claim_rejected",
    actorId: admin.uid,
    actorRole: adminProfile.role,
    targetCollection: "claims",
    targetId: claimId,
    context: { reason, requesterId: claimData.requesterId }
  });
}
