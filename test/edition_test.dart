import 'dart:convert';
import 'dart:io';

import 'package:festes_almassora/models/edition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ed = Edition.from(jsonDecode(File('assets/editions/2026/edition.json').readAsStringSync()) as Map<String, dynamic>);

  test('carrega l\'edició 2026', () {
    expect(ed.year, 2026);
    expect(ed.court.length, 5);
    expect(ed.bulls.length, 12);
    expect(ed.cows.length, 7);
    expect(ed.festDays.first, DateTime(2026, 10, 2));
  });

  test('tots els actes tenen lloc conegut', () {
    for (final e in ed.events) {
      expect(ed.places.containsKey(e.placeId), isTrue, reason: e.id);
    }
  });

  test('actes de matinada compten com a dia següent', () {
    final e = ed.eventsOn(DateTime(2026, 10, 2)).last;
    expect(e.time, '03:00');
    expect(e.start, DateTime(2026, 10, 3, 3, 0));
    final first = ed.eventsOn(DateTime(2026, 10, 2)).first;
    expect(first.sortKey < e.sortKey, isTrue);
  });
}
