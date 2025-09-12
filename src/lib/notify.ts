import { toast } from "sonner";
import { useNotificationStore, Notification } from "@/store/notifications";

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