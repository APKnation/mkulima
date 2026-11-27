import '../models/agri_tools.dart';

const cropBudgetsSeed = [
  CropBudgetTemplate(
    id: 'crop-mahindi',
    cropName: 'Mahindi',
    category: 'Nafaka',
    seedCostPerAcre: 60000,
    fertilizerCostPerAcre: 280000, // DAP + UREA
    pesticideCostPerAcre: 50000,
    laborCostPerAcre: 180000, // Kulima, kupalilia, kuvuna
    expectedYieldBagsPerAcre: 22,
    yieldUnit: 'gunia (100kg)',
    defaultMarketPricePerUnit: 68000,
    durationMonths: 4,
    aiAdvice:
        'Tumia mbegu chotara zilizothibitishwa (k.m. SC 719, DK 8031). Panda kwa nafasi ya 75cm kwa 25cm. Weka DAP wakati wa kupanda na UREA wiki ya 4.',
  ),
  CropBudgetTemplate(
    id: 'crop-nyanya',
    cropName: 'Nyanya',
    category: 'Mbogamboga',
    seedCostPerAcre: 150000,
    fertilizerCostPerAcre: 450000,
    pesticideCostPerAcre: 320000, // Kuvu na wadudu
    laborCostPerAcre: 350000,
    expectedYieldBagsPerAcre: 350,
    yieldUnit: 'tenga (crater)',
    defaultMarketPricePerUnit: 25000,
    durationMonths: 3,
    aiAdvice:
        'Zao lenye faida kubwa lakini linahitaji uangalizi wa karibu wa magonjwa ya ukungu (blight) na funza wa vitumba. Hakikisha umeweka mifumo thabiti ya umwagiliaji.',
  ),
  CropBudgetTemplate(
    id: 'crop-vitunguu',
    cropName: 'Vitunguu Maji',
    category: 'Mbogamboga',
    seedCostPerAcre: 200000,
    fertilizerCostPerAcre: 380000,
    pesticideCostPerAcre: 200000,
    laborCostPerAcre: 320000,
    expectedYieldBagsPerAcre: 140,
    yieldUnit: 'gunia (100kg)',
    defaultMarketPricePerUnit: 120000,
    durationMonths: 4,
    aiAdvice:
        'Vitunguu vina soko imara hasa mwezi Desemba hadi Machi. Epuka umwagiliaji kupita kiasi wiki 2 kabla ya kuvuna ili vikae muda mrefu bila kuoza.',
  ),
  CropBudgetTemplate(
    id: 'crop-alizeti',
    cropName: 'Alizeti',
    category: 'Mafuta',
    seedCostPerAcre: 45000,
    fertilizerCostPerAcre: 120000,
    pesticideCostPerAcre: 40000,
    laborCostPerAcre: 130000,
    expectedYieldBagsPerAcre: 14,
    yieldUnit: 'gunia (65kg)',
    defaultMarketPricePerUnit: 52000,
    durationMonths: 4,
    aiAdvice:
        'Alizeti inavumilia ukame na inahitaji gharama nafuu ukilinganisha na mazao mengine. Soko la viwanda vya mafuta ni la uhakika.',
  ),
  CropBudgetTemplate(
    id: 'crop-mpunga',
    cropName: 'Mpunga (Mpunga wa Mabondeni)',
    category: 'Nafaka',
    seedCostPerAcre: 50000,
    fertilizerCostPerAcre: 240000,
    pesticideCostPerAcre: 60000,
    laborCostPerAcre: 260000,
    expectedYieldBagsPerAcre: 28,
    yieldUnit: 'gunia (100kg)',
    defaultMarketPricePerUnit: 85000,
    durationMonths: 5,
    aiAdvice:
        'Panda kwa mistari ili kupunguza msongamano na kuongeza mashina yenye afya. Vuna mapema mmea ukianza kubadilika rangi ya manjano ili kuzuia upotevu.',
  ),
];

