import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app_state.dart';
import '../i18n.dart';
import '../models/edition.dart';
import 'bull_icon.dart';

const Map<String, IconData> kCatIcons = {
  'bous': Icons.sports_martial_arts,
  'religios': Icons.church,
  'musica': Icons.music_note,
  'infantil': Icons.child_care,
  'penyes': Icons.groups,
  'majors': Icons.elderly,
  'cultura': Icons.palette,
  'festa': Icons.celebration,
  'focs': Icons.auto_awesome,
};

/// Icona d'una categoria (el bou usa la silueta pròpia).
Widget catIcon(String cat, {double? size, Color? color}) {
  if (cat == 'bous') return BullIcon(size: size, color: color);
  return Icon(kCatIcons[cat] ?? Icons.circle, size: size, color: color);
}

Color catColor(String cat, ColorScheme cs) {
  switch (cat) {
    case 'bous':
      return const Color(0xFFD7263D);
    case 'religios':
      return const Color(0xFF6C5CE7);
    case 'musica':
      return const Color(0xFFF08A24);
    case 'infantil':
      return const Color(0xFF1FA2B8);
    case 'penyes':
      return const Color(0xFF3F6FD8);
    case 'majors':
      return const Color(0xFF8E6E53);
    case 'cultura':
      return const Color(0xFFC2459C);
    case 'focs':
      return const Color(0xFFE0A100);
    default:
      return cs.primary;
  }
}

class EventTile extends StatelessWidget {
  const EventTile({super.key, required this.state, required this.event, this.showDay = false});
  final AppState state;
  final Event event;
  final bool showDay;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l = state.lang;
    final place = state.edition.places[event.placeId];
    final fav = state.isFavorite(event.id);
    final color = catColor(event.cat, cs);
    return Card(
      color: cs.surfaceContainerLow,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => showEventDetail(context, state, event),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Column(children: [
              Text(event.displayTime, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: color)),
              const SizedBox(height: 4),
              catIcon(event.cat, size: 18, color: color),
            ]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (showDay)
                  Text(longDate(l, event.day), style: Theme.of(context).textTheme.labelSmall?.copyWith(color: cs.outline)),
                Text(event.title.of(l), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                if (place != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(children: [
                      Icon(Icons.place_outlined, size: 14, color: cs.outline),
                      const SizedBox(width: 2),
                      Flexible(child: Text(place.name.of(l), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline))),
                    ]),
                  ),
              ]),
            ),
            IconButton(
              tooltip: tr(l, 'favorites'),
              icon: Icon(fav ? Icons.star : Icons.star_border, color: fav ? const Color(0xFFF5A623) : cs.outline),
              onPressed: () => state.toggleFavorite(event.id),
            ),
          ]),
        ),
      ),
    );
  }
}

void showEventDetail(BuildContext context, AppState state, Event e) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => ListenableBuilder(
      listenable: state,
      builder: (ctx, _) {
        final l = state.lang;
        final cs = Theme.of(ctx).colorScheme;
        final place = state.edition.places[e.placeId];
        final cat = state.edition.categories[e.cat];
        final fav = state.isFavorite(e.id);
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Wrap(spacing: 8, children: [
                Chip(
                  avatar: catIcon(e.cat, size: 16, color: catColor(e.cat, cs)),
                  label: Text(cat?.of(l) ?? e.cat),
                  visualDensity: VisualDensity.compact,
                ),
              ]),
              Text(e.title.of(l), style: Theme.of(ctx).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Row(children: [
                const Icon(Icons.schedule, size: 18),
                const SizedBox(width: 6),
                Text('${longDate(l, e.day)} · ${e.displayTime}', style: Theme.of(ctx).textTheme.titleMedium),
              ]),
              if (place != null) ...[
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.place, size: 18),
                  const SizedBox(width: 6),
                  Expanded(child: Text(place.name.of(l), style: Theme.of(ctx).textTheme.titleMedium)),
                ]),
              ],
              if (!e.desc.isEmpty) ...[
                const SizedBox(height: 12),
                Text(e.desc.of(l), style: Theme.of(ctx).textTheme.bodyLarge),
              ],
              const SizedBox(height: 16),
              Wrap(spacing: 8, runSpacing: 8, children: [
                FilledButton.tonalIcon(
                  onPressed: () => state.toggleFavorite(e.id),
                  icon: Icon(fav ? Icons.star : Icons.star_border),
                  label: Text(tr(l, 'favorites')),
                ),
                if (place != null)
                  FilledButton.icon(
                    onPressed: () => launchUrl(place.mapsUri, mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.directions),
                    label: Text(tr(l, 'how_to_get')),
                  ),
              ]),
            ]),
          ),
        );
      },
    ),
  );
}

/// Capçalera gràfica pròpia (substitueix la portada fins a tindre permís).
class FestaHeader extends StatelessWidget {
  const FestaHeader({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B6B43), Color(0xFF2E9E5B), Color(0xFF9CCC4F)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('ALMASSORA', style: TextStyle(color: Colors.white, letterSpacing: 4, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 30, height: 1.1, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text(subtitle, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
      );
}
