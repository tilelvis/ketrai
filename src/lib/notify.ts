
import { toast } from "sonner";
import { useNotificationStore } from "@/store/notifications";

export const notify = {
  success: (msg: string) => {
    toast.success(msg);
    useNotificationStore.getState().add({ message: msg, type: "success" });
  },
  warning: (msg: string) => {
    toast.warning(msg);
    useNotificationStore.getState().add({ message: msg, type: "warning" });
  },
  error: (msg: string) => {
    toast.error(msg);
    useNotificationStore.getState().add({ message: msg, type: "error" });
  },
  info: (msg: string) => {
    toast.info(msg);
    useNotificationStore.getState().add({ message: msg, type: "info" });
  },
  risk: (msg: string, severity: "low" | "medium" | "high") => {
    const toastMethod = {
        low: toast.info,
        medium: toast.warning,
        high: toast.error,
    }
    toastMethod[severity](msg, {
      duration: severity === "high" ? 8000 : 4000,
    });
    useNotificationStore.getState().add({ message: msg, type: "risk", severity });
  },
};
