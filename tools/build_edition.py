# -*- coding: utf-8 -*-
"""Genera assets/editions/<any>/edition.json a partir de les dades d'esta edició.

Per a una nova edició: copia este fitxer, canvia YEAR, DATES, PLACES, EVENTS,
COURT, BULLS i COWS, i executa:  python tools/build_edition.py
Els textos són { "ca": ..., "es": ... }. Les fotos (photo) queden a None fins
a tindre permís per a publicar-les.
"""
import json
import os

YEAR = 2026
VERSION = 1
OUT = os.path.join(os.path.dirname(__file__), '..', 'assets', 'editions', str(YEAR), 'edition.json')


def t(ca, es=None):
    return {'ca': ca, 'es': es if es is not None else ca}


PLACES = {
    'major': t('Plaça Major', 'Plaza Mayor'),
    'picaora': t('Plaça de la Picaora', 'Plaza de la Picaora'),
    'espanya': t("Plaça d'Espanya", 'Plaza España'),
    'molineta': t('Zona Latina · Plaça de la Molineta', 'Zona Latina · Plaza de la Molineta'),
    'recinte': t('Recinte Fester', 'Recinte Fester'),
    'cultura': t('Casa de la Cultura', 'Casa de la Cultura'),
    'residencia': t('Residència Municipal Vicente Vilar Morellà', 'Residencia Municipal Vicente Vilar Morellà'),
    'molas': t('Residència Maria Rosa Molas (c/ Darremur, 39)', 'Residencia Maria Rosa Molas (c/ Darremur, 39)'),
    'trinitat': t('c/ Trinitat', 'c/ Trinidad'),
    'leos': t('c/ Trinitat, 5 (pub Leos)', 'c/ Trinidad, 5 (pub Leos)'),
    'junta': t('Junta Local de Festes', 'Junta Local de Fiestas'),
    'sant_pere': t('Esplanada del c/ Sant Pere', 'Explanada del c/ San Pedro'),
    'caixa': t('CaixAlmassora', 'CaixAlmassora'),
    'llauradors': t('Saló dels Llauradors (CaixAlmassora)', 'Salón de los Labradores (CaixAlmassora)'),
    'espai_mercat': t('Espai Mercat', 'Espai Mercat'),
    'pere_cornell': t('Plaça de Pere Cornell', 'Plaza de Pere Cornell'),
    'botanic': t('Plaça del Botànic Calduch', 'Plaza del Botànic Calduch'),
    'victimes': t('Plaça Víctimes del Terrorisme', 'Plaza Víctimas del Terrorismo'),
    'piscina': t('Pàrquing de la piscina municipal', 'Aparcamiento de la piscina municipal'),
    'jaume': t('Monument al rei Jaume I', 'Monumento al rey Jaime I'),
    'sant_marc': t('c/ Sant Marc, 127', 'c/ San Marcos, 127'),
    'sant_marc_picaora': t('c/ Sant Marc (davant de la Picaora)', 'c/ San Marcos (delante de la Picaora)'),
    'sant_roc': t('c/ Sant Roc, s/n (casal del Caragol)', 'c/ San Roque, s/n (casal de El Caragol)'),
    'sant_roc31': t('c/ Sant Roc, 31', 'c/ San Roque, 31'),
    'cervantes': t('c/ Cervantes, 11', 'c/ Cervantes, 11'),
    'major19': t('c/ Major, 19 (penya El Barrilet)', 'c/ Mayor, 19 (peña El Barrilet)'),
    'major_carrer': t('c/ Major', 'c/ Mayor'),
    'dolors': t('c/ Virgen de los Dolores, 13', 'c/ Virgen de los Dolores, 13'),
    'cristofol': t('c/ Sant Cristòfol, 3', 'c/ San Cristóbal, 3'),
    'sant_joaquim': t('c/ Sant Joaquim, 72', 'c/ San Joaquín, 72'),
    'sant_agusti': t('c/ Sant Agustí, 12', 'c/ San Agustín, 12'),
    'sant_roc24': t('c/ Sant Roc, 24', 'c/ San Roque, 24'),
    'sant_marc_alcora': t("c/ Sant Marc (cantonada Santa Quitèria-l'Alcora)", 'c/ San Marcos (esquina Santa Quiteria-Alcora)'),
    'santa_quiteria': t('Paratge de Santa Quitèria', 'Paraje de Santa Quiteria'),
    'platja': t("Platja d'Almassora", 'Playa de Almassora'),
    'les_goles': t('Bar Les Goles', 'Bar Les Goles'),
    'esglesia': t('Parròquia de la Nativitat', 'Parroquia de la Natividad'),
    'calvari': t('Església del Santíssim Crist del Calvari', 'Iglesia del Stmo. Cristo del Calvario'),
    'vila': t('Per la Vila', 'Por la Vila'),
    'alzheimer': t("Unitat de Respir d'Alzheimer (Santa Quitèria)", 'Unidad de Respiro de Alzheimer (Santa Quiteria)'),
    'tasqueta': t("Plaça d'Espanya (Tasqueta del Mercat)", 'Plaza España (Tasqueta del Mercat)'),
}

