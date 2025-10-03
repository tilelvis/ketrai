# Ketrai: AI-Powered Supply Chain Orchestration

[![Ketrai CI](https://github.com/YOUR_USERNAME/YOUR_REPONAME/actions/workflows/main.yml/badge.svg)](https://github.com/YOUR_USERNAME/YOUR_REPONAME/actions/workflows/main.yml)

**Ketrai** is a modern, AI-powered web application designed for logistics and supply chain professionals. It moves beyond traditional static dashboards to provide a suite of intelligent, real-time tools for decision-making, risk management, and process automation. The platform is built on a robust, scalable, and secure architecture, leveraging Next.js for the frontend and Firebase for the backend and AI orchestration.

## Core Features

The application is structured around a set of specialized AI-driven flows, each designed to tackle a specific logistics challenge.

-   **Dashboard**: A central hub providing a high-level overview of operations and quick access to all available AI tools.
-   **Proactive ETA**: An AI agent that recalculates delivery ETAs by analyzing real-time traffic and weather data, assesses delay risks, and drafts customer-facing notifications.
-   **Smart Dispatch**: Analyzes pickup and dropoff locations to recommend the optimal and safest delivery route, factoring in variables like traffic, theft hotspots, and road closures.
-   **Automated Claim Processing**: A dual-function module where:
    -   Support and dispatch staff can submit requests for insurance claims.
    -   Admins and claims officers can review pending requests in a dedicated queue and use an AI agent to generate professional, structured claim drafts.
-   **Claims History**: A complete, read-only log of all processed claims (approved, rejected, drafted) for auditing and review.
-   **Cross-Carrier Risk Visibility**: Aggregates shipment data from multiple carriers and cross-references it with global alerts (e.g., weather events, port strikes) to generate a unified risk report.
-   **Secure Admin Panel**:
    -   **User Management**: Admins can invite new users with pre-assigned roles, manage existing user roles, and activate/deactivate accounts.
    -   **Audit Log**: A real-time, immutable stream of every significant event that occurs within the system, providing complete administrative oversight.

## Tech Stack & Architecture

Ketrai is built with a modern, server-centric, and type-safe stack.

-   **Frontend**: Next.js 14 (App Router), React, TypeScript, and Tailwind CSS.
-   **UI Components**: ShadCN UI for a consistent, professional, and accessible component library.
-   **Backend & Database**: Firebase handles the entire backend, including:
    -   **Authentication**: Secure email/password login and user management.
    -   **Firestore**: A NoSQL database for all application data, secured with granular, role-based security rules.
    -   **Cloud Functions**: For secure, server-side logic like assigning user roles.
-   **Generative AI**: **Genkit (by Google)** is used to define, orchestrate, and execute all AI-powered workflows, ensuring structured inputs and outputs.
-   **State Management**: Zustand for lightweight, global client-side state management (user profile, notifications).

### Key Architectural Concepts

-   **Role-Based Access Control (RBAC)**: The application enforces strict permissions at every level. User roles (`admin`, `manager`, `claims`, etc.) are managed via Firebase Custom Claims, which are securely validated in Firestore Security Rules to control data access.
-   **AI as Specialized Agents**: Instead of a generic chatbot, Ketrai uses a collection of distinct AI agents (Genkit Flows), each engineered with a specific context and schema to excel at a single task.
-   **Immutable Auditing**: Every critical action—from a user logging in to a claim being approved—is recorded in an append-only `auditLogs` collection in Firestore, ensuring a complete and verifiable history.

## Getting Started

To run this project locally, follow these steps:

1.  **Install Dependencies**:
    ```bash
    npm install
    ```

2.  **Set Up Environment Variables**:
    Create a `.env.local` file in the root of the project and populate it with your Firebase project configuration keys. You can get these from your Firebase project settings.

    ```
    NEXT_PUBLIC_FIREBASE_API_KEY=...
    NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=...
    NEXT_PUBLIC_FIREBASE_PROJECT_ID=...
    NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=...
    NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=...
    NEXT_PUBLIC_FIREBASE_APP_ID=...
    ```

3.  **Run the Development Server**:
    ```bash
    npm run dev
    ```

The application will be available at `http://localhost:9002`.
