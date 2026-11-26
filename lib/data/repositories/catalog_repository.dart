import '../models/category.dart';
import '../models/guide.dart';
import '../models/market_price.dart';
import '../models/post.dart';
import '../models/product.dart';
import '../seed/categories_seed.dart';
import '../seed/guides_seed.dart';
import '../seed/prices_seed.dart';
import '../seed/products_seed.dart';

/// Single access point for catalogue content.
///
/// Today it serves bundled seed data so the app works offline. Swapping this
/// for an HTTP client later only touches this class.
class CatalogRepository {
  const CatalogRepository();

  List<AgriCategory> get categories => categoriesSeed;
  List<Product> get products => productsSeed;
  List<MarketPrice> get prices => marketPricesSeed;
  List<FarmingGuide> get guides => guidesSeed;
  List<CommunityPost> get seededPosts => communitySeed();

  AgriCategory? category(String? id) => categoryById(id);
  Subcategory? subcategory(String categoryId, String? id) =>
      subcategoryById(categoryId, id);

  Product? product(String id) {
    for (final item in products) {
      if (item.id == id) return item;
    }
    return null;
  }

  FarmingGuide? guide(String id) {
    for (final item in guides) {
      if (item.id == id) return item;
    }
    return null;
  }

  List<Product> byCategory(String categoryId, {String? subcategoryId}) {
    return products
        .where((p) =>
            p.categoryId == categoryId &&
            (subcategoryId == null || p.subcategoryId == subcategoryId))
        .toList();
  }

  List<Product> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return products;
    return products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.subcategoryName.toLowerCase().contains(q) ||
            p.sellerName.toLowerCase().contains(q) ||
            p.region.toLowerCase().contains(q))
        .toList();
  }
}