# Cerca per a obrir en mapes (Google/Apple Maps); sense coordenades exactes.
MAP_QUERY = {
    'vila': 'Plaça Major, Almassora',
    'jaume': 'Plaça Major, Almassora',
    'molas': 'Carrer Darremur 39, Almassora',
    'sant_marc': 'Carrer Sant Marc 127, Almassora',
    'sant_marc_picaora': 'Plaça de la Picaora, Almassora',
    'sant_marc_alcora': 'Carrer Sant Marc, Almassora',
    'trinitat': 'Carrer de la Trinitat, Almassora',
    'leos': 'Carrer de la Trinitat 5, Almassora',
    'sant_roc': 'Carrer Sant Roc, Almassora',
    'sant_roc31': 'Carrer Sant Roc 31, Almassora',
    'sant_roc24': 'Carrer Sant Roc 24, Almassora',
    'cervantes': 'Carrer Cervantes 11, Almassora',
    'major19': 'Carrer Major 19, Almassora',
    'major_carrer': 'Carrer Major, Almassora',
    'dolors': 'Carrer Virgen de los Dolores 13, Almassora',
    'cristofol': 'Carrer Sant Cristòfol 3, Almassora',
    'sant_joaquim': 'Carrer Sant Joaquim 72, Almassora',
    'sant_agusti': 'Carrer Sant Agustí 12, Almassora',
    'sant_pere': 'Carrer Sant Pere, Almassora',
    'junta': 'Junta Local de Festes, Almassora',
    'tasqueta': "Plaça d'Espanya, Almassora",
    'santa_quiteria': 'Ermita Santa Quitèria, Almassora',
    'platja': "Platja d'Almassora",
    'esglesia': 'Parròquia de la Nativitat, Almassora',
    'calvari': 'Església del Santíssim Crist del Calvari, Almassora',
    'piscina': 'Piscina municipal, Almassora',
    'alzheimer': 'Ermita Santa Quitèria, Almassora',
    'recinte': 'Recinte Fester, Almassora',
}
for _k, _v in PLACES.items():
    _v['query'] = MAP_QUERY.get(_k, _v['ca'] + ', Almassora')

DATES = [
    '2026-10-02', '2026-10-03', '2026-10-04', '2026-10-05', '2026-10-06', '2026-10-07',
    '2026-10-08', '2026-10-09', '2026-10-10', '2026-10-11',
]

EVENTS = []


def ev(date, time, cat, place, ca, es, dca=None, des=None):
    EVENTS.append({
        'date': date, 'time': time, 'cat': cat, 'place': place,
        'title': t(ca, es),
        'desc': t(dca, des if des is not None else dca) if dca else None,
    })


D = lambda n: '2026-10-%02d' % n

# ---------- Penyes patrocinadores (de la programació taurina) ----------
P_SANT_ROC = "Sant Roc, K-nut, El Duro, El Desfase, La Priva, La Kolva, La Trama, La Treba, La Falkà, La Kalimba, El Demacre, La Juerga, La Trivà"
P_ROLLET = "El Rollet, La Fuga, La Travessa, L'Emboscà, L'Artiste, La Katrava, La Kurda, El Porrat, La Maraña, La Traskà, La Xascà, El Vaivén, L'Estampà, La Desídia, El Desmadrao"
P_VINT = "Els Vint, La Brusa, La Colla, Els Casats, L'Aberració, La Galbana, L'Estocà, La Tribu, Tots Tancats, La Kalaña, L'Embolic, El Deklive, El Descaro, La Tabarra, La Jarana, La Xabola"
P_PENJATS = "Els Penjats, El Barrilet, El Racó, T'Empujen, El Gavell, El Corb, Els Clafidors, San Fermín, Amigues del Bou, El Roser"
P_POLP = "El Polp, El Bocao, Gamusinos, La Jerga, La Tremba, La Kliba, La Kalatra, Bufa la Gamba, El Desdén, El Intento, La Strankà, La Trenkà, L'Avagelio, El Jolgorio, La Tolka, Joventut Taurina"


def reina(d, hora='17:00'):
    ev(d, hora, 'festa', 'cultura', 'Eixida de la reina i les dames des de la Casa de la Cultura',
       'Salida de la reina y las damas desde la Casa de la Cultura',
       'Acompanyades per les penyes i colles, es dirigixen a la Vila.',
       'Acompañadas por las peñas y collas, se dirigen a la Vila.')


def cremaet(d, hora='22:30'):
    ev(d, hora, 'festa', 'junta', 'Repartiment de cremaet (majors de 18 anys)',
       'Reparto de cremaet (mayores de 18 años)')


def conc_cultura(d, hora='23:00'):
    ev(d, hora, 'festa', 'cultura', 'Concentració de penyes i colles a la Casa de la Cultura',
       'Concentración de peñas y collas en la Casa de la Cultura',
       'Es trasllada a la Vila amb la xaranga Banana Boom.',
       'Traslado a la Vila con la charanga Banana Boom.')


def vaques(d, ca_gan, es_gan=None, hora='13:00'):
    ev(d, hora, 'bous', 'trinitat', 'Entrada de vaques · ' + ca_gan, 'Entrada de vacas · ' + (es_gan or ca_gan),
       'Pels carrers de Sant Marc, Santa Quitèria-l\'Alcora i Trinitat, i prova per la Vila.',
       'Por las calles San Marcos, Santa Quiteria-Alcora y Trinidad, y prueba por la Vila.')


def casal_vi(d, hora, qui_ca, qui_es=None, place='espanya'):
    ev(d, hora, 'musica', 'espanya', 'Casal del Vi · ' + qui_ca, 'Mesón del Vino · ' + (qui_es or qui_ca))


def concentracio(d, hora, penyes):
    ev(d, hora, 'penyes', 'trinitat', 'Concentració de penyes i colles al c/ Trinitat',
       'Concentración de peñas y collas en la c/ Trinidad',
       penyes + '. A continuació, cercavila amb la xaranga Banana Boom.',
       penyes + '. A continuación, pasacalle con la charanga Banana Boom.')


def bous_vila(d, hora, penyes):
    ev(d, hora, 'bous', 'major', 'Bous per la Vila', 'Bous per la Vila',
       'Penyes i colles: ' + penyes + '. Eixides des de la plaça Major.',
       'Peñas y collas: ' + penyes + '. Salidas desde la plaza Mayor.')


def embolats(d, hora, penyes, place='major'):
    ev(d, hora, 'bous', place, 'Bous embolats', '«Bous embolats»',
       'Penyes i colles: ' + penyes + '.', 'Peñas y collas: ' + penyes + '.')


def infantil(d, qui, place='espanya', hora='18:30'):
    ev(d, hora, 'infantil', place, 'Activitats infantils · ' + qui, 'Actividades infantiles · ' + qui)


