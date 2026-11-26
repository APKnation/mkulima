import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/weather.dart';
import '../../data/seed/misc_seed.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  IconData _iconFor(String code) => switch (code) {
        'rain' => Icons.water_drop_rounded,
        'partly' => Icons.wb_cloudy_rounded,
        _ => Icons.wb_sunny_rounded,
      };

  Color _colorFor(String code) => switch (code) {
        'rain' => AppColors.info,
        'partly' => AppColors.muted,
        _ => AppColors.accent,
      };

  @override
  Widget build(BuildContext context) {
    final weather = weatherSeed;
    return Scaffold(
      appBar: AppBar(title: const Text('Hali ya hewa')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppShadows.floating,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.place_rounded,
                      size: 15,
                      color: AppColors.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      weather.location,
                      style: AppText.label.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature}°',
                      style: AppText.display.copyWith(
                        color: Colors.white,
                        fontSize: 64,
                        height: 1,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.wb_sunny_rounded,
                      size: 58,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  weather.summary,
                  style: AppText.body.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                Text(
                  'Inahisi kama ${weather.feelsLike}°',
                  style: AppText.small.copyWith(
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    _Stat(
                      icon: Icons.water_drop_outlined,
                      label: 'Mvua',
                      value: '${weather.rainChance}%',
                    ),
                    _Stat(
                      icon: Icons.air_rounded,
                      label: 'Upepo',
                      value: '${weather.windKph} km/h',
                    ),
                    _Stat(
                      icon: Icons.thermostat_rounded,
                      label: 'Unyevu',
                      value: '${weather.humidity}%',
                    ),
                    _Stat(
                      icon: Icons.grain_rounded,
                      label: 'Mvua',
                      value: '${weather.rainfallMm} mm',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(weather.updatedAt, style: AppText.small),
          const SizedBox(height: AppSpacing.xl),
          Text('Utabiri wa siku 7', style: AppText.h2),
          const SizedBox(height: AppSpacing.md),
          MkCard(
            shadow: AppShadows.soft,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xs,
            ),
            child: Column(
              children: [
                for (var i = 0; i < weather.days.length; i++)
                  _DayRow(
                    day: weather.days[i],
                    icon: _iconFor(weather.days[i].icon),
                    color: _colorFor(weather.days[i].icon),
                    showDivider: i != weather.days.length - 1,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              const Icon(
                Icons.agriculture_rounded,
                size: 20,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text('Ushauri kwa shamba', style: AppText.h2),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          for (final advisory in weather.advisories) ...[
            MkCard(
              shadow: AppShadows.soft,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: AppColors.primaryDark,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: Text(advisory, style: AppText.body)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.infoSoft,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.info,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Utabiri huu unatokana na kituo cha hali ya hewa kilichothibitishwa. '
                    'Angalia taarifa mpya kila asubuhi.',
                    style: AppText.small.copyWith(color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.label.copyWith(color: Colors.white),
          ),
          Text(
            label,
            style: AppText.small.copyWith(
              color: Colors.white60,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({
    required this.day,
    required this.icon,
    required this.color,
    required this.showDivider,
  });

  final WeatherDay day;
  final IconData icon;
  final Color color;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              SizedBox(
                width: 78,
                child: Text(day.day, style: AppText.bodyStrong),
              ),
              Icon(icon, size: 20, color: color),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  day.summary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.small,
                ),
              ),
              const Icon(
                Icons.water_drop_outlined,
                size: 13,
                color: AppColors.info,
              ),
              const SizedBox(width: 2),
              SizedBox(
                width: 34,
                child: Text('${day.rainChance}%', style: AppText.small),
              ),
              Text(
                '${day.high}°',
                style: AppText.bodyStrong.copyWith(fontSize: 14),
              ),
              Text(
                ' / ${day.low}°',
                style: AppText.small,
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(),
      ],
    );
  }
}
