enum ProductSort { newest, priceLow, priceHigh, popular }

extension ProductSortLabel on ProductSort {
  String get label => switch (this) {
        ProductSort.newest => 'Mpya zaidi',
        ProductSort.priceLow => 'Bei: ndogo hadi kubwa',
        ProductSort.priceHigh => 'Bei: kubwa hadi ndogo',
        ProductSort.popular => 'Maarufu zaidi',
      };
}

/// Filter state shared by listing, search and filter screens.
class ProductFilter {
  const ProductFilter({
    this.categoryId,
    this.subcategoryId,
    this.query = '',
    this.region,
    this.maxPrice,
    this.sort = ProductSort.newest,
    this.availableOnly = false,
    this.verifiedOnly = false,
  });

  final String? categoryId;
  final String? subcategoryId;
  final String query;
  final String? region;
  final double? maxPrice;
  final ProductSort sort;
  final bool availableOnly;
  final bool verifiedOnly;

  ProductFilter copyWith({
    String? categoryId,
    String? subcategoryId,
    String? query,
    String? region,
    double? maxPrice,
    ProductSort? sort,
    bool? availableOnly,
    bool? verifiedOnly,
    bool clearRegion = false,
    bool clearMaxPrice = false,
  }) {
    return ProductFilter(
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      query: query ?? this.query,
      region: clearRegion ? null : (region ?? this.region),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      sort: sort ?? this.sort,
      availableOnly: availableOnly ?? this.availableOnly,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
    );
  }

  int get activeCount {
    var count = 0;
    if (region != null) count++;
    if (maxPrice != null) count++;
    if (availableOnly) count++;
    if (verifiedOnly) count++;
    return count;
  }
}

/// A marketplace listing.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.description,
    required this.price,
    required this.unit,
    required this.location,
    required this.region,
    required this.sellerName,
    required this.sellerPhone,
    required this.sellerType,
    required this.quantityLabel,
    required this.listedAt,
    required this.imageAsset,
    this.previousPrice,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.views = 0,
    this.verified = false,
    this.negotiable = true,
    this.organic = false,
    this.available = true,
    this.minOrder,
  });

  final String id;
  final String name;
  final String categoryId;
  final String subcategoryId;
  final String subcategoryName;
  final String description;
  final double price;
  final double? previousPrice;
  final String unit;
  final String location;
  final String region;
  final String sellerName;
  final String sellerPhone;
  final String sellerType;
  final String quantityLabel;
  final String listedAt;
  final String imageAsset;
  final double rating;
  final int reviewCount;
  final int views;
  final bool verified;
  final bool negotiable;
  final bool organic;
  final bool available;
  final int? minOrder;

  String get priceLabel => 'TSh ${_format(price)} / $unit';

  String get locationLine => '$location, $region';

  static String _format(double value) {
    final digits = value.round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }
}
