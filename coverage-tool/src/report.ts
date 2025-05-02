import fs from "fs";

/**
 * Generates a coverage report from parsed coverage data.
 * @param coverageData The parsed coverage data.
 * @param outputPath Path to save the generated report (JSON format).
 */
export function generateCoverageReport(
  coverageData: Record<string, Record<number, number>>,
  outputPath: string
): void {
  const report: Record<string, { total: number; covered: number; coverage: number }> = {};

  // Process the coverage data
  for (const [fileName, lines] of Object.entries(coverageData)) {
    const totalLines = Object.keys(lines).length;
    const coveredLines = Object.values(lines).filter((hits) => hits > 0).length;
    const coverage = (coveredLines / totalLines) * 100;

    report[fileName] = { total: totalLines, covered: coveredLines, coverage };
  }

  // Save the report to the output path
  fs.writeFileSync(outputPath, JSON.stringify(report, null, 2));
}