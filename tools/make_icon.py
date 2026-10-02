# -*- coding: utf-8 -*-
"""Genera la icona de l'app (assets/icon/icon.png i icon_fg.png): el mateix «celebration» (canó de
confeti) que la pestanya Inici, en blanc sobre verd. Usa la font MaterialIcons del SDK de Flutter."""
import os
from PIL import Image, ImageDraw, ImageFont

FONT = r'D:\Javi\Documentos\python\flutter\bin\cache\artifacts\material_fonts\materialicons-regular.otf'
CODEPOINT = 0xE149  # Icons.celebration
OUT = os.path.join(os.path.dirname(__file__), '..', 'assets', 'icon')
S = 1024
GREEN = (0x2E, 0x8B, 0x57, 255)


def glyph(size_px, color, bg=None):
    f = ImageFont.truetype(FONT, size_px)
    img = Image.new('RGBA', (S, S), bg if bg else (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    box = d.textbbox((0, 0), chr(CODEPOINT), font=f)
    w, h = box[2] - box[0], box[3] - box[1]
    d.text(((S - w) / 2 - box[0], (S - h) / 2 - box[1]), chr(CODEPOINT), font=f, fill=color)
    return img


glyph(700, (255, 255, 255, 255), GREEN).convert('RGB').save(os.path.join(OUT, 'icon.png'))
glyph(520, (255, 255, 255, 255)).save(os.path.join(OUT, 'icon_fg.png'))
print('ok')
