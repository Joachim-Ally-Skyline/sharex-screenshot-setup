# Prompt for GitHub Copilot: ShareX explainer videos

Copy everything below the line into GitHub Copilot (agent mode, with access to this repo folder).

---

You are helping me maintain three short explainer videos for my repo `sharex-screenshot-setup` (github.com/Joachim-Ally-Skyline/sharex-screenshot-setup). The repo sets up ShareX on Windows with one PowerShell script (`Setup-ShareX.ps1`) or one AI prompt (`PROMPT.md`), and configures four hotkeys: Ctrl+Shift+1 (area capture, pick a frame, annotate), Ctrl+Shift+2 (area capture with grey rounded border, annotate, Enter), Ctrl+Shift+3 (area with border straight to clipboard), Ctrl+Shift+4 (scrolling capture into one long image). The audience is my colleagues at Skyline Communications, so the videos are about DataMiner and customer work. Read README.md first for context.

Below is exactly how the videos were made, so you can rebuild, tweak or extend them. Do not change the style unless I ask. The build scripts are in `videos/tools/` (`lib.py`, `make_videos.py`, `make_install.py`). They were written for Linux, so adjust the paths (source recordings, fonts, output folder) before running them on Windows. They need Python 3 with Pillow, and ffmpeg/ffprobe on the PATH.

## The three outputs (in `videos/`)

1. `ShareX - Ctrl+Shift+4 DataMiner Assistant conversation.mp4` (about 28 s)
2. `ShareX - Ctrl+Shift+2 quick screenshot for a customer.mp4` (about 24 s)
3. `ShareX - install in one prompt.mp4` (about 27 s)

All three are 1920x1080, 30 fps, H.264 (libx264, preset veryfast, CRF 18, yuv420p, `+faststart`), with no audio track. The raw recordings had only keyboard and room noise, no narration, so the audio was dropped and on-screen captions tell the story.

## Visual style (shared by all three)

- Background colour: dark navy RGB (15, 20, 33).
- Accent colour: pink-red RGB (232, 57, 91), the same colour as the ShareX annotation arrows. It is used for a thin 8 px bar at the top of title and end cards, for the step-number circles and for the call-to-action line.
- Text: white RGB (245, 247, 250) for main text, grey RGB (150, 160, 178) for secondary text.
- Font: Inter (Bold for titles, SemiBold for captions, Medium for subtitles). On Windows, install Inter or fall back to Segoe UI.
- Screen-recording scenes: the recording sits centred near the top of the frame (top edge at y = 22, max 1646x948 px) with a soft blurred drop shadow. Under it, at y about 1001, is a caption bar: a 58 px accent circle with the step number, then the caption in 38 px SemiBold white, then optional keycaps. On the far right sits a small grey tag such as "DataMiner Assistant · Ctrl+Shift+4".
- Keycaps are drawn as dark rounded rectangles (fill (44, 50, 66), outline (90, 98, 118), small dark drop shadow), separated by a grey "+".
- Title and end cards: centred text on the navy background, accent bar on top, optional large keycaps under the title, the repo URL in small grey text at the bottom.
- Scenes are joined with 0.4 s crossfades (ffmpeg `xfade=transition=fade`), plus a 0.4 s fade-in at the very start.
- Writing style for captions: short, casual, human. No em dashes anywhere.

## Video 1: Ctrl+Shift+4, sharing a whole DataMiner Assistant conversation

Source: `raw/Screen Recording (19-11-2026 10-35-56).wmv`, 1646x948, 24 fps, 76 s. It is a DataMiner Assistant chat (a satellite booking conversation with the SatOps Agent) that is much longer than the screen. The recording shows the Ctrl/Shift/key presses as on-screen keycaps, which we keep.

What was cut: 0 to 18 s (fumbling with Ctrl+Win), the first Ctrl+Shift+4 attempt at 18 to 25 s (it did not finish), the idle stretch 25 to 38 s, the ShareX "Scrolling capture options" dialog at 68 to 70 s and everything after.

Timeline (source times, recording shown at native size, no crop):
1. Title card, 3.8 s: "Share a whole DataMiner Assistant conversation" / "as one image, even when it's way longer than your screen" / keycaps Ctrl + Shift + 4.
2. 13.0 to 16.5 s, no step number: "This DataMiner Assistant answer doesn't fit on one screen".
3. 38.2 to 41.3 s, step 1: "Press" + keycaps Ctrl Shift 4.
4. 41.3 to 45.0 s, step 2: "Drag a box around the Assistant chat".
5. 45.0 to 55.0 s at 2x speed, step 3: "ShareX scrolls through the conversation for you".
6. 55.2 to 67.4 s at 2x speed, step 4: "Done: the whole conversation in one image". This shows the ShareX result window (status bar says 862x4718, so one image 4,718 px tall).
7. End card, 5 s: "The full Assistant conversation, ready to paste" / "into Teams, a mail, a ticket or a Dojo post" / accent line "Want the same setup? One prompt does it all." / repo URL.

## Video 2: Ctrl+Shift+2, a quick screenshot with an arrow for a customer

Source: `raw/Screen Recording (19-11-2026 10-52-40).wmv`, 1914x1006, 37 s. It shows a DataMiner app (Thermal Sensors view), a Ctrl+Shift+2 capture, the ShareX editor with an arrow and the text "added the alarm template", then pasting into an Outlook mail to a customer.

