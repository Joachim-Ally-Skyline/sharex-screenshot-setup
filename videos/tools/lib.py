import subprocess, os
from PIL import Image, ImageDraw, ImageFilter, ImageFont

W, H = 1920, 1080
BG = (15, 20, 33)
ACCENT = (232, 57, 91)
WHITE = (245, 247, 250)
GREY = (150, 160, 178)
FPS = 30
F = "/usr/share/fonts/opentype/inter/"
ENC = ["-c:v", "libx264", "-preset", "veryfast", "-crf", "18", "-pix_fmt", "yuv420p", "-r", str(FPS), "-an"]


def font(w, s): return ImageFont.truetype(F + f"Inter-{w}.otf", s)
def run(args): subprocess.run(["ffmpeg", "-v", "error", "-y"] + args, check=True)


def keycaps(d, x, y, keys, size=34):
    f = font("SemiBold", size)
    h = int(size * 1.7)
    for i, k in enumerate(keys):
        bw = d.textlength(k, font=f) + 36
        d.rounded_rectangle([x, y + 4, x + bw, y + h + 4], 10, fill=(10, 12, 20))
        d.rounded_rectangle([x, y, x + bw, y + h], 10, fill=(44, 50, 66), outline=(90, 98, 118), width=2)
        d.text((x + 18, y + (h - size) / 2 - 4), k, font=f, fill=WHITE)
        x += bw
        if i < len(keys) - 1:
            d.text((x + 12, y + (h - size) / 2 - 4), "+", font=f, fill=GREY)
            x += 44
    return x


class Video:
    def __init__(self, workdir, src, vw, vh, tag):
        self.wd, self.src, self.tag = workdir, src, tag
        self.vw, self.vh = vw, vh
        self.vx, self.vy = (W - vw) // 2, 22
        os.makedirs(f"{workdir}/ov", exist_ok=True)
        os.makedirs(f"{workdir}/seg", exist_ok=True)
        self.order = []

    def p(self, rel): return f"{self.wd}/{rel}"

    def bg(self, name, step, text, keys=None):
        im = Image.new("RGBA", (W, H), BG + (255,))
        sh = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        ImageDraw.Draw(sh).rounded_rectangle([self.vx - 4, self.vy + 6, self.vx + self.vw + 4, self.vy + self.vh + 12], 14, fill=(0, 0, 0, 170))
        im = Image.alpha_composite(im, sh.filter(ImageFilter.GaussianBlur(14)))
        d = ImageDraw.Draw(im)
        cy, x = 1001, self.vx
        if step:
            d.ellipse([x, cy, x + 58, cy + 58], fill=ACCENT)
            f = font("Bold", 32)
            d.text((x + 29 - d.textlength(str(step), font=f) / 2, cy + 9), str(step), font=f, fill=WHITE)
            x += 80
        f = font("SemiBold", 38)
        d.text((x, cy + 6), text, font=f, fill=WHITE)
        x += d.textlength(text, font=f) + 26
        if keys:
            keycaps(d, x, cy, keys)
        ft = font("Medium", 24)
        d.text((self.vx + self.vw - d.textlength(self.tag, font=ft), cy + 17), self.tag, font=ft, fill=GREY)
        im.save(self.p(f"ov/{name}.png"))

    def card(self, name, lines, keys=None, foot=None, dur=4.0):
        im = Image.new("RGB", (W, H), BG)
        d = ImageDraw.Draw(im)
        total = sum(s for _, s, _, _ in lines) * 1.35 + (130 if keys else 0)
        y = (H - total) / 2
        for txt, size, weight, col in lines:
            f = font(weight, size)
            d.text(((W - d.textlength(txt, font=f)) / 2, y), txt, font=f, fill=col)
            y += size * 1.35
        if keys:
            endx = keycaps(ImageDraw.Draw(Image.new("RGB", (10, 10))), 0, 0, keys, 44)
            keycaps(d, (W - endx) / 2, y + 50, keys, 44)
        if foot:
            f = font("Medium", 28)
            d.text(((W - d.textlength(foot, font=f)) / 2, H - 120), foot, font=f, fill=GREY)
        d.rectangle([0, 0, W, 8], fill=ACCENT)
        im.save(self.p(f"ov/{name}.png"))
        run(["-loop", "1", "-t", str(dur), "-i", self.p(f"ov/{name}.png"), "-vf", f"fps={FPS},format=yuv420p"] + ENC + [self.p(f"seg/{name}.mp4")])
        self.order.append(name)

    def clip(self, name, start, end, step, text, keys=None, speed=1.0, crop=None, blurs=(), hold=0.0):
        """crop=(x,y,w,h) in source px. blurs=[(x,y,w,h,t_until)] in cropped px, t relative to clip start (source time)."""
        self.bg(name, step, text, keys)
        chain = f"[0:v]trim={start}:{end},setpts=PTS-STARTPTS"
        if crop:
            chain += f",crop={crop[2]}:{crop[3]}:{crop[0]}:{crop[1]}"
        chain += "[c0]"
        parts, cur = [chain], "c0"
        for i, (bx, by, bw, bh, until) in enumerate(blurs):
            parts.append(f"[{cur}]split[a{i}][b{i}];[b{i}]crop={bw}:{bh}:{bx}:{by},gblur=sigma=9:steps=3[bb{i}];"
                         f"[a{i}][bb{i}]overlay={bx}:{by}:enable='lt(t,{until})'[c{i+1}]")
            cur = f"c{i+1}"
        tail = f"[{cur}]scale={self.vw}:{self.vh}:flags=lanczos,setpts=PTS/{speed},fps={FPS}"
        if hold:
            tail += f",tpad=stop_mode=clone:stop_duration={hold}"
        parts.append(tail + "[v]")
        parts.append(f"[1:v]fps={FPS}[bg];[bg][v]overlay={self.vx}:{self.vy}:shortest=1,format=yuv420p[o]")
        run(["-i", self.src, "-loop", "1", "-i", self.p(f"ov/{name}.png"), "-filter_complex", ";".join(parts), "-map", "[o]"] + ENC + [self.p(f"seg/{name}.mp4")])
        self.order.append(name)

    def join(self, out, xf=0.4):
        durs = [float(subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", self.p(f"seg/{n}.mp4")],
                                     capture_output=True, text=True).stdout) for n in self.order]
        inputs = sum([["-i", self.p(f"seg/{n}.mp4")] for n in self.order], [])
        fc, prev, t = [], "0:v", durs[0]
        for i in range(1, len(self.order)):
            off = t - xf
            fc.append(f"[{prev}][{i}:v]xfade=transition=fade:duration={xf}:offset={off:.3f}[x{i}]")
            prev, t = f"x{i}", off + durs[i]
        fc.append(f"[{prev}]fade=t=in:st=0:d=0.4,format=yuv420p[out]")
        run(inputs + ["-filter_complex", ";".join(fc), "-map", "[out]", "-movflags", "+faststart"] + ENC + [out])
        return t
