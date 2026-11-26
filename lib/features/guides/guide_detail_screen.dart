import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/mk_image.dart';
import '../../data/models/guide.dart';

class GuideDetailScreen extends StatefulWidget {
  const GuideDetailScreen({super.key, required this.guide});

  final FarmingGuide guide;

  @override
  State<GuideDetailScreen> createState() => _GuideDetailScreenState();
}

class _GuideDetailScreenState extends State<GuideDetailScreen> {
  bool _saved = true;

  @override
  Widget build(BuildContext context) {
    final guide = widget.guide;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 230,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  MkImage(asset: guide.imageAsset),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.22),
                          Colors.black.withValues(alpha: 0.62),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.page),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _CircleButton(
                                icon: Icons.arrow_back_rounded,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              const Spacer(),
                              _CircleButton(
                                icon: _saved
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_border_rounded,
                                onTap: () {
                                  setState(() => _saved = !_saved);
                                  showAppSnack(
                                    context,
                                    _saved
                                        ? 'Mwongozo umehifadhiwa kwa matumizi bila mtandao'
                                        : 'Umwongozo umeondolewa kwenye kifaa',
                                  );
                                },
                              ),
                            ],
                          ),
                          const Spacer(),
                          MkPill(
                            label: guide.season,
                            icon: Icons.calendar_month_rounded,
                            foreground: AppColors.primaryDeep,
                            background: AppColors.secondary,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            guide.title,
                            style: AppText.h1.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: [
                      MkPill(
                        label: 'Dakika ${guide.minutes}',
                        icon: Icons.schedule_rounded,
                      ),
                      MkPill(
                        label: guide.level,
                        icon: Icons.signal_cellular_alt_rounded,
                        foreground: AppColors.info,
                        background: AppColors.infoSoft,
                      ),
                      if (guide.offlineReady) const OfflineChip(),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(guide.summary, style: AppText.body),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: [
                      const Icon(
                        Icons.list_alt_rounded,
                        size: 20,
                        color: AppColors.primaryDark,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text('Hatua za kufuata', style: AppText.h2),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (var i = 0; i < guide.steps.length; i++)
                    _StepRow(
                      number: i + 1,
                      step: guide.steps[i],
                      isLast: i == guide.steps.length - 1,
                    ),
                  const SizedBox(height: AppSpacing.xl),
                  MkCard(
                    color: AppColors.accentSoft,
                    borderColor: const Color(0xFFF2E2B4),
                    shadow: AppShadows.soft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.tips_and_updates_rounded,
                              color: Color(0xFF8A6205),
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Vidokezo vya ziada',
                              style: AppText.h3.copyWith(
                                color: const Color(0xFF6A4A05),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        for (final tip in guide.tips)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  '•  ',
                                  style: TextStyle(
                                    color: Color(0xFF8A6205),
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    tip,
                                    style: AppText.body.copyWith(
                                      color: const Color(0xFF5C4305),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  MkCard(
                    shadow: AppShadows.soft,
                    child: Row(
                      children: [
                        const FarmerAvatar(
                          initials: 'W',
                          size: 42,
                          icon: Icons.verified_user_rounded,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(guide.author, style: AppText.bodyStrong),
                              const SizedBox(height: 2),
                              Text(
                                'Imeandaliwa na wataalamu wa kilimo',
                                style: AppText.small,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  MkButton(
                    label: _saved
                        ? 'Imehifadhiwa kwa matumizi bila mtandao'
                        : 'Hifadhi mwongozo huu',
                    icon: _saved
                        ? Icons.download_done_rounded
                        : Icons.download_rounded,
                    variant: _saved
                        ? MkButtonVariant.soft
                        : MkButtonVariant.primary,
                    onPressed: () {
                      setState(() => _saved = !_saved);
                      showAppSnack(
                        context,
                        _saved
                            ? 'Mwongozo umehifadhiwa'
                            : 'Umwongozo umeondolewa',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 21, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.step,
    required this.isLast,
  });

  final int number;
  final GuideStep step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: AppText.label.copyWith(color: Colors.white),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.line),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(step.title, style: AppText.h3),
                  const SizedBox(height: 3),
                  Text(step.body, style: AppText.body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
