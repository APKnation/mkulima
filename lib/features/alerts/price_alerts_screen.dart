import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/business_tools.dart';
import '../../data/seed/business_tools_seed.dart';

class PriceAlertsScreen extends StatefulWidget {
  const PriceAlertsScreen({super.key});

  @override
  State<PriceAlertsScreen> createState() => _PriceAlertsScreenState();
}

class _PriceAlertsScreenState extends State<PriceAlertsScreen> {
  late List<PriceWatchAlert> _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = List.from(initialPriceAlertsSeed);
  }

  void _toggleAlert(int index) {
    setState(() {
      final a = _alerts[index];
      _alerts[index] = PriceWatchAlert(
        id: a.id,
        cropName: a.cropName,
        market: a.market,
        targetPrice: a.targetPrice,
        condition: a.condition,
        currentPrice: a.currentPrice,
        active: !a.active,
      );
    });
    showAppSnack(
      context,
      _alerts[index].active ? 'Arifa imewashwa' : 'Arifa imezimwa',
    );
  }

  void _addNewAlert() {
    showAppSheet(
      context,
      child: _NewAlertSheet(
        onAdded: (newAlert) {
          setState(() => _alerts.add(newAlert));
          showAppSnack(
            context,
            'Arifa ya ${newAlert.cropName} imeongezwa',
            icon: Icons.notifications_active_rounded,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arifa za Bei za Masoko'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add-price-alert-fab',
        onPressed: _addNewAlert,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_alert_rounded),
        label: const Text('Weka Arifa'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          100,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: AppShadows.soft,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.secondary,
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ufuatiliaji wa Bei (Smart Radar)',
                        style: AppText.bodyStrong.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pata arifa papo hapo bei ya zao lako inapofikia kiasi unachotaka kuuzia.',
                        style: AppText.small.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          Text('Arifa Zangu za Bei (${_alerts.length})', style: AppText.h2),
          const SizedBox(height: AppSpacing.md),

          for (var i = 0; i < _alerts.length; i++) ...[
            _AlertCard(
              alert: _alerts[i],
              onToggle: () => _toggleAlert(i),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert, required this.onToggle});

  final PriceWatchAlert alert;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      shadow: AppShadows.soft,
      color: alert.active ? AppColors.surface : AppColors.surfaceAlt,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: alert.active ? AppColors.successSoft : AppColors.mutedSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_active_rounded,
              color: alert.active ? AppColors.success : AppColors.muted,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(alert.cropName, style: AppText.h3),
                    Switch(
                      value: alert.active,
                      activeColor: AppColors.primary,
                      onChanged: (_) => onToggle(),
                    ),
                  ],
                ),
                Text(alert.market, style: AppText.small),
                const SizedBox(height: 6),
                Row(
                  children: [
                    MkPill(
                      label: 'Lengo: ${alert.condition} ${formatTsh(alert.targetPrice)}',
                      foreground: AppColors.primaryDark,
                      background: AppColors.primarySoft,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Bei ya sasa sokoni: ${formatTsh(alert.currentPrice)}',
                  style: AppText.small.copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewAlertSheet extends StatefulWidget {
  const _NewAlertSheet({required this.onAdded});

  final ValueChanged<PriceWatchAlert> onAdded;

  @override
  State<_NewAlertSheet> createState() => _NewAlertSheetState();
}

class _NewAlertSheetState extends State<_NewAlertSheet> {
  final _cropName = TextEditingController(text: 'Mahindi');
  final _market = TextEditingController(text: 'Soko Kuu la Kariakoo, Dar');
  final _targetPrice = TextEditingController(text: '75000');
  String _condition = 'inapozidi';

  @override
  void dispose() {
    _cropName.dispose();
    _market.dispose();
    _targetPrice.dispose();
    super.dispose();
  }

  void _save() {
    final price = double.tryParse(_targetPrice.text.replaceAll(',', '').trim()) ?? 0;
    if (_cropName.text.trim().isEmpty || price <= 0) {
      showAppSnack(context, 'Weka jina la zao na bei sahihi', isError: true);
      return;
    }

    final alert = PriceWatchAlert(
      id: 'alert-${DateTime.now().microsecondsSinceEpoch}',
      cropName: _cropName.text.trim(),
      market: _market.text.trim(),
      targetPrice: price,
      condition: _condition,
      currentPrice: price * 0.92,
      active: true,
    );

    widget.onAdded(alert);
    Navigator.of(context).pop();
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
              title: 'Weka Arifa Mpya ya Bei',
              subtitle: 'Chagua zao, soko na kiasi unachotaka kuarifiwa',
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _cropName,
              decoration: const InputDecoration(labelText: 'Zao (k.m. Mahindi, Nyanya)'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _market,
              decoration: const InputDecoration(labelText: 'Soko Linalofuatiliwa'),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _condition,
              decoration: const InputDecoration(labelText: 'Niarifu bei ikiwa:'),
              items: const [
                DropdownMenuItem(value: 'inapozidi', child: Text('Inapozidi (Bei ikipanda)')),
                DropdownMenuItem(value: 'inapopungua', child: Text('Inapopungua (Bei ikishuka)')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _condition = val);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _targetPrice,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Kiwango cha Bei (Tsh)'),
            ),
            const SizedBox(height: AppSpacing.xl),
            MkButton(
              label: 'Hifadhi Arifa ya Bei',
              icon: Icons.check_rounded,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