# ===== Divendres 2 =====
d = D(2)
ev(d, '17:30', 'majors', 'residencia', 'Actuació de Raquel López Soler (XXV aniversari de la Residència)',
   'Actuación de Raquel López Soler (XXV aniversario de la Residencia)')
ev(d, '19:00', 'religios', 'calvari', 'Novena a la Mare de Déu del Roser', 'Novena a la Virgen del Rosario')
ev(d, '19:00', 'cultura', 'llauradors', 'Inauguració de l\'exposició de labors', 'Inauguración de la exposición de labores',
   'A càrrec de l\'Associació d\'Ames de Casa d\'Almassora.', 'A cargo de la Asociación de Amas de Casa de Almassora.')
ev(d, '19:00', 'musica', 'sant_roc24', 'Tardeo amb Fabian Sánchez (penya Bufa la Gamba)',
   'Tardeo con Fabian Sánchez (peña Bufa la Gamba)')
ev(d, '19:30', 'cultura', 'caixa', 'Exposició de pintura «El alma sobre lienzo»', 'Exposición de pintura «El alma sobre lienzo»',
   'De Santiago Tena Climent. Fins al 15 d\'octubre. Horari: dl-dv 18.30-21.00 h; ds i festius 11.30-13.30 i 18.30-21.00 h; dg tancat.',
   'De Santiago Tena Climent. Hasta el 15 de octubre. Horario: L-V 18.30-21.00 h; sáb y festivos 11.30-13.30 y 18.30-21.00 h; dom cerrado.')
ev(d, '20:00', 'cultura', 'espai_mercat', 'Exposició «Cuatro mujeres, cuatro miradas»', 'Exposición «Cuatro mujeres, cuatro miradas»',
   'Anna N., Mayeska, Chus Comellas i Maria Griñó. Del 2 al 18 d\'octubre.', 'Anna N., Mayeska, Chus Comellas y Maria Griñó. Del 2 al 18 de octubre.')
ev(d, '20:00', 'musica', 'espanya', 'Inauguració del Casal del Vi · Ruta festera dels 90\'s',
   'Inauguración del Mesón del Vino · Ruta festera de los 90\'s')
ev(d, '21:30', 'festa', 'sant_marc_alcora', 'Sopar de pa i porta amb el duo Almazahara', 'Cena de pa i porta con el dúo Almazahara',
   'Organitza: ACT La Picaora. Col·labora: Ajuntament d\'Almassora.', 'Organiza: ACT La Picaora. Colabora: Ayuntamiento de Almassora.')
ev(d, '22:00', 'festa', 'molineta', 'Inauguració de la Zona Latina', 'Inauguración de la Zona Latina',
   'Amb mariachis i DJ en directe.', 'Con mariachis y DJ en directo.')
ev(d, '24:00', 'focs', 'major', 'ESCLAT DE FESTA · Inici de les festes', '¡CHUPINAZO! · Inicio de las fiestas',
   'Esclat de festa d\'inici de les festes de la Mare de Déu del Roser.', 'Chupinazo de inicio de las fiestas de la Virgen del Rosario.')
ev(d, '24:30', 'penyes', 'major19', 'DJ Font (penya El Barrilet)', 'DJ Font (peña El Barrilet)',
   'Per al seu 45 aniversari.', 'Por su 45 aniversario.')
ev(d, '24:30', 'penyes', 'dolors', 'Desde Dentro (penya El Corb · 50 aniversari)', 'Desde Dentro (peña El Corb · 50 aniversario)')
ev(d, '03:00', 'musica', 'recinte', 'Inauguració del Recinte Fester', 'Inauguración del Recinte Fester',
   'Amb DJ Monty i DJ Clare Apir.', 'Con DJ Monty y DJ Clare Apir.')

# ===== Dissabte 3 =====
d = D(3)
ev(d, '11:00', 'penyes', 'trinitat', 'Concentració de la penya Gent del Bou', 'Concentración de la peña Gent del Bou',
   'Al c/ Trinitat. A continuació, cercavila amb la xaranga Banana Boom.', 'En la c/ Trinidad. A continuación, pasacalle con la charanga Banana Boom.')
ev(d, '11:00', 'musica', 'cristofol', 'Tret d\'eixida a la colla El Perico · Cote_Beat', 'Pistoletazo de salida en la colla El Perico · Cote_Beat',
   'Música electrònica al carrer.', 'Música electrónica en la calle.')
vaques(d, 'Fernando Mansilla')
reina(d)
ev(d, '18:00', 'bous', 'major', 'Bous per la Vila · Ajuntament i Gent del Bou', 'Bous per la Vila · Ayuntamiento y Gent del Bou',
   'Eixides des de la plaça Major.', 'Salidas desde la plaza Mayor.')
