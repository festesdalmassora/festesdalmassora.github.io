# -*- coding: utf-8 -*-
"""Genera assets/icon/icon.png (1024) i icon_fg.png a partir de assets/icon/osborne-el-toro.svg
(es pren el segon <path>, el del toro; el primer és el fons blanc)."""
import os
import re
from PIL import Image, ImageChops, ImageDraw
from svgpathtools import parse_path

HERE = os.path.dirname(__file__)
OUT = os.path.join(HERE, '..', 'assets', 'icon')
svg = open(os.path.join(OUT, 'osborne-el-toro.svg'), encoding='utf-8').read()
d = re.findall(r'd="([^"]+)"', svg)[1]
path = parse_path(d)
subs = path.continuous_subpaths()
xs0, xs1, ys0, ys1 = path.bbox()
S, SS = 1024, 4


def render(scale, color, bg=None):
    big = S * SS
    w, h = xs1 - xs0, ys1 - ys0
    k = scale * big / max(w, h)
    ox = (big - w * k) / 2 - xs0 * k
    oy = (big - h * k) / 2 - ys0 * k
    mask = Image.new('L', (big, big), 0)
    for sp in subs:
        pts = [(sp.point(t / 40).real * k + ox, sp.point(t / 40).imag * k + oy) for t in range(0, 41)]
        # mostrejar tots els segments
        pts = []
        for seg in sp:
            for i in range(24):
                z = seg.point(i / 24)
                pts.append((z.real * k + ox, z.imag * k + oy))
        layer = Image.new('L', (big, big), 0)
        ImageDraw.Draw(layer).polygon(pts, fill=255)
        mask = ImageChops.logical_xor(mask.convert('1'), layer.convert('1')).convert('L')
    mask = mask.resize((S, S), Image.LANCZOS)
    out = Image.new('RGBA', (S, S), bg if bg else (0, 0, 0, 0))
    solid = Image.new('RGBA', (S, S), color)
    out.paste(solid, (0, 0), mask)
    return out


render(0.74, (15, 15, 15, 255), (0x2E, 0x8B, 0x57, 255)).convert('RGB').save(os.path.join(OUT, 'icon.png'))
render(0.52, (15, 15, 15, 255)).save(os.path.join(OUT, 'icon_fg.png'))
print('ok')
