
import { toast } from "sonner";
import { useNotificationStore, Notification } from "@/store/notifications";

export const notify = {
  success: (msg: string, category: Notification["category"] = "system") => {
    toast.success(msg);
    useNotificationStore.getState().add({ message: msg, type: "success", category });
  },
  warning: (msg: string, category: Notification["category"] = "system") => {
    toast.warning(msg);
    useNotificationStore.getState().add({ message: msg, type: "warning", category });
  },
  error: (msg: string, category: Notification["category"] = "system") => {
    toast.error(msg);
    useNotificationStore.getState().add({ message: msg, type: "error", category });
  },
  info: (msg: string, category: Notification["category"] = "system") => {
    toast.info(msg);
    useNotificationStore.getState().add({ message: msg, type: "info", category });
  },
  risk: (
    msg: string,
    severity: "low" | "medium" | "high",
    category: Notification["category"] = "system"
  ) => {
    const toastMethod = {
      low: toast.info,
      medium: toast.warning,
      high: toast.error,
    };
    toastMethod[severity](msg, {
      duration: severity === "high" ? 8000 : 4000,
    });
    useNotificationStore.getState().add({ message: msg, type: "risk", severity, category });
  },
};