infantil(d, 'Sagals')
ev(d, '18:30', 'musica', 'sant_roc', 'Remember amb DJ Javi Blasco', 'Remember con DJ Javi Blasco')
ev(d, '18:30', 'musica', 'sant_marc', "Tardeo L'Alcria Rock · Herbasana", "Tardeo L'Alcria Rock · Herbasana")
ev(d, '19:00', 'religios', 'calvari', 'Novena a la Mare de Déu del Roser', 'Novena a la Virgen del Rosario')
ev(d, '19:00', 'musica', 'cervantes', 'Tardeo amb Quimbala (penya La Kliba)', 'Tardeo con Quimbala (peña La Kliba)')
ev(d, '19:30', 'infantil', 'major_carrer', 'Entrada infantil de carretons', 'Entrada infantil de carretones', 'Patrocina: Junta Local de Festes.', 'Patrocina: Junta Local de Fiestas.')
ev(d, '19:30', 'musica', 'leos', 'El Showman del Serrucho (penya Gent del Bou)', 'El Showman del Serrucho (peña Gent del Bou)')
ev(d, '19:30', 'musica', 'sant_roc31', 'Tardeo amb Benicai (penya La Strankà · X aniversari)', 'Tardeo con Benicai (peña La Strankà · X aniversario)')
casal_vi(d, '20:00', 'Patxi Ojana')
ev(d, '20:30', 'musica', 'sant_marc', "Tardeo L'Alcria Rock · N'Rockats", "Tardeo L'Alcria Rock · N'Rockats")
ev(d, '21:00', 'festa', 'espanya', 'Truita monumental', 'Tortilla monumental', 'Patrocina: Cajamar.', 'Patrocina: Cajamar.')
ev(d, '21:00', 'musica', 'molineta', 'Artistes convidats especials a la Zona Latina', 'Artistas invitados especiales en la Zona Latina')
ev(d, '22:00', 'musica', 'molineta', 'DJ en directe a la Zona Latina', 'DJ en directo en la Zona Latina')
cremaet(d)
conc_cultura(d)
ev(d, '23:30', 'bous', 'picaora', "Bous embolats · Ajuntament i Gent del Bou", "«Bous embolats» · Ayuntamiento y Gent del Bou",
   "Bou de l'Ajuntament amb eixida de la plaça de la Picaora i el de la penya Gent del Bou amb eixida des de la plaça Major.",
   "Toro del Ayuntamiento con salida desde la plaza de la Picaora y el de la peña Gent del Bou con salida desde la plaza Mayor.")
ev(d, '24:00', 'musica', 'espanya', 'Mojinos Escozíos', 'Mojinos Escozíos', 'Concert a la plaça d\'Espanya.', 'Concierto en la plaza España.')
ev(d, '01:30', 'musica', 'major19', 'Tech house amb DJ Ximo Pacheco (penya La Kliba)', 'Tech house con DJ Ximo Pacheco (peña La Kliba)')
ev(d, '03:00', 'musica', 'recinte', 'Recinte Fester · Roberto Anglès, DJ Alenn i Diego Marza', 'Recinte Fester · Roberto Anglès, DJ Alenn y Diego Marza')

# ===== Diumenge 4 =====
d = D(4)
ev(d, '08:30', 'religios', 'esglesia', 'Volteig general de campanes', 'Volteo general de campanas',
   'Anunciant la festivitat de la Mare de Déu del Roser.', 'Anunciando la festividad de la Virgen del Rosario.')
ev(d, '10:30', 'religios', 'espanya', 'Ofrena a la Mare de Déu del Roser', 'Ofrenda a la Virgen del Rosario',
   'Concentració a la plaça d\'Espanya i ofrena des de l\'església del Crist del Calvari fins a la parròquia de la Nativitat.',
   'Concentración en la plaza de España y ofrenda desde la iglesia del Cristo del Calvario hasta la parroquia de la Natividad.')
ev(d, '18:00', 'musica', 'molineta', 'Gran Festival Folklòric', 'Gran Festival Folclórico',
   'Una jornada dedicada a les nostres arrels i tradicions amb música i dansa.', 'Una jornada dedicada a nuestras raíces y tradiciones con música y danza.')
infantil(d, 'Imagine')
ev(d, '19:00', 'religios', 'esglesia', 'Missa solemne i processó', 'Misa solemne y procesión',
   'Presidida per Juan Ángel Tapiador Navas, amb la reina i les dames, el clergat i les autoritats. En finalitzar, gran traca amb rematada final de focs artificials.',
   'Presidida por Juan Ángel Tapiador Navas, con la reina y las damas, el clero y las autoridades. Al finalizar, gran traca con remate final de fuegos artificiales.')
casal_vi(d, '20:00', 'Los Resilientes')

# ===== Dilluns 5 =====
d = D(5)
ev(d, '10:00', 'cultura', 'residencia', 'Visita de la reina i les dames a la Residència',
   'Visita de la reina y las damas a la Residencia',
   'Signatura del conveni de la partida Vila-Roja i inauguració de l\'exposició «Més que arbres i rostres», amb la xaranga Banana Boom.',
   'Firma del convenio de la partida Vila-Roja e inauguración de la exposición «Més que arbres i rostres», con la charanga Banana Boom.')
concentracio(d, '11:00', 'Penyes ' + P_SANT_ROC + ' i ' + P_ROLLET)
vaques(d, 'Jaime Tárrega Lucas')
reina(d)
bous_vila(d, '18:00', P_SANT_ROC + ' · ' + P_ROLLET)
infantil(d, 'Jara Túria')
casal_vi(d, '20:00', 'Alejandro Díaz')
cremaet(d)
conc_cultura(d)
embolats(d, '23:30', 'Picaora: ' + P_ROLLET + ' · Plaça Major: ' + P_SANT_ROC, 'picaora')

# ===== Dimarts 6 =====
d = D(6)
ev(d, '11:00', 'majors', 'residencia', 'Matí de copla espanyola amb Juanra Castillo', 'Mañana de copla española con Juanra Castillo')
concentracio(d, '11:00', 'Penyes Aficionats al Bou i El Comboi')
vaques(d, 'Hermanos Bellés')
reina(d)
bous_vila(d, '18:00', 'Aficionats al Bou · El Comboi')
infantil(d, 'Splai Teatre')
ev(d, '19:00', 'musica', 'leos', 'Tardeo amb DJ Alfonso (penya Aficionats al Bou)', 'Tardeo con DJ Alfonso (peña Aficionats al Bou)')
casal_vi(d, '20:00', 'Rumba Sierra')
cremaet(d)
conc_cultura(d)
embolats(d, '23:30', 'El Comboi · Aficionats al Bou')

# ===== Dimecres 7 =====
d = D(7)
ev(d, '10:00', 'cultura', 'alzheimer', "Visita de la reina i les dames a la Unitat de Respir d'Alzheimer",
   'Visita de la reina y las damas a la Unidad de Respiro de Alzheimer', 'Amb la xaranga Banana Boom.', 'Con la charanga Banana Boom.')
