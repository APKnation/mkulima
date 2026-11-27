import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/business_tools.dart';
import '../../data/seed/business_tools_seed.dart';

class AgriLogisticsScreen extends StatefulWidget {
  const AgriLogisticsScreen({super.key});

  @override
  State<AgriLogisticsScreen> createState() => _AgriLogisticsScreenState();
}

class _AgriLogisticsScreenState extends State<AgriLogisticsScreen> {
  int _tabIndex = 0; // 0 = Usafirishaji, 1 = Maghala

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usafirishaji na Maghala'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          // Banner
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
                  Icons.local_shipping_rounded,
                  color: AppColors.secondary,
                  size: 28,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usafiri wa Mazao na Hifadhi Salama',
                        style: AppText.bodyStrong.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Ungana na malori ya kubeba mazao kutoka shambani kwenda sokoni na maghala salama ya kuhifadhia.',
                        style: AppText.small.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Tabs
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Madereva & Malori')),
                  selected: _tabIndex == 0,
                  onSelected: (_) => setState(() => _tabIndex = 0),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: ChoiceChip(
                  label: const Center(child: Text('Maghala & Hifadhi')),
                  selected: _tabIndex == 1,
                  onSelected: (_) => setState(() => _tabIndex = 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          if (_tabIndex == 0) ...[
            Text('Wasafirishaji Waliothibitishwa (${initialLogisticsSeed.length})', style: AppText.h3),
            const SizedBox(height: AppSpacing.md),
            for (final trans in initialLogisticsSeed) ...[
              _TransporterCard(transporter: trans),
              const SizedBox(height: AppSpacing.md),
            ],
          ] else ...[
            Text('Maghala ya Nafaka na Cold Storage (${initialWarehousesSeed.length})', style: AppText.h3),
            const SizedBox(height: AppSpacing.md),
            for (final wh in initialWarehousesSeed) ...[
              _WarehouseCard(warehouse: wh),
              const SizedBox(height: AppSpacing.md),
            ],
          ],
        ],
      ),
    );
  }
}

class _TransporterCard extends StatelessWidget {
  const _TransporterCard({required this.transporter});

  final LogisticsTransporter transporter;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      shadow: AppShadows.soft,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(transporter.name, style: AppText.h3)),
                        if (transporter.verified)
                          const Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
                      ],
                    ),
                    Text(
                      '${transporter.vehicleType} · Kituo: ${transporter.baseRegion}',
                      style: AppText.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final route in transporter.routes)
                MkPill(
                  label: route,
                  foreground: AppColors.primaryDeep,
                  background: AppColors.primarySoft,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Gharama: ${transporter.rateDescription}',
            style: AppText.bodyStrong.copyWith(color: AppColors.ink),
          ),
          const Divider(height: AppSpacing.lg),
          MkButton(
            label: 'Wasiliana na Dereva (${transporter.phone})',
            icon: Icons.phone_rounded,
            height: 44,
            onPressed: () {
              showAppSnack(
                context,
                'Inapiga simu kwa dereva ${transporter.name}: ${transporter.phone}',
                icon: Icons.phone_in_talk_rounded,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WarehouseCard extends StatelessWidget {
  const _WarehouseCard({required this.warehouse});

  final AgriWarehouse warehouse;

  @override
  Widget build(BuildContext context) {
    return MkCard(
      shadow: AppShadows.soft,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.turquoiseSoft,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.warehouse_rounded,
                  color: Color(0xFF00806A),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(warehouse.name, style: AppText.h3)),
                        if (warehouse.verified)
                          const Icon(Icons.verified_rounded, size: 16, color: AppColors.primary),
                      ],
                    ),
                    Text(
                      '${warehouse.type} · ${warehouse.district}, ${warehouse.region}',
                      style: AppText.small,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Uwezo: Gunia ${warehouse.capacityBags} · Bei: ${formatTsh(warehouse.pricePerBagPerMonth)} / gunia kwa mwezi',
            style: AppText.bodyStrong.copyWith(color: AppColors.primaryDark),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final feat in warehouse.features)
                MkPill(
                  label: feat,
                  foreground: AppColors.inkSoft,
                  background: AppColors.surfaceAlt,
                ),
            ],
          ),
          const Divider(height: AppSpacing.lg),
          MkButton(
            label: 'Hifadhi Mzigo / Wasiliana (${warehouse.phone})',
            icon: Icons.phone_rounded,
            height: 44,
            onPressed: () {
              showAppSnack(
                context,
                'Inapiga simu kwa wasimamizi wa ghala: ${warehouse.phone}',
                icon: Icons.phone_in_talk_rounded,
              );
            },
          ),
        ],
      ),
    );
  }
}
