import 'package:flutter/material.dart';

// Silueta de bou (mateixa que la icona de l'app), coordenades 0-100.
const List<Offset> _bull = [
  Offset(8, 21), Offset(12, 28), Offset(18, 31), Offset(24, 30),
  Offset(28, 25), Offset(33, 17), Offset(37, 17), Offset(36, 24), Offset(34, 31),
  Offset(38, 24), Offset(44, 17), Offset(52, 16), Offset(60, 22),
  Offset(70, 28), Offset(82, 29), Offset(89, 33),
  Offset(91, 44), Offset(93, 58), Offset(94, 70), Offset(91, 70), Offset(89, 60),
  Offset(86, 54), Offset(86, 66), Offset(82, 78), Offset(84, 92), Offset(78, 92),
  Offset(76, 80), Offset(74, 68), Offset(68, 62), Offset(60, 60),
  Offset(54, 62), Offset(52, 76), Offset(53, 92), Offset(47, 92), Offset(45, 78),
  Offset(42, 66), Offset(35, 60), Offset(29, 56), Offset(25, 52),
  Offset(19, 51), Offset(13, 50), Offset(9, 45), Offset(10, 39), Offset(15, 36), Offset(19, 33),
];

List<Offset> _chaikin(List<Offset> pts, int n) {
  for (var i = 0; i < n; i++) {
    final out = <Offset>[];
    for (var k = 0; k < pts.length; k++) {
      final a = pts[k];
      final b = pts[(k + 1) % pts.length];
      out.add(Offset(0.75 * a.dx + 0.25 * b.dx, 0.75 * a.dy + 0.25 * b.dy));
      out.add(Offset(0.25 * a.dx + 0.75 * b.dx, 0.25 * a.dy + 0.75 * b.dy));
    }
    pts = out;
  }
  return pts;
}

final List<Offset> _smooth = _chaikin(_bull, 2);

/// Icona de bou que respecta la mida i el color de l'[IconTheme].
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
    // Caixa del dibuix: x 6..96, y 14..94 (es manté la proporció).
    const minX = 6.0, minY = 14.0, w = 90.0, h = 80.0;
    final k = size.width / w < size.height / h ? size.width / w : size.height / h;
    final dx = (size.width - w * k) / 2;
    final dy = (size.height - h * k) / 2;
    final path = Path();
    for (var i = 0; i < _smooth.length; i++) {
      final p = Offset((_smooth[i].dx - minX) * k + dx, (_smooth[i].dy - minY) * k + dy);
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
      }
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill..isAntiAlias = true);
  }

  @override
  bool shouldRepaint(_BullPainter old) => old.color != color;
}