Clean-up applied to every clip:
- Crop to x=200, y=62, w=1446, h=896 (source pixels). This removes the ShareX toolbar at the top, a Copilot/Claude window behind, and a terminal strip at the bottom that showed unrelated personal text. The crop is then scaled to 1530x948.
- Privacy: in the Outlook part, the To field showed a real customer name and email address (Telenor), and Outlook's banner "The following recipient is outside your organization: <name>" repeats it. Both are covered with a Gaussian blur box (`gblur=sigma=9:steps=3`) at x=250, y=192, w=520, h=112 in cropped coordinates, active for the whole Outlook clip. Always check frame by frame that no customer name or address is readable. The mail view scrolls around, so do not trust one fixed position without checking.
- The idle part 16.4 to 31 s (back on the app, nothing happening) was cut.

Timeline (source times):
1. Title card, 3.8 s: "Send a customer a quick screenshot" / "with an arrow and a note on it, in a few seconds" / keycaps Ctrl + Shift + 2.
2. 1.4 to 3.0 s, step 1: "Press" + Ctrl Shift 2.
3. 3.0 to 5.0 s, step 2: "Drag around what you want to show".
4. 5.0 to 10.6 s at 1.4x, step 3: "Draw an arrow" + keycap A.
5. 10.6 to 15.6 s at 1.4x, step 4: "Type a short note" + keycap T.
6. 15.0 to 15.75 s, then the last frame frozen for 1.3 s (`tpad=stop_mode=clone`), step 5: "Press Enter: it's on your clipboard" + keycap Enter.
7. 31.2 to 33.4 s, then the last frame frozen for 2.2 s, with the blur, step 6: "Paste it in your mail" + keycaps Ctrl V. The clip stops at 33.4 s because the mail scrolls after that and the blur box would drift.
8. End card, 5 s: "Grey rounded border, pink-red arrows" / "the same clean look for everyone on the team" / accent line "Want the same setup? One prompt does it all." / repo URL.

## Video 3: how to install it with one prompt

No screen recording. It is built from two real screenshots plus drawn panels:
- Screenshot A: the Copilot app chat box with the prompt "check this repo, and help me install share x and configure it the exact same way as recommended there" + the repo link, model "Gemini 3.8 Flash · High", mode "This computer".
- Screenshot B: the top part of the agent's reply after it ran the script (crop the top 300 px): the backup path, the four configured hotkeys, and "Capture sound and exit prompt are disabled, and ShareX is running in the tray".

Timeline:
1. Title card, 3.2 s: "Get the same setup in one prompt" / "free, no account, about a minute".
2. Step 1, 5 s, screenshot A scaled 1.85x, centred, with a slow 6% push-in zoom (ffmpeg `zoompan` on a single input image, not a looped one): "Ask an AI agent that can work on your computer".
3. Step 2, "Let it run": a dark rounded panel titled "The agent runs Setup-ShareX.ps1, which:" with four check items that turn green one by one (1.1 s each, the last one held 2.4 s): "Backs up your current ShareX settings", "Installs ShareX with winget, only if it's missing", "Sets the four hotkeys, frames and annotation style", "Starts ShareX with Windows, quietly in the tray".
4. Step 3, 4.5 s, screenshot B scaled 1.75x with the same push-in: "It tells you where the backup is and what it set up".
5. Step 4, 5 s, "Done: four new hotkeys, ready to use": four rows, each with keycaps Ctrl Shift N, a bold title and a grey use case: 1 "Pick a frame, annotate / share with context", 2 "Grey rounded border + arrows / a quick screenshot for a customer", 3 "Border, straight to clipboard / a quick bug for an AI to look at", 4 "Scrolling capture / a whole DataMiner Assistant chat".
6. End card, 5.5 s: "Two ways to install" / "With an AI agent: paste the prompt from PROMPT.md" / "By hand: run the PowerShell one-liner in the README" / "Changed your mind? The backup folder puts everything back." / repo URL.
Crossfades in this video are 0.3 s.

Note: screenshot B shows my OneDrive path with my Windows username. That is fine for an internal channel. Blur it if the video goes public.

## Repo housekeeping

- Keep the raw recordings in `raw/` and never commit them (they are 21 MB and 43 MB, and git history keeps them forever). Add `raw/` to `.gitignore`.
- The rendered videos live in `videos/`. If they should not be in git either, add `videos/*.mp4` to `.gitignore`. To show a video in the README, drag the MP4 into the README editor on github.com instead, so GitHub stores it as an attachment and the repo stays light.
- An old file `ShareX - Ctrl+Shift+4 scrolling capture explainer.mp4` in the repo root is an outdated first version and can be deleted.

## How to verify after any change

- Pull a contact sheet, for example `ffmpeg -i video.mp4 -vf "fps=1,scale=640:-1,tile=4x6" -frames:v 1 sheet.png`, and check every frame.
- Check that the captions don't overlap the grey tag on the right, that the keycaps are readable, and that no customer name, email address or unrelated window is visible anywhere.
- Check the total duration with ffprobe. Every video should stay under about 30 s.

When I ask for a new hotkey video (for example Ctrl+Shift+1 or Ctrl+Shift+3), follow the same recipe: look at the raw recording frame by frame, cut the fumbling and idle parts, crop away other windows, blur any customer data, add a title card, numbered step captions with keycaps and an end card, and use the same colours, fonts and timings.
