import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/farm.dart';
import 'farm_register_screen.dart';

class FarmScreen extends StatelessWidget {
  const FarmScreen({super.key});

  static IconData _taskIcon(String type) => switch (type) {
        'umwagiliaji' => Icons.water_drop_outlined,
        'chanjo' => Icons.vaccines_outlined,
        'mbolea' => Icons.grass_rounded,
        'mavuno' => Icons.agriculture_rounded,
        'uondoaji' => Icons.cleaning_services_outlined,
        'uuzaji' => Icons.payments_outlined,
        _ => Icons.task_alt_rounded,
      };

  static IconData _activityIcon(String type) => switch (type) {
        'kupanda' => Icons.spa_outlined,
        'mbolea' => Icons.grass_rounded,
        'ufugaji' => Icons.pets_outlined,
        'uuzaji' => Icons.payments_outlined,
        'palizi' => Icons.cleaning_services_outlined,
        _ => Icons.event_note_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final farm = state.farm;
    final doneTasks = farm.tasks.where((t) => t.done).length;
    final progress = farm.tasks.isEmpty ? 0.0 : doneTasks / farm.tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shamba langu'),
        actions: [
          IconButton(
            tooltip: 'Hariri shamba',
            onPressed: () => pushScreen(context, const FarmRegisterScreen()),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.2,
              ),
              boxShadow: AppShadows.floating,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.verified_user_rounded,
                      color: AppColors.secondary,
                      size: 22,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Shamba Lako la ${farm.name}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.h2.copyWith(color: Colors.white),
                      ),
                    ),
                    MkPill(
                      label: farm.registered ? 'Mali Yako Imesajiliwa' : 'Haijasajiliwa',
                      foreground: farm.registered
                          ? AppColors.primaryDeep
                          : AppColors.danger,
                      background: farm.registered
                          ? AppColors.secondary
                          : AppColors.dangerSoft,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${farm.ward}, ${farm.region} · Hekta ${farm.sizeHa} za uzalishaji',
                  style: AppText.small.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Goal-gradient progress toward harvest
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.eco_rounded,
                                size: 16,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Maendeleo ya Kuelekea Mavuno',
                                style: AppText.small.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: AppText.small.copyWith(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: LinearProgressIndicator(
                          value: progress == 0.0 ? 0.25 : progress,
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Umebakiwa na hatua chache kukamilisha mzunguko wa faida ya zao lako!',
                        style: AppText.overline.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final crop in farm.crops)
                      MkPill(
                        label: 'Zao Lako: $crop',
                        foreground: AppColors.primaryDeep,
                        background: Colors.white.withValues(alpha: 0.92),
                      ),
                    for (final stock in farm.livestock)
                      MkPill(
                        label: stock,
                        icon: Icons.pets_rounded,
                        foreground: AppColors.primaryDeep,
                        background: AppColors.secondary,
                      ),
                  ],
                ),
              ],
            ),
          ),
          // Loss aversion alert banner if tasks or expenses need attention
          if (farm.tasks.any((t) => !t.done))
            Container(
              margin: const EdgeInsets.only(top: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Color(0xFF8A6205),
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kumbuka: Usalama wa Mazao Yako',
                          style: AppText.bodyStrong.copyWith(color: const Color(0xFF523B02)),
                        ),
                        Text(
                          'Kuchelewa kuweka mbolea au kupulizia dawa kunaweza kupunguza hadi 30% ya mavuno yako ya msimu!',
                          style: AppText.small.copyWith(color: const Color(0xFF523B02)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _MoneyCard(
                  label: 'Mauzo ya mwezi',
                  value: farm.monthlySales,
                  color: AppColors.success,
                  background: AppColors.successSoft,
                  icon: Icons.trending_up_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MoneyCard(
                  label: 'Gharama',
                  value: farm.totalExpenses,
                  color: AppColors.danger,
                  background: AppColors.dangerSoft,
                  icon: Icons.trending_down_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _MoneyCard(
                  label: 'Faida',
                  value: farm.estimatedProfit,
                  color: AppColors.primaryDark,
                  background: AppColors.primarySoft,
                  icon: Icons.savings_outlined,
                  signed: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Text('Kazi na kumbusho', style: AppText.h2),
              const Spacer(),
              Text(
                '$doneTasks/${farm.tasks.length} zimekamilika',
                style: AppText.small,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppColors.primarySoft,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          MkCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            shadow: AppShadows.soft,
            child: Column(
              children: [
                for (var i = 0; i < farm.tasks.length; i++)
                  _TaskRow(
                    task: farm.tasks[i],
                    showDivider: i != farm.tasks.length - 1,
                    onToggle: () => state.toggleTask(farm.tasks[i].id),
                    icon: _taskIcon(farm.tasks[i].type),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Text('Gharama za hivi karibuni', style: AppText.h2),
              const Spacer(),
              TextButton.icon(
                onPressed: () => showAppSheet(
                  context,
                  child: const _AddExpenseSheet(),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Ongeza'),
              ),
            ],
          ),
          MkCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            shadow: AppShadows.soft,
            child: Column(
              children: [
                for (var i = 0; i < farm.expenses.length; i++)
                  _ExpenseRow(
                    expense: farm.expenses[i],
                    showDivider: i != farm.expenses.length - 1,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text('Shughuli za shambani', style: AppText.h2),
              ),
              TextButton.icon(
                onPressed: () => showAppSheet(
                  context,
                  child: const _AddActivitySheet(),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Ongeza'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final activity in farm.activities)
            _ActivityRow(
              activity: activity,
              icon: _activityIcon(activity.type),
            ),
          const SizedBox(height: AppSpacing.lg),
          MkCard(
            color: AppColors.surfaceAlt,
            shadow: const [],
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 18,
                  color: AppColors.muted,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Faida ni makadirio: mauzo ya mwezi huu ukiondoa gharama zilizorekodiwa. '
                    'Rekodi gharama zote ili kupata picha sahihi.',
                    style: AppText.small,
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

class _MoneyCard extends StatelessWidget {
  const _MoneyCard({
    required this.label,
    required this.value,
    required this.color,
    required this.background,
    required this.icon,
    this.signed = false,
  });

  final String label;
  final double value;
  final Color color;
  final Color background;
  final IconData icon;
  final bool signed;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      shadow: AppShadows.soft,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(label, style: AppText.small, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(
            formatCompact(signed ? value.abs() : value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.h3.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.task,
    required this.showDivider,
    required this.onToggle,
    required this.icon,
  });

  final FarmTask task;
  final bool showDivider;
  final VoidCallback onToggle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: task.done ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: task.done ? AppColors.primary : AppColors.line,
                      width: 1.6,
                    ),
                  ),
                  child: task.done
                      ? const Icon(
                          Icons.check_rounded,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(icon, size: 17, color: AppColors.inkSoft),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.bodyStrong.copyWith(
                          color: task.done ? AppColors.muted : AppColors.ink,
                          decoration:
                              task.done ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      Text(
                        task.due,
                        style: AppText.small.copyWith(
                          color: task.done
                              ? AppColors.muted
                              : AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(),
      ],
    );
  }
}

class _ExpenseRow extends StatelessWidget {
  const _ExpenseRow({required this.expense, required this.showDivider});

  final FarmExpense expense;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.dangerSoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.receipt_long_outlined,
                  size: 17,
                  color: AppColors.danger,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(expense.title, style: AppText.bodyStrong),
                    Text(
                      '${expense.category} · ${expense.date}',
                      style: AppText.small,
                    ),
                  ],
                ),
              ),
              Text(
                formatTsh(expense.amount),
                style: AppText.label.copyWith(color: AppColors.danger),
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity, required this.icon});

  final FarmActivity activity;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, size: 17, color: AppColors.primaryDark),
              ),
              Expanded(
                child: Container(width: 2, color: AppColors.line),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(activity.title, style: AppText.bodyStrong),
                  Text(
                    '${activity.date}${activity.note == null ? '' : ' · ${activity.note}'}',
                    style: AppText.small,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddExpenseSheet extends StatefulWidget {
  const _AddExpenseSheet();

  @override
  State<_AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends State<_AddExpenseSheet> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  String _category = 'Mbolea';

  static const _categories = [
    'Mbegu',
    'Mbolea',
    'Chakula',
    'Afya',
    'Usafirishaji',
    'Kazi',
    'Nyingine',
  ];

  @override
  void dispose() {
    _title.dispose();
    _amount.dispose();
    super.dispose();
  }

  void _save() {
    final amount = double.tryParse(_amount.text.replaceAll(',', '').trim());
    if (_title.text.trim().isEmpty || amount == null || amount <= 0) {
      showAppSnack(
        context,
        'Weka jina na kiasi sahihi cha gharama',
        isError: true,
        icon: Icons.error_outline_rounded,
      );
      return;
    }
    AppScope.read(context).addExpense(
      FarmExpense(
        id: 'expense-${DateTime.now().microsecondsSinceEpoch}',
        title: _title.text.trim(),
        category: _category,
        amount: amount,
        date: todayLabel(),
      ),
    );
    Navigator.of(context).pop();
    showAppSnack(context, 'Gharama imerekodiwa');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: AppSpacing.lg),
            const SheetHeader(
              title: 'Ongeza gharama',
              subtitle: 'Rekodi gharama za shamba kwa mwezi huu',
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Maelezo ya gharama',
                hintText: 'Mfano: Mbolea ya DAP',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kiasi (TSh)',
                prefixIcon: Icon(Icons.payments_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _category,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Aina'),
              items: [
                for (final category in _categories)
                  DropdownMenuItem(value: category, child: Text(category)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _category = value);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            MkButton(label: 'Hifadhi gharama', onPressed: _save),
          ],
        ),
      ),
    );
  }
}

class _AddActivitySheet extends StatefulWidget {
  const _AddActivitySheet();

  @override
  State<_AddActivitySheet> createState() => _AddActivitySheetState();
}

class _AddActivitySheetState extends State<_AddActivitySheet> {
  final _title = TextEditingController();
  final _note = TextEditingController();
  String _type = 'kupanda';

  static const _types = [
    'kupanda',
    'mbolea',
    'palizi',
    'ufugaji',
    'uuzaji',
    'mavuno',
  ];

  @override
  void dispose() {
    _title.dispose();
    _note.dispose();
    super.dispose();
  }

  void _save() {
    if (_title.text.trim().length < 3) {
      showAppSnack(
        context,
        'Eleza shughuli uliyofanya',
        isError: true,
        icon: Icons.error_outline_rounded,
      );
      return;
    }
    AppScope.read(context).addActivity(
      FarmActivity(
        id: 'act-${DateTime.now().microsecondsSinceEpoch}',
        title: _title.text.trim(),
        date: todayLabel(),
        type: _type,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      ),
    );
    Navigator.of(context).pop();
    showAppSnack(context, 'Shughuli imeongezwa kwenye kumbukumbu');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: AppSpacing.lg),
            const SheetHeader(
              title: 'Rekodi shughuli',
              subtitle: 'Nini kimefanyika shambani leo?',
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Shughuli',
                hintText: 'Mfano: Kupalilia bustani ya mboga',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _type,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Aina'),
              items: [
                for (final type in _types)
                  DropdownMenuItem(
                    value: type,
                    child: Text(type[0].toUpperCase() + type.substring(1)),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _type = value);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _note,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Maelezo ya ziada (hiari)',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            MkButton(label: 'Hifadhi shughuli', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
