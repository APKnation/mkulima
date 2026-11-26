import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/badges.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/market_price.dart';
import 'price_widgets.dart';

class PricesScreen extends StatefulWidget {
  const PricesScreen({super.key});

  @override
  State<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  String? _categoryId;
  String? _region;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final all = state.repo.prices;
    final categories = state.repo.categories
        .where((c) => all.any((p) => p.categoryId == c.id))
        .toList();
    final regions = all.map((p) => p.region).toSet().toList()..sort();

    final filtered = all
        .where((p) =>
            (_categoryId == null || p.categoryId == _categoryId) &&
            (_region == null || p.region == _region))
        .toList();

    final groups = <String, List<MarketPrice>>{};
    for (final price in filtered) {
      groups.putIfAbsent('${price.commodity}|${price.unit}', () => []).add(price);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bei za soko'),
        actions: [
          PopupMenuButton<String?>(
            tooltip: 'Chagua mkoa',
            onSelected: (value) => setState(() => _region = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('Mikoa yote')),
              for (final region in regions)
                PopupMenuItem(value: region, child: Text(region)),
            ],
            child: Container(
              margin: const EdgeInsets.only(right: AppSpacing.lg),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.place_outlined,
                    size: 16,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _region ?? 'Mikoa yote',
                    style: AppText.label.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          MkCard(
            color: AppColors.infoSoft,
            borderColor: const Color(0xFFCFE6F5),
            shadow: AppShadows.soft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.info,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bei elekezi, si bei za mazungumzo ya moja kwa moja',
                        style: AppText.label.copyWith(color: AppColors.info),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Bei zilizothibitishwa zinaonyeshwa kwa alama ya kuthibitishwa. '
                        'Bei elekezi ni makadirio na hazipaswi kutumiwa kama bei rasmi.',
                        style: AppText.small,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: FilterChip(
                    label: const Text('Zote'),
                    selected: _categoryId == null,
                    onSelected: (_) => setState(() => _categoryId = null),
                  ),
                ),
                for (final category in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: FilterChip(
                      label: Text(category.name),
                      selected: _categoryId == category.id,
                      onSelected: (_) =>
                          setState(() => _categoryId = category.id),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (groups.isEmpty)
            const _EmptyPrices()
          else
            for (final entries in groups.values) ...[
              _CommodityCard(prices: entries),
              const SizedBox(height: AppSpacing.md),
            ],
        ],
      ),
    );
  }
}

class _CommodityCard extends StatelessWidget {
  const _CommodityCard({required this.prices});

  final List<MarketPrice> prices;

  @override
  Widget build(BuildContext context) {
    final lead = prices.first;
    final others = prices.skip(1).toList();
    return MkCard(
      shadow: AppShadows.soft,
      onTap: () => showAppSheet(
        context,
        child: _PriceDetailSheet(prices: prices),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: const Icon(
                  Icons.eco_rounded,
                  color: AppColors.primaryDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            lead.commodity,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.h3,
                          ),
                        ),
                        if (!lead.isVerified || lead.isIndicative) ...[
                          const SizedBox(width: 6),
                          MkPill(
                            label: lead.sourceLabel,
                            foreground: AppColors.muted,
                            background: AppColors.surfaceAlt,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${lead.market} · ${lead.region}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.small,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatTsh(lead.retail),
                    style: AppText.h3.copyWith(
                      color: AppColors.primaryDark,
                      fontSize: 15,
                    ),
                  ),
                  Text('kwa ${lead.unit}', style: AppText.small),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              ChangeBadge(percent: lead.changePercent),
              const SizedBox(width: AppSpacing.sm),
              if (prices.length > 1)
                Text(
                  'Maeneo ${prices.length}',
                  style: AppText.small,
                ),
              const Spacer(),
              Sparkline(values: lead.trend, width: 74, height: 28),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.muted,
              ),
            ],
          ),
          if (others.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(
                  Icons.compare_arrows_rounded,
                  size: 14,
                  color: AppColors.muted,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    others
                        .take(2)
                        .map((p) => '${p.region} ${formatTsh(p.retail)}')
                        .join('  ·  '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.small,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PriceDetailSheet extends StatelessWidget {
  const _PriceDetailSheet({required this.prices});

  final List<MarketPrice> prices;

  @override
  Widget build(BuildContext context) {
    final lead = prices.first;
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
          SheetHeader(
            title: lead.commodity,
            subtitle: '${lead.commodityEn} · kwa ${lead.unit}',
          ),
          const SizedBox(height: AppSpacing.lg),
          MkCard(
            color: AppColors.surfaceAlt,
            shadow: const [],
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Mwenendo wa bei', style: AppText.label),
                    const Spacer(),
                    Text('Imesasishwa ${lead.updatedOn}', style: AppText.small),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Sparkline(
                  values: lead.trend,
                  width: double.infinity,
                  height: 64,
                  color: lead.changePercent >= 0
                      ? AppColors.success
                      : AppColors.danger,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Siku 6 zilizopita', style: AppText.small),
                    Text('Leo', style: AppText.small),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Ulinganisho wa maeneo', style: AppText.h3),
          const SizedBox(height: AppSpacing.sm),
          for (final price in prices) ...[
            MkCard(
              shadow: AppShadows.soft,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(price.market, style: AppText.bodyStrong),
                            Text(price.region, style: AppText.small),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatTsh(price.retail),
                            style: AppText.h3.copyWith(
                              color: AppColors.primaryDark,
                            ),
                          ),
                          Text(
                            'Jumla ${formatTsh(price.wholesale)}',
                            style: AppText.small,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      ChangeBadge(percent: price.changePercent),
                      const SizedBox(width: AppSpacing.sm),
                      MkPill(
                        label: price.sourceLabel,
                        icon: price.isVerified
                            ? Icons.verified_rounded
                            : Icons.schedule_rounded,
                        foreground: price.isVerified
                            ? AppColors.success
                            : AppColors.muted,
                        background: price.isVerified
                            ? AppColors.successSoft
                            : AppColors.surfaceAlt,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Bei hizi ni za mwongozo. Hakikisha unathibitisha na mnunuzi au '
            'afisa wa soko kabla ya kufanya malipo.',
            style: AppText.small,
          ),
        ],
      ),
    );
  }
}

class _EmptyPrices extends StatelessWidget {
  const _EmptyPrices();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.huge),
      child: Column(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.show_chart_rounded,
              size: 34,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Hakuna bei kwa chaguo hili', style: AppText.h3),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Badilisha kategoria au mkoa ili kuona bei zilizopo.',
            textAlign: TextAlign.center,
            style: AppText.small,
          ),
        ],
      ),
    );
  }
}