ev(d, '11:00', 'majors', 'residencia', 'Matí musical «Allà vas, cabàs» amb Pepe Falomir, Dori & Friends',
   'Mañana musical «Allà vas, cabàs» con Pepe Falomir, Dori & Friends')
concentracio(d, '11:00', 'Penyes ACT La Picaora, El Jaleo, El Bureo i ' + P_VINT)
vaques(d, 'Vicente Benavent')
reina(d)
bous_vila(d, '18:00', 'Picaora: ACT La Picaora, El Jaleo, El Bureo · Plaça Major: ' + P_VINT)
infantil(d, 'Wanda', 'botanic')
ev(d, '19:00', 'majors', 'pere_cornell', 'Dia del Major · Tribut a Julio Iglesias', 'Día del Mayor · Tributo a Julio Iglesias',
   "Obertura de portes a les 18.15 h i berenar per als inscrits (empadronats a Almassora nascuts el 1966 o abans).",
   "Apertura de puertas a las 18.15 h y merienda para los inscritos (empadronados en Almassora nacidos en 1966 o antes).")
casal_vi(d, '20:30', 'Fabián Sánchez')
cremaet(d)
conc_cultura(d)
embolats(d, '23:30', 'Plaça Major: ' + P_VINT + ' · Picaora: ACT La Picaora, El Jaleo, El Bureo')

# ===== Dijous 8 =====
d = D(8)
ev(d, '10:00', 'cultura', 'molas', 'Visita de la reina i les dames a la Residència Maria Rosa Molas',
   'Visita de la reina y las damas a la Residencia Maria Rosa Molas', 'Amb la xaranga Banana Boom.', 'Con la charanga Banana Boom.')
ev(d, '11:00', 'festa', 'tasqueta', 'Gran Bingo Musical', 'Gran Bingo Musical', 'Patrocina: penya Amigues del Bou.', 'Patrocina: peña Amigues del Bou.')
ev(d, '11:00', 'majors', 'residencia', "Música per l'Eternitat · Elena Greandia", "Música per l'Eternitat · Elena Greandia",
   'Experiència de plena atenció.', 'Experiencia de atención plena.')
concentracio(d, '11:00', 'Penyes ' + P_PENJATS + ' i ' + P_POLP)
vaques(d, 'La Paloma')
ev(d, '13:30', 'penyes', 'major19', 'Cervesa i faves a gogó (penya El Barrilet)', 'Cerveza y fabes a gogó (peña El Barrilet)',
   'Per a tots els assistents. Patrocina: FORTEX360. Fins a les 14.30 h.', 'Para todos los asistentes. Patrocina: FORTEX360. Hasta las 14.30 h.')
reina(d)
bous_vila(d, '18:00', P_PENJATS + ' · ' + P_POLP)
infantil(d, 'Tic-Tac Animacions')
ev(d, '19:30', 'musica', 'leos', 'Tardeo amb Cuerda pa Rato (penya T\'Empujen · XX aniversari)', 'Tardeo con Cuerda pa Rato (peña T\'Empujen · XX aniversario)',
   'Col·labora: Pub Leos.', 'Colabora: Pub Leos.')
casal_vi(d, '20:00', 'Generación Z')
ev(d, '21:00', 'musica', 'molineta', 'Ball i fusió · Salsa en directe', 'Baile y fusión · Salsa en directo')
ev(d, '22:00', 'musica', 'molineta', 'DJ en directe a la Zona Latina', 'DJ en directo en la Zona Latina')
cremaet(d)
conc_cultura(d)
ev(d, '23:30', 'musica', 'leos', "Daniel MuBe (penya T'Empujen · XX aniversari)", "Daniel MuBe (peña T'Empujen · XX aniversario)")
embolats(d, '23:30', 'Plaça Major: ' + P_POLP + ' · ' + P_PENJATS)
ev(d, '03:00', 'musica', 'recinte', 'Festa Indalo · DJ Pixo i DJ Blanch', 'Fiesta Indalo · DJ Pixo y DJ Blanch')

# ===== Divendres 9 =====
d = D(9)
ev(d, '11:00', 'cultura', 'jaume', 'Ofrena floral al rei Jaume I', 'Ofrenda floral al rey Jaime I',
   "A continuació, ofrena al bust de Pere Cornell, Himne Regional (tenor Javier Bovea) i ball de l'Associació Cultural El Torrelló.",
   'A continuación, ofrenda al busto de Pere Cornell, Himno Regional (tenor Javier Bovea) y baile de la Associació Cultural El Torrelló.')
vaques(d, 'Hermanos Cali')
ev(d, '18:00', 'bous', 'vila', 'Vesprada de vaques · Vicente Benavent', 'Tarde de vacas · Vicente Benavent')
infantil(d, 'Superanimaciones', 'victimes')
ev(d, '19:00', 'penyes', 'sant_marc_picaora', 'Festa remember (penya El Corb · 50 aniversari)', 'Fiesta remember (peña El Corb · 50 aniversario)',
   'DJ Tonet Marzà, Paco Moliner, Jorge Killer i Juanvi Dimensión.', 'DJ Tonet Marzà, Paco Moliner, Jorge Killer y Juanvi Dimensión.')
ev(d, '19:30', 'festa', 'picaora', 'II Concurs de llançament de carretilla', 'II Concurso de lanzamiento de carretilla', 'Patrocina: penya El Jaleo.', 'Patrocina: peña El Jaleo.')
casal_vi(d, '20:00', 'El Show del Serrucho')
ev(d, '21:30', 'festa', 'espanya', 'Sopar de pa i porta amb orquestra-espectacle', 'Cena de pa i porta con orquesta-espectáculo',
   'Parc infantil per als més xicotets (Tic-Tac Animacions). Inscripcions fins al 2 d\'octubre a l\'Ajuntament.',
   'Parque infantil para los más pequeños (Tic-Tac Animacions). Inscripciones hasta el 2 de octubre en el Ayuntamiento.')
