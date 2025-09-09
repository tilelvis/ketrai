
import { db } from "./firebase";
import { collection, writeBatch, Timestamp } from "firebase/firestore";
import type { Vehicle } from "@/types/vehicle";

// Mock data based on locations in Kenya
const mockVehicles: Vehicle[] = [
  {
    id: "KDA 123B",
    driverId: "UID001",
    lastLocation: { lat: -1.286389, lng: 36.817223, timestamp: Timestamp.now() }, // Nairobi CBD
    status: "in_transit",
    eta: new Date(Date.now() + 2 * 60 * 60 * 1000).toISOString(),
    routeId: "NRB-MSA-01",
  },
  {
    id: "KDB 456C",
    driverId: "UID002",
    lastLocation: { lat: -4.043477, lng: 39.668205, timestamp: Timestamp.now() }, // Mombasa
    status: "loading",
    eta: new Date(Date.now() + 5 * 60 * 60 * 1000).toISOString(),
    routeId: "MSA-KIS-02",
  },
  {
    id: "KDC 789D",
    driverId: "UID003",
    lastLocation: { lat: -0.091702, lng: 34.767956, timestamp: Timestamp.now() }, // Kisumu
    status: "idle",
    eta: new Date(Date.now() + 1 * 60 * 60 * 1000).toISOString(),
    routeId: "KIS-ELD-03",
  },
  {
    id: "KDD 012E",
    driverId: "UID004",
    lastLocation: { lat: 0.514270, lng: 35.269779, timestamp: Timestamp.now() }, // Eldoret
    status: "delayed",
    eta: new Date(Date.now() + 3 * 60 * 60 * 1000).toISOString(),
    routeId: "ELD-NAI-04",
  },
];

export async function seedMockVehicles() {
  const batch = writeBatch(db);
  const vehiclesCollection = collection(db, "vehicles");

  mockVehicles.forEach((vehicle) => {
    const docRef = doc(vehiclesCollection, vehicle.id);
    batch.set(docRef, vehicle);
  });

  try {
    await batch.commit();
    console.log("Mock vehicles seeded successfully!");
    return { success: true };
  } catch (error) {
    console.error("Error seeding mock vehicles:", error);
    return { success: false, error };
  }
}

function getRandomOffset(value: number, maxOffset = 0.01) {
    return value + (Math.random() - 0.5) * maxOffset * 2;
}

export async function updateMockVehicleLocations() {
    const batch = writeBatch(db);
    const vehiclesCollection = collection(db, "vehicles");

    mockVehicles.forEach((vehicle) => {
        const docRef = doc(vehiclesCollection, vehicle.id);
        const newLat = getRandomOffset(vehicle.lastLocation.lat);
        const newLng = getRandomOffset(vehicle.lastLocation.lng);
        
        batch.update(docRef, {
            "lastLocation.lat": newLat,
            "lastLocation.lng": newLng,
            "lastLocation.timestamp": Timestamp.now(),
        });
    });

    try {
        await batch.commit();
        console.log("Mock vehicle locations updated.");
        return { success: true };
    } catch (error) {
        console.error("Error updating mock locations:", error);
        return { success: false, error };
    }
}