const cropPestsDiseasesSeed = [
  CropPestDisease(
    id: 'pest-fall-armyworm',
    name: 'Funza wa Jeshi (Fall Armyworm)',
    crop: 'Mahindi',
    type: 'Mwadudu',
    severity: 'Hatari kubwa',
    symptoms: [
      'Mashimo yenye ukubwa tofauti kwenye majani ya mahindi machanga',
      'Uchafu kama pumba (frass) ndani ya kiini cha mmea',
      'Kukatika au kuanguka kwa shina la katikati',
    ],
    solutionChemical:
        'Pulizia Emamectin Benzoate (Belt/Match) au Chlorantraniliprole majira ya asubuhi au jioni sana kwenye kiini.',
    solutionOrganic:
        'Nyunyizia unga wa majivu safi yaliyochanganywa na pilipili manga kwenye kiini, au mwarobaini.',
    preventionTip:
        'Panda mapema mara mvua za kwanza zikinyesha na kagua shamba mara mbili kwa wiki.',
    imageAsset: 'assets/images/cereals.jpg',
  ),
  CropPestDisease(
    id: 'disease-early-late-blight',
    name: 'Kinyausi / Ukungu wa Nyanya (Late Blight)',
    crop: 'Nyanya',
    type: 'Ugonjwa',
    severity: 'Hatari kubwa',
    symptoms: [
      'Madoa ya kijivu/kahawia yasiyo na umbo maalum kwenye majani',
      'Majani kukauka haraka kama yamemwagiwa maji ya moto',
      'Madoa magumu ya kahawia kwenye matunda ya nyanya',
    ],
    solutionChemical:
        'Tumia dawa za kuzuia zenye Mancozeb mapema, na zenye Metalaxyl au Ridomil wakati ugonjwa unapoanza.',
    solutionOrganic:
        'Dawa asili ya mwarobaini iliyochanganywa na sabuni laini ya maji; ng’oa mimea iliyoathirika sana uichome moto.',
    preventionTip:
        'Punguza majani ya chini ili kuruhusu hewa kupita, na epuka kumwagia maji majani moja kwa moja.',
    imageAsset: 'assets/images/vegetables.jpg',
  ),
  CropPestDisease(
    id: 'pest-tuta-absoluta',
    name: 'Kipekecha Nyanya (Tuta Absoluta)',
    crop: 'Nyanya',
    type: 'Mwadudu',
    severity: 'Hatari kubwa',
    symptoms: [
      'Mistari myembamba yenye uwazi ndani ya jani (leaf mines)',
      'Tundu ndogo sana zenye weusi karibu na kikonyo cha nyanya',
      'Matunda kuoza kabla ya kuiva',
    ],
    solutionChemical:
        'Pulizia Coragen au Radiant kwa mzunguko sahihi kuzuia mdudu kuwa sugu.',
    solutionOrganic:
        'Tumia mitego ya mwanga (light traps) na mitego ya pheromone kukamata vipepeo dume usiku.',
    preventionTip:
        'Safisha magugu yanayozunguka shamba na usitupe matunda yaliyoharibika shambani.',
    imageAsset: 'assets/images/vegetables.jpg',
  ),
  CropPestDisease(
    id: 'disease-maize-streak',
    name: 'Milia ya Mahindi (Maize Streak Virus)',
    crop: 'Mahindi',
    type: 'Ugonjwa',
    severity: 'Wastani',
    symptoms: [
      'Milia ya manjano au nyeupe inayofuata mishipa ya majani',
      'Mmea kudumaa na kutotoa mahindi yenye uzito',
      'Majani kuwa membamba na yasiyo na nguvu',
    ],
    solutionChemical:
        'Dhibiti wadudu warukao (leafhoppers) wanaoeneza ugonjwa kwa kutumia Imidacloprid.',
    solutionOrganic:
        'Mimea iliyoathirika inapaswa kung’olewa mara moja na kuchomwa nje ya shamba.',
    preventionTip:
        'Panda mbegu zinazovumilia ugonjwa wa milia (streak resistant varieties).',
    imageAsset: 'assets/images/cereals.jpg',
  ),
  CropPestDisease(
    id: 'disease-onion-purple-blotch',
    name: 'Madoa Zambarau ya Vitunguu (Purple Blotch)',
    crop: 'Vitunguu Maji',
    type: 'Ugonjwa',
    severity: 'Wastani',
    symptoms: [
      'Madoa madogo yanayogeuka kuwa ya rangi ya zambarau katikati',
      'Majani kuvunjika na ncha zake kukauka',
      'Vitunguu kuwa vidogo na kutoota vizuri',
    ],
    solutionChemical:
        'Nyunyizia Chlorothalonil au Copper Oxychloride kila baada ya siku 10-14 kipindi cha unyevunyevu.',
    solutionOrganic:
        'Mchanganyiko wa majivu na kitunguu saumu kilichosagwa hupunguza kasi ya ukungu.',
    preventionTip:
        'Mzunguko wa mazao (crop rotation) usiopanda mazao ya jamii ya vitunguu kwa miaka 2 mfululizo.',
    imageAsset: 'assets/images/vegetables.jpg',
  ),
];

