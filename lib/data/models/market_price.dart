/// A dated, sourced market price record.
///
/// `isVerified` reflects whether the price was confirmed by a market officer.
/// Indicative or estimated prices are surfaced as such in the UI and never
/// presented as verified live prices.
class MarketPrice {
  const MarketPrice({
    required this.id,
    required this.commodity,
    required this.commodityEn,
    required this.categoryId,
    required this.unit,
    required this.region,
    required this.market,
    required this.retail,
    required this.wholesale,
    required this.changePercent,
    required this.updatedOn,
    required this.trend,
    this.isVerified = true,
    this.isIndicative = false,
  });

  final String id;
  final String commodity;
  final String commodityEn;
  final String categoryId;
  final String unit;
  final String region;
  final String market;
  final double retail;
  final double wholesale;
  final double changePercent;

  /// Human-readable date, e.g. `25 Nov 2026`.
  final String updatedOn;

  /// Recent retail prices used for the sparkline.
  final List<double> trend;
  final bool isVerified;
  final bool isIndicative;

  String get sourceLabel =>
      isIndicative ? 'Bei elekezi' : (isVerified ? 'Imethibitishwa' : 'Haijathibitishwa');
}
