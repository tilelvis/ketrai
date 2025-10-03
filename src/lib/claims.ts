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
import { errorEmitter } from "@/firebase/error-emitter";
import { FirestorePermissionError } from "@/firebase/errors";

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
  const claimRef = doc(collection(db, "claims"));

  batch.set(claimRef, {
    ...claimData,
    requesterId: user.uid,
    status: "requested",
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });

  const historyRef = doc(collection(claimRef, "history"));
  batch.set(historyRef, {
    action: 'requested',
    by: user.uid,
    timestamp: serverTimestamp(),
    details: 'Claim submitted by user',
    requesterId: user.uid
  });

  batch.commit()
    .then(async () => {
        await logEvent({
            action: "claim_requested",
            actorId: user.uid,
            actorRole: userProfile.role,
            targetCollection: "claims",
            targetId: claimRef.id,
            context: { type: claimData.type, packageId: claimData.packageId }
        });
    })
    .catch((serverError) => {
        errorEmitter.emit('permission-error', new FirestorePermissionError({
            path: claimRef.path,
            operation: 'create',
            requestResourceData: claimData,
        }));
    });
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
  const updatedData = {
    status: "approved",
    adminId: admin.uid,
    updatedAt: serverTimestamp(),
  };
  batch.update(claimRef, updatedData);

  const historyRef = doc(collection(claimRef, "history"));
  batch.set(historyRef, {
    action: "approved",
    by: admin.uid,
    timestamp: serverTimestamp(),
    details: "Claim approved by admin."
  });

  const notificationRef = doc(collection(db, "users", claimData.requesterId, "notifications"));
  batch.set(notificationRef, {
    type: "claim",
    claimId,
    message: `Your claim for package ${claimData.packageId} has been approved.`,
    read: false,
    createdAt: serverTimestamp(),
  });
  
  batch.commit()
    .then(async () => {
      await logEvent({
        action: "claim_approved",
        actorId: admin.uid,
        actorRole: adminProfile.role,
        targetCollection: "claims",
        targetId: claimId,
        context: { requesterId: claimData.requesterId }
      });
    })
    .catch((serverError) => {
        errorEmitter.emit('permission-error', new FirestorePermissionError({
            path: claimRef.path,
            operation: 'update',
            requestResourceData: updatedData,
        }));
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
  const updatedData = {
    status: "rejected",
    adminId: admin.uid,
    rejectionReason: reason,
    updatedAt: serverTimestamp(),
  };

  batch.update(claimRef, updatedData);

  const historyRef = doc(collection(claimRef, "history"));
  batch.set(historyRef, {
    action: "rejected",
    by: admin.uid,
    timestamp: serverTimestamp(),
    details: `Claim rejected. Reason: ${reason}`
  });

  const notificationRef = doc(collection(db, "users", claimData.requesterId, "notifications"));
  batch.set(notificationRef, {
    type: "claim",
    claimId,
    message: `Your claim for package ${claimData.packageId} was rejected. Reason: ${reason}`,
    read: false,
    createdAt: serverTimestamp(),
  });

  batch.commit()
    .then(async () => {
       await logEvent({
        action: "claim_rejected",
        actorId: admin.uid,
        actorRole: adminProfile.role,
        targetCollection: "claims",
        targetId: claimId,
        context: { reason, requesterId: claimData.requesterId }
      });
    })
    .catch((serverError) => {
        errorEmitter.emit('permission-error', new FirestorePermissionError({
            path: claimRef.path,
            operation: 'update',
            requestResourceData: updatedData,
        }));
    });
}
