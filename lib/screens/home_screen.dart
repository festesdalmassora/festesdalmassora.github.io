import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../i18n.dart';
import '../widgets/common.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.state, required this.onGoToProgram, required this.onGoToBulls});
  final AppState state;
  final VoidCallback onGoToProgram;
  final VoidCallback onGoToBulls;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final l = state.lang;
        final ed = state.edition;
        final now = DateTime.now();
        final current = ed.events
            .where((e) => !e.start.isAfter(now) && now.difference(e.start).inMinutes <= 90)
            .toList();
        final upcoming = ed.events.where((e) => e.start.isAfter(now)).take(3).toList();
        final startDay = ed.start;
        final daysLeft = DateTime(startDay.year, startDay.month, startDay.day).difference(DateTime(now.year, now.month, now.day)).inDays;
        final over = !ed.events.any((e) => e.start.isAfter(now));
        final dates = '${ed.start.day}–${ed.end.day} ${longDate(l, ed.end).split(' ').skip(2).join(' ')} ${ed.year}';

        return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
          FestaHeader(title: ed.title.of(l), subtitle: dates),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Text(tr(l, 'unofficial'), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline)),
          ),
          if (daysLeft > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(tr(l, 'countdown_days', {'n': '$daysLeft'}),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          if (current.isNotEmpty) ...[
            SectionTitle(tr(l, 'now')),
            ...current.map((e) => EventTile(state: state, event: e)),
          ],
          if (upcoming.isNotEmpty) ...[
            SectionTitle(tr(l, 'next')),
            ...upcoming.map((e) => EventTile(state: state, event: e, showDay: true)),
          ],
          if (over)
            Padding(padding: const EdgeInsets.all(24), child: Center(child: Text(tr(l, 'fest_over'), style: Theme.of(context).textTheme.titleMedium))),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Expanded(
                child: FilledButton.icon(onPressed: onGoToProgram, icon: const Icon(Icons.event_note), label: Text(tr(l, 'program'))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.tonalIcon(onPressed: onGoToBulls, icon: const Icon(Icons.pets), label: Text(tr(l, 'bulls'))),
              ),
            ]),
          ),
        ]);
      },
    );
  }
}
