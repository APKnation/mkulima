import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../ai/ai_assistant_screen.dart';
import '../categories/categories_screen.dart';
import '../community/community_screen.dart';
import '../home/home_screen.dart';
import '../marketplace/marketplace_screen.dart';
import '../profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>
    with SingleTickerProviderStateMixin {
  int _index = 0;

  // ── AI FAB pulse animation ─────────────────────────────────────────────────
  late final AnimationController _fabController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 1.0, end: 1.10).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void _select(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(onOpenProfile: () => _select(4)),
      const CategoriesScreen(),
      const MarketplaceScreen(),
      const CommunityScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _index, children: pages),

          // ── Floating AI button ───────────────────────────────────────────
          Positioned(
            right: 16,
            bottom: 12, // right above the bottom navigation bar (Wasifu)
            child: _AiFab(pulseAnim: _pulseAnim),
          ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: SafeArea(
          top: false,
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: AppColors.surface,
              surfaceTintColor: Colors.transparent,
              indicatorColor: AppColors.primarySoft,
              labelTextStyle: WidgetStateProperty.resolveWith(
                (states) => AppText.label.copyWith(
                  fontSize: 11.5,
                  color: states.contains(WidgetState.selected)
                      ? AppColors.primaryDark
                      : AppColors.muted,
                  fontWeight: states.contains(WidgetState.selected)
                      ? FontWeight.w800
                      : FontWeight.w600,
                ),
              ),
              iconTheme: WidgetStateProperty.resolveWith(
                (states) => IconThemeData(
                  size: 24,
                  color: states.contains(WidgetState.selected)
                      ? AppColors.primaryDark
                      : AppColors.muted,
                ),
              ),
            ),
            child: NavigationBar(
              height: 66,
              selectedIndex: _index,
              onDestinationSelected: _select,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: 'Nyumbani',
                ),
                NavigationDestination(
                  icon: Icon(Icons.grid_view_outlined),
                  selectedIcon: Icon(Icons.grid_view_rounded),
                  label: 'Kategoria',
                ),
                NavigationDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront_rounded),
                  label: 'Soko',
                ),
                NavigationDestination(
                  icon: Icon(Icons.forum_outlined),
                  selectedIcon: Icon(Icons.forum_rounded),
                  label: 'Jamii',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: 'Wasifu',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Animated AI FAB ───────────────────────────────────────────────────────────

class _AiFab extends StatelessWidget {
  const _AiFab({required this.pulseAnim});

  final Animation<double> pulseAnim;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulseAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: pulseAnim.value,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF499A13), // primary green
              Color(0xFF00C49A), // turquoise
            ],
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF499A13).withValues(alpha: 0.45),
              blurRadius: 18,
              spreadRadius: 2,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(32),
            onTap: () => pushScreen(context, const AiAssistantScreen()),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _AiLogoIcon(),
                  SizedBox(width: 8),
                  Text(
                    'Uliza sasa',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom AI spark / logo icon painted with canvas
class _AiLogoIcon extends StatelessWidget {
  const _AiLogoIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 22),
      painter: _SparkPainter(),
    );
  }
}

class _SparkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Draw 4-pointed star (AI spark logo)
    final path = Path();
    const points = 4;
    final outerR = size.width * 0.5;
    final innerR = size.width * 0.18;

    for (var i = 0; i < points * 2; i++) {
      final angle = (math.pi / points) * i - math.pi / 2;
      final r = i.isEven ? outerR : innerR;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);

    // Small center circle
    canvas.drawCircle(
      Offset(cx, cy),
      size.width * 0.08,
      paint..color = const Color(0xFF00E0BA),
    );
  }

  @override
  bool shouldRepaint(_SparkPainter oldDelegate) => false;
}
