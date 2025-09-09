"use client";

import React, { createContext, useContext, useState, ReactNode } from 'react';

interface DeveloperContextType {
  isDeveloperMode: boolean;
  setIsDeveloperMode: (isDeveloperMode: boolean) => void;
}

const DeveloperContext = createContext<DeveloperContextType | undefined>(undefined);

export const DeveloperProvider = ({ children }: { children: ReactNode }) => {
  const [isDeveloperMode, setIsDeveloperMode] = useState(false);

  return (
    <DeveloperContext.Provider value={{ isDeveloperMode, setIsDeveloperMode }}>
      {children}
    </DeveloperContext.Provider>
  );
};

export const useDeveloper = (): DeveloperContextType => {
  const context = useContext(DeveloperContext);
  if (!context) {
    throw new Error('useDeveloper must be used within a DeveloperProvider');
  }
  return context;
};
