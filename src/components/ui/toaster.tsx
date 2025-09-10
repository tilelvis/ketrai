
"use client";

import { Toaster as Sonner } from "sonner";

export function Toaster() {
  return (
    <Sonner
      position="top-right"
      richColors
      toastOptions={{
        style: {
          borderRadius: "0.5rem",
          fontSize: "0.9rem",
        },
      }}
    />
  );
}
