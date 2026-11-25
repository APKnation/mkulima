import 'package:material_ui/material_ui.dart';

/// A top-level agricultural category (Mifugo, Matunda, Nafaka, ...).
class AgriCategory {
  const AgriCategory({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.tagline,
    required this.description,
    required this.imageAsset,
    required this.icon,
    required this.tint,
    required this.subcategories,
    required this.listingCount,
  });

  final String id;
  final String name;
  final String nameEn;
  final String tagline;
  final String description;
  final String imageAsset;
  final IconData icon;
  final Color tint;
  final List<Subcategory> subcategories;
  final int listingCount;
}

class Subcategory {
  const Subcategory({
    required this.id,
    required this.name,
    required this.nameEn,
    required this.imageAsset,
    this.listingCount = 0,
  });

  final String id;
  final String name;
  final String nameEn;
  final String imageAsset;
  final int listingCount;

  String get bilingual => '$name · $nameEn';
}
