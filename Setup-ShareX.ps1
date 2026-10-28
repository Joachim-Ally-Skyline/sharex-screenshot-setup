<#
.SYNOPSIS
    Sets up ShareX the way Joachim uses it: three screenshot hotkeys, rounded grey border, no sound,
    no "unsaved changes" prompt when closing the editor.

.DESCRIPTION
    - Installs ShareX through winget ONLY when it is not installed yet.
    - Backs up the existing ShareX settings before touching anything.
    - Ctrl+Shift+1  area capture -> choose a frame -> annotate -> Enter
    - Ctrl+Shift+2  area capture -> default frame (rounded grey border) -> annotate -> Enter
    - Ctrl+Shift+3  area capture -> default frame -> straight to clipboard + file
    - Installs 10 image-effect presets ("frames"); the default is "Rounded grey border".
    - Capture sound off, editor exit confirmation off, ShareX starts with Windows (tray only).
    Other hotkeys and settings are left alone. Safe to run more than once.
    Run with Windows PowerShell 5.1:  powershell.exe -ExecutionPolicy Bypass -File .\Setup-ShareX.ps1

.PARAMETER ConfigDir   Use another settings folder (for testing). Default: Documents\ShareX.
.PARAMETER ShareXDir   Use another ShareX install folder (for testing).
.PARAMETER NoRestart   Do not start ShareX again at the end.
#>
[CmdletBinding()]
param(
    [string]$ConfigDir,
    [string]$ShareXDir,
    [switch]$NoRestart
)
$ErrorActionPreference = 'Stop'

# The JSON handling below relies on Windows PowerShell 5.1, which every Windows 10/11 PC has.
if ($PSVersionTable.PSEdition -ne 'Desktop') {
    $forward = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', $PSCommandPath)
    if ($ConfigDir) { $forward += @('-ConfigDir', $ConfigDir) }
    if ($ShareXDir) { $forward += @('-ShareXDir', $ShareXDir) }
    if ($NoRestart) { $forward += '-NoRestart' }
    & powershell.exe @forward
    exit $LASTEXITCODE
}

