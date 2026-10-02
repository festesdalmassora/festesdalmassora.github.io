# -*- coding: utf-8 -*-
"""Genera la icona de l'app (assets/icon/icon.png i icon_fg.png): una rosa («Roser»).
El toro (osborne-el-toro.svg) només s'usa dins de l'app (BullIcon), no com a icona principal."""
import math
import os
from PIL import Image, ImageDraw

OUT = os.path.join(os.path.dirname(__file__), '..', 'assets', 'icon')
S, SS = 1024, 4
BIG = S * SS
GREEN = (0x2E, 0x8B, 0x57, 255)
LEAF = (0x1B, 0x6B, 0x43, 255)
LEAF_LIGHT = (0x3C, 0xA8, 0x6B, 255)


def darker(c, f=0.78):
    return (int(c[0] * f), int(c[1] * f), int(c[2] * f), 255)


def circle(d, cx, cy, r, fill):
    d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=fill, outline=darker(fill), width=int(BIG * 0.004))


def leaf(img, cx, cy, length, width, angle, fill):
    layer = Image.new('RGBA', img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    pts = []
    for i in range(0, 101):
        t = i / 100
        x = (t - 0.5) * length
        y = math.sin(t * math.pi) * width / 2
        pts.append((x, y))
    for i in range(100, -1, -1):
        t = i / 100
        x = (t - 0.5) * length
        y = -math.sin(t * math.pi) * width / 2
        pts.append((x, y))
    a = math.radians(angle)
    pts = [(cx + x * math.cos(a) - y * math.sin(a), cy + x * math.sin(a) + y * math.cos(a)) for x, y in pts]
    d.polygon(pts, fill=fill)
    img.alpha_composite(layer)


def rose(scale, bg=None):
    img = Image.new('RGBA', (BIG, BIG), bg if bg else (0, 0, 0, 0))
    c = BIG / 2
    k = scale * BIG / 1200  # unitats de disseny (~1200 de diàmetre total)
    # fulles
    leaf(img, c - 400 * k, c + 330 * k, 600 * k, 260 * k, 150, LEAF)
    leaf(img, c + 400 * k, c + 330 * k, 600 * k, 260 * k, 30, LEAF)
    leaf(img, c, c + 480 * k, 560 * k, 220 * k, 90, LEAF_LIGHT)
    d = ImageDraw.Draw(img)
    layers = [
        (6, 330, 300, 0, (0xF7, 0xB6, 0xC4, 255)),
        (5, 215, 235, 36, (0xF0, 0x7F, 0x9A, 255)),
        (4, 120, 170, 20, (0xE2, 0x4F, 0x73, 255)),
    ]
    for n, dist, r, off, col in layers:
        for i in range(n):
            a = math.radians(off + i * 360 / n)
            circle(d, c + dist * k * math.cos(a), c + dist * k * math.sin(a) - 20 * k, r * k, col)
    circle(d, c, c - 20 * k, 110 * k, (0xC6, 0x2D, 0x55, 255))
    circle(d, c + 10 * k, c - 35 * k, 55 * k, (0xA8, 0x1F, 0x45, 255))
    return img.resize((S, S), Image.LANCZOS)


rose(0.60, GREEN).convert('RGB').save(os.path.join(OUT, 'icon.png'))
rose(0.44).save(os.path.join(OUT, 'icon_fg.png'))
print('ok')