const agroDealersSeed = [
  AgroDealer(
    id: 'dealer-1',
    name: 'Kibo Agro Inputs Centre',
    type: 'Muuzaji Pembejeo',
    region: 'Arusha',
    district: 'Arusha Mjini',
    phone: '0754 123 456',
    location: 'Soko Kuu la Arusha, Barabara ya Sokoine',
    specialties: ['Mbegu Chotara', 'Mbolea za YARA', 'Dawa za Ukungu'],
    verified: true,
  ),
  AgroDealer(
    id: 'dealer-2',
    name: 'Mbeya Farm Hub & Seeds',
    type: 'Muuzaji Pembejeo',
    region: 'Mbeya',
    district: 'Mbeya Mjini',
    phone: '0767 987 654',
    location: 'Mwanjelwa, Karibu na kituo cha mabasi',
    specialties: ['Mbegu za Mpunga & Mahindi', 'Mbolea ya Minjingu', 'Mifumo ya Matone'],
    verified: true,
  ),
  AgroDealer(
    id: 'dealer-3',
    name: 'Afisa Ugani - Bw. James Mgalla',
    type: 'Afisa Ugani',
    region: 'Morogoro',
    district: 'Kilosa',
    phone: '0713 555 123',
    location: 'Ofisi ya Kilimo ya Kata, Dumila',
    specialties: ['Ushauri wa Mahindi & Mpunga', 'Kupima Udongo', 'Ratiba ya Viuatilifu'],
    verified: true,
  ),
  AgroDealer(
    id: 'dealer-4',
    name: 'Afisa Ugani - Bi. Rehema Bakari',
    type: 'Afisa Ugani',
    region: 'Iringa',
    district: 'Iringa Vijijini',
    phone: '0784 444 890',
    location: 'Kituo cha Mafunzo ya Wakulima Ilula',
    specialties: ['Kilimo cha Nyanya & Pilipili', 'Udhibiti wa Tuta Absoluta'],
    verified: true,
  ),
  AgroDealer(
    id: 'dealer-5',
    name: 'Dodoma Green Agrovet',
    type: 'Muuzaji Pembejeo',
    region: 'Dodoma',
    district: 'Dodoma Mjini',
    phone: '0755 888 222',
    location: 'Kibaigwa Soko la Mazao',
    specialties: ['Mbegu za Alizeti & Mtama', 'Dawa za Mifugo', 'Mbolea'],
    verified: true,
  ),
];

const farmCalendarTemplates = [
  FarmCalendarTask(
    id: 'task-1',
    title: 'Maandalizi ya shamba & Kupima pH',
    crop: 'Mahindi',
    dayOffset: -14,
    description: 'Kulima kwa kina, kusawazisha ardhi na kuweka samadi au mbolea ya kuku.',
    category: 'Kupanda',
  ),
  FarmCalendarTask(
    id: 'task-2',
    title: 'Kupanda na Kuweka Mbolea ya Kupandia (DAP)',
    crop: 'Mahindi',
    dayOffset: 0,
    description: 'Panda nafasi ya 75cm x 25cm, weka DAP gramu 5 kwa shimo bila kugusisha mbegu moja kwa moja.',
    category: 'Kupanda',
  ),
  FarmCalendarTask(
    id: 'task-3',
    title: 'Palizi ya Kwanza na Ukaguzi wa Funza',
    crop: 'Mahindi',
    dayOffset: 14,
    description: 'Ondoa magugu yote machanga na kagua dalili za funza wa jeshi (Fall armyworm).',
    category: 'Palizi',
  ),
  FarmCalendarTask(
    id: 'task-4',
    title: 'Kuweka Mbolea ya Kukuzia (UREA / CAN)',
    crop: 'Mahindi',
    dayOffset: 28,
    description: 'Weka UREA mzunguko wa kwanza karibu na shina na kufunika kidogo na udongo wenye unyevu.',
    category: 'Mbolea',
  ),
  FarmCalendarTask(
    id: 'task-5',
    title: 'Palizi ya Pili na Mbolea ya Mwisho',
    crop: 'Mahindi',
    dayOffset: 45,
    description: 'Palilia na weka awamu ya mwisho ya mbolea kabla mahindi hayajaanza kutoa mbelewele.',
    category: 'Mbolea',
  ),
  FarmCalendarTask(
    id: 'task-6',
    title: 'Ukaguzi wa Kutoa Mbelewele & Unyevu',
    crop: 'Mahindi',
    dayOffset: 65,
    description: 'Kipindi muhimu sana cha unyevu ili mahindi yajae vizuri hadi kwenye ncha ya gunzi.',
    category: 'Kupanda',
  ),
  FarmCalendarTask(
    id: 'task-7',
    title: 'Mavuno na Kukausha',
    crop: 'Mahindi',
    dayOffset: 120,
    description: 'Vuna baada ya mmea kukauka kabisa, kausha nafaka hadi unyevu uwe chini ya asilimia 13.5 kabla ya kuhifadhi.',
    category: 'Mavuno',
  ),
];
