import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/mk_image.dart';
import '../../data/models/user.dart';
import '../../data/seed/misc_seed.dart';
import '../calculator/crop_calculator_screen.dart';
import '../calendar/farm_calendar_screen.dart';
import '../diagnosis/pest_diagnosis_screen.dart';
import '../directory/agro_directory_screen.dart';
import '../farm/farm_screen.dart';
import '../marketplace/create_listing_screen.dart';
import '../marketplace/my_listings_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final user = state.user;
    final farm = state.farm;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.page,
            AppSpacing.lg,
            AppSpacing.page,
            AppSpacing.xxxl,
          ),
          children: [
            Row(
              children: [
                Text('Wasifu', style: AppText.display),
                const Spacer(),
                MkIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: 'Mipangilio',
                  onTap: () => pushScreen(context, const SettingsScreen()),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: AppShadows.floating,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      FarmerAvatar(
                        initials: initialsOf(user.name),
                        size: 62,
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppText.h2.copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.role,
                              style: AppText.small.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(
                                  Icons.place_rounded,
                                  size: 13,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    '${user.ward}, ${user.region}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppText.small.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      if (user.verified)
                        const MkPill(
                          label: 'Amethibitishwa',
                          icon: Icons.verified_rounded,
                          foreground: AppColors.primaryDeep,
                          background: AppColors.secondary,
                        ),
                      const SizedBox(width: AppSpacing.sm),
                      MkPill(
                        label: 'Mwanachama ${user.joined}',
                        foreground: Colors.white,
                        background: Colors.white.withValues(alpha: 0.16),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => showAppSheet(
                          context,
                          child: _EditProfileSheet(user: user),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(0, 32),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 15),
                            SizedBox(width: 4),
                            Text(
                              'Hariri',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '${state.myListings.length}',
                    label: 'Bidhaa zangu',
                    icon: Icons.inventory_2_outlined,
                    color: AppColors.accent,
                    onTap: () =>
                        pushScreen(context, const MyListingsScreen()),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _StatCard(
                    value: '${state.favoriteCount}',
                    label: 'Vipendwa',
                    icon: Icons.favorite_border_rounded,
                    color: AppColors.danger,
                    onTap: () => pushScreen(context, const FavoritesScreen()),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _StatCard(
                    value: '${state.unreadNotifications}',
                    label: 'Arifa mpya',
                    icon: Icons.notifications_none_rounded,
                    color: AppColors.success,
                    onTap: () =>
                        pushScreen(context, const NotificationsScreen()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Shughuli zangu', style: AppText.h2),
            const SizedBox(height: AppSpacing.sm),
            MkCard(
              shadow: AppShadows.soft,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  _MenuTile(
                    icon: Icons.calculate_outlined,
                    color: AppColors.accent,
                    title: 'Kikokotoo cha Faida',
                    subtitle: 'Hesabu gharama na faida tarajiwa ya kilimo',
                    onTap: () => pushScreen(context, const CropCalculatorScreen()),
                  ),
                  const Divider(),
                  _MenuTile(
                    icon: Icons.bug_report_outlined,
                    color: AppColors.danger,
                    title: 'Utambuzi wa Magonjwa',
                    subtitle: 'Dalili, tiba asili na dawa za kilimo',
                    onTap: () => pushScreen(context, const PestDiagnosisScreen()),
                  ),
                  const Divider(),
                  _MenuTile(
                    icon: Icons.calendar_month_outlined,
                    color: AppColors.primaryDark,
                    title: 'Kalenda ya Shamba',
                    subtitle: 'Ratiba ya mbolea, palizi na mavuno',
                    onTap: () => pushScreen(context, const FarmCalendarScreen()),
                  ),
                  const Divider(),
                  _MenuTile(
                    icon: Icons.storefront_outlined,
                    color: AppColors.info,
                    title: 'Wauzaji & Maafisa Ugani',
                    subtitle: 'Wataalamu na maduka ya pembejeo',
                    onTap: () => pushScreen(context, const AgroDirectoryScreen()),
                  ),
                  const Divider(),
                  _MenuTile(
                    icon: Icons.agriculture_rounded,
                    color: AppColors.primary,
                    title: 'Shamba langu',
                    subtitle:
                        '${farm.name} · Hekta ${farm.sizeHa}',
                    onTap: () => pushScreen(context, const FarmScreen()),
                  ),
                  const Divider(),
                  _MenuTile(
                    icon: Icons.inventory_2_outlined,
                    color: AppColors.accent,
                    title: 'Bidhaa zangu',
                    subtitle: '${state.myListings.length} zimetangazwa',
                    onTap: () =>
                        pushScreen(context, const MyListingsScreen()),
                  ),
                  const Divider(),
                  _MenuTile(
                    icon: Icons.add_business_outlined,
                    color: AppColors.info,
                    title: 'Tangaza bidhaa mpya',
                    subtitle: 'Weka zao lako sokoni',
                    onTap: () =>
                        pushScreen(context, const CreateListingScreen()),
                  ),
                  const Divider(),
                  _MenuTile(
                    icon: Icons.favorite_border_rounded,
                    color: AppColors.danger,
                    title: 'Vipendwa',
                    subtitle: 'Bidhaa ulizohifadhi',
                    onTap: () => pushScreen(context, const FavoritesScreen()),
                  ),
                  const Divider(),
                  _MenuTile(
                    icon: Icons.notifications_none_rounded,
                    color: AppColors.success,
                    title: 'Arifa',
                    subtitle: '${state.unreadNotifications} hazijasomwa',
                    onTap: () =>
                        pushScreen(context, const NotificationsScreen()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Akaunti', style: AppText.h2),
            const SizedBox(height: AppSpacing.sm),
            MkCard(
              shadow: AppShadows.soft,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  _MenuTile(
                    icon: Icons.interests_outlined,
                    color: AppColors.primary,
                    title: 'Maslahi yangu',
                    subtitle: user.interests.join(' · '),
                    onTap: () => showAppSnack(
                      context,
                      'Maslahi: ${user.interests.join(', ')}',
                    ),
                  ),
                  const Divider(),
                  _MenuTile(
                    icon: Icons.settings_outlined,
                    color: AppColors.muted,
                    title: 'Mipangilio',
                    subtitle: 'Lugha, arifa na faragha',
                    onTap: () => pushScreen(context, const SettingsScreen()),
                  ),
                  const Divider(),
                  _MenuTile(
                    icon: Icons.help_outline_rounded,
                    color: AppColors.info,
                    title: 'Msaada',
                    subtitle: 'Maswali yanayoulizwa mara kwa mara',
                    onTap: () => showAppSheet(
                      context,
                      child: const _HelpSheet(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            MkButton(
              label: 'Toka kwenye akaunti',
              icon: Icons.logout_rounded,
              variant: MkButtonVariant.danger,
              onPressed: () async {
                final confirmed = await showConfirmDialog(
                  context,
                  title: 'Toka kwenye akaunti?',
                  message:
                      'Utahitaji kuingia tena kwa namba yako ya simu ili kuendelea.',
                  confirmLabel: 'Toka',
                  destructive: true,
                );
                if (confirmed && context.mounted) {
                  AppScope.read(context).signOut();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Center(
              child: Text(
                'Mkulima App · Toleo 1.0.0',
                style: AppText.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      onTap: onTap,
      shadow: AppShadows.soft,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.md,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: AppText.h2.copyWith(color: AppColors.primaryDark),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppText.small,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 2),
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
      title: Text(title, style: AppText.bodyStrong),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppText.small,
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.muted,
        size: 20,
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({required this.user});

  final UserProfile user;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final _name = TextEditingController(text: widget.user.name);
  late final _phone = TextEditingController(text: widget.user.phone);
  late final _email = TextEditingController(text: widget.user.email);
  late String _region = widget.user.region;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
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
              title: 'Hariri wasifu',
              subtitle: 'Taarifa zako zinaonekana kwa wauzaji na wanunuzi',
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Jina kamili'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Namba ya simu'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Barua pepe'),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: regionsSeed.contains(_region)
                  ? _region
                  : regionsSeed.first,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Mkoa'),
              items: [
                for (final region in regionsSeed)
                  DropdownMenuItem(value: region, child: Text(region)),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _region = value);
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            MkButton(
              label: 'Hifadhi mabadiliko',
              onPressed: () {
                if (_name.text.trim().length < 3) {
                  showAppSnack(
                    context,
                    'Jina linahitajika',
                    isError: true,
                    icon: Icons.error_outline_rounded,
                  );
                  return;
                }
                AppScope.read(context).updateProfile(
                  widget.user.copyWith(
                    name: _name.text.trim(),
                    phone: _phone.text.trim(),
                    email: _email.text.trim(),
                    region: _region,
                  ),
                );
                Navigator.of(context).pop();
                showAppSnack(context, 'Wasifu umehifadhiwa');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpSheet extends StatelessWidget {
  const _HelpSheet();

  static const _faqs = [
    (
      'Jinsi ya kutangaza bidhaa?',
      'Nenda kwenye kichupo cha Soko kisha gusa "Tangaza bidhaa". Weka taarifa sahihi ili wanunuzi wakupate.'
    ),
    (
      'Bei za soko zinatoka wapi?',
      'Bei zilizothibitishwa hutoka kwa maafisa wa soko. Bei elekezi zinaonyeshwa waziwazi na hazipaswi kuchukuliwa kama bei rasmi.'
    ),
    (
      'Naweza kutumia bila mtandao?',
      'Miongozo ya kilimo inahifadhiwa kwenye kifaa. Bidhaa na bei zinahitaji mtandao ili kupata taarifa mpya.'
    ),
    (
      'Jinsi ya kuwasiliana na msaada?',
      'Tuma barua pepe kwa msaada@mkulima.co.tz au piga 0800 123 456 (bila malipo).'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
            title: 'Msaada',
            subtitle: 'Majibu ya maswali yanayoulizwa mara kwa mara',
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final (question, answer) in _faqs)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: MkCard(
                shadow: AppShadows.soft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(question, style: AppText.bodyStrong),
                    const SizedBox(height: 4),
                    Text(answer, style: AppText.small),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