$PresetsJson = @'
[{"Name":"No effect","Effects":[]},{"Name":"Rounded grey border","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":6},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"2, 2, 2, 2"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"222, 222, 222","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8}]},{"Name":"Blue border","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"37, 99, 235","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"3, 3, 3, 3"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"239, 246, 255","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":7},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"37, 99, 235","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8}]},{"Name":"Blue glow","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"37, 99, 235","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"3, 3, 3, 3"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"239, 246, 255","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":7},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"37, 99, 235","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Size":30,"Color":"37, 99, 235"},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Size":0,"Color":"37, 99, 235"}]},{"Name":"Green border","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"64, 207, 145","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"3, 3, 3, 3"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"225, 251, 241","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":7},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"64, 207, 145","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8}]},{"Name":"Green glow","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"64, 207, 145","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"3, 3, 3, 3"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"225, 251, 241","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":7},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"64, 207, 145","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Size":30,"Color":"60, 187, 136"},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Size":0,"Color":"60, 187, 136"}]},{"Name":"Gold border","Effects":[{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"5, 0, 5, 0"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","UseGradient":true,"Gradient":{"Colors":[{"Color":"0, 218, 180, 0"},{"Color":"246, 203, 0","Location":50.0},{"Color":"0, 218, 180, 0","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"0, 5, 0, 5"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","UseGradient":true,"Gradient":{"Type":"Horizontal","Colors":[{"Color":"0, 218, 180, 0"},{"Color":"246, 203, 0","Location":50.0},{"Color":"0, 218, 180, 0","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"239, 185, 79","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.AutoCrop, ShareX.ImageEffectsLib"}]},{"Name":"Gold wavy edge","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":10},{"$type":"ShareX.ImageEffectsLib.Glow, ShareX.ImageEffectsLib","Color":"242, 194, 0","Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"0, 187, 138"},{"Color":"0, 105, 163","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib"},{"$type":"ShareX.ImageEffectsLib.Glow, ShareX.ImageEffectsLib","Color":"242, 194, 0","Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"0, 187, 138"},{"Color":"0, 105, 163","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib"},{"$type":"ShareX.ImageEffectsLib.Glow, ShareX.ImageEffectsLib","Color":"242, 120, 0","Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"0, 187, 138"},{"Color":"0, 105, 163","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib"},{"$type":"ShareX.ImageEffectsLib.Crop, ShareX.ImageEffectsLib","Margin":"45, 45, 45, 45"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"150, 78, 0","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib"},{"$type":"ShareX.ImageEffectsLib.Glow, ShareX.ImageEffectsLib","Size":10,"Color":"150, 78, 0","Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"184, 11, 195"},{"Color":"98, 54, 255","Location":100.0}]}}]},{"Name":"Red torn edge","Effects":[{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib","Depth":3,"Range":30},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":10},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"10, 10, 10, 10"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"180, 0, 0"},{"Color":"103, 0, 0","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib","Depth":3,"Range":30},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":10}]},{"Name":"Pill shape (ShareX ring)","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":1000},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"5, 5, 5, 5"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"100, 0, 0, 0","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":1000},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"8, 8, 8, 8"},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"47, 126, 249"},{"Color":"0, 0, 0, 0","Location":50.0}]}},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","UseGradient":true,"Gradient":{"Type":"BackwardDiagonal","Colors":[{"Color":"4, 180, 34"},{"Color":"0, 0, 0, 0","Location":50.0}]}},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"0, 0, 0, 0","Location":50.0},{"Color":"253, 185, 0","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","UseGradient":true,"Gradient":{"Type":"BackwardDiagonal","Colors":[{"Color":"0, 0, 0, 0","Location":50.0},{"Color":"248, 33, 26","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Gradient":{"Colors":[{"Color":"68, 120, 194"},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]}},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":1000},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":0.4,"Offset":"0, 3"}]}]
'@
$DefaultPreset = 'Rounded grey border'
$AfterCaptureQuick = 'AddImageEffects, CopyImageToClipboard, SaveImageToFile'
$AfterCaptureEdit = 'AddImageEffects, AnnotateImage, CopyImageToClipboard, SaveImageToFile'

function Write-Step([string]$Text) { Write-Host "==> $Text" -ForegroundColor Cyan }

function Find-ShareXDir {
    $candidates = @($ShareXDir, (Join-Path $env:ProgramFiles 'ShareX'), (Join-Path ${env:ProgramFiles(x86)} 'ShareX'), (Join-Path $env:LOCALAPPDATA 'Programs\ShareX'))
    foreach ($c in $candidates) {
        if ($c -and (Test-Path -LiteralPath (Join-Path $c 'ShareX.exe'))) { return $c }
    }
    $null
}

function Wait-ShareXExit {
    $deadline = (Get-Date).AddSeconds(60)
    while ((Get-Process -Name ShareX -ErrorAction SilentlyContinue) -and (Get-Date) -lt $deadline) { Start-Sleep -Milliseconds 500 }
    if (Get-Process -Name ShareX -ErrorAction SilentlyContinue) { throw 'ShareX did not close. Right-click the ShareX tray icon, choose Exit, and run this script again.' }
    Start-Sleep -Seconds 1
}

function Stop-ShareX {
    if (Get-Process -Name ShareX -ErrorAction SilentlyContinue) {
        # ShareX rewrites its settings when it exits, so it must be closed before editing them.
        Start-Process -FilePath (Join-Path $script:Dir 'ShareX.exe') -ArgumentList '-ExitShareX'
        Wait-ShareXExit
    }
}

