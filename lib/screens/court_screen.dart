import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../i18n.dart';
import '../models/edition.dart';
import '../widgets/common.dart';

class CourtScreen extends StatelessWidget {
  const CourtScreen({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final l = state.lang;
        final court = state.edition.court;
        final queen = court.first;
        final dames = court.skip(1).toList();
        return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
          FestaHeader(title: tr(l, 'court'), subtitle: '${state.edition.year}'),
          const SizedBox(height: 16),
          _QueenCard(person: queen, l: l),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.95,
              children: [for (final d in dames) _PersonCard(person: d, l: l)],
            ),
          ),
        ]);
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.person, required this.radius});
  final Person person;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    if (person.photo != null) {
      return CircleAvatar(radius: radius, backgroundImage: NetworkImage(person.photo!));
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: cs.primaryContainer,
      child: Text(person.initials, style: TextStyle(fontSize: radius * 0.8, fontWeight: FontWeight.w800, color: cs.onPrimaryContainer)),
    );
  }
}

class _QueenCard extends StatelessWidget {
  const _QueenCard({required this.person, required this.l});
  final Person person;
  final String l;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.tertiaryContainer,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          _Avatar(person: person, radius: 56),
          const SizedBox(height: 12),
          Text(person.role.of(l).toUpperCase(), style: Theme.of(context).textTheme.labelLarge?.copyWith(letterSpacing: 2)),
          const SizedBox(height: 4),
          Text(person.name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        ]),
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  const _PersonCard({required this.person, required this.l});
  final Person person;
  final String l;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          _Avatar(person: person, radius: 38),
          const SizedBox(height: 10),
          Text(person.name, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
          Text(person.role.of(l), style: Theme.of(context).textTheme.bodySmall),
        ]),
      ),
    );
  }
}
