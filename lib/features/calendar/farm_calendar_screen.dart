import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/agri_tools.dart';
import '../../data/seed/agri_tools_seed.dart';

class FarmCalendarScreen extends StatefulWidget {
  const FarmCalendarScreen({super.key});

  @override
  State<FarmCalendarScreen> createState() => _FarmCalendarScreenState();
}

class _FarmCalendarScreenState extends State<FarmCalendarScreen> {
  DateTime _plantingDate = DateTime.now().subtract(const Duration(days: 20));
  late List<FarmCalendarTask> _tasks;

  @override
  void initState() {
    super.initState();
    _tasks = List.from(farmCalendarTemplates);
  }

  void _toggleTask(int index) {
    setState(() {
      final t = _tasks[index];
      _tasks[index] = FarmCalendarTask(
        id: t.id,
        title: t.title,
        crop: t.crop,
        dayOffset: t.dayOffset,
        description: t.description,
        category: t.category,
        completed: !t.completed,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final daysSincePlanting = now.difference(_plantingDate).inDays;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ratiba na Kalenda ya Shamba'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          // Crop Header Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              boxShadow: AppShadows.floating,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Zao: Mahindi (SC 719)',
                      style: AppText.h2.copyWith(color: Colors.white),
                    ),
                    const MkPill(
                      label: 'Msimu wa Mvua',
                      foreground: AppColors.primaryDeep,
                      background: AppColors.secondary,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Siku $daysSincePlanting tangu kupandwa · Shamba la Kilosa',
                  style: AppText.small.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: AppSpacing.md),
                LinearProgressIndicator(
                  value: (daysSincePlanting / 120).clamp(0.0, 1.0),
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Hatua: Mbolea ya Kukuzia na Palizi ya Pili',
                  style: AppText.small.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Text('Ratiba ya Hatua kwa Hatua', style: AppText.h2),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Gusa kisanduku baada ya kukamilisha hatua ya shambani.',
            style: AppText.small,
          ),
          const SizedBox(height: AppSpacing.md),

          // Timeline tasks
          for (var i = 0; i < _tasks.length; i++) ...[
            _CalendarTimelineItem(
              task: _tasks[i],
              isCurrentPhase: _tasks[i].dayOffset >= daysSincePlanting - 7 &&
                  _tasks[i].dayOffset <= daysSincePlanting + 7,
              onToggle: () => _toggleTask(i),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _CalendarTimelineItem extends StatelessWidget {
  const _CalendarTimelineItem({
    required this.task,
    required this.isCurrentPhase,
    required this.onToggle,
  });

  final FarmCalendarTask task;
  final bool isCurrentPhase;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      shadow: AppShadows.soft,
      color: task.completed
          ? AppColors.surfaceAlt
          : (isCurrentPhase ? AppColors.primarySoft : AppColors.surface),
      borderColor: isCurrentPhase ? AppColors.primary : null,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: task.completed,
            activeColor: AppColors.primary,
            onChanged: (_) => onToggle(),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    MkPill(
                      label: task.dayOffset <= 0
                          ? 'Kabla ya Kupanda'
                          : 'Siku ya ${task.dayOffset}',
                      foreground: isCurrentPhase ? AppColors.primaryDark : AppColors.inkSoft,
                      background: isCurrentPhase ? Colors.white : AppColors.surfaceAlt,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    MkPill(
                      label: task.category,
                      foreground: AppColors.accent,
                      background: AppColors.accentSoft,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  task.title,
                  style: AppText.bodyStrong.copyWith(
                    decoration: task.completed ? TextDecoration.lineThrough : null,
                    color: task.completed ? AppColors.muted : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: AppText.small.copyWith(
                    color: task.completed ? AppColors.muted : AppColors.inkSoft,
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
