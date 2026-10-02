import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../i18n.dart';
import '../models/edition.dart';
import '../widgets/bull_icon.dart';
import '../widgets/common.dart';

class BullsScreen extends StatelessWidget {
  const BullsScreen({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final l = state.lang;
        final ed = state.edition;
        final days = {...ed.bulls.map((b) => b.day), ...ed.cows.map((c) => c.day)}.toList()..sort();
        return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
          FestaHeader(title: tr(l, 'bulls'), subtitle: '${ed.year}'),
          for (final d in days) ...[
            SectionTitle(longDate(l, d)),
            for (final c in ed.cows.where((c) => c.day == d))
              _CowsTile(c: c, l: l),
            for (final b in ed.bulls.where((b) => b.day == d))
              _BullCard(bull: b, l: l),
          ],
          SectionTitle(tr(l, 'trophies')),
          for (final t in ed.trophies)
            ListTile(
              leading: const Icon(Icons.emoji_events, color: Color(0xFFE0A100)),
              title: Text(t.name.of(l)),
              subtitle: Text(t.sponsor),
            ),
        ]);
      },
    );
  }
}

class _CowsTile extends StatelessWidget {
  const _CowsTile({required this.c, required this.l});
  final Cows c;
  final String l;

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: ListTile(
          leading: const BullIcon(),
          title: Text('${c.time} · ${tr(l, 'cows_title')}', style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text('${tr(l, 'bull_ranch')}: ${c.ranch}'),
        ),
      );
}

class _BullCard extends StatelessWidget {
  const _BullCard({required this.bull, required this.l});
  final Bull bull;
  final String l;

  Widget _row(BuildContext context, String k, String v) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 96, child: Text(k, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.outline))),
          Expanded(child: Text(v)),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            if (bull.photo != null)
              ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(bull.photo!, width: 72, height: 72, fit: BoxFit.cover))
            else
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: cs.errorContainer, borderRadius: BorderRadius.circular(14)),
                child: Padding(padding: const EdgeInsets.all(8), child: BullIcon(color: cs.onErrorContainer)),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${bull.time} h', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: cs.primary, fontWeight: FontWeight.w800)),
                Text(bull.name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                Text(bull.ranch, style: Theme.of(context).textTheme.bodyMedium),
              ]),
            ),
          ]),
          const SizedBox(height: 8),
          _row(context, tr(l, 'bull_number'), 'N.º ${bull.number}'),
          _row(context, tr(l, 'bull_coat'), bull.coat.of(l)),
          _row(context, tr(l, 'bull_exit'), bull.exit.of(l)),
          _row(context, tr(l, 'bull_embolada'), bull.embolada.of(l)),
          _row(context, tr(l, 'bull_sponsor'), bull.sponsor),
        ]),
      ),
    );
  }
}
