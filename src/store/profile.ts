import { create } from "zustand";
import { User } from "firebase/auth";

export type Profile = {
  uid: string;
  email: string | null;
  name: string;
  role: "dispatcher" | "manager" | "claims" | "admin" | "support";
  status: "active" | "inactive";
  photoURL?: string;
  profile?: { 
    phone?: string; 
    vehicleId?: string;
  },
  preferences?: {
    theme: "light" | "dark" | "system";
    locale: string;
    notifications: {
        inApp: boolean;
        email: boolean;
    };
    dashboardLayout: "grid" | "compact";
  }
};

type ProfileStore = {
  user: User | null;
  profile: Profile | null;
  setUser: (u: User | null) => void;
  setProfile: (p: Profile | null) => void;
};

export const useProfileStore = create<ProfileStore>((set) => ({
  user: null,
  profile: null,
  setUser: (u) => set({ user: u }),
  setProfile: (p) => set({ profile: p }),
}));
