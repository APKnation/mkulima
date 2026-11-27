import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/mk_button.dart';

class _Slide {
  const _Slide({
    required this.imageAsset,
    required this.icon,
    required this.secondaryIcon,
    required this.gradient,
    required this.title,
    required this.body,
  });

  final String imageAsset;
  final IconData icon;
  final IconData secondaryIcon;
  final Gradient gradient;
  final String title;
  final String body;
}

const _slides = [
  _Slide(
    imageAsset: 'assets/images/mkulima1.jpg',
    icon: Icons.storefront_rounded,
    secondaryIcon: Icons.local_shipping_rounded,
    gradient: AppColors.heroGradient,
    title: 'Uza mazao yako moja kwa moja',
    body:
        'Fikia wanunuzi, wakulima na vyama vya ushirika kote Tanzania bila dalali. '
        'Weka tangazo lako kwa dakika mbili tu.',
  ),
  _Slide(
    imageAsset: 'assets/images/mkulima2.jpg',
    icon: Icons.trending_up_rounded,
    secondaryIcon: Icons.insights_rounded,
    gradient: AppColors.goldGradient,
    title: 'Fahamu bei za soko kwa wakati',
    body:
        'Bei za mahindi, nyanya, mifugo na zaidi kutoka masoko mbalimbali, '
        'pamoja na mwenendo wa bei na vyanzo vilivyothibitishwa.',
  ),
  _Slide(
    imageAsset: 'assets/images/mkulima3.jpg',
    icon: Icons.menu_book_rounded,
    secondaryIcon: Icons.cloud_off_rounded,
    gradient: AppColors.turquoiseGradient,
    title: 'Jifunze kilimo bora kila siku',
    body:
        'Miongozo ya hatua kwa hatua, ushauri wa wataalamu na jamii ya wakulima '
        '— inapatikana hata bila mtandao.',
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_index == _slides.length - 1) {
      AppScope.read(context).completeOnboarding();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _slides.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  AppScope.read(context).completeOnboarding();
                },
                child: const Text('Ruka'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) => _SlideView(slide: _slides[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                AppSpacing.sm,
                AppSpacing.page,
                AppSpacing.xxl,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var i = 0; i < _slides.length; i++)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          height: 7,
                          width: i == _index ? 26 : 7,
                          decoration: BoxDecoration(
                            color: i == _index
                                ? AppColors.primary
                                : AppColors.line,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  MkButton(
                    label: isLast ? 'Anza sasa' : 'Endelea',
                    trailingIcon: Icons.arrow_forward_rounded,
                    onPressed: _next,
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

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.xxl),
              decoration: BoxDecoration(
                gradient: slide.gradient,
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                boxShadow: AppShadows.floating,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.xxl),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      slide.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.10),
                            Colors.black.withValues(alpha: 0.55),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 18,
                      left: 18,
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.90),
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.soft,
                        ),
                        child: Icon(
                          slide.icon,
                          size: 24,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 18,
                      right: 18,
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.card,
                        ),
                        child: Icon(
                          slide.secondaryIcon,
                          size: 20,
                          color: AppColors.primaryDeep,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Text(slide.title, style: AppText.display),
          const SizedBox(height: AppSpacing.md),
          Text(slide.body, style: AppText.body),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
