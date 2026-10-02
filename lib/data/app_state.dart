import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/edition.dart';

/// URL pública de l'edició per a actualitzacions sense passar per les botigues.
/// Buida = només s'usa el contingut embegut. Exemple (GitHub Pages):
/// 'https://USUARI.github.io/festes-almassora/editions/2026/edition.json'
const String kRemoteEditionUrl = '';
const String kEditionAsset = 'assets/editions/2026/edition.json';
const String _kCacheKey = 'edition_cache';

class AppState extends ChangeNotifier {
  AppState._(this._prefs, this.edition, this.lang, this._favorites);

  final SharedPreferences _prefs;
  Edition edition;
  String lang; // 'ca' | 'es'
  final Set<String> _favorites;

  static Future<AppState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final embedded = Edition.from(jsonDecode(await rootBundle.loadString(kEditionAsset)) as Map<String, dynamic>);
    var edition = embedded;
    final cached = prefs.getString(_kCacheKey);
    if (cached != null) {
      try {
        final c = Edition.from(jsonDecode(cached) as Map<String, dynamic>);
        if (c.year == embedded.year && c.version > embedded.version) edition = c;
      } catch (_) {}
    }
    final lang = prefs.getString('lang') ?? 'ca';
    final favs = (prefs.getStringList('favorites') ?? <String>[]).toSet();
    return AppState._(prefs, edition, lang, favs);
  }

  /// Comprova si hi ha una versió més nova de l'edició (silenciós si falla).
  Future<void> refreshRemote() async {
    if (kRemoteEditionUrl.isEmpty) return;
    try {
      final r = await http.get(Uri.parse(kRemoteEditionUrl)).timeout(const Duration(seconds: 8));
      if (r.statusCode != 200) return;
      final body = utf8.decode(r.bodyBytes);
      final e = Edition.from(jsonDecode(body) as Map<String, dynamic>);
      if (e.version > edition.version || e.year != edition.year) {
        await _prefs.setString(_kCacheKey, body);
        edition = e;
        notifyListeners();
      }
    } catch (_) {}
  }

  void setLang(String l) {
    lang = l;
    _prefs.setString('lang', l);
    notifyListeners();
  }

  bool isFavorite(String id) => _favorites.contains(id);
  Set<String> get favorites => _favorites;

  void toggleFavorite(String id) {
    if (!_favorites.add(id)) _favorites.remove(id);
    _prefs.setStringList('favorites', _favorites.toList());
    notifyListeners();
  }
}