ev(d, '22:00', 'musica', 'molineta', 'DJ en directe a la Zona Latina', 'DJ en directo en la Zona Latina')
ev(d, '23:00', 'musica', 'molineta', 'Gran show de timbals', 'Gran show de timbales')
ev(d, '24:00', 'penyes', 'sant_joaquim', 'Remember anys 90 i 2000 (penya San Fermín)', 'Remember años 90 y 2000 (peña San Fermín)')
ev(d, '24:00', 'penyes', 'sant_agusti', 'Discomòbil (penya La Desidia)', 'Discomóvil (peña La Desidia)')
ev(d, '01:00', 'bous', 'vila', 'Vaques enfundades · Hermanos Bellés', 'Vacas enfundadas · Hermanos Bellés',
   'Amb animació, obstacles, música i locutor. Col·labora: ACT Penya Santa Quitèria.', 'Con animación, obstáculos, música y locutor. Colabora: ACT Peña Santa Quitèria.')
ev(d, '03:00', 'musica', 'recinte', 'Recinte Fester · DJ Alenn i Sergi Mora', 'Recinte Fester · DJ Alenn y Sergi Mora')

# ===== Dissabte 10 =====
d = D(10)
concentracio(d, '11:00', 'Penyes El Caragol, El Trasto i Aficionades Taurines')
vaques(d, 'Sergio Rúa')
reina(d)
bous_vila(d, '18:00', 'El Caragol · El Trasto · Aficionades Taurines')
infantil(d, 'Kim')
ev(d, '18:30', 'musica', 'sant_roc', 'Remember amb DJ Vicente Añó & Tonet Marzá', 'Remember con DJ Vicente Añó & Tonet Marzá')
ev(d, '19:00', 'musica', 'leos', 'Tardeo amb DJ Pixo (ACT Aficionades Taurines)', 'Tardeo con DJ Pixo (ACT Aficionades Taurines)')
ev(d, '19:30', 'bous', 'major_carrer', 'Transhumància urbana de ramat mestís', 'Trashumancia urbana de ganado mestizo',
   'Pel carrer Major. Patrocina: Associació de Penyes Taurines d\'Almassora.', 'Por la c/ Mayor. Patrocina: Associació de Penyes Taurines d\'Almassora.')
casal_vi(d, '20:00', 'A contracorriente (tribut a El Canto del Loco)', 'A contracorriente (tributo a El Canto del Loco)')
ev(d, '21:00', 'bous', 'trinitat', 'Tombet de bou', 'Tombet de bou', 'Patrocina: CaixAlmassora.', 'Patrocina: CaixAlmassora.')
ev(d, '22:00', 'musica', 'molineta', 'DJ en directe a la Zona Latina', 'DJ en directo en la Zona Latina')
cremaet(d)
ev(d, '23:00', 'musica', 'molineta', 'Gran Parradón Vallenato', 'Gran Parradón Vallenato')
conc_cultura(d)
embolats(d, '23:30', 'Aficionades Taurines · El Caragol · El Trasto')
ev(d, '24:00', 'musica', 'leos', 'Vudú (ACT Aficionades Taurines)', 'Vudú (ACT Aficionades Taurines)', 'Col·labora: Pub Leos.', 'Colabora: Pub Leos.')
ev(d, '24:00', 'musica', 'espanya', 'Tribut a El Barrio', 'Tributo a El Barrio')
ev(d, '01:00', 'musica', 'piscina', 'Orquestra espectacle de gran format', 'Orquesta espectáculo de gran formato')
ev(d, '03:00', 'musica', 'recinte', 'Recinte Fester · Diego Marza, DJ Monty i Roberto Anglès', 'Recinte Fester · Diego Marza, DJ Monty y Roberto Anglès')

# ===== Diumenge 11 =====
d = D(11)
ev(d, '07:00', 'festa', 'les_goles', 'Concurs Social de Pesca', 'Concurso Social de Pesca',
   'Concentració i inscripcions al Bar Les Goles a les 6.00 h. Lliurament de trofeus a les 14.00 h, a la platja.',
   'Concentración e inscripciones en el Bar Les Goles a las 6.00 h. Entrega de trofeos a las 14.00 h, en la playa.')
ev(d, '14:00', 'festa', 'molineta', 'Gran Sancochada Colombiana', 'Gran Sancochada Colombiana',
   'Dia d\'activitats recreatives per a tota la família.', 'Día de actividades recreativas para toda la familia.')
ev(d, '17:00', 'infantil', 'piscina', 'Dia del Xiquet (3 a 12 anys)', 'Día del Niño (3 a 12 años)',
   'Làser Combat, Monitors, Viunatura i berenar per als xiquets inscrits (inscripcions fins al 2 d\'octubre a l\'Ajuntament).',
   'Laser Combat, Monitors, Viunatura y merienda para los niños inscritos (inscripciones hasta el 2 de octubre en el Ayuntamiento).')
casal_vi(d, '20:00', 'Los Sueters')
ev(d, '23:00', 'focs', 'espanya', 'Actuació final de festes · Tribut a Alejandro Sanz', 'Actuación final de fiestas · Tributo a Alejandro Sanz',
   'A continuació, castell de focs artificials de fi de festes a l\'esplanada del c/ Sant Pere.',
   'A continuación, castillo de fuegos artificiales de fin de fiestas en la explanada del c/ San Pedro.')

# ===== Després de festes =====
ev(D(12), '12:00', 'religios', 'esglesia', 'Missa en honor a la Mare de Déu del Pilar', 'Misa en honor a la Virgen del Pilar', 'Patrona de la Guàrdia Civil.', 'Patrona de la Guardia Civil.')
ev(D(16), '19:00', 'cultura', 'cultura', 'Concert de l\'Orquestra de Cambra de la Societat Filharmònica de València', 'Concierto de la Orquesta de Cámara de la Sociedad Filarmónica de Valencia')
ev(D(16), '23:00', 'musica', 'recinte', 'Santi de Santiago', 'Santi de Santiago')
ev(D(18), '08:30', 'religios', 'esglesia', "Rosari de l'aurora · in memoriam Rosarito «la Llebra»", 'Rosario de la aurora · in memoriam Rosarito «la Llebra»',
   'Eixida des de la plaça de l\'església de la Nativitat. En finalitzar, xocolatada. Organitza: Lluïsos Almassora.',
   'Salida desde la plaza de la iglesia de la Natividad. Al finalizar, chocolatada. Organiza: Lluïsos Almassora.')
