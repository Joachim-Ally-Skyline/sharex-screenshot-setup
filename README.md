# ShareX screenshot setup

One script that sets up [ShareX](https://getsharex.com) for fast, good-looking screenshots. No account needed.

## Quick start

1. Open [PROMPT.md](PROMPT.md), copy the prompt into an AI agent that can run PowerShell, and let it run.
2. Or run it yourself in Windows PowerShell:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\Setup-ShareX.ps1
```

The script:

- **backs up** your current ShareX settings first (`Backup\SetupBackup_<timestamp>` in your ShareX folder),
- installs ShareX with `winget` **only if it is not installed yet**,
- starts ShareX with Windows (tray only),
- changes only the settings below; everything else is left alone. Running it again is safe.

Training slides (two slides, English): [ShareX mini training.pptx](<ShareX mini training.pptx>).

More to explore, all built into ShareX: OCR (tray icon, under Capture), Blur and Pixelate in the editor, Shift+PrintScreen for a screen recording and Ctrl+Shift+PrintScreen for a GIF.

## What you get

| Hotkey | What it does |
|---|---|
| **Ctrl+Shift+1** | Select an area, **pick a frame**, annotate, Enter |
| **Ctrl+Shift+2** | Select an area, default frame (rounded grey border), annotate, Enter |
| **Ctrl+Shift+3** | Select an area, default frame, straight to the clipboard. Fastest, ideal for pasting into AI |
| **Ctrl+Shift+4** | Scrolling capture: pick a window and a long web page becomes one image, straight to the clipboard |

- No capture sound, and no "unsaved changes" question when you close the editor.
- Annotations look the same for everyone: pink-red arrows and rectangles with rounded corners, thin text, blur 11 and pixelate 7.
- Every screenshot is copied to the clipboard and saved in `Documents\ShareX\Screenshots\<year-month>`.
- 10 frames: No effect, Rounded grey border (default), Blue border, Blue glow, Green border, Green glow,
  Gold border, Gold wavy edge, Red torn edge, Pill shape.

## Editor tips

`A` arrow, `T` text, `R` rectangle, `Ctrl+D` duplicate the selected shape, `Enter` copy + save, `Esc` discard.

Also turn on Windows clipboard history with **Windows+V**: take several screenshots and paste the one you need.

## Why ShareX

Free, open source and actively maintained (unlike Greenshot). The grey rounded border looks good in e-mails,
and the region capture shows the edges of e.g. your browser window.

## Undo

Close ShareX (tray, Exit), copy the files from `Backup\SetupBackup_<timestamp>` back into the ShareX folder
(`Documents\ShareX`), and start ShareX.

## Requirements

Windows 10/11 with Windows PowerShell 5.1 (built in). `winget` is only needed when ShareX is not installed.
Tested with ShareX 21.
