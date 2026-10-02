import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../data/app_state.dart';
import '../i18n.dart';
import '../widgets/common.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final l = state.lang;
        final ed = state.edition;
        return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
          FestaHeader(title: tr(l, 'info'), subtitle: '${ed.year}'),
          SectionTitle(tr(l, 'language')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'ca', label: Text('Valencià')),
                ButtonSegment(value: 'es', label: Text('Castellano')),
              ],
              selected: {l},
              onSelectionChanged: (v) => state.setLang(v.first),
            ),
          ),
          SectionTitle(tr(l, 'emergency')),
          for (final e in ed.emergency)
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(e.name.of(l)),
              subtitle: Text(e.phone),
              trailing: TextButton(onPressed: () => launchUrl(Uri.parse('tel:${e.phone}')), child: Text(tr(l, 'call'))),
            ),
          for (final i in ed.info) ...[
            SectionTitle(i.title.of(l)),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text(i.body.of(l))),
          ],
          if (kContactEmail.isNotEmpty) ...[
            SectionTitle(tr(l, 'contact')),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(tr(l, 'contact_body')),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () => launchUrl(Uri(scheme: 'mailto', path: kContactEmail, queryParameters: {'subject': kContactSubject})),
                  icon: const Icon(Icons.mail_outline),
                  label: Text(tr(l, 'contact_btn')),
                ),
              ]),
            ),
          ],
          SectionTitle(tr(l, 'about')),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tr(l, 'about_body')),
              const SizedBox(height: 8),
              Text(tr(l, 'source'), style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text(tr(l, 'unofficial'), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              if (kAuthorName.isNotEmpty) Text('${tr(l, 'made_by')} $kAuthorName', style: Theme.of(context).textTheme.bodySmall),
              Text('v1.0 · edició ${ed.year} (${ed.version})', style: Theme.of(context).textTheme.bodySmall),
            ]),
          ),
        ]);
      },
    );
  }
}