# 1. Find or install ShareX
Write-Step 'Looking for ShareX'
$script:Dir = Find-ShareXDir
if ($script:Dir) {
    Write-Host "ShareX is already installed: $script:Dir (not reinstalling)"
} else {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        throw 'ShareX is not installed and winget is not available. Install ShareX from https://getsharex.com and run this script again.'
    }
    Write-Step 'Installing ShareX with winget'
    & winget install --id ShareX.ShareX -e --silent --accept-package-agreements --accept-source-agreements
    $script:Dir = Find-ShareXDir
    if (-not $script:Dir) { throw 'winget finished but ShareX.exe was not found. Install ShareX manually from https://getsharex.com and run this script again.' }
}

# 2. Locate the settings folder
$personalPath = Join-Path $script:Dir 'PersonalPath.cfg'
if (-not $ConfigDir) {
    $ConfigDir = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'ShareX'
    if (Test-Path -LiteralPath $personalPath) {
        $p = [Environment]::ExpandEnvironmentVariables(([IO.File]::ReadAllText($personalPath)).Trim())
        if ($p) { if (-not [IO.Path]::IsPathRooted($p)) { $p = Join-Path $script:Dir $p }; $ConfigDir = $p }
    }
}
$appPath = Join-Path $ConfigDir 'ApplicationConfig.json'
$hotkeysPath = Join-Path $ConfigDir 'HotkeysConfig.json'

Stop-ShareX

# A brand-new installation has no settings files until ShareX has run and exited once.
if (-not ((Test-Path -LiteralPath $appPath) -and (Test-Path -LiteralPath $hotkeysPath))) {
    Write-Step 'First run of ShareX to create its settings files'
    Start-Process -FilePath (Join-Path $script:Dir 'ShareX.exe') -ArgumentList '-silent'
    Start-Sleep -Seconds 10
    Stop-ShareX
    if (-not ((Test-Path -LiteralPath $appPath) -and (Test-Path -LiteralPath $hotkeysPath))) {
        throw "ShareX did not create its settings in $ConfigDir. Start ShareX once manually, close it from the tray, and run this script again."
    }
}

# 3. Backup
Write-Step 'Backing up your current ShareX settings'
$backupDir = Join-Path $ConfigDir ('Backup\SetupBackup_' + (Get-Date -Format 'yyyy-MM-dd_HHmmss'))
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
foreach ($name in 'ApplicationConfig.json', 'HotkeysConfig.json', 'UploadersConfig.json') {
    $src = Join-Path $ConfigDir $name
    if (Test-Path -LiteralPath $src) {
        $dst = Join-Path $backupDir $name
        Copy-Item -LiteralPath $src -Destination $dst
        if ((Get-FileHash $src).Hash -ne (Get-FileHash $dst).Hash) { throw "Backup of $name does not match the original. Nothing was changed." }
    }
}
Write-Host "Backup: $backupDir"
Write-Host 'To undo: close ShareX (tray > Exit), copy these files back to the ShareX folder, start ShareX.'

# 4. Edit the settings. Only the keys below are touched; every other setting is written back unchanged.
Write-Step 'Applying settings'
Add-Type -AssemblyName System.Web.Extensions
$ser = New-Object System.Web.Script.Serialization.JavaScriptSerializer
$ser.MaxJsonLength = [int]::MaxValue
$ser.RecursionLimit = 1000

