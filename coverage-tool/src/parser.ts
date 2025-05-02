import fs from "fs";
//import path from "path";

/**
 * Parses a coverage log to calculate execution counts per line.
 * @param logPath Path to the coverage.log file.
 * @returns An object mapping each script file path to its line-hit counts.
 */
export function parseCoverageLog(logPath: string): Record<string, Record<number, number>> {
  const logData = fs.readFileSync(logPath, 'utf-8');
  const logLines = logData.split(/\r?\n/);

  // Trace lines are prefixed with: + <script>:<line>:
  const traceRegex = /^\+\s+(.+?):(\d+):/;

  // Determine the target script from the first matching trace
  let targetScript = '';
  for (const line of logLines) {
    const m = traceRegex.exec(line);
    if (m) {
      targetScript = m[1];
      break;
    }
  }
  if (!targetScript) {
    throw new Error('Could not infer script path from coverage log');
  }

  // Prepare coverage map for this script
  const coverageData: Record<string, Record<number, number>> = {};
  coverageData[targetScript] = {};

  // Read script contents and initialize counts
  const scriptText = fs.readFileSync(targetScript, 'utf-8');
  scriptText.split(/\r?\n/).forEach((lnText, idx) => {
    const num = idx + 1;
    const trimmed = lnText.trim();
    if (trimmed && !trimmed.startsWith('#')) {
      coverageData[targetScript][num] = 0;
    }
  });

  // Count execution hits
  for (const line of logLines) {
    const m = traceRegex.exec(line);
    if (!m) continue;
    const file = m[1];
    const num = parseInt(m[2], 10);
    if (coverageData[file] && coverageData[file][num] !== undefined) {
      coverageData[file][num]++;
    }
  }

  return coverageData;
}