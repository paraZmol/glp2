param(
  [string]$ProjectId = "appglp2",
  [string]$ClientePkg = "com.jla.cliente",
  [string]$RepartidorPkg = "com.jla.repartidor"
)

Set-StrictMode -Version Latest

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$AndroidAppDir = Join-Path $RepoRoot "..\android\app" | Resolve-Path -Relative:$false
$ClienteDir = Join-Path $AndroidAppDir "src\cliente"
$RepartidorDir = Join-Path $AndroidAppDir "src\repartidor"

Write-Output "Project: $ProjectId"
Write-Output "Android app dir: $AndroidAppDir"
Write-Output "Cliente dir: $ClienteDir"
Write-Output "Repartidor dir: $RepartidorDir"

if (-not (Get-Command firebase -ErrorAction SilentlyContinue)) {
  Write-Error "Firebase CLI 'firebase' not found in PATH. Instala CLI antes de continuar: https://firebase.google.com/docs/cli"
  exit 1
}

New-Item -ItemType Directory -Force -Path $ClienteDir | Out-Null
New-Item -ItemType Directory -Force -Path $RepartidorDir | Out-Null

function Ensure-App-And-Download {
  param(
    [string]$PackageName,
    [string]$OutDir
  )
  Write-Output "Processing $PackageName..."

  $appsJson = firebase apps:list --project $ProjectId --json 2>$null
  $exists = $false
  if ($appsJson) {
    try {
      $appsList = $appsJson | ConvertFrom-Json
      foreach ($a in $appsList) {
        if ($a.packageName -eq $PackageName -or $a.appId -eq $PackageName) { $exists = $true; break }
      }
    } catch {
      # ignore parse error
    }
  }

  if (-not $exists) {
    Write-Output "Creating app $PackageName in Firebase project $ProjectId..."
    firebase apps:create android $PackageName --project $ProjectId --display-name $PackageName
  } else {
    Write-Output "App $PackageName already exists in project."
  }

  $outFile = Join-Path $OutDir "google-services.json"
  Write-Output "Downloading google-services.json for $PackageName -> $outFile"
  firebase apps:sdkconfig android $PackageName --project $ProjectId > $outFile

  if (-not (Test-Path $outFile)) {
    Write-Error "Fallo al generar/descargar google-services.json para $PackageName"
    exit 1
  }
}

# cliente
Ensure-App-And-Download -PackageName $ClientePkg -OutDir $ClienteDir

# repartidor
Ensure-App-And-Download -PackageName $RepartidorPkg -OutDir $RepartidorDir

# Cleanup stray files
$rootJson = Join-Path $AndroidAppDir "google-services.json"
if (Test-Path $rootJson) {
  Write-Output "Removing stray $rootJson"
  Remove-Item -Force $rootJson
}

Write-Output "Done. Files placed:"
Write-Output " - Cliente: $(Join-Path $ClienteDir 'google-services.json')"
Write-Output " - Repartidor: $(Join-Path $RepartidorDir 'google-services.json')"
