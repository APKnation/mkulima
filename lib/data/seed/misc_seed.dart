import '../models/user.dart';
import '../models/weather.dart';

const userProfileSeed = UserProfile(
  name: 'Baraka John Mwakyusa',
  phone: '+255 754 712 884',
  email: 'baraka.mwakyusa@example.co.tz',
  region: 'Dodoma',
  ward: 'Chamwino',
  role: 'Mkulima na mfugaji',
  joined: 'Novemba 2025',
  interests: ['Mahindi', 'Mboga', 'Kuku'],
);

const List<AppNotification> notificationsSeed = [
  AppNotification(
    id: 'n1',
    title: 'Bei ya mahindi imepanda',
    body: 'Bei ya mahindi sokoni Mbeya imepanda kwa 2.4% leo. Bei elekezi: TSh 680 kwa kilo.',
    timeAgo: 'Dakika 18 zilizopita',
    type: 'bei',
  ),
  AppNotification(
    id: 'n2',
    title: 'Ombi jipya la bidhaa yako',
    body: 'Joseph Mrema anaomba nyanya kilo 20 kutoka kwenye tangazo lako.',
    timeAgo: 'Saa 1 iliyopita',
    type: 'ombi',
  ),
  AppNotification(
    id: 'n3',
    title: 'Mvua inatarajiwa kesho',
    body: 'Hali ya hewa ya Dodoma inaonyesha nafasi ya mvua ya 70% kesho mchana. Fikiria kuahirisha umwagiliaji.',
    timeAgo: 'Saa 3 zilizopita',
    type: 'hali_ya_hewa',
  ),
  AppNotification(
    id: 'n4',
    title: 'Jibu jipya kwenye swali lako',
    body: 'Dk. Faraja Mwenda amejibu swali lako kuhusu lishe ya kuku.',
    timeAgo: 'Jana',
    type: 'jamii',
    read: true,
  ),
  AppNotification(
    id: 'n5',
    title: 'Kumbusho la chanjo',
    body: 'Chanjo ya Newcastle kwa kundi lako la kuku imepangwa kesho saa 08:00.',
    timeAgo: 'Jana',
    type: 'mfumo',
  ),
  AppNotification(
    id: 'n6',
    title: 'Taarifa mpya ya msimu',
    body: 'Mwongozo mpya wa kupanda mahindi msimu wa mvua umeongezwa. Unapatikana bila mtandao.',
    timeAgo: 'Siku 2 zilizopita',
    type: 'mfumo',
    read: true,
  ),
];

const weatherSeed = WeatherSnapshot(
  location: 'Chamwino, Dodoma',
  temperature: 29,
  feelsLike: 31,
  summary: 'Jua kali na mawingu ya jioni',
  humidity: 58,
  windKph: 14,
  rainChance: 30,
  rainfallMm: 2.4,
  updatedAt: 'Imesasishwa 25 Nov 2026, 06:40',
  days: [
    WeatherDay(day: 'Leo', icon: 'sun', high: 31, low: 19, rainChance: 30, summary: 'Jua kali'),
    WeatherDay(day: 'Alhamisi', icon: 'rain', high: 27, low: 18, rainChance: 70, summary: 'Mvua za mchana'),
    WeatherDay(day: 'Ijumaa', icon: 'partly', high: 28, low: 18, rainChance: 45, summary: 'Mawingu kiasi'),
    WeatherDay(day: 'Jumamosi', icon: 'sun', high: 30, low: 19, rainChance: 20, summary: 'Jua kali'),
    WeatherDay(day: 'Jumapili', icon: 'partly', high: 29, low: 19, rainChance: 35, summary: 'Mawingu kiasi'),
    WeatherDay(day: 'Jumatatu', icon: 'rain', high: 26, low: 17, rainChance: 65, summary: 'Mvua ndogo'),
    WeatherDay(day: 'Jumanne', icon: 'sun', high: 30, low: 18, rainChance: 15, summary: 'Jua kali'),
  ],
  advisories: [
    'Mvua inatarajiwa Alhamisi — chelewesha umwagiliaji wa bustani.',
    'Joto la juu: mwagilia mboga asubuhi mapema au jioni.',
    'Hakikisha ghala la nafaka lina hewa ya kutosha wakati wa unyevu.',
    'Weka kivuli kwa vifaranga wakati wa joto la mchana.',
  ],
);

const List<String> regionsSeed = [
  'Dar es Salaam',
  'Arusha',
  'Dodoma',
  'Mbeya',
  'Mwanza',
  'Iringa',
  'Morogoro',
  'Tanga',
  'Kilimanjaro',
  'Kigoma',
  'Mtwara',
  'Njombe',
  'Singida',
  'Pwani',
  'Kagera',
  'Ruvuma',
  'Zanzibar',
];
