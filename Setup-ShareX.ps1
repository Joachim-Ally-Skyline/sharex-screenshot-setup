<#
.SYNOPSIS
    Sets up ShareX the way Joachim uses it: four screenshot hotkeys, rounded grey border, no sound,
    no "unsaved changes" prompt when closing the editor.

.DESCRIPTION
    - Installs ShareX through winget ONLY when it is not installed yet.
    - Backs up the existing ShareX settings before touching anything.
    - Ctrl+Shift+1  area capture -> choose a frame -> annotate -> Enter
    - Ctrl+Shift+2  area capture -> default frame (rounded grey border) -> annotate -> Enter
    - Ctrl+Shift+3  area capture -> default frame -> straight to clipboard + file
    - Ctrl+Shift+4  scrolling capture (long web page in one image) -> clipboard + file
    - Installs 35 image-effect presets ("frames"); the default is "Rounded grey border".
    - Capture sound off, editor exit confirmation off, ShareX starts with Windows (tray only).
    - Annotation look: pink-red arrows/rectangles with rounded corners, thin text, blur 11, pixelate 7.
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
[{"Name":"No effect","Effects":[]},{"Name":"Rounded grey border","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":6,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"2, 2, 2, 2","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"222, 222, 222","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8,"Enabled":true}]},{"Name":"Thin dark border","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"55, 65, 81","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":5,"Enabled":true}]},{"Name":"Soft shadow","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":6,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":1.0,"Size":12,"Darkness":0.0,"Color":"Black","Offset":"3, 3","AutoResize":true,"Enabled":true}]},{"Name":"Blue border","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"37, 99, 235","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"3, 3, 3, 3","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"239, 246, 255","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":7,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"37, 99, 235","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8,"Enabled":true}]},{"Name":"Blue glow","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"37, 99, 235","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"3, 3, 3, 3","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"239, 246, 255","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":7,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"37, 99, 235","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":0.6,"Size":30,"Darkness":0.0,"Color":"37, 99, 235","Offset":"0, 0","AutoResize":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":0.6,"Size":0,"Darkness":0.0,"Color":"37, 99, 235","Offset":"0, 0","AutoResize":true,"Enabled":true}]},{"Name":"Green border","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"64, 207, 145","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"3, 3, 3, 3","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"225, 251, 241","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":7,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"64, 207, 145","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8,"Enabled":true}]},{"Name":"Green glow","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"64, 207, 145","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"3, 3, 3, 3","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"225, 251, 241","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":7,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"1, 1, 1, 1","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"64, 207, 145","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":0.6,"Size":30,"Darkness":0.0,"Color":"60, 187, 136","Offset":"0, 0","AutoResize":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":0.6,"Size":0,"Darkness":0.0,"Color":"60, 187, 136","Offset":"0, 0","AutoResize":true,"Enabled":true}]},{"Name":"Hot pink border","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"3, 3, 3, 3","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"234, 0, 94","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":6,"Enabled":true}]},{"Name":"Gold border","Effects":[{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"5, 0, 5, 0","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"Vertical","Colors":[{"Color":"0, 218, 180, 0","Location":0.0},{"Color":"246, 203, 0","Location":50.0},{"Color":"0, 218, 180, 0","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"0, 5, 0, 5","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"Horizontal","Colors":[{"Color":"0, 218, 180, 0","Location":0.0},{"Color":"246, 203, 0","Location":50.0},{"Color":"0, 218, 180, 0","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"239, 185, 79","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.AutoCrop, ShareX.ImageEffectsLib","Sides":"Top, Bottom, Left, Right","Padding":0,"Enabled":true}]},{"Name":"Dark mode frame","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":6,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"10, 10, 10, 10","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"17, 24, 39","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":14,"Enabled":true}]},{"Name":"Polaroid","Effects":[{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"0, 0, 0, 0","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"14, 14, 14, 48","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"White","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":1.0,"Size":12,"Darkness":0.0,"Color":"Black","Offset":"3, 3","AutoResize":true,"Enabled":true}]},{"Name":"Mirror floor","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Reflection, ShareX.ImageEffectsLib","Percentage":20,"MaxAlpha":255,"MinAlpha":0,"Offset":0,"Skew":false,"SkewSize":25,"Enabled":true}]},{"Name":"Black and white","Effects":[{"$type":"ShareX.ImageEffectsLib.Grayscale, ShareX.ImageEffectsLib","Value":1.0,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":6,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"2, 2, 2, 2","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"222, 222, 222","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8,"Enabled":true}]},{"Name":"Old photo","Effects":[{"$type":"ShareX.ImageEffectsLib.Sepia, ShareX.ImageEffectsLib","Value":1.0,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"12, 12, 12, 12","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"245, 235, 215","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":1.0,"Size":10,"Darkness":0.0,"Color":"Black","Offset":"3, 3","AutoResize":true,"Enabled":true}]},{"Name":"Rainbow border","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"6, 6, 6, 6","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"255, 59, 48","Location":0.0},{"Color":"255, 204, 0","Location":25.0},{"Color":"52, 199, 89","Location":50.0},{"Color":"0, 199, 255","Location":75.0},{"Color":"175, 82, 222","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8,"Enabled":true}]},{"Name":"Tilted snapshot","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"8, 8, 8, 8","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"White","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":3,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Rotate, ShareX.ImageEffectsLib","Angle":4.0,"Upsize":true,"Clip":false,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":1.0,"Size":12,"Darkness":0.0,"Color":"Black","Offset":"3, 3","AutoResize":true,"Enabled":true}]},{"Name":"Gold wavy edge","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":10,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Glow, ShareX.ImageEffectsLib","Size":20,"Strength":1.0,"Color":"242, 194, 0","UseGradient":false,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"0, 187, 138","Location":0.0},{"Color":"0, 105, 163","Location":100.0}]},"Offset":"0, 0","Enabled":true},{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib","Depth":15,"Range":20,"Sides":"Top, Bottom, Left, Right","CurvedEdges":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Glow, ShareX.ImageEffectsLib","Size":20,"Strength":1.0,"Color":"242, 194, 0","UseGradient":false,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"0, 187, 138","Location":0.0},{"Color":"0, 105, 163","Location":100.0}]},"Offset":"0, 0","Enabled":true},{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib","Depth":15,"Range":20,"Sides":"Top, Bottom, Left, Right","CurvedEdges":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Glow, ShareX.ImageEffectsLib","Size":20,"Strength":1.0,"Color":"242, 120, 0","UseGradient":false,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"0, 187, 138","Location":0.0},{"Color":"0, 105, 163","Location":100.0}]},"Offset":"0, 0","Enabled":true},{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib","Depth":15,"Range":20,"Sides":"Top, Bottom, Left, Right","CurvedEdges":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Crop, ShareX.ImageEffectsLib","Margin":"45, 45, 45, 45","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"150, 78, 0","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":20,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Glow, ShareX.ImageEffectsLib","Size":10,"Strength":1.0,"Color":"150, 78, 0","UseGradient":false,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"184, 11, 195","Location":0.0},{"Color":"98, 54, 255","Location":100.0}]},"Offset":"0, 0","Enabled":true}]},{"Name":"Red torn edge","Effects":[{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib","Depth":3,"Range":30,"Sides":"Top, Bottom, Left, Right","CurvedEdges":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":10,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"10, 10, 10, 10","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"180, 0, 0","Location":0.0},{"Color":"103, 0, 0","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib","Depth":3,"Range":30,"Sides":"Top, Bottom, Left, Right","CurvedEdges":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":10,"Enabled":true}]},{"Name":"Pill shape (ShareX ring)","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":1000,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"5, 5, 5, 5","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"100, 0, 0, 0","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":1000,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"8, 8, 8, 8","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"47, 126, 249","Location":0.0},{"Color":"0, 0, 0, 0","Location":50.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"BackwardDiagonal","Colors":[{"Color":"4, 180, 34","Location":0.0},{"Color":"0, 0, 0, 0","Location":50.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"0, 0, 0, 0","Location":50.0},{"Color":"253, 185, 0","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"BackwardDiagonal","Colors":[{"Color":"0, 0, 0, 0","Location":50.0},{"Color":"248, 33, 26","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":1000,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":0.4,"Size":10,"Darkness":0.0,"Color":"Black","Offset":"0, 3","AutoResize":true,"Enabled":true}]},{"Name":"Torn paper","Effects":[{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"18, 18, 18, 18","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"252, 252, 250","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib","Depth":4,"Range":25,"Sides":"Top, Bottom, Left, Right","CurvedEdges":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":1.0,"Size":10,"Darkness":0.0,"Color":"Black","Offset":"3, 3","AutoResize":true,"Enabled":true}]},{"Name":"Dashed outline","Effects":[{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"8, 8, 8, 8","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBorder, ShareX.ImageEffectsLib","Type":"Inside","Size":3,"DashStyle":"Dash","Color":"234, 0, 94","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true}]},{"Name":"RGB glitch","Effects":[{"$type":"ShareX.ImageEffectsLib.RGBSplit, ShareX.ImageEffectsLib","OffsetRed":"-6, 0","OffsetGreen":"0, 0","OffsetBlue":"6, 0","Enabled":true,"Name":null}]},{"Name":"Pixel panic","Effects":[{"$type":"ShareX.ImageEffectsLib.Pixelate, ShareX.ImageEffectsLib","Size":6,"BorderSize":0,"BorderColor":"Black","Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":4,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"3, 3, 3, 3","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"0, 199, 255","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":6,"Enabled":true}]},{"Name":"Upside down","Effects":[{"$type":"ShareX.ImageEffectsLib.Flip, ShareX.ImageEffectsLib","Horizontally":true,"Vertically":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":6,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"2, 2, 2, 2","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"222, 222, 222","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8,"Enabled":true}]},{"Name":"Silver border","Effects":[{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"5, 0, 5, 0","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"Vertical","Colors":[{"Color":"Transparent","Location":0.0},{"Color":"White","Location":50.0},{"Color":"Transparent","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"0, 5, 0, 5","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"Horizontal","Colors":[{"Color":"Transparent","Location":0.0},{"Color":"White","Location":50.0},{"Color":"Transparent","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"147, 147, 147","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":0.4,"Size":20,"Darkness":0.0,"Color":"212, 212, 212","Offset":"0, 0","AutoResize":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":0.4,"Size":20,"Darkness":0.0,"Color":"212, 212, 212","Offset":"0, 0","AutoResize":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.AutoCrop, ShareX.ImageEffectsLib","Sides":"Top, Bottom, Left, Right","Padding":0,"Enabled":true}]},{"Name":"macOS window","Effects":[{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"0, 32, 0, 0","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"232, 232, 232","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"54, 56, 58","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":false},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":8,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawTextEx, ShareX.ImageEffectsLib","Text":"","Placement":"TopLeft","Offset":"12, 10","Angle":0,"AutoHide":true,"Font":"Segoe MDL2 Assets, 9pt","Color":"255, 95, 86","UseGradient":false,"Gradient":{"Type":"Horizontal","Colors":[{"Color":"255, 3, 135","Location":0.0},{"Color":"255, 143, 3","Location":100.0}]},"Outline":true,"OutlineSize":2,"OutlineColor":"224, 68, 62","OutlineUseGradient":false,"OutlineGradient":{"Type":"Horizontal","Colors":[{"Color":"184, 11, 195","Location":0.0},{"Color":"98, 54, 255","Location":100.0}]},"Shadow":false,"ShadowOffset":"0, 5","ShadowColor":"125, 0, 0, 0","ShadowUseGradient":false,"ShadowGradient":{"Type":"Horizontal","Colors":[{"Color":"0, 187, 138","Location":0.0},{"Color":"0, 105, 163","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawTextEx, ShareX.ImageEffectsLib","Text":"","Placement":"TopLeft","Offset":"32, 10","Angle":0,"AutoHide":true,"Font":"Segoe MDL2 Assets, 9pt","Color":"255, 189, 46","UseGradient":false,"Gradient":{"Type":"Horizontal","Colors":[{"Color":"255, 3, 135","Location":0.0},{"Color":"255, 143, 3","Location":100.0}]},"Outline":true,"OutlineSize":2,"OutlineColor":"222, 161, 35","OutlineUseGradient":false,"OutlineGradient":{"Type":"Horizontal","Colors":[{"Color":"0, 187, 138","Location":0.0},{"Color":"0, 105, 163","Location":100.0}]},"Shadow":false,"ShadowOffset":"0, 5","ShadowColor":"125, 0, 0, 0","ShadowUseGradient":false,"ShadowGradient":{"Type":"Horizontal","Colors":[{"Color":"0, 187, 138","Location":0.0},{"Color":"0, 105, 163","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawTextEx, ShareX.ImageEffectsLib","Text":"","Placement":"TopLeft","Offset":"52, 10","Angle":0,"AutoHide":true,"Font":"Segoe MDL2 Assets, 9pt","Color":"39, 201, 63","UseGradient":false,"Gradient":{"Type":"Horizontal","Colors":[{"Color":"0, 187, 138","Location":0.0},{"Color":"0, 105, 163","Location":100.0}]},"Outline":true,"OutlineSize":2,"OutlineColor":"26, 171, 41","OutlineUseGradient":false,"OutlineGradient":{"Type":"Horizontal","Colors":[{"Color":"184, 11, 195","Location":0.0},{"Color":"98, 54, 255","Location":100.0}]},"Shadow":false,"ShadowOffset":"0, 5","ShadowColor":"125, 0, 0, 0","ShadowUseGradient":false,"ShadowGradient":{"Type":"Horizontal","Colors":[{"Color":"184, 11, 195","Location":0.0},{"Color":"98, 54, 255","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":0.6,"Size":20,"Darkness":0.0,"Color":"Black","Offset":"0, 0","AutoResize":true,"Enabled":true}]},{"Name":"Background gradient","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":20,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Shadow, ShareX.ImageEffectsLib","Opacity":0.6,"Size":30,"Darkness":0.0,"Color":"Black","Offset":"0, 10","AutoResize":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"20, 20, 20, 10","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"BackwardDiagonal","Colors":[{"Color":"255, 81, 47","Location":0.0},{"Color":"221, 36, 118","Location":100.0}]},"Enabled":true}]},{"Name":"Sunset glow","Effects":[{"$type":"ShareX.ImageEffectsLib.DrawBorder, ShareX.ImageEffectsLib","Type":"Outside","Size":5,"DashStyle":"Solid","Color":"Black","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"255, 3, 135","Location":0.0},{"Color":"255, 143, 3","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Glow, ShareX.ImageEffectsLib","Size":40,"Strength":1.0,"Color":"White","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"255, 3, 135","Location":0.0},{"Color":"255, 143, 3","Location":100.0}]},"Offset":"0, 0","Enabled":true}]},{"Name":"Neon rainbow glow","Effects":[{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":5,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"10, 10, 10, 10","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"40, 255, 255, 255","UseGradient":false,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"Red","Location":0.0},{"Color":"Magenta","Location":17.0},{"Color":"Blue","Location":33.0},{"Color":"Cyan","Location":50.0},{"Color":"Lime","Location":67.0},{"Color":"Yellow","Location":83.0},{"Color":"Red","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.RoundedCorners, ShareX.ImageEffectsLib","CornerRadius":15,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Glow, ShareX.ImageEffectsLib","Size":30,"Strength":3.0,"Color":"White","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"Red","Location":0.0},{"Color":"Magenta","Location":17.0},{"Color":"Blue","Location":33.0},{"Color":"Cyan","Location":50.0},{"Color":"Lime","Location":67.0},{"Color":"Yellow","Location":83.0},{"Color":"Red","Location":100.0}]},"Offset":"0, 0","Enabled":true}]},{"Name":"ShareX curly border","Effects":[{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib","Depth":5,"Range":5,"Sides":"Top, Bottom, Left, Right","CurvedEdges":true,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"10, 10, 10, 10","MarginMode":"AbsoluteSize","Color":"Transparent","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"0, 98, 255","Location":0.0},{"Color":"0, 0, 0, 0","Location":50.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"BackwardDiagonal","Colors":[{"Color":"77, 230, 0","Location":0.0},{"Color":"0, 0, 0, 0","Location":50.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"ForwardDiagonal","Colors":[{"Color":"0, 0, 0, 0","Location":50.0},{"Color":"255, 217, 0","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":true,"Gradient":{"Type":"BackwardDiagonal","Colors":[{"Color":"0, 0, 0, 0","Location":50.0},{"Color":"255, 21, 0","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawBackground, ShareX.ImageEffectsLib","Color":"Black","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.TornEdge, ShareX.ImageEffectsLib","Depth":5,"Range":5,"Sides":"Top, Bottom, Left, Right","CurvedEdges":true,"Enabled":true}]},{"Name":"Discord spoiler","Effects":[{"$type":"ShareX.ImageEffectsLib.Blur, ShareX.ImageEffectsLib","Radius":101,"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawText, ShareX.ImageEffectsLib","Text":"SPOILER","Placement":"MiddleCenter","Offset":"0, 0","AutoHide":false,"TextFont":"Segoe UI, 9.75pt, style=Bold","TextRenderingMode":"SystemDefault","TextColor":"206, 206, 206","DrawTextShadow":false,"TextShadowColor":"Black","TextShadowOffset":"-1, -1","CornerRadius":20,"Padding":"12, 8, 12, 8","DrawBorder":false,"BorderColor":"Black","BorderSize":1,"DrawBackground":true,"BackgroundColor":"150, 0, 0, 0","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true}]},{"Name":"what (meme)","Effects":[{"$type":"ShareX.ImageEffectsLib.DrawBorder, ShareX.ImageEffectsLib","Type":"Outside","Size":4,"DashStyle":"Solid","Color":"235, 235, 235","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.Canvas, ShareX.ImageEffectsLib","Margin":"20, 20, 20, 70","MarginMode":"AbsoluteSize","Color":"Black","Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawTextEx, ShareX.ImageEffectsLib","Text":"what","Placement":"BottomCenter","Offset":"0, 18","Angle":0,"AutoHide":false,"Font":"Times New Roman, 36pt","Color":"235, 235, 235","UseGradient":false,"Gradient":{"Type":"Horizontal","Colors":[{"Color":"255, 3, 135","Location":0.0},{"Color":"255, 143, 3","Location":100.0}]},"Outline":false,"OutlineSize":5,"OutlineColor":"235, 0, 0","OutlineUseGradient":false,"OutlineGradient":{"Type":"Horizontal","Colors":[{"Color":"0, 187, 138","Location":0.0},{"Color":"0, 105, 163","Location":100.0}]},"Shadow":false,"ShadowOffset":"0, 5","ShadowColor":"125, 0, 0, 0","ShadowUseGradient":false,"ShadowGradient":{"Type":"Horizontal","Colors":[{"Color":"255, 3, 135","Location":0.0},{"Color":"255, 143, 3","Location":100.0}]},"Enabled":true}]},{"Name":"Activate Windows (meme)","Effects":[{"$type":"ShareX.ImageEffectsLib.DrawText, ShareX.ImageEffectsLib","Text":"Activate Windows","Placement":"BottomRight","Offset":"127, 61","AutoHide":false,"TextFont":"Segoe UI, 15.75pt","TextRenderingMode":"SystemDefault","TextColor":"125, 255, 255, 255","DrawTextShadow":false,"TextShadowColor":"Black","TextShadowOffset":"-1, -1","CornerRadius":4,"Padding":"5, 5, 5, 5","DrawBorder":false,"BorderColor":"Black","BorderSize":1,"DrawBackground":false,"BackgroundColor":"10, 110, 230","UseGradient":true,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawText, ShareX.ImageEffectsLib","Text":"Go to Settings to activate Windows.","Placement":"BottomRight","Offset":"40, 38","AutoHide":false,"TextFont":"Segoe UI, 12pt","TextRenderingMode":"SystemDefault","TextColor":"125, 255, 255, 255","DrawTextShadow":false,"TextShadowColor":"Black","TextShadowOffset":"-1, -1","CornerRadius":4,"Padding":"5, 5, 5, 5","DrawBorder":false,"BorderColor":"Black","BorderSize":1,"DrawBackground":false,"BackgroundColor":"10, 110, 230","UseGradient":true,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true}]},{"Name":"Twitch live (meme)","Effects":[{"$type":"ShareX.ImageEffectsLib.DrawText, ShareX.ImageEffectsLib","Text":"LIVE","Placement":"TopLeft","Offset":"10, 10","AutoHide":false,"TextFont":"Arial, 9.75pt, style=Bold","TextRenderingMode":"SystemDefault","TextColor":"235, 235, 235","DrawTextShadow":false,"TextShadowColor":"Black","TextShadowOffset":"-1, -1","CornerRadius":4,"Padding":"2, 2, 2, 2","DrawBorder":false,"BorderColor":"Black","BorderSize":1,"DrawBackground":true,"BackgroundColor":"233, 25, 22","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true},{"$type":"ShareX.ImageEffectsLib.DrawText, ShareX.ImageEffectsLib","Text":"1%rn.%rnK viewers","Placement":"BottomLeft","Offset":"10, 10","AutoHide":false,"TextFont":"Arial, 9.75pt","TextRenderingMode":"SystemDefault","TextColor":"235, 235, 235","DrawTextShadow":false,"TextShadowColor":"Black","TextShadowOffset":"-1, -1","CornerRadius":3,"Padding":"3, 3, 3, 3","DrawBorder":false,"BorderColor":"Black","BorderSize":1,"DrawBackground":true,"BackgroundColor":"150, 0, 0, 0","UseGradient":false,"Gradient":{"Type":"Vertical","Colors":[{"Color":"68, 120, 194","Location":0.0},{"Color":"13, 58, 122","Location":50.0},{"Color":"6, 36, 78","Location":50.0},{"Color":"23, 89, 174","Location":100.0}]},"Enabled":true}]}]
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
function Unwrap($Value) { if ($null -eq $Value) { return $null }; $base = $Value.PSObject.BaseObject; return , $base }
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
# The editor copies the image to the clipboard itself, so Esc still leaves a screenshot there
$editor['AutoCopyImageToClipboard'] = $true

# Annotation look: pink-red shapes with rounded corners, thin non-bold text, tuned blur and pixelate
$editor['BorderColorHex'] = '#FFEA005E'
$editor['TextBorderColorHex'] = '#FFEA005E'
$editor['CornerRadius'] = 15
$editor['TextThickness'] = 4
$editor['TextBold'] = $false
$editor['BlurStrength'] = [double]11
$editor['PixelateStrength'] = [double]7

# Frames: ShareX keeps a separate list for the default settings and for the editor's effects button
$imageSettings = Get-Child $dts 'ImageSettings'
$imageSettings['ImageEffectPresets'] = Copy-Json $presets
$imageSettings['SelectedImageEffectPreset'] = $defaultIndex
$surface = Get-Child (Get-Child $dts 'CaptureSettings') 'SurfaceOptions'
$surface['ImageEffectPresets'] = Copy-Json $presets
$surface['SelectedImageEffectPreset'] = 0

# Screenshot backup folder: <ShareX folder>\Screenshots\<yyyy-mm>
$app['SaveImageSubFolderPattern'] = '%y-%mo'

# Hotkeys: replace only our four, keep everything else
$ours = @('D1, Shift, Control', 'D2, Shift, Control', 'D3, Shift, Control', 'D4, Shift, Control')
$list = New-Object System.Collections.ArrayList
if ($hotkeys.ContainsKey('Hotkeys') -and $hotkeys['Hotkeys']) {
    foreach ($entry in $hotkeys['Hotkeys']) {
        if ($ours -notcontains [string]$entry['HotkeyInfo']['Hotkey']) { [void]$list.Add($entry) }
    }
}

function New-Hotkey([string]$Key, [string]$Description, [string]$AfterCapture, $ImageSettings, [string]$Job = 'RectangleRegion') {
    $info = New-Dict
    $info['Hotkey'] = $Key
    $info['Win'] = $false
    $ts = New-Dict
    $ts['Description'] = $Description
    $ts['Job'] = $Job
    $ts['UseDefaultAfterCaptureJob'] = $false
    $ts['AfterCaptureJob'] = $AfterCapture
    # ShareX dereferences these lists at startup and fails when they are missing
    $ts['ExternalPrograms'] = New-Object System.Collections.ArrayList
    $ts['WatchFolderList'] = New-Object System.Collections.ArrayList
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
[void]$list.Add((New-Hotkey 'D4, Shift, Control' 'Scrolling capture, quick copy and save' $AfterCaptureQuick $null 'ScrollingCapture'))
$hotkeys['Hotkeys'] = $list.ToArray()

Save-Json $app $appPath
Save-Json $hotkeys $hotkeysPath

# 5. Verify what was written
$checkApp = Read-Json $appPath
$checkHotkeys = Read-Json $hotkeysPath
$found = @($checkHotkeys['Hotkeys'] | Where-Object { $ours -contains [string]$_['HotkeyInfo']['Hotkey'] }).Count
$checkDts = $checkApp['DefaultTaskSettings']
$ok = ($found -eq 4) `
    -and ($checkDts['ImageSettings']['ImageEffectPresets'].Count -eq $presets.Count) `
    -and ($checkDts['ToolsSettings']['ImageEditorOptions']['ShowExitConfirmation'] -eq $false) `
    -and ($checkDts['ToolsSettings']['ImageEditorOptions']['AutoCopyImageToClipboard'] -eq $true) `
    -and ($checkDts['ToolsSettings']['ImageEditorOptions']['BorderColorHex'] -eq '#FFEA005E') `
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
Write-Host '  Ctrl+Shift+4  scrolling capture: pick a window, a long page becomes one image'
Write-Host 'Annotate: A = arrow, T = text, R = rectangle, Ctrl+D = duplicate. Enter = copy + save, Esc = discard.'
Write-Host "Every screenshot is also saved in: $shots\<year-month>"
Write-Host "Backup of your old settings: $backupDir"