function Read-Json([string]$Path) { $ser.DeserializeObject([IO.File]::ReadAllText($Path)) }
# PowerShell wraps objects that pass through functions in PSObject, which the serializer cannot handle.
function Unwrap($Value) { if ($null -eq $Value) { return $null }; return $Value.PSObject.BaseObject }
function ConvertTo-Plain($Value) {
    $Value = Unwrap $Value
    if ($Value -is [System.Collections.IDictionary]) {
        $copy = New-Object 'System.Collections.Generic.Dictionary[string,object]'
        foreach ($key in @($Value.Keys)) { $copy[[string]$key] = Unwrap (ConvertTo-Plain $Value[$key]) }
        return $copy
    }
    if (($Value -is [System.Collections.IEnumerable]) -and ($Value -isnot [string])) {
        $copy = New-Object System.Collections.ArrayList
        foreach ($item in $Value) { [void]$copy.Add((Unwrap (ConvertTo-Plain $item))) }
        return , $copy
    }
    return $Value
}
function Save-Json($Doc, [string]$Path) { [IO.File]::WriteAllText($Path, $ser.Serialize((Unwrap (ConvertTo-Plain $Doc))), (New-Object Text.UTF8Encoding($false))) }
function New-Dict { New-Object 'System.Collections.Generic.Dictionary[string,object]' }
function Get-Child($Parent, [string]$Name) {
    if (-not ($Parent.ContainsKey($Name) -and $Parent[$Name] -is [System.Collections.IDictionary])) { $Parent[$Name] = New-Dict }
    return , $Parent[$Name]
}
function Copy-Json($Value) { , $ser.DeserializeObject($ser.Serialize((Unwrap (ConvertTo-Plain $Value)))) }
function Get-PresetIndex($Presets, [string]$Name) {
    for ($i = 0; $i -lt $Presets.Count; $i++) { if ([string]$Presets[$i]['Name'] -ceq $Name) { return $i } }
    throw "Preset '$Name' not found."
}

$presets = $ser.DeserializeObject($PresetsJson)
$defaultIndex = Get-PresetIndex $presets $DefaultPreset
$app = Read-Json $appPath
$hotkeys = Read-Json $hotkeysPath

$dts = Get-Child $app 'DefaultTaskSettings'
$dts['AfterCaptureJob'] = $AfterCaptureQuick

# No sound
$general = Get-Child $dts 'GeneralSettings'
$general['PlaySoundAfterCapture'] = $false
$general['PlaySoundAfterUpload'] = $false
$general['PlaySoundAfterAction'] = $false

# No "unsaved changes" question when closing the image editor
$editor = Get-Child (Get-Child $dts 'ToolsSettings') 'ImageEditorOptions'
$editor['ShowExitConfirmation'] = $false

# Frames: ShareX keeps a separate list for the default settings and for the editor's effects button
$imageSettings = Get-Child $dts 'ImageSettings'
$imageSettings['ImageEffectPresets'] = Copy-Json $presets
$imageSettings['SelectedImageEffectPreset'] = $defaultIndex
$surface = Get-Child (Get-Child $dts 'CaptureSettings') 'SurfaceOptions'
$surface['ImageEffectPresets'] = Copy-Json $presets
$surface['SelectedImageEffectPreset'] = 0

# Screenshot backup folder: <ShareX folder>\Screenshots\<yyyy-mm>
$app['SaveImageSubFolderPattern'] = '%y-%mo'

# Hotkeys: replace only our three, keep everything else
$ours = @('D1, Shift, Control', 'D2, Shift, Control', 'D3, Shift, Control')
$list = New-Object System.Collections.ArrayList
if ($hotkeys.ContainsKey('Hotkeys') -and $hotkeys['Hotkeys']) {
    foreach ($entry in $hotkeys['Hotkeys']) {
        if ($ours -notcontains [string]$entry['HotkeyInfo']['Hotkey']) { [void]$list.Add($entry) }
    }
}

function New-Hotkey([string]$Key, [string]$Description, [string]$AfterCapture, $ImageSettings) {
    $info = New-Dict
    $info['Hotkey'] = $Key
    $info['Win'] = $false
    $ts = New-Dict
    $ts['Description'] = $Description
    $ts['Job'] = 'RectangleRegion'
    $ts['UseDefaultAfterCaptureJob'] = $false
    $ts['AfterCaptureJob'] = $AfterCapture
    if ($ImageSettings) {
        $ts['UseDefaultImageSettings'] = $false
        $ts['ImageSettings'] = $ImageSettings
    }
    $entry = New-Dict
    $entry['HotkeyInfo'] = $info
    $entry['TaskSettings'] = $ts
    return , $entry
}