ev(D(23), '18:00', 'festa', 'recinte', 'Mistery Puzzle · Activitat benèfica AECC', 'Mistery Puzzle · Actividad benéfica AECC',
   'La recaptació es destinarà íntegrament a la lluita contra el càncer. Inscripcions: aepuzz.es', 'La recaudación se destinará íntegramente a la lucha contra el cáncer. Inscripciones: aepuzz.es')
ev(D(24), '09:30', 'musica', 'sant_pere', 'VII Fira Flamenca · Eixida de la romeria', 'VII Feria Flamenca · Salida de la romería')
ev(D(24), '10:00', 'festa', 'recinte', 'Concurs de puzzle individual', 'Concurso de puzzle individual', 'Categoria adulta i infantils de 100 i 200 peces.', 'Categoría adulta e infantiles de 100 y 200 piezas.')
ev(D(24), '10:30', 'festa', 'pere_cornell', 'Esmorzar dels romers', 'Almuerzo de los romeros')
ev(D(24), '11:00', 'festa', 'santa_quiteria', 'Continua la romeria cap a Santa Quitèria', 'Continúa la romería hacia Santa Quiteria')
ev(D(24), '12:30', 'festa', 'recinte', 'Puzzle Chess', 'Puzzle Chess')
ev(D(24), '13:00', 'musica', 'santa_quiteria', 'Cuerda pa rato (rumbes i sevillanes)', 'Cuerda pa rato (rumbas y sevillanas)')
ev(D(24), '16:00', 'musica', 'santa_quiteria', 'Tardeo amb Cuerda pa rato', 'Tardeo con Cuerda pa rato')
ev(D(24), '16:30', 'festa', 'recinte', 'Continuació de Puzzle Chess', 'Continuación de Puzzle Chess')
ev(D(24), '18:00', 'festa', 'recinte', 'Puzzle per parelles · Lliurament de premis', 'Puzzle por parejas · Entrega de premios')
ev(D(24), '19:30', 'festa', 'santa_quiteria', 'Tornada de la romeria cap al poble', 'Vuelta de la romería hacia el pueblo')
ev(D(25), '10:00', 'festa', 'recinte', 'Concurs de puzzle per equips', 'Concurso de puzzle por equipos', 'Activitat benèfica a favor de l\'AECC.', 'Actividad benéfica a favor de la AECC.')

# ---------- Cort d'honor ----------
COURT = [
    {'id': 'reina', 'role': t('Reina de les festes', 'Reina de las fiestas'), 'name': 'Martina Caparrós Mezquita', 'photo': None},
    {'id': 'dama1', 'role': t("Cort d'honor", 'Corte de honor'), 'name': 'Beatriz Alcaide Ahís', 'photo': None},
    {'id': 'dama2', 'role': t("Cort d'honor", 'Corte de honor'), 'name': 'Marta Curic Vega', 'photo': None},
    {'id': 'dama3', 'role': t("Cort d'honor", 'Corte de honor'), 'name': 'Belén Zafrilla Piñero', 'photo': None},
    {'id': 'dama4', 'role': t("Cort d'honor", 'Corte de honor'), 'name': 'Diana Zafrilla Piñero', 'photo': None},
]

# ---------- Toros (18:00) ----------
def bull(date, num, name, capa, gan, eixida, embolada, patro):
    return {
        'date': date, 'time': '18:00', 'number': num, 'name': name, 'coat': t(capa), 'ranch': gan,
        'exit': t(eixida), 'embolada': t(embolada), 'sponsor': patro, 'photo': None,
    }

BULLS = [
    bull(D(3), 21, 'Cortijero', 'Cárdeno oscuro bragado corrido salpicado rabicano', 'San Martín', 'Plaça Major', 'Plaça Picaora', "Ajuntament d'Almassora (Bou del Poble)"),
    bull(D(3), 92, 'Cantante', 'Negro burraco listón', 'Torrestrella', 'Plaça Major', 'Plaça Major', 'Penya Gent del Bou'),
    bull(D(5), 34, 'Lirio', 'Colorado', 'El Pilar', 'Plaça Major', 'Plaça Major', 'Penyes ' + P_SANT_ROC),
    bull(D(5), 743, 'Aguito', 'Negro mulato', 'El Torreón', 'Plaça Major', 'Plaça Picaora', 'Penyes ' + P_ROLLET),
    bull(D(6), 18, 'Artesano', 'Negro mulato', 'Los Lastrones S.L.', 'Plaça Major', 'Plaça Major', "Aficionats al Bou d'Almassora"),
    bull(D(6), 48, 'Mariscador', 'Cárdeno calcetero coletero', 'Ana Romero', 'Plaça Major', 'Plaça Major', 'Penya El Comboi'),
    bull(D(7), 88, 'Durazno', 'Negro', 'Hermanas Angoso Clavijo', 'Plaça Picaora', 'Plaça Picaora', 'A.C.T. La Picaora, El Jaleo i El Bureo'),
    bull(D(7), 26, 'Barbafina', 'Castaño bragado corrido', 'Torrestrella', 'Plaça Major', 'Plaça Major', 'Penyes ' + P_VINT),
    bull(D(8), 68, 'Bello', 'Colorado', 'El Pilar', 'Plaça Major', 'Plaça Major', 'Penyes ' + P_PENJATS),
    bull(D(8), 719, 'Margaritino', 'Negro mulato', 'El Torreón', 'Plaça Major', 'Plaça Major', 'Penyes ' + P_POLP),
    bull(D(10), 50, 'Gambito', 'Castaño', 'Toros de El Torero', 'Plaça Major', 'Plaça Major', 'Penyes El Caragol i El Trasto'),
    bull(D(10), 55, 'Honduro', 'Negro mulato chorreado bragado', 'Manuel y Antonio Tornay', 'Plaça Major', 'Plaça Major', "Aficionades Taurines d'Almassora"),
]

