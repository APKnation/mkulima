class GuideStep {
  const GuideStep({required this.title, required this.body});

  final String title;
  final String body;
}

class FarmingGuide {
  const FarmingGuide({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.subcategoryId,
    required this.summary,
    required this.imageAsset,
    required this.minutes,
    required this.level,
    required this.season,
    required this.steps,
    required this.tips,
    required this.author,
    this.offlineReady = true,
  });

  final String id;
  final String title;
  final String categoryId;
  final String subcategoryId;
  final String summary;
  final String imageAsset;
  final int minutes;
  final String level;
  final String season;
  final List<GuideStep> steps;
  final List<String> tips;
  final String author;
  final bool offlineReady;
}
