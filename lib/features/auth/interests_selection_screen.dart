import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';

class _InterestItem {
  const _InterestItem({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
}

const _interestItems = [
  _InterestItem(
    label: 'Mahindi & Nafaka',
    subtitle: 'Kilimo cha mazao ya nafaka',
    icon: Icons.grass_rounded,
    color: AppColors.primary,
  ),
  _InterestItem(
    label: 'Mboga',
    subtitle: 'Nyanya, vitunguu, kabichi',
    icon: Icons.eco_rounded,
    color: AppColors.success,
  ),
  _InterestItem(
    label: 'Matunda',
    subtitle: 'Embe, parachichi, ndizi',
    icon: Icons.park_rounded,
    color: AppColors.accent,
  ),
  _InterestItem(
    label: 'Kuku & Mayai',
    subtitle: 'Ufugaji wa kuku wa kisasa & asili',
    icon: Icons.egg_alt_rounded,
    color: AppColors.accent,
  ),
  _InterestItem(
    label: 'Mifugo',
    subtitle: "Ng'ombe, mbuzi na kondoo",
    icon: Icons.pets_rounded,
    color: AppColors.primaryDark,
  ),
  _InterestItem(
    label: 'Samaki',
    subtitle: 'Ufugaji wa samaki na uvuvi',
    icon: Icons.set_meal_rounded,
    color: AppColors.info,
  ),
  _InterestItem(
    label: 'Asali',
    subtitle: 'Ufugaji wa nyuki na asali',
    icon: Icons.hive_rounded,
    color: AppColors.accent,
  ),
  _InterestItem(
    label: 'Pembejeo',
    subtitle: 'Mbegu bora, mbolea na viuatilifu',
    icon: Icons.science_rounded,
    color: AppColors.turquoise,
  ),
  _InterestItem(
    label: 'Masoko & Bei',
    subtitle: 'Fuatilia bei na wanunuzi sokoni',
    icon: Icons.trending_up_rounded,
    color: AppColors.primary,
  ),
  _InterestItem(
    label: 'Ushauri & AI',
    subtitle: 'Msaidizi wa kilimo na wataalamu',
    icon: Icons.auto_awesome_rounded,
    color: AppColors.turquoise,
  ),
];

/// Shown right after tapping "Fungua akaunti" so the farmer can pick
/// the topics, crops, and services they love most.
class InterestsSelectionScreen extends StatefulWidget {
  const InterestsSelectionScreen({super.key, required this.phone});

  final String phone;

  @override
  State<InterestsSelectionScreen> createState() =>
      _InterestsSelectionScreenState();
}

class _InterestsSelectionScreenState extends State<InterestsSelectionScreen> {
  final Set<String> _selected = {'Mahindi & Nafaka', 'Mboga'};

  void _finish({bool skip = false}) {
    final state = AppScope.read(context);
    if (!skip) {
      state.updateProfile(
        state.user.copyWith(
          interests: _selected.isEmpty
              ? const ['Mahindi & Nafaka']
              : _selected.toList(),
        ),
      );
    }
    state.signIn(widget.phone);
    showAppSnack(context, 'Karibu Mkulima, akaunti yako imefunguliwa!');
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unachopenda zaidi'),
        actions: [
          TextButton(
            onPressed: () => _finish(skip: true),
            child: const Text('Ruka'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.sm,
                AppSpacing.page,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chagua vitu unavyopenda na vinavyokuvutia zaidi',
                    style: AppText.h2,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Tutakuonyesha mazao, bei za masoko, na ushauri unaokufaa kulingana na chaguo lako.',
                    style: AppText.body,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      'Umechagua: ${_selected.length}',
                      style: AppText.label.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  AppSpacing.xs,
                  AppSpacing.page,
                  AppSpacing.lg,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.32,
                ),
                itemCount: _interestItems.length,
                itemBuilder: (context, index) {
                  final item = _interestItems[index];
                  final selected = _selected.contains(item.label);

                  return InkWell(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _selected.remove(item.label);
                        } else {
                          _selected.add(item.label);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primarySoft
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: selected ? AppColors.primary : AppColors.line,
                          width: selected ? 2 : 1,
                        ),
                        boxShadow: selected ? AppShadows.soft : const [],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: item.color.withValues(alpha: 0.14),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.md),
                                ),
                                child: Icon(
                                  item.icon,
                                  size: 20,
                                  color: item.color,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                selected
                                    ? Icons.check_circle_rounded
                                    : Icons.circle_outlined,
                                size: 20,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.line,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            item.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.bodyStrong.copyWith(
                              color: selected
                                  ? AppColors.primaryDeep
                                  : AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.small.copyWith(fontSize: 11.5),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.sm,
                AppSpacing.page,
                AppSpacing.xl,
              ),
              child: MkButton(
                label: 'Endelea na anza',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: _selected.isEmpty ? null : () => _finish(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
