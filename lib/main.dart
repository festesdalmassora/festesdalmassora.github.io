import 'package:flutter/material.dart';

import 'data/app_state.dart';
import 'i18n.dart';
import 'screens/agenda_screen.dart';
import 'screens/bulls_screen.dart';
import 'screens/court_screen.dart';
import 'screens/home_screen.dart';
import 'screens/info_screen.dart';
import 'widgets/bull_icon.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.load();
  runApp(FestesApp(state: state));
  state.refreshRemote();
}

class FestesApp extends StatelessWidget {
  const FestesApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        ThemeData theme(Brightness b) => ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Color(state.edition.seedColor), brightness: b),
              appBarTheme: const AppBarTheme(centerTitle: false),
              cardTheme: CardThemeData(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            );
        return MaterialApp(
          title: tr(state.lang, 'app_title'),
          debugShowCheckedModeBanner: false,
          theme: theme(Brightness.light),
          darkTheme: theme(Brightness.dark),
          home: Shell(state: state),
        );
      },
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key, required this.state});
  final AppState state;

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    final l = s.lang;
    final pages = <Widget>[
      HomeScreen(state: s, onGoToProgram: () => _go(1), onGoToBulls: () => _go(3)),
      AgendaScreen(state: s),
      CourtScreen(state: s),
      BullsScreen(state: s),
      InfoScreen(state: s),
    ];
    return Scaffold(
      body: SafeArea(bottom: false, child: IndexedStack(index: _index, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _go,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.celebration_outlined), selectedIcon: const Icon(Icons.celebration), label: tr(l, 'home')),
          NavigationDestination(icon: const Icon(Icons.event_note_outlined), selectedIcon: const Icon(Icons.event_note), label: tr(l, 'program')),
          NavigationDestination(icon: const Icon(Icons.workspace_premium_outlined), selectedIcon: const Icon(Icons.workspace_premium), label: tr(l, 'court')),
          NavigationDestination(icon: const BullIcon(), selectedIcon: const BullIcon(), label: tr(l, 'bulls')),
          NavigationDestination(icon: const Icon(Icons.info_outline), selectedIcon: const Icon(Icons.info), label: tr(l, 'info')),
        ],
      ),
    );
  }
}
