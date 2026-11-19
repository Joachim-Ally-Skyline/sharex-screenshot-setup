import sys
sys.path.insert(0, "/home/claude")
from lib import Video, WHITE, GREY, ACCENT

REPO = "github.com/Joachim-Ally-Skyline/sharex-screenshot-setup"
OUT = "/mnt/user-data/outputs"
which = sys.argv[1:] or ["4", "2"]

if "4" in which:
    v = Video("/home/claude/v4", "/home/claude/work/raw.wmv", 1646, 948, "DataMiner Assistant  ·  Ctrl+Shift+4")
    v.card("title", [("Share a whole DataMiner Assistant conversation", 66, "Bold", WHITE),
                     ("as one image, even when it's way longer than your screen", 38, "Medium", GREY)],
           keys=["Ctrl", "Shift", "4"], dur=3.8)
    v.clip("c0", 13.0, 16.5, None, "This DataMiner Assistant answer doesn't fit on one screen")
    v.clip("c1", 38.2, 41.3, 1, "Press", keys=["Ctrl", "Shift", "4"])
    v.clip("c2", 41.3, 45.0, 2, "Drag a box around the Assistant chat")
    v.clip("c3", 45.0, 55.0, 3, "ShareX scrolls through the conversation for you", speed=2.0)
    v.clip("c4", 55.2, 67.4, 4, "Done: the whole conversation in one image", speed=2.0)
    v.card("end", [("The full Assistant conversation, ready to paste", 58, "Bold", WHITE),
                   ("into Teams, a mail, a ticket or a Dojo post", 38, "Medium", GREY),
                   ("", 30, "Medium", GREY),
                   ("Want the same setup? One prompt does it all.", 36, "SemiBold", ACCENT)],
           foot=REPO, dur=5.0)
    print("ctrl4", v.join(f"{OUT}/ShareX - Ctrl+Shift+4 DataMiner Assistant conversation.mp4"))

if "2" in which:
    CROP = (200, 62, 1446, 896)  # drops the other windows and taskbar strip around the work
    v = Video("/home/claude/v2", "/home/claude/w2/raw.wmv", 1530, 948, "ShareX  ·  Ctrl+Shift+2")
    v.card("title", [("Send a customer a quick screenshot", 66, "Bold", WHITE),
                     ("with an arrow and a note on it, in a few seconds", 38, "Medium", GREY)],
           keys=["Ctrl", "Shift", "2"], dur=3.8)
    v.clip("c1", 1.4, 3.0, 1, "Press", keys=["Ctrl", "Shift", "2"], crop=CROP)
    v.clip("c2", 3.0, 5.0, 2, "Drag around what you want to show", crop=CROP)
    v.clip("c3", 5.0, 10.6, 3, "Draw an arrow", keys=["A"], crop=CROP, speed=1.4)
    v.clip("c4", 10.6, 15.6, 4, "Type a short note", keys=["T"], crop=CROP, speed=1.4)
    v.clip("c5", 15.0, 15.75, 5, "Press Enter: it's on your clipboard", keys=["Enter"], crop=CROP, hold=1.3)
    # recipient address and the "outside your organization" banner get blurred until the mail scrolls
    blurs = [(250, 192, 520, 112, 99)]
    v.clip("c6", 31.2, 33.4, 6, "Paste it in your mail", keys=["Ctrl", "V"], crop=CROP, blurs=blurs, hold=2.2)
    v.card("end", [("Grey rounded border, pink-red arrows", 58, "Bold", WHITE),
                   ("the same clean look for everyone on the team", 38, "Medium", GREY),
                   ("", 30, "Medium", GREY),
                   ("Want the same setup? One prompt does it all.", 36, "SemiBold", ACCENT)],
           foot=REPO, dur=5.0)
    print("ctrl2", v.join(f"{OUT}/ShareX - Ctrl+Shift+2 quick screenshot for a customer.mp4"))
