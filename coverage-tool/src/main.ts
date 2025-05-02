import fs from "fs";
import path from "path";
import { parseCoverageLog } from "./parser";
import { generateCoverageReport } from "./report";

// Entry point
const logPath = process.argv[2]; // Path to coverage.log
const outputPath = process.argv[3]; // Path to save the report

if (!logPath || !outputPath) {
  console.error("Usage: node main.js <coverage.log> <report.json>");
  process.exit(1);
}

try {
  // Ensure output directory exists
  const outDir = path.dirname(outputPath);
  fs.mkdirSync(outDir, { recursive: true });

  // Parse the coverage log
  const coverageData = parseCoverageLog(logPath);

  // Generate the coverage report
  generateCoverageReport(coverageData, outputPath);

  console.log(`Coverage report saved to ${outputPath}`);
} catch (error) {
  console.error("Error generating coverage report:", error);
  process.exit(1);
}