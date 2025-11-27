param(
    [string]$Extension = "pes",    # main extension
    [string]$Drive = "C:\",        # drive to scan
    [int]$HeartbeatSeconds = 2,    # heartbeat interval
    [switch]$svg                   # optional flag to include .svg
)

Write-Host ""
Write-Host "Scanning $Drive for *.$Extension files..." -ForegroundColor Cyan

if ($svg) {
    Write-Host "svg mode enabled - also scanning for *.svg files" -ForegroundColor Magenta
}
Write-Host ""

$startTime     = Get-Date
$lastHeartbeat = Get-Date

$totalChecked  = 0
$foundCount    = 0
$results       = @()

# Build list of extensions to match
$extensionsToMatch = @(".$Extension")
if ($svg) { $extensionsToMatch += ".svg" }

# ======================
# COPY FEATURE: Create output folder next to this script
# ======================

$scriptDir  = Split-Path -Parent $MyInvocation.MyCommand.Definition
$destFolder = Join-Path $scriptDir "embroidery_files_found"

# If it already exists, append _2, _3, etc.
$folderBase = $destFolder
$i = 1
while (Test-Path $destFolder) {
    $destFolder = "${folderBase}_$i"
    $i++
}

New-Item -ItemType Directory -Path $destFolder | Out-Null

Write-Host "Copy destination folder created: $destFolder" -ForegroundColor Gray
Write-Host ""

# ======================
# MAIN SCAN LOOP
# ======================

Get-ChildItem -Path $Drive -Recurse -Force -ErrorAction SilentlyContinue |
    ForEach-Object {
        # Skip ALL embroidery_files_found* folders (avoid recursive scanning of previous runs)
        if ($_.FullName -like "$scriptDir\embroidery_files_found*") { return }

        $totalChecked++

        # Heartbeat (time-based)
        $now = Get-Date
        if (($now - $lastHeartbeat).TotalSeconds -ge $HeartbeatSeconds) {
            $elapsed    = $now - $startTime
            $elapsedStr = $elapsed.ToString("hh\:mm\:ss")
            Write-Host "[Heartbeat] Checked: $($totalChecked) files | Found: $($foundCount) matches | Elapsed: $elapsedStr" -ForegroundColor DarkCyan
            $lastHeartbeat = $now
        }

        # Skip directories
        if ($_.PSIsContainer) { return }

        # Match allowed extensions
        $ext = $_.Extension
        if ($null -ne $ext -and $extensionsToMatch -contains $ext.ToLower()) {
            $foundCount++

            $fileRecord = $_ | Select-Object Name, FullName, DirectoryName, Length, LastWriteTime, LastAccessTime
            $results += $fileRecord

            Write-Host "Found: $($_.FullName)" -ForegroundColor Yellow

            # Copy only .pes files
            if ($ext.ToLower() -eq ".pes") {
                $destPath = Join-Path $destFolder $_.Name
                Copy-Item -Path $_.FullName -Destination $destPath -ErrorAction SilentlyContinue
            }
        }
    }

Write-Host ""
Write-Host "Scan complete." -ForegroundColor Green
Write-Host "Checked $totalChecked files total" -ForegroundColor Green
Write-Host "Found $foundCount matching files" -ForegroundColor Green

# Save results
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outFile   = Join-Path $scriptDir ("pes_scan_{0}.csv" -f $timestamp)

$results |
    Sort-Object FullName -Unique |
    Export-Csv -Path $outFile -NoTypeInformation -Encoding UTF8

Write-Host "Results saved to:" -ForegroundColor Green
Write-Host "  $outFile" -ForegroundColor Green
Write-Host ""
Write-Host "All .pes files copied to:" -ForegroundColor Green
Write-Host "  $destFolder" -ForegroundColor Green
