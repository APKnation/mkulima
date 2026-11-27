import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _priceAlerts = true;
  bool _weatherAlerts = true;
  bool _communityUpdates = false;
  bool _dataSaver = false;
  String _language = 'Kiswahili';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mipangilio')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          Text('Arifa', style: AppText.h2),
          const SizedBox(height: AppSpacing.sm),
          MkCard(
            shadow: AppShadows.soft,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                SwitchListTile(
                  value: _priceAlerts,
                  onChanged: (value) => setState(() => _priceAlerts = value),
                  contentPadding: EdgeInsets.zero,
                  title: Text('Arifa za bei', style: AppText.bodyStrong),
                  subtitle: Text(
                    'Bei za mazao yako zinapobadilika',
                    style: AppText.small,
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  value: _weatherAlerts,
                  onChanged: (value) => setState(() => _weatherAlerts = value),
                  contentPadding: EdgeInsets.zero,
                  title: Text('Arifa za hali ya hewa', style: AppText.bodyStrong),
                  subtitle: Text(
                    'Mvua, joto na tahadhari za shambani',
                    style: AppText.small,
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  value: _communityUpdates,
                  onChanged: (value) =>
                      setState(() => _communityUpdates = value),
                  contentPadding: EdgeInsets.zero,
                  title: Text('Majibu ya jamii', style: AppText.bodyStrong),
                  subtitle: Text(
                    'Wakati mtu anajibu swali lako',
                    style: AppText.small,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Lugha na data', style: AppText.h2),
          const SizedBox(height: AppSpacing.sm),
          MkCard(
            shadow: AppShadows.soft,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.translate_rounded,
                    color: AppColors.primaryDark,
                  ),
                  title: Text('Lugha', style: AppText.bodyStrong),
                  subtitle: Text(_language, style: AppText.small),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.muted,
                  ),
                  onTap: () async {
                    final selected = await showAppSheet<String>(
                      context,
                      child: _LanguageSheet(current: _language),
                    );
                    if (!context.mounted || selected == null) return;
                    setState(() => _language = selected);
                    showAppSnack(context, 'Lugha imebadilishwa: $selected');
                  },
                ),
                const Divider(),
                SwitchListTile(
                  value: _dataSaver,
                  onChanged: (value) => setState(() => _dataSaver = value),
                  contentPadding: EdgeInsets.zero,
                  title: Text('Hifadhi data', style: AppText.bodyStrong),
                  subtitle: Text(
                    'Pakia picha zenye ubora wa chini',
                    style: AppText.small,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Kuhusu', style: AppText.h2),
          const SizedBox(height: AppSpacing.sm),
          MkCard(
            shadow: AppShadows.soft,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.agriculture_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text('Mkulima App', style: AppText.bodyStrong),
                  subtitle: Text('Toleo 1.0.0', style: AppText.small),
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: AppColors.muted,
                  ),
                  title: Text('Sera ya faragha', style: AppText.bodyStrong),
                  trailing: const Icon(
                    Icons.open_in_new_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                  onTap: () => showAppSnack(
                    context,
                    'Sera ya faragha itafunguka kwenye kivinjari',
                    icon: Icons.open_in_new_rounded,
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
        ],
      ),
    );
  }
}

class _LanguageSheet extends StatelessWidget {
  const _LanguageSheet({required this.current});

  final String current;

  @override
  Widget build(BuildContext context) {
    const languages = ['Kiswahili', 'English'];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const SizedBox(height: AppSpacing.lg),
            const SheetHeader(
              title: 'Chagua lugha',
              subtitle: 'Kiswahili ni lugha kuu ya Mkulima App',
            ),
            const SizedBox(height: AppSpacing.sm),
            for (final language in languages)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(language, style: AppText.bodyStrong),
                trailing: language == current
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
                      )
                    : null,
                onTap: () => Navigator.of(context).pop(language),
              ),
          ],
        ),
      ),
    );
  }
}
