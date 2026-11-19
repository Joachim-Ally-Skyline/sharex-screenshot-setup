import sys
sys.path.insert(0, "/home/claude")
from PIL import Image, ImageDraw, ImageFilter
from lib import Video, W, H, BG, ACCENT, WHITE, GREY, FPS, ENC, font, keycaps, run

REPO = "github.com/Joachim-Ally-Skyline/sharex-screenshot-setup"
v = Video("/home/claude/vi", None, 1646, 948, "ShareX  ·  one-prompt install")
PANEL = (44, 50, 66)


def scene(name, step, caption, draw_fn, dur, keys=None, zoom=False):
    v.bg(name, step, caption, keys)
    im = Image.open(v.p(f"ov/{name}.png")).convert("RGB")
    d = ImageDraw.Draw(im)
    d.rectangle([0, 0, W, 992], fill=BG)
    draw_fn(im, d)
    im.save(v.p(f"ov/{name}_f.png"))
    vf = f"fps={FPS},format=yuv420p"
    if zoom:  # gentle push-in
        frames = int(dur * FPS)
        vf = (f"scale=3840:-1,zoompan=z='1+0.06*on/{frames}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d={frames}:s={W}x{H}:fps={FPS},format=yuv420p")
    src = ["-i", v.p(f"ov/{name}_f.png")] if zoom else ["-loop", "1", "-t", str(dur), "-i", v.p(f"ov/{name}_f.png")]
    run(src + ["-vf", vf] + ENC + [v.p(f"seg/{name}.mp4")])
    v.order.append(name)


def shadowed_paste(im, src, box_xy):
    x, y = box_xy
    sh = Image.new("RGBA", im.size, (0, 0, 0, 0))
    ImageDraw.Draw(sh).rounded_rectangle([x - 6, y + 8, x + src.width + 6, y + src.height + 18], 20, fill=(0, 0, 0, 180))
    im.paste(Image.alpha_composite(im.convert("RGBA"), sh.filter(ImageFilter.GaussianBlur(18))).convert("RGB"))
    im.paste(src, (x, y))


shot = Image.open("/mnt/user-data/uploads/1abc3fd9-image.png").convert("RGB")
shot = shot.resize((int(shot.width * 1.85), int(shot.height * 1.85)), Image.LANCZOS)

v.card("title", [("Get the same setup in one prompt", 70, "Bold", WHITE),
                 ("free, no account, about a minute", 38, "Medium", GREY)], dur=3.2)


def s1(im, d):
    shadowed_paste(im, shot, ((W - shot.width) // 2, (990 - shot.height) // 2))


scene("i1", 1, "Ask an AI agent that can work on your computer", s1, 5.0, zoom=True)

checks = ["Backs up your current ShareX settings",
          "Installs ShareX with winget, only if it's missing",
          "Sets the four hotkeys, frames and annotation style",
          "Starts ShareX with Windows, quietly in the tray"]


def make_checks(n):
    def fn(im, d):
        x0, y0, w = 360, 210, 1200
        d.rounded_rectangle([x0, y0, x0 + w, y0 + 120 + 130 * len(checks)], 24, fill=PANEL)
        d.text((x0 + 50, y0 + 40), "The agent runs Setup-ShareX.ps1, which:", font=font("SemiBold", 34), fill=GREY)
        for i, t in enumerate(checks):
            y = y0 + 120 + i * 130
            done = i < n
            col = (46, 196, 112) if done else (90, 98, 118)
            d.ellipse([x0 + 50, y, x0 + 110, y + 60], fill=col)
            if done:
                d.line([(x0 + 66, y + 31), (x0 + 77, y + 43), (x0 + 96, y + 19)], fill=WHITE, width=7)
            d.text((x0 + 140, y + 8), t, font=font("SemiBold", 38), fill=WHITE if done else (120, 128, 146))
    return fn


for n in range(1, 5):
    scene(f"i2_{n}", 2, "Let it run", make_checks(n), 1.1 if n < 4 else 2.4)

rows = [("1", "Pick a frame, annotate", "share with context"),
        ("2", "Grey rounded border + arrows", "a quick screenshot for a customer"),
        ("3", "Border, straight to clipboard", "a quick bug for an AI to look at"),
        ("4", "Scrolling capture", "a whole DataMiner Assistant chat")]


reply = Image.open("/mnt/user-data/uploads/5db34989-image.png").convert("RGB").crop((0, 0, 874, 300))
reply = reply.resize((int(reply.width * 1.75), int(reply.height * 1.75)), Image.LANCZOS)


def s_reply(im, d):
    shadowed_paste(im, reply, ((W - reply.width) // 2, (975 - reply.height) // 2))


scene("i25", 3, "It tells you where the backup is and what it set up", s_reply, 4.5, zoom=True)


def s3(im, d):
    x0, y0 = 250, 150
    for i, (k, what, use) in enumerate(rows):
        y = y0 + i * 175
        d.rounded_rectangle([x0, y, x0 + 1420, y + 145], 22, fill=PANEL)
        keycaps(d, x0 + 40, y + 37, ["Ctrl", "Shift", k], 32)
        d.text((x0 + 470, y + 28), what, font=font("Bold", 40), fill=WHITE)
        d.text((x0 + 470, y + 84), use, font=font("Medium", 30), fill=GREY)


scene("i3", 4, "Done: four new hotkeys, ready to use", s3, 5.0)

v.card("end", [("Two ways to install", 64, "Bold", WHITE),
               ("", 20, "Medium", GREY),
               ("With an AI agent: paste the prompt from PROMPT.md", 40, "SemiBold", WHITE),
               ("By hand: run the PowerShell one-liner in the README", 40, "SemiBold", WHITE),
               ("", 20, "Medium", GREY),
               ("Changed your mind? The backup folder puts everything back.", 32, "Medium", GREY)],
       foot=REPO, dur=5.5)

for n in ["i2_1", "i2_2", "i2_3"]:
    pass
print("install", v.join("/mnt/user-data/outputs/ShareX - install in one prompt.mp4", xf=0.3))
