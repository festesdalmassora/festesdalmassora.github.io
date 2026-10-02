import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../i18n.dart';
import '../models/edition.dart';
import '../widgets/common.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key, required this.state});
  final AppState state;

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime? _day;
  String? _cat; // null = tots
  bool _onlyFav = false;
  String _query = '';

  DateTime _initialDay(Edition ed) {
    final days = ed.festDays;
    final n = DateTime.now();
    final today = DateTime(n.year, n.month, n.day);
    if (days.contains(today)) return today;
    return days.firstWhere((d) => d.isAfter(today), orElse: () => days.last);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    return ListenableBuilder(
      listenable: s,
      builder: (context, _) {
        final l = s.lang;
        final ed = s.edition;
        final days = ed.festDays;
        final day = _day ?? _initialDay(ed);
        final searching = _query.trim().isNotEmpty;
        Iterable<Event> events = searching || _onlyFav ? ed.events : ed.eventsOn(day);
        if (_onlyFav) events = events.where((e) => s.isFavorite(e.id));
        if (_cat != null) events = events.where((e) => e.cat == _cat);
        if (searching) {
          final q = _query.trim().toLowerCase();
          events = events.where((e) =>
              e.title.of(l).toLowerCase().contains(q) ||
              e.desc.of(l).toLowerCase().contains(q) ||
              (ed.places[e.placeId]?.name.of(l).toLowerCase().contains(q) ?? false));
        }
        final list = events.toList();

        return Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: SearchBar(
              hintText: tr(l, 'search'),
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          SizedBox(
            height: 76,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: days.length,
              itemBuilder: (_, i) {
                final d = days[i];
                final sel = d == day && !searching && !_onlyFav;
                final cs = Theme.of(context).colorScheme;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => setState(() {
                      _day = d;
                      _onlyFav = false;
                    }),
                    child: Container(
                      width: 56,
                      decoration: BoxDecoration(
                        color: sel ? cs.primary : cs.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(weekday(l, d, short: true), style: TextStyle(fontSize: 12, color: sel ? cs.onPrimary : cs.onSurfaceVariant)),
                        Text('${d.day}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: sel ? cs.onPrimary : cs.onSurface)),
                      ]),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    avatar: const Icon(Icons.star, size: 16),
                    label: Text(tr(l, 'favorites')),
                    selected: _onlyFav,
                    onSelected: (v) => setState(() => _onlyFav = v),
                  ),
                ),
                for (final c in ed.categories.entries)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      avatar: Icon(kCatIcons[c.key], size: 16, color: catColor(c.key, Theme.of(context).colorScheme)),
                      label: Text(c.value.of(l)),
                      selected: _cat == c.key,
                      onSelected: (v) => setState(() => _cat = v ? c.key : null),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? Center(child: Text(_onlyFav ? tr(l, 'no_favorites') : tr(l, 'no_events')))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 16),
                    itemCount: list.length,
                    itemBuilder: (_, i) => EventTile(state: s, event: list[i], showDay: searching || _onlyFav),
                  ),
          ),
        ]);
      },
    );
  }
}
