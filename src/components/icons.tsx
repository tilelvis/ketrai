import type { SVGProps } from "react";

export function Logo(props: SVGProps<SVGSVGElement>) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      {...props}
    >
      <path d="M10.7 15.3a2.4 2.4 0 0 1-3.4 0" />
      <path d="M6.6 12.5a2.4 2.4 0 0 1 0-3.4" />
      <path d="M16.7 15.3a2.4 2.4 0 0 0-3.4 0" />
      <path d="M12.6 12.5a2.4 2.4 0 0 0 0-3.4" />
      <path d="M17.4 9.1a2.4 2.4 0 0 0 0 3.4" />
      <path d="M13.3 6.7a2.4 2.4 0 0 0 3.4 0" />
      <path d="M7.3 6.7a2.4 2.4 0 0 1 3.4 0" />
      <path d="M3.2 9.1a2.4 2.4 0 0 1 0 3.4" />
      <path d="M4.6 19.8a2.4 2.4 0 0 0 3.4 0" />
      <path d="M8.7 17.5a2.4 2.4 0 0 0 0-3.4" />
      <path d="M15.3 17.5a2.4 2.4 0 0 1 0-3.4" />
      <path d="M19.4 19.8a2.4 2.4 0 0 1-3.4 0" />
      <circle cx="12" cy="12" r="10" />
    </svg>
  );
}
