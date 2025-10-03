/**
 * @fileOverview A simple, global event emitter for application-wide events.
 * This is used to decouple components, allowing them to communicate without
 * having direct references to each other.
 *
 * It's a lightweight implementation of the pub/sub pattern.
 */

type EventMap = Record<string, any>;
type EventKey<T extends EventMap> = string & keyof T;

class Emitter<T extends EventMap> {
  private listeners: { [K in keyof T]?: Array<(p: T[K]) => void> } = {};

  on<K extends EventKey<T>>(key: K, listener: (p: T[K]) => void): void {
    if (!this.listeners[key]) {
      this.listeners[key] = [];
    }
    this.listeners[key]!.push(listener);
  }

  off<K extends EventKey<T>>(key: K, listener: (p: T[K]) => void): void {
    const group = this.listeners[key];
    if (group) {
      this.listeners[key] = group.filter((l) => l !== listener);
    }
  }

  emit<K extends EventKey<T>>(key: K, payload: T[K]): void {
    const group = this.listeners[key];
    if (group) {
      group.forEach((listener) => listener(payload));
    }
  }
}

/**
 * Defines the types of errors that can be emitted throughout the application.
 */
interface ErrorEvents {
  "permission-error": any; // Can be any error object, but typically FirestorePermissionError
}

/**
 * A global singleton instance of the Emitter for handling specific error events.
 * This is used to centralize the handling of Firestore permission errors.
 */
export const errorEmitter = new Emitter<ErrorEvents>();
