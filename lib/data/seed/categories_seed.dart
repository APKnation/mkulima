import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../models/category.dart';

const _img = 'assets/images';

AgriCategory _cat({
  required String id,
  required String name,
  required String nameEn,
  required String tagline,
  required String description,
  required String image,
  required IconData icon,
  required Color tint,
  required int count,
  required List<Subcategory> subs,
}) {
  return AgriCategory(
    id: id,
    name: name,
    nameEn: nameEn,
    tagline: tagline,
    description: description,
    imageAsset: '$_img/$image',
    icon: icon,
    tint: tint,
    listingCount: count,
    subcategories: subs,
  );
}

Subcategory _sub(String id, String name, String nameEn, String image, int count) {
  return Subcategory(
    id: id,
    name: name,
    nameEn: nameEn,
    imageAsset: '$_img/$image',
    listingCount: count,
  );
}

final List<AgriCategory> categoriesSeed = [
  _cat(
    id: 'mifugo',
    name: 'Mifugo',
    nameEn: 'Livestock',
    tagline: 'Ngombe, mbuzi, kondoo na zaidi',
    description:
        'Soko la mifugo yenye afya kutoka kwa wafugaji waliothibitishwa kote Tanzania. '
        'Pata maelezo ya umri, uzito na historia ya chanjo kabla ya kununua.',
    image: 'livestock.jpg',
    icon: Icons.pets_rounded,
    tint: AppColors.accent,
    count: 412,
    subs: [
      _sub('ngombe', 'Ngombe', 'Cattle', 'livestock.jpg', 96),
      _sub('mbuzi', 'Mbuzi', 'Goats', 'livestock.jpg', 128),
      _sub('kondoo', 'Kondoo', 'Sheep', 'livestock.jpg', 74),
      _sub('nguruwe', 'Nguruwe', 'Pigs', 'livestock.jpg', 58),
      _sub('sungura', 'Sungura', 'Rabbits', 'livestock.jpg', 31),
      _sub('punda', 'Punda na Farasi', 'Donkeys & Horses', 'livestock.jpg', 25),
    ],
  ),
  _cat(
    id: 'matunda',
    name: 'Matunda',
    nameEn: 'Fruits',
    tagline: 'Matunda mabichi ya msimu',
    description:
        'Matunda yaliyovunwa hivi karibuni kutoka mikoa maarufu ya kilimo. '
        'Chagua kwa aina, kiasi na eneo la mkulima.',
    image: 'fruits.jpg',
    icon: Icons.local_florist_rounded,
    tint: AppColors.danger,
    count: 386,
    subs: [
      _sub('parachichi', 'Parachichi', 'Avocado', 'fruits.jpg', 62),
      _sub('maembe', 'Maembe', 'Mangoes', 'fruits.jpg', 71),
      _sub('mananasi', 'Mananasi', 'Pineapples', 'fruits.jpg', 44),
      _sub('ndizi', 'Ndizi', 'Bananas', 'fruits.jpg', 83),
      _sub('machungwa', 'Machungwa', 'Oranges', 'fruits.jpg', 39),
      _sub('matikiti', 'Matikiti Maji', 'Watermelon', 'fruits.jpg', 27),
      _sub('mapapai', 'Mapapai', 'Pawpaw', 'fruits.jpg', 24),
      _sub('mapera', 'Mapera', 'Guava', 'fruits.jpg', 18),
    ],
  ),
  _cat(
    id: 'nafaka',
    name: 'Nafaka',
    nameEn: 'Cereals & Grains',
    tagline: 'Mahindi, mpunga na nafaka nyingine',
    description:
        'Nafaka kwa wingi au rejareja, moja kwa moja kutoka kwa wakulima na '
        'vyama vya ushirika. Bei zinaonyeshwa kwa kilo au gunia.',
    image: 'cereals.jpg',
    icon: Icons.grass_rounded,
    tint: AppColors.accent,
    count: 298,
    subs: [
      _sub('mahindi', 'Mahindi', 'Maize', 'cereals.jpg', 88),
      _sub('mpunga', 'Mpunga', 'Rice', 'cereals.jpg', 64),
      _sub('ngano', 'Ngano', 'Wheat', 'cereals.jpg', 31),
      _sub('mtama', 'Mtama', 'Sorghum', 'cereals.jpg', 42),
      _sub('ulezi', 'Ulezi', 'Millet', 'cereals.jpg', 29),
      _sub('shayiri', 'Shayiri', 'Barley', 'cereals.jpg', 18),
      _sub('oats', 'Oats', 'Oats', 'cereals.jpg', 12),
    ],
  ),
  _cat(
    id: 'mboga',
    name: 'Mboga',
    nameEn: 'Vegetables',
    tagline: 'Mboga mbichi kila siku',
    description:
        'Mboga zilizopandwa kwa umakini na kupatikana karibu nawe. '
        'Bidhaa nyingi zinaweza kuagizwa kwa kiasi kidogo.',
    image: 'vegetables.jpg',
    icon: Icons.eco_rounded,
    tint: AppColors.primary,
    count: 341,
    subs: [
      _sub('nyanya', 'Nyanya', 'Tomatoes', 'vegetables.jpg', 92),
      _sub('vitunguu', 'Vitunguu', 'Onions', 'vegetables.jpg', 76),
      _sub('kabichi', 'Kabichi', 'Cabbage', 'vegetables.jpg', 48),
      _sub('mchicha', 'Mchicha', 'Amaranth Greens', 'vegetables.jpg', 37),
      _sub('karoti', 'Karoti', 'Carrots', 'vegetables.jpg', 33),
      _sub('pilipili-hoho', 'Pilipili Hoho', 'Bell Pepper', 'vegetables.jpg', 29),
      _sub('bilinganya', 'Bilinganya', 'Eggplant', 'vegetables.jpg', 22),
      _sub('matango', 'Matango', 'Cucumber', 'vegetables.jpg', 16),
    ],
  ),
  _cat(
    id: 'kuku',
    name: 'Ufugaji wa Kuku',
    nameEn: 'Poultry',
    tagline: 'Kuku, bata na mayai',
    description:
        'Kuku wa broiler, waria na wenyeji pamoja na mayai mapya. '
        'Wafugaji wengi wanaonyesha rekodi za chanjo.',
    image: 'poultry.jpg',
    icon: Icons.egg_alt_rounded,
    tint: AppColors.accent,
    count: 274,
    subs: [
      _sub('kuku-broiler', 'Kuku Broiler', 'Broiler Chicken', 'poultry.jpg', 84),
      _sub('kuku-waria', 'Kuku Waria', 'Improved Kienyeji', 'poultry.jpg', 69),
      _sub('kuku-wenyeji', 'Kuku Wenyeji', 'Local Chicken', 'poultry.jpg', 58),
      _sub('bata', 'Bata', 'Ducks', 'poultry.jpg', 26),
      _sub('bata-mzinga', 'Bata Mzinga', 'Turkeys', 'poultry.jpg', 19),
      _sub('kanga', 'Kanga', 'Guinea Fowl', 'poultry.jpg', 14),
    ],
  ),
  _cat(
    id: 'uvuvi',
    name: 'Uvuvi na Samaki',
    nameEn: 'Fisheries & Aquaculture',
    tagline: 'Samaki wabichi na mazao ya ziwa',
    description:
        'Samaki kutoka ziwa Victoria, Tanganyika na bahari ya Hindi, '
        'pamoja na vifaa vya ufugaji wa samaki.',
    image: 'fisheries.jpg',
    icon: Icons.water_rounded,
    tint: AppColors.info,
    count: 187,
    subs: [
      _sub('tilapia', 'Tilapia', 'Tilapia', 'fisheries.jpg', 54),
      _sub('kambale', 'Kambale', 'Sardines (Dagaa)', 'fisheries.jpg', 41),
      _sub('sangara', 'Sangara', 'Catfish', 'fisheries.jpg', 28),
      _sub('bwawa', 'Bwawa la Samaki', 'Fish Farming', 'fisheries.jpg', 22),
      _sub('chakula-samaki', 'Chakula cha Samaki', 'Fish Feed', 'fisheries.jpg', 25),
      _sub('vifaa-samaki', 'Vifaa vya Uvuvi', 'Fishing Gear', 'fisheries.jpg', 17),
    ],
  ),
  _cat(
    id: 'chakula',
    name: 'Chakula na Mazao',
    nameEn: 'Food & Agri Products',
    tagline: 'Asali, maziwa, mayai na zaidi',
    description:
        'Mazao ya chakula yaliyosindikwa na yasiyosindikwa: asali, maziwa, '
        'mayai, unga na mafuta ya mazao.',
    image: 'food.jpg',
    icon: Icons.restaurant_rounded,
    tint: AppColors.accent,
    count: 226,
    subs: [
      _sub('asali', 'Asali', 'Honey', 'food.jpg', 46),
      _sub('maziwa', 'Maziwa', 'Milk', 'food.jpg', 52),
      _sub('mayai', 'Mayai', 'Eggs', 'food.jpg', 63),
      _sub('unga', 'Unga', 'Flour', 'food.jpg', 34),
      _sub('mafuta', 'Mafuta ya Mazao', 'Cooking Oil', 'food.jpg', 21),
    ],
  ),
  _cat(
    id: 'pembejeo',
    name: 'Pembejeo za Kilimo',
    nameEn: 'Agricultural Inputs',
    tagline: 'Mbegu, mbolea na dawa',
    description:
        'Pembejeo halali kutoka kwa wauzaji waliosajiliwa: mbegu bora, mbolea, '
        'dawa za wadudu na vifaa vya kilimo.',
    image: 'inputs.jpg',
    icon: Icons.inventory_2_rounded,
    tint: AppColors.info,
    count: 164,
    subs: [
      _sub('mbegu', 'Mbegu', 'Seeds', 'inputs.jpg', 58),
      _sub('mbolea', 'Mbolea', 'Fertiliser', 'inputs.jpg', 41),
      _sub('dawa', 'Dawa za Wadudu', 'Pesticides', 'inputs.jpg', 27),
      _sub('zana', 'Zana za Kilimo', 'Farm Tools', 'inputs.jpg', 38),
    ],
  ),
  _cat(
    id: 'nyingine',
    name: 'Shughuli Nyingine',
    nameEn: 'Other Activities',
    tagline: 'Nyuki, bustani na huduma',
    description:
        'Shughuli za ziada zinazosaidia kipato cha mkulima: ufugaji nyuki, '
        'bustani za nyumbani, huduma za ushauri na usafirishaji.',
    image: 'other.jpg',
    icon: Icons.handyman_rounded,
    tint: AppColors.turquoise,
    count: 93,
    subs: [
      _sub('nyuki', 'Ufugaji Nyuki', 'Beekeeping', 'other.jpg', 28),
      _sub('bustani', 'Bustani za Nyumbani', 'Home Gardens', 'other.jpg', 24),
      _sub('huduma', 'Huduma za Kilimo', 'Agri Services', 'other.jpg', 26),
      _sub('usafirishaji', 'Usafirishaji', 'Transport', 'other.jpg', 15),
    ],
  ),
];

AgriCategory? categoryById(String? id) {
  for (final category in categoriesSeed) {
    if (category.id == id) return category;
  }
  return null;
}

Subcategory? subcategoryById(String categoryId, String? id) {
  final category = categoryById(categoryId);
  if (category == null || id == null) return null;
  for (final sub in category.subcategories) {
    if (sub.id == id) return sub;
  }
  return null;
}