# Ctrl+Shift+1 has its own image settings so it can show the frame chooser after the capture.
$chooser = Copy-Json $imageSettings
$chooser['ShowImageEffectsWindowAfterCapture'] = $true
[void]$list.Add((New-Hotkey 'D1, Shift, Control' 'Region + choose frame and edit' $AfterCaptureEdit $chooser))
[void]$list.Add((New-Hotkey 'D2, Shift, Control' 'Region + default frame and edit' $AfterCaptureEdit $null))
[void]$list.Add((New-Hotkey 'D3, Shift, Control' 'Region + default frame, quick copy and save' $AfterCaptureQuick $null))
$hotkeys['Hotkeys'] = $list.ToArray()

Save-Json $app $appPath
Save-Json $hotkeys $hotkeysPath

# 5. Verify what was written
$checkApp = Read-Json $appPath
$checkHotkeys = Read-Json $hotkeysPath
$found = @($checkHotkeys['Hotkeys'] | Where-Object { $ours -contains [string]$_['HotkeyInfo']['Hotkey'] }).Count
$checkDts = $checkApp['DefaultTaskSettings']
$ok = ($found -eq 3) `
    -and ($checkDts['ImageSettings']['ImageEffectPresets'].Count -eq $presets.Count) `
    -and ($checkDts['ToolsSettings']['ImageEditorOptions']['ShowExitConfirmation'] -eq $false) `
    -and ($checkDts['GeneralSettings']['PlaySoundAfterCapture'] -eq $false)
if (-not $ok) { throw "Verification failed. Restore your settings from $backupDir" }
Write-Host 'Settings written and verified.' -ForegroundColor Green

# 6. Start with Windows (tray only) unless ShareX already starts with Windows
$startup = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'
$runKey = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Run' -ErrorAction SilentlyContinue
$hasRunEntry = $runKey -and ($runKey.PSObject.Properties.Name -contains 'ShareX')
if ((Test-Path -LiteralPath (Join-Path $startup 'ShareX.lnk')) -or $hasRunEntry) {
    Write-Host 'ShareX already starts with Windows.'
} else {
    $shell = New-Object -ComObject WScript.Shell
    $lnk = $shell.CreateShortcut((Join-Path $startup 'ShareX.lnk'))
    $lnk.TargetPath = Join-Path $script:Dir 'ShareX.exe'
    $lnk.Arguments = '-silent'
    $lnk.WorkingDirectory = $script:Dir
    $lnk.Save()
    Write-Host 'ShareX will now start with Windows (tray only).'
}

# 7. Start ShareX
if (-not $NoRestart) {
    Write-Step 'Starting ShareX'
    Start-Process -FilePath (Join-Path $script:Dir 'ShareX.exe') -ArgumentList '-silent'
    Start-Sleep -Seconds 5
    if (Get-Process -Name ShareX -ErrorAction SilentlyContinue) { Write-Host 'ShareX is running in the tray.' } else { Write-Warning 'ShareX did not start. Start it from the Start menu.' }
}

$shots = Join-Path $ConfigDir 'Screenshots'
Write-Host ''
Write-Host 'Done. Try it:' -ForegroundColor Green
Write-Host '  Ctrl+Shift+1  area + pick a frame + annotate, then Enter'
Write-Host '  Ctrl+Shift+2  area + grey border + annotate, then Enter'
Write-Host '  Ctrl+Shift+3  area + grey border, straight to clipboard'
Write-Host 'Annotate: A = arrow, T = text, R = rectangle, Ctrl+D = duplicate. Enter = copy + save, Esc = discard.'
Write-Host "Every screenshot is also saved in: $shots\<year-month>"
Write-Host "Backup of your old settings: $backupDir"
