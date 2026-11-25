class WeatherDay {
  const WeatherDay({
    required this.day,
    required this.icon,
    required this.high,
    required this.low,
    required this.rainChance,
    required this.summary,
  });

  final String day;

  /// Icon code mapped by the presentation layer.
  final String icon;
  final int high;
  final int low;
  final int rainChance;
  final String summary;
}

class WeatherSnapshot {
  const WeatherSnapshot({
    required this.location,
    required this.temperature,
    required this.feelsLike,
    required this.summary,
    required this.humidity,
    required this.windKph,
    required this.rainChance,
    required this.rainfallMm,
    required this.updatedAt,
    required this.days,
    required this.advisories,
  });

  final String location;
  final int temperature;
  final int feelsLike;
  final String summary;
  final int humidity;
  final int windKph;
  final int rainChance;
  final double rainfallMm;
  final String updatedAt;
  final List<WeatherDay> days;
  final List<String> advisories;
}
