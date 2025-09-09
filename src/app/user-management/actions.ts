
"use server";

import { db, collection, getDocs, doc, updateDoc } from "@/lib/firebase";
import { Profile } from "@/store/profile";
import { revalidatePath } from "next/cache";

export async function getUsers() {
    const usersCollection = collection(db, "users");
    const userSnapshot = await getDocs(usersCollection);
    const userList = userSnapshot.docs.map(doc => ({ ...doc.data(), id: doc.id } as Profile & { id: string }));
    return userList;
}

export async function updateUserRole(uid: string, role: Profile['role']) {
    try {
        const userDoc = doc(db, "users", uid);
        await updateDoc(userDoc, { role });
        revalidatePath("/user-management");
        return { success: true };
    } catch (error) {
        const message = error instanceof Error ? error.message : "An unknown error occurred.";
        return { success: false, error: `Failed to update role: ${message}` };
    }
}
