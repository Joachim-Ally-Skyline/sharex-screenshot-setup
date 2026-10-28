# The prompt

Copy everything in the block below into an AI agent that can run PowerShell commands on your Windows PC
(for example GitHub Copilot CLI or Copilot Chat in agent mode).

```text
Set up ShareX on this Windows PC using the script in this public repo:
https://github.com/Joachim-Ally-Skyline/sharex-screenshot-setup

Follow these steps exactly, and do nothing else:
1. Download the raw script to a temp folder:
   https://raw.githubusercontent.com/Joachim-Ally-Skyline/sharex-screenshot-setup/main/Setup-ShareX.ps1
2. Show me a short summary of what the script does (it backs up my existing ShareX settings first,
   installs ShareX with winget only if it is missing, then configures four screenshot hotkeys).
3. Run it with Windows PowerShell 5.1:
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File <path to the downloaded script>
4. Do not edit the script, do not change any other ShareX or system settings, and do not install anything
   yourself. If ShareX is already installed, it must NOT be reinstalled.
5. When it finishes, tell me: whether ShareX was already installed, the backup folder path that the script
   printed, and the four hotkeys. If the script fails, show me the error and stop.
```

## Can a small model (e.g. Gemini 3.8 Flash) run this?

Yes. The agent does not have to understand ShareX: it only downloads one script, runs one command and
reports the output. All the real logic (backup, install-if-missing, settings, frames) is in the script.
