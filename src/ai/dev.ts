import { config } from 'dotenv';
config();

// Dynamically import all flows from the registry
import { aiFlows } from './flowRegistry';
aiFlows.forEach(flow => {
    require(`@/ai/flows/${flow.file}.ts`);
});
