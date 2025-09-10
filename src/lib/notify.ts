import { toast } from "sonner";

// This is now just a simple wrapper around the `sonner` toast library
// for ephemeral, non-persistent UI feedback. For persistent, database-backed
// notifications, you should write directly to the user's notification
// sub-collection in Firestore.

export const notify = {
  success: (msg: string) => {
    toast.success(msg);
  },
  warning: (msg: string) => {
    toast.warning(msg);
  },
  error: (msg: string) => {
    toast.error(msg);
  },
  info: (msg: string) => {
    toast.info(msg);
  },
  risk: (
    msg: string,
    severity: "low" | "medium" | "high"
  ) => {
    const toastMethod = {
      low: toast.info,
      medium: toast.warning,
      high: toast.error,
    };
    toastMethod[severity](msg, {
      duration: severity === "high" ? 8000 : 4000,
    });
  },
};