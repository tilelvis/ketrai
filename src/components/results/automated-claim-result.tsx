
"use client";

import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import type { AutomatedInsuranceClaimDraftOutput } from "@/ai/flows/automated-insurance-claim-draft";
import { CheckCircle, FileJson, FileText } from "lucide-react";

function safeJsonParse(jsonString: string) {
  try {
    return JSON.parse(jsonString);
  } catch (e) {
    return jsonString;
  }
}

export function AutomatedClaimResult({ data }: { data: AutomatedInsuranceClaimDraftOutput }) {

  const parsedJson = safeJsonParse(data.claimDraftJson);
  const formattedJson = typeof parsedJson === 'object' 
    ? JSON.stringify(parsedJson, null, 2)
    : parsedJson; 

  return (
    <div className="space-y-6">
       <Card className="bg-green-500/10 border-green-500/30">
        <CardHeader>
            <div className="flex items-center gap-3">
                <CheckCircle className="h-8 w-8 text-green-600" />
                <div>
                    <CardTitle className="font-headline text-lg text-green-900 dark:text-green-300">Claim Draft Generated</CardTitle>
                    <CardDescription className="text-green-800 dark:text-green-400">The AI has generated a draft for your review. You can copy the text or data below.</CardDescription>
                </div>
            </div>
        </CardHeader>
      </Card>
      
      <Card>
        <CardHeader>
            <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <FileText className="h-5 w-5 text-muted-foreground" />
                Claim Narrative
            </div>
        </CardHeader>
        <CardContent>
          <div className="rounded-md border bg-secondary/50 p-4 text-sm whitespace-pre-wrap">{data.claimDraftText}</div>
        </CardContent>
      </Card>

      <Card>
         <CardHeader>
            <div className="flex items-center gap-2 text-lg font-medium font-headline">
                <FileJson className="h-5 w-5 text-muted-foreground" />
                Structured Data (JSON)
            </div>
        </CardHeader>
        <CardContent>
           <pre className="rounded-md border bg-secondary/50 p-4 text-xs overflow-x-auto">
              <code>{formattedJson}</code>
            </pre>
        </CardContent>
      </Card>
    </div>
  );
}
