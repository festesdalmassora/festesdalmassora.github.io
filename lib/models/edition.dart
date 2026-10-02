/// Text bilingüe { "ca": ..., "es": ... }.
class L10n {
  final String ca;
  final String es;
  const L10n(this.ca, this.es);

  factory L10n.from(dynamic j) {
    if (j == null) return const L10n('', '');
    final m = j as Map<String, dynamic>;
    return L10n(m['ca'] as String? ?? '', m['es'] as String? ?? m['ca'] as String? ?? '');
  }

  String of(String lang) => lang == 'es' ? es : ca;
  bool get isEmpty => ca.isEmpty && es.isEmpty;
}

class Place {
  final String id;
  final L10n name;
  final String query;
  Place(this.id, this.name, this.query);

  factory Place.from(String id, Map<String, dynamic> j) =>
      Place(id, L10n.from(j), j['query'] as String? ?? '');

  Uri get mapsUri =>
      Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': query});
}

class Event {
  final String id;
  final DateTime day; // només data
  final String time; // "HH:mm" (24:00 = mitjanit)
  final String cat;
  final String placeId;
  final L10n title;
  final L10n desc;

  Event({
    required this.id,
    required this.day,
    required this.time,
    required this.cat,
    required this.placeId,
    required this.title,
    required this.desc,
  });

  factory Event.from(Map<String, dynamic> j) => Event(
        id: j['id'] as String,
        day: DateTime.parse(j['date'] as String),
        time: j['time'] as String,
        cat: j['cat'] as String,
        placeId: j['place'] as String,
        title: L10n.from(j['title']),
        desc: L10n.from(j['desc']),
      );

  int get hour => int.parse(time.substring(0, 2));
  int get minute => int.parse(time.substring(3, 5));

  /// Els actes de matinada (00:00–05:59) pertanyen al dia festiu anterior.
  DateTime get start {
    final extra = hour < 6 || hour >= 24 ? 1 : 0;
    return DateTime(day.year, day.month, day.day + extra, hour % 24, minute);
  }

  /// Clau per a ordenar dins del dia festiu.
  int get sortKey => (hour < 6 ? hour + 24 : hour) * 60 + minute;

  String get displayTime => hour >= 24 ? '00:${time.substring(3)}' : time;
}

class Person {
  final String id;
  final L10n role;
  final String name;
  final String? photo;
  Person(this.id, this.role, this.name, this.photo);

  factory Person.from(Map<String, dynamic> j) =>
      Person(j['id'] as String, L10n.from(j['role']), j['name'] as String, j['photo'] as String?);

  String get initials {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    return (parts.first[0] + (parts.length > 1 ? parts[1][0] : '')).toUpperCase();
  }
}

class Bull {
  final DateTime day;
  final String time;
  final int number;
  final String name;
  final L10n coat;
  final String ranch;
  final L10n exit;
  final L10n embolada;
  final String sponsor;
  final String? photo;

  Bull({
    required this.day,
    required this.time,
    required this.number,
    required this.name,
    required this.coat,
    required this.ranch,
    required this.exit,
    required this.embolada,
    required this.sponsor,
    required this.photo,
  });

  factory Bull.from(Map<String, dynamic> j) => Bull(
        day: DateTime.parse(j['date'] as String),
        time: j['time'] as String,
        number: j['number'] as int,
        name: j['name'] as String,
        coat: L10n.from(j['coat']),
        ranch: j['ranch'] as String,
        exit: L10n.from(j['exit']),
        embolada: L10n.from(j['embolada']),
        sponsor: j['sponsor'] as String,
        photo: j['photo'] as String?,
      );
}

class Cows {
  final DateTime day;
  final String time;
  final String ranch;
  Cows(this.day, this.time, this.ranch);

  factory Cows.from(Map<String, dynamic> j) =>
      Cows(DateTime.parse(j['date'] as String), j['time'] as String, j['ranch'] as String);
}

class Trophy {
  final L10n name;
  final String sponsor;
  Trophy(this.name, this.sponsor);
  factory Trophy.from(Map<String, dynamic> j) => Trophy(L10n.from(j['name']), j['sponsor'] as String);
}

class InfoItem {
  final L10n title;
  final L10n body;
  InfoItem(this.title, this.body);
  factory InfoItem.from(Map<String, dynamic> j) => InfoItem(L10n.from(j['title']), L10n.from(j['body']));
}

class Emergency {
  final L10n name;
  final String phone;
  Emergency(this.name, this.phone);
  factory Emergency.from(Map<String, dynamic> j) => Emergency(L10n.from(j['name']), j['phone'] as String);
}

class Edition {
  final int year;
  final int version;
  final L10n title;
  final String town;
  final DateTime start;
  final DateTime end;
  final int seedColor;
  final Map<String, L10n> categories;
  final Map<String, Place> places;
  final List<Event> events;
  final List<Person> court;
  final List<Bull> bulls;
  final List<Cows> cows;
  final List<Trophy> trophies;
  final List<InfoItem> info;
  final List<Emergency> emergency;

  Edition({
    required this.year,
    required this.version,
    required this.title,
    required this.town,
    required this.start,
    required this.end,
    required this.seedColor,
    required this.categories,
    required this.places,
    required this.events,
    required this.court,
    required this.bulls,
    required this.cows,
    required this.trophies,
    required this.info,
    required this.emergency,
  });

  factory Edition.from(Map<String, dynamic> j) {
    final dates = j['dates'] as Map<String, dynamic>;
    final events = (j['events'] as List).map((e) => Event.from(e as Map<String, dynamic>)).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    return Edition(
      year: j['year'] as int,
      version: j['version'] as int,
      title: L10n.from(j['title']),
      town: j['town'] as String,
      start: DateTime.parse(dates['start'] as String),
      end: DateTime.parse(dates['end'] as String),
      seedColor: int.parse((j['seedColor'] as String).substring(1), radix: 16) | 0xFF000000,
      categories: (j['categories'] as Map<String, dynamic>).map((k, v) => MapEntry(k, L10n.from(v))),
      places: (j['places'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, Place.from(k, v as Map<String, dynamic>))),
      events: events,
      court: (j['court'] as List).map((e) => Person.from(e as Map<String, dynamic>)).toList(),
      bulls: (j['bulls'] as List).map((e) => Bull.from(e as Map<String, dynamic>)).toList(),
      cows: (j['cows'] as List).map((e) => Cows.from(e as Map<String, dynamic>)).toList(),
      trophies: (j['trophies'] as List).map((e) => Trophy.from(e as Map<String, dynamic>)).toList(),
      info: (j['info'] as List).map((e) => InfoItem.from(e as Map<String, dynamic>)).toList(),
      emergency: (j['emergency'] as List).map((e) => Emergency.from(e as Map<String, dynamic>)).toList(),
    );
  }

  /// Dies que tenen algun acte, ordenats.
  List<DateTime> get festDays => (events.map((e) => e.day).toSet().toList()..sort());

  List<Event> eventsOn(DateTime day) {
    final l = events.where((e) => e.day == day).toList()..sort((a, b) => a.sortKey.compareTo(b.sortKey));
    return l;
  }
}
