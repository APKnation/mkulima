import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
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

class _MainShellState extends State<MainShell> {
  int _index = 0;

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
      body: IndexedStack(index: _index, children: pages),
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
