# -*- coding: utf-8 -*-
"""Genera icon.png (1024) i icon_fg.png: silueta pròpia de bou (inspirada en el
bou tradicional de carretera) sobre fons verd. Dibuix original."""
import os
from PIL import Image, ImageDraw

HERE = os.path.dirname(__file__)
OUT = os.path.join(HERE, '..', 'assets', 'icon')
os.makedirs(OUT, exist_ok=True)
S = 1024
SS = 4  # supermostreig

# Silueta mirant a l'esquerra, coordenades 0-100 (y cap avall)
BULL = [
    (8, 21), (12, 28), (18, 31), (24, 30),                 # banya davantera
    (28, 25), (33, 17), (37, 17), (36, 24), (34, 31),      # banya darrere
    (38, 24), (44, 17), (52, 16), (60, 22),                # gep alt
    (70, 28), (82, 29), (89, 33),                          # llom i gropa
    (91, 44), (93, 58), (94, 70), (91, 70), (89, 60),      # cua
    (86, 54), (86, 66), (82, 78), (84, 92), (78, 92),      # pota darrere
    (76, 80), (74, 68), (68, 62), (60, 60),                # panxa alta
    (54, 62), (52, 76), (53, 92), (47, 92), (45, 78),      # pota davant
    (42, 66), (35, 60), (29, 56), (25, 52),                # pit
    (19, 51), (13, 50), (9, 45), (10, 39), (15, 36), (19, 33),  # morro baix
]

SHARP = {(5, 12), (34, 13), (38, 12), (95, 72), (92, 92)}


def chaikin(pts, n=2):
    for _ in range(n):
        out = []
        for k in range(len(pts)):
            a, b = pts[k], pts[(k + 1) % len(pts)]
            out.append((0.75 * a[0] + 0.25 * b[0], 0.75 * a[1] + 0.25 * b[1]))
            out.append((0.25 * a[0] + 0.75 * b[0], 0.25 * a[1] + 0.75 * b[1]))
        pts = out
    return pts


BULL = chaikin(BULL, 2)


def draw_bull(size, scale, offset, color):
    img = Image.new('RGBA', (size * SS, size * SS), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    pts = [((x - 50) * scale + 50 + offset[0], (y - 50) * scale + 50 + offset[1]) for x, y in BULL]
    pts = [(x / 100 * size * SS, y / 100 * size * SS) for x, y in pts]
    d.polygon(pts, fill=color)
    return img.resize((size, size), Image.LANCZOS)


# Icona completa: fons verd arredonit + bou negre
bg = Image.new('RGBA', (S, S), (0x2E, 0x8B, 0x57, 255))
bull = draw_bull(S, 0.78, (0, 0), (15, 15, 15, 255))
bg.alpha_composite(bull)
bg.convert('RGB').save(os.path.join(OUT, 'icon.png'))

# Primer pla per a icona adaptativa d'Android (zona segura ~66%)
fg = draw_bull(S, 0.55, (0, 0), (15, 15, 15, 255))
fg.save(os.path.join(OUT, 'icon_fg.png'))
print('ok')
