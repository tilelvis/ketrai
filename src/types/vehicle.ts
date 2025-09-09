
import type { Timestamp } from "firebase/firestore";

export type Vehicle = {
  id: string;
  driverId: string;
  lastLocation: {
    lat: number;
    lng: number;
    timestamp: Timestamp;
  };
  status: "in_transit" | "idle" | "loading" | "delivered" | "delayed";
  eta: string; 
  routeId: string;
};
