/// Textos de la interfície (ca / es). El contingut de les festes ve de l'edició.
const _s = <String, Map<String, String>>{
  'app_title': {'ca': 'Festes del Roser', 'es': 'Fiestas del Roser'},
  'home': {'ca': 'Inici', 'es': 'Inicio'},
  'program': {'ca': 'Programa', 'es': 'Programa'},
  'court': {'ca': 'Reina i Cort', 'es': 'Reina y Corte'},
  'bulls': {'ca': 'Bous', 'es': 'Toros'},
  'info': {'ca': 'Info', 'es': 'Info'},
  'unofficial': {
    'ca': "App no oficial · no vinculada a l'Ajuntament d'Almassora",
    'es': 'App no oficial · no vinculada al Ayuntamiento de Almassora',
  },
  'now': {'ca': 'Ara mateix', 'es': 'Ahora mismo'},
  'next': {'ca': 'Pròxim acte', 'es': 'Próximo acto'},
  'countdown_days': {'ca': 'Falten {n} dies per a les festes', 'es': 'Faltan {n} días para las fiestas'},
  'fest_over': {'ca': 'Bones festes! Fins l\'any que ve', 'es': '¡Felices fiestas! Hasta el año que viene'},
  'today': {'ca': 'Hui', 'es': 'Hoy'},
  'all': {'ca': 'Tots', 'es': 'Todos'},
  'favorites': {'ca': 'Favorits', 'es': 'Favoritos'},
  'no_events': {'ca': 'No hi ha actes', 'es': 'No hay actos'},
  'no_favorites': {
    'ca': 'Marca amb ★ els actes que no et vols perdre',
    'es': 'Marca con ★ los actos que no te quieras perder',
  },
  'how_to_get': {'ca': 'Com arribar', 'es': 'Cómo llegar'},
  'share': {'ca': 'Compartir', 'es': 'Compartir'},
  'place': {'ca': 'Lloc', 'es': 'Lugar'},
  'search': {'ca': 'Cerca un acte…', 'es': 'Busca un acto…'},
  'queen': {'ca': 'Reina de les festes', 'es': 'Reina de las fiestas'},
  'cows_title': {'ca': 'Entrada i prova de vaques', 'es': 'Entrada y prueba de vacas'},
  'bull_ranch': {'ca': 'Ramaderia', 'es': 'Ganadería'},
  'bull_coat': {'ca': 'Capa', 'es': 'Capa'},
  'bull_number': {'ca': 'Número', 'es': 'Número'},
  'bull_exit': {'ca': 'Eixida', 'es': 'Salida'},
  'bull_embolada': {'ca': 'Embolada', 'es': 'Embolada'},
  'bull_sponsor': {'ca': 'Patrocina', 'es': 'Patrocina'},
  'trophies': {'ca': 'Trofeus', 'es': 'Trofeos'},
  'emergency': {'ca': 'Telèfons d\'emergència', 'es': 'Teléfonos de emergencia'},
  'language': {'ca': 'Idioma', 'es': 'Idioma'},
  'about': {'ca': "Sobre l'app", 'es': 'Sobre la app'},
  'about_body': {
    'ca': "Programa de les festes en honor a la Mare de Déu del Roser d'Almassora. Sense publicitat. Només estadístiques anònimes d'ús, sense galetes ni dades personals. Els horaris poden canviar: consulta sempre les indicacions de la Junta Local de Festes.",
    'es': 'Programa de las fiestas en honor a la Virgen del Rosario de Almassora. Sin publicidad. Solo estadísticas anónimas de uso, sin cookies ni datos personales. Los horarios pueden cambiar: consulte siempre las indicaciones de la Junta Local de Fiestas.',
  },
  'source': {
    'ca': 'Dades extretes del llibret de festes 2026.',
    'es': 'Datos extraídos del llibret de fiestas 2026.',
  },
  'contact': {'ca': 'Contacte', 'es': 'Contacto'},
  'contact_body': {
    'ca': 'Has trobat un error o tens un suggeriment? Escriu-nos.',
    'es': '¿Has encontrado un error o tienes una sugerencia? Escríbenos.',
  },
  'contact_btn': {'ca': 'Envia un correu', 'es': 'Enviar un correo'},
  'made_by': {'ca': 'Fet per', 'es': 'Hecho por'},
  'update_available': {'ca': "Hi ha una versió nova de l'app", 'es': 'Hay una versión nueva de la app'},
  'update_btn': {'ca': 'Descarrega', 'es': 'Descargar'},
  'call': {'ca': 'Telefona', 'es': 'Llamar'},
};

const _wdCa = ['Dilluns', 'Dimarts', 'Dimecres', 'Dijous', 'Divendres', 'Dissabte', 'Diumenge'];
const _wdEs = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
const _moCa = ['gener', 'febrer', 'març', 'abril', 'maig', 'juny', 'juliol', 'agost', 'setembre', 'octubre', 'novembre', 'desembre'];
const _moEs = ['enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];

String tr(String lang, String key, [Map<String, String>? args]) {
  var v = _s[key]?[lang] ?? key;
  args?.forEach((k, val) => v = v.replaceAll('{$k}', val));
  return v;
}

String weekday(String lang, DateTime d, {bool short = false}) {
  final n = (lang == 'es' ? _wdEs : _wdCa)[d.weekday - 1];
  return short ? n.substring(0, 3) : n;
}

String longDate(String lang, DateTime d) {
  final mo = (lang == 'es' ? _moEs : _moCa)[d.month - 1];
  final String de;
  if (lang == 'es') {
    de = ' de ';
  } else {
    de = RegExp('^[aeiou]').hasMatch(mo) ? " d'" : ' de ';
  }
  return '${weekday(lang, d)} ${d.day}$de$mo';
}