COWS = [
    {'date': D(3), 'time': '13:00', 'ranch': 'Fernando Mansilla'},
    {'date': D(5), 'time': '13:00', 'ranch': 'Jaime Tárrega Lucas'},
    {'date': D(6), 'time': '13:00', 'ranch': 'Hermanos Bellés'},
    {'date': D(7), 'time': '13:00', 'ranch': 'Vicente Benavent'},
    {'date': D(8), 'time': '13:00', 'ranch': 'La Paloma'},
    {'date': D(9), 'time': '13:00', 'ranch': 'Hermanos Cali'},
    {'date': D(10), 'time': '13:00', 'ranch': 'Sergio Rúa'},
]

TROPHIES = [
    {'name': t('Trofeu al millor bou de la fira', 'Trofeo al mejor toro de la feria'), 'sponsor': 'CaixAlmassora'},
    {'name': t('Trofeu al bou millor presentat', 'Trofeo al toro mejor presentado'), 'sponsor': 'Associació de Penyes Taurines'},
    {'name': t('Trofeu a la millor eixida', 'Trofeo a la mejor salida'), 'sponsor': 'Penya El Deklive'},
    {'name': t('Trofeu a la millor embolada', 'Trofeo a la mejor embolada'), 'sponsor': 'Penyes La Galbana i La Jarana'},
    {'name': t("Trofeu al millor recort d'eixida", 'Trofeo al mejor recorte de salida'), 'sponsor': 'Penya El Caragol'},
]

INFO = [
    {'id': 'rules', 'title': t('Normes dels actes taurins', 'Normas de los actos taurinos'), 'body': t(
        "1. En la festa taurina tradicional no es permetrà la participació de menors de 16 anys, que tan sols podran anar com a espectadors i sempre sota la responsabilitat de pares, mares o tutors.\n"
        "2. No es permetrà la participació de persones que mostren manca de condicions físiques per a intervindre en la festa tradicional.\n"
        "3. Els organitzadors podran sol·licitar ajuda de l'autoritat si es produïx resistència al compliment d'estes disposicions.\n"
        "Durant els actes taurins, l'accés al recinte de la vila és baix la responsabilitat de cadascun dels aficionats.",
        "1. En la fiesta taurina tradicional no se permitirá la participación de menores de 16 años, que tan solo podrán ir como espectadores y siempre bajo la responsabilidad de padres, madres o tutores.\n"
        "2. No se permitirá la participación de personas que muestren carencia de condiciones físicas para intervenir en la fiesta tradicional.\n"
        "3. Los organizadores podrán solicitar ayuda de la autoridad si se produce resistencia al cumplimiento de estas disposiciones.\n"
        "Durante los actos taurinos, el acceso al recinto de la vila es bajo la responsabilidad de cada uno de los aficionados.")},
    {'id': 'parking', 'title': t('Aparcament', 'Aparcamiento'), 'body': t(
        "Per a evitar sancions, no aparqueu en les zones reservades per als actes festius. L'11 d'octubre l'aparcament de Sant Pere no estarà disponible; el 10 i 11 d'octubre tampoc el de la piscina.",
        "Para evitar sanciones, no aparque en las zonas reservadas para los actos festivos. El 11 de octubre el aparcamiento de San Pedro no estará disponible; el 10 y 11 de octubre tampoco el de la piscina.")},
    {'id': 'junta', 'title': t('Junta Local de Festes', 'Junta Local de Fiestas'), 'body': t(
        "La Junta Local de Festes es reserva el dret de modificar el programa d'actes o de suspendre alguna celebració festera si circumstàncies adverses ho aconsellen.",
        "La Junta Local de Fiestas se reserva el derecho de modificar el programa de actos o de suspender alguna celebración festiva si circunstancias adversas lo aconsejan.")},
]

EMERGENCY = [
    {'name': t('Emergències', 'Emergencias'), 'phone': '112'},
    {'name': t('Guàrdia Civil', 'Guardia Civil'), 'phone': '062'},
    {'name': t('Policia Local', 'Policía Local'), 'phone': '092'},
]

edition = {
    'year': YEAR,
    'version': VERSION,
    'title': t('Festes de la Mare de Déu del Roser', 'Fiestas de la Virgen del Rosario'),
    'town': 'Almassora',
    'dates': {'start': DATES[0], 'end': DATES[-1]},
    'seedColor': '#2E8B57',
    'categories': {
        'bous': t('Bous', 'Toros'), 'religios': t('Religiós', 'Religioso'), 'musica': t('Música', 'Música'),
        'infantil': t('Infantil', 'Infantil'), 'penyes': t('Penyes', 'Peñas'), 'majors': t('Gent gran', 'Mayores'),
        'cultura': t('Cultura', 'Cultura'), 'festa': t('Festa', 'Fiesta'), 'focs': t('Focs', 'Fuegos'),
    },
    'places': PLACES,
    'events': EVENTS,
    'court': COURT,
    'bulls': BULLS,
    'cows': COWS,
    'trophies': TROPHIES,
    'info': INFO,
    'emergency': EMERGENCY,
}

# Numera els actes
for i, e in enumerate(EVENTS):
    e['id'] = 'e%03d' % i

os.makedirs(os.path.dirname(OUT), exist_ok=True)
with open(OUT, 'w', encoding='utf-8') as f:
    json.dump(edition, f, ensure_ascii=False, indent=1)
print('events:', len(EVENTS), 'bulls:', len(BULLS), '->', os.path.abspath(OUT))
