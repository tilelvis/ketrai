
"use server";

import { db, collection, getDocs, doc, updateDoc } from "@/lib/firebase";
import { Profile } from "@/store/profile";
import { revalidatePath } from "next/cache";

export async function getUsers() {
    try {
        const usersCollection = collection(db, "users");
        const userSnapshot = await getDocs(usersCollection);
        const userList = userSnapshot.docs.map(doc => ({ ...doc.data(), id: doc.id } as Profile & { id: string }));
        return { success: true, users: userList };
    } catch (error) {
        const message = error instanceof Error ? error.message : "An unknown error occurred.";
        console.error("Error fetching users:", message);
        return { success: false, error: `Failed to fetch users: ${message}` };
    }
}

export async function updateUserRole(uid: string, role: Profile['role']) {
    try {
        const userDoc = doc(db, "users", uid);
        await updateDoc(userDoc, { role });
        
        // We will need a backend function to update the user's custom claims.
        // This is a placeholder for that logic.
        // For now, role changes will apply on next login.

        revalidatePath("/user-management");
        return { success: true };
    } catch (error) {
        const message = error instanceof Error ? error.message : "An unknown error occurred.";
        return { success: false, error: `Failed to update role: ${message}` };
    }
}
