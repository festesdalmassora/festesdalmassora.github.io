import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import 'bull_path.dart';

final Path _bullPath = parseSvgPathData(kBullPathData);

/// Icona de bou (silueta del SVG de l'app); respecta mida i color de l'[IconTheme].
class BullIcon extends StatelessWidget {
  const BullIcon({super.key, this.size, this.color});
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final s = size ?? theme.size ?? 24;
    return SizedBox(
      width: s,
      height: s,
      child: CustomPaint(painter: _BullPainter(color ?? theme.color ?? Colors.black)),
    );
  }
}

class _BullPainter extends CustomPainter {
  _BullPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / kBullW < size.height / kBullH ? size.width / kBullW : size.height / kBullH;
    final dx = (size.width - kBullW * k) / 2 - kBullMinX * k;
    final dy = (size.height - kBullH * k) / 2 - kBullMinY * k;
    final m = Matrix4.identity()
      ..translateByDouble(dx, dy, 0, 1)
      ..scaleByDouble(k, k, 1, 1);
    final path = _bullPath.transform(m.storage)..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true);
  }

  @override
  bool shouldRepaint(_BullPainter old) => old.color != color;
}
