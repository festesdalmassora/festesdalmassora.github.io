<#
.SYNOPSIS
  Publica una versión nueva de la app (APK + web) con un solo comando.

.EXAMPLE
  .\tools\release.ps1 -Version 1.0.2 -NotesCa "Nou icona" -NotesEs "Nuevo icono"

  Sin -Version solo sube el número de compilación (build) y deja la versión.
  Usa -NoPush para preparar todo sin subirlo a GitHub (para revisar antes).

Pasos: comprueba cambios y firma -> sube versión/build -> analyze + test ->
compila APK (arm64 y arm32) -> verifica la firma -> copia a web/download ->
actualiza web/version.json -> commit + push (GitHub Pages lo despliega).
#>
param(
  [string]$Version,
  [string]$NotesCa = "Versió nova amb millores.",
  [string]$NotesEs = "Versión nueva con mejoras.",
  [switch]$NoPush
)

$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

function Step($t) { Write-Host "`n==> $t" -ForegroundColor Green }
function Run($exe, $argList) {
  & $exe @argList
  if ($LASTEXITCODE -ne 0) { throw "Ha fallado: $exe $($argList -join ' ')" }
}

# 0. Requisitos
Step 'Comprobando requisitos'
if (-not (Test-Path 'android/key.properties')) { throw 'Falta android/key.properties (keystore de firma). Mira E:\Apps\_secretos\' }
$props = Get-Content 'android/key.properties' | Where-Object { $_ -match '^storeFile=' }
$ks = ($props -replace '^storeFile=', '').Trim()
if (-not (Test-Path $ks)) { throw "No encuentro el keystore: $ks" }
$apksigner = Get-ChildItem "$env:LOCALAPPDATA\Android\sdk\build-tools" -Recurse -Filter apksigner.bat -ErrorAction SilentlyContinue | Sort-Object FullName | Select-Object -Last 1
if (-not $apksigner) { throw 'No encuentro apksigner en el Android SDK.' }

# 1. Versión y build
Step 'Calculando versión'
$cfg = Get-Content 'lib/config.dart' -Raw
$curBuild = [int]([regex]::Match($cfg, 'kAppBuild = (\d+);').Groups[1].Value)
$curName = [regex]::Match($cfg, "kAppVersionName = '([^']+)'").Groups[1].Value
$newBuild = $curBuild + 1
if (-not $Version) { $Version = $curName }
Write-Host "  $curName+$curBuild  ->  $Version+$newBuild"

$cfg = $cfg -replace 'kAppBuild = \d+;', "kAppBuild = $newBuild;"
$cfg = $cfg -replace "kAppVersionName = '[^']+'", "kAppVersionName = '$Version'"
[IO.File]::WriteAllText((Resolve-Path 'lib/config.dart'), $cfg, (New-Object Text.UTF8Encoding $false))

$pub = Get-Content 'pubspec.yaml' -Raw
$pub = $pub -replace '(?m)^version: .*$', "version: $Version+$newBuild"
[IO.File]::WriteAllText((Resolve-Path 'pubspec.yaml'), $pub, (New-Object Text.UTF8Encoding $false))

# 2. Comprobaciones
Step 'flutter analyze + test'
Run 'flutter' @('analyze')
Run 'flutter' @('test')

# 3. Compilar
Step 'Compilando APK (por arquitectura)'
Run 'flutter' @('build', 'apk', '--release', '--split-per-abi')
$out = 'build/app/outputs/flutter-apk'
$map = @{ 'app-arm64-v8a-release.apk' = 'FestesAlmassora-arm64.apk'; 'app-armeabi-v7a-release.apk' = 'FestesAlmassora-arm32.apk' }

# 4. Verificar firma y copiar
Step 'Verificando firma y copiando a web/download'
New-Item -ItemType Directory -Force 'web/download' | Out-Null
foreach ($k in $map.Keys) {
  $src = Join-Path $out $k
  $certs = & $apksigner.FullName verify --print-certs $src
  if ($LASTEXITCODE -ne 0) { throw "Firma inválida en $k" }
  if (($certs -join ' ') -match 'Android Debug') { throw "$k está firmado con la clave de depuración, no con el keystore propio." }
  Copy-Item $src (Join-Path 'web/download' $map[$k]) -Force
  Copy-Item $src (Join-Path '..\apk' $map[$k]) -Force -ErrorAction SilentlyContinue
  Write-Host "  OK $($map[$k])  ($([math]::Round((Get-Item $src).Length/1MB,1)) MB)"
}

# 5. version.json
Step 'Actualizando web/version.json'
$ver = [ordered]@{
  build = $newBuild
  name  = $Version
  apk   = 'https://festesdalmassora.github.io/download/FestesAlmassora-arm64.apk'
  page  = 'https://festesdalmassora.github.io/descarga.html'
  notes = [ordered]@{ ca = $NotesCa; es = $NotesEs }
}
[IO.File]::WriteAllText((Resolve-Path 'web/version.json'), ($ver | ConvertTo-Json -Depth 4), (New-Object Text.UTF8Encoding $false))

# 6. Git
Step 'Commit y push'
Run 'git' @('add', '-A')
Run 'git' @('commit', '-m', "Release $Version (build $newBuild)", '-m', 'Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>')
if ($NoPush) {
  Write-Host "`n-NoPush: todo preparado y commit hecho en local. Sube con: git push" -ForegroundColor Yellow
} else {
  Run 'git' @('push')
  Write-Host "`nPublicado. En 2-3 min: https://festesdalmassora.github.io/descarga.html" -ForegroundColor Green
}
