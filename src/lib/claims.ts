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
    description: string;
}

/**
 * Raise a new claim (user side)
 */
export async function raiseClaim({ type, description }: RaiseClaimInput) {
  const user = auth.currentUser;
  if (!user) throw new Error("Not authenticated");

  const userProfile = (await getDoc(doc(db, "users", user.uid))).data() as Profile;
  if (!userProfile) throw new Error("User profile not found.");

  const batch = writeBatch(db);

  // 1. Create claim document
  const claimRef = doc(collection(db, "claims"));
  batch.set(claimRef, {
    requesterId: user.uid,
    status: "requested",
    type,
    description,
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  // 2. Log event to the audit log
  const auditLogRef = doc(collection(db, "auditLogs"));
  batch.set(auditLogRef, {
    action: "claim_requested",
    actorId: user.uid,
    actorRole: userProfile.role,
    targetId: claimRef.id,
    targetCollection: "claims",
    context: { type, description },
    timestamp: serverTimestamp(),
  });
  
  await batch.commit();

  return claimRef.id;
}

/**
 * Approve a claim (admin side)
 */
export async function approveClaim(claimId: string) {
  const admin = auth.currentUser;
  if (!admin) throw new Error("Not authenticated");
  const adminProfile = (await getDoc(doc(db, "users", admin.uid))).data() as Profile;
  if (!adminProfile) throw new Error("Admin profile not found.");


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

  // 2. Create a notification for the user
  const notificationRef = doc(collection(db, `users/${claimData.requesterId}/notifications`));
  batch.set(notificationRef, {
    type: "claim",
    claimId,
    message: `Your claim for "${claimData.type}" has been approved.`,
    read: false,
    createdAt: serverTimestamp(),
  });

  // 3. Log event to the audit log
  const auditLogRef = doc(collection(db, "auditLogs"));
  batch.set(auditLogRef, {
    action: "claim_approved",
    actorId: admin.uid,
    actorRole: adminProfile.role,
    targetId: claimId,
    targetCollection: "claims",
    context: { requesterId: claimData.requesterId },
    timestamp: serverTimestamp(),
  });
  
  await batch.commit();
}

/**
 * Reject a claim (admin side)
 */
export async function rejectClaim(claimId: string, reason: string) {
  const admin = auth.currentUser;
  if (!admin) throw new Error("Not authenticated");
  const adminProfile = (await getDoc(doc(db, "users", admin.uid))).data() as Profile;
  if (!adminProfile) throw new Error("Admin profile not found.");


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

  // 2. Create a notification for the user
  const notificationRef = doc(collection(db, `users/${claimData.requesterId}/notifications`));
  batch.set(notificationRef, {
    type: "claim",
    claimId,
    message: `Your claim for "${claimData.type}" was rejected. Reason: ${reason}`,
    read: false,
    createdAt: serverTimestamp(),
  });

  // 3. Log event to the audit log
  const auditLogRef = doc(collection(db, "auditLogs"));
  batch.set(auditLogRef, {
    action: "claim_rejected",
    actorId: admin.uid,
    actorRole: adminProfile.role,
    targetId: claimId,
    targetCollection: "claims",
    context: { reason, requesterId: claimData.requesterId },
    timestamp: serverTimestamp(),
  });
  
  await batch.commit();
}
