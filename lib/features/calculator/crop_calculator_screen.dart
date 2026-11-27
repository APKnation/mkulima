import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/agri_tools.dart';
import '../../data/seed/agri_tools_seed.dart';

class CropCalculatorScreen extends StatefulWidget {
  const CropCalculatorScreen({super.key});

  @override
  State<CropCalculatorScreen> createState() => _CropCalculatorScreenState();
}

class _CropCalculatorScreenState extends State<CropCalculatorScreen> {
  late CropBudgetTemplate _selectedTemplate;
  double _acres = 1.0;
  late double _marketPrice;
  late double _expectedYield;

  @override
  void initState() {
    super.initState();
    _selectedTemplate = cropBudgetsSeed.first;
    _marketPrice = _selectedTemplate.defaultMarketPricePerUnit;
    _expectedYield = _selectedTemplate.expectedYieldBagsPerAcre;
  }

  void _onTemplateChanged(CropBudgetTemplate template) {
    setState(() {
      _selectedTemplate = template;
      _marketPrice = template.defaultMarketPricePerUnit;
      _expectedYield = template.expectedYieldBagsPerAcre;
    });
  }

  @override
  Widget build(BuildContext context) {
    final seedCost = _selectedTemplate.seedCostPerAcre * _acres;
    final fertCost = _selectedTemplate.fertilizerCostPerAcre * _acres;
    final pestCost = _selectedTemplate.pesticideCostPerAcre * _acres;
    final laborCost = _selectedTemplate.laborCostPerAcre * _acres;
    final totalCost = seedCost + fertCost + pestCost + laborCost;

    final totalYield = _expectedYield * _acres;
    final grossRevenue = totalYield * _marketPrice;
    final netProfit = grossRevenue - totalCost;
    final roi = totalCost > 0 ? (netProfit / totalCost) * 100 : 0.0;
    final isProfitable = netProfit > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kikokotoo cha Faida'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.sm,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Assistant banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: AppColors.heroGradient,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.secondary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Uchambuzi wa Makadirio (AI Ready)',
                          style: AppText.bodyStrong.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Piga hesabu za gharama, mavuno na faida kabla ya kuanza kilimo.',
                          style: AppText.small.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Select Crop
            Text('Chagua Zao', style: AppText.h3),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cropBudgetsSeed.length,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final t = cropBudgetsSeed[index];
                  final isSelected = t.id == _selectedTemplate.id;
                  return ChoiceChip(
                    label: Text(t.cropName),
                    selected: isSelected,
                    onSelected: (_) => _onTemplateChanged(t),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Acres selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ukubwa wa Shamba (Ekari)', style: AppText.h3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '${_acres.toStringAsFixed(1)} Ekari',
                    style: AppText.bodyStrong.copyWith(color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
            Slider(
              value: _acres,
              min: 0.5,
              max: 20.0,
              divisions: 39,
              activeColor: AppColors.primary,
              label: '${_acres.toStringAsFixed(1)} Ekari',
              onChanged: (val) => setState(() => _acres = val),
            ),
            const SizedBox(height: AppSpacing.md),

            // Market Price & Yield adjustments
            MkCard(
              shadow: AppShadows.soft,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bei Tarajiwa ya Soko', style: AppText.bodyStrong),
                      Text(
                        formatTsh(_marketPrice),
                        style: AppText.bodyStrong.copyWith(color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                  Text(
                    'Kwa kila ${_selectedTemplate.yieldUnit}',
                    style: AppText.small,
                  ),
                  Slider(
                    value: _marketPrice,
                    min: _selectedTemplate.defaultMarketPricePerUnit * 0.4,
                    max: _selectedTemplate.defaultMarketPricePerUnit * 2.2,
                    divisions: 36,
                    label: formatTsh(_marketPrice),
                    onChanged: (val) => setState(() => _marketPrice = val),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mavuno Tarajiwa / Ekari', style: AppText.bodyStrong),
                      Text(
                        '${_expectedYield.toInt()} ${_selectedTemplate.yieldUnit}',
                        style: AppText.bodyStrong.copyWith(color: AppColors.accent),
                      ),
                    ],
                  ),
                  Slider(
                    value: _expectedYield,
                    min: 5,
                    max: _selectedTemplate.expectedYieldBagsPerAcre * 2.0,
                    divisions: 30,
                    label: '${_expectedYield.toInt()}',
                    onChanged: (val) => setState(() => _expectedYield = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Financial summary Card
            MkCard(
              color: isProfitable ? const Color(0xFFF1F8EE) : AppColors.dangerSoft,
              borderColor: isProfitable ? const Color(0xFFC7E5BE) : AppColors.danger,
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        isProfitable
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: isProfitable ? AppColors.success : AppColors.danger,
                        size: 28,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        isProfitable ? 'Makadirio ya Faida Halisi' : 'Tahadhari ya Hasara',
                        style: AppText.h3.copyWith(
                          color: isProfitable ? AppColors.success : AppColors.danger,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    formatTsh(netProfit.abs()),
                    style: AppText.display.copyWith(
                      fontSize: 32,
                      color: isProfitable ? AppColors.primaryDeep : AppColors.danger,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Mzunguko wa mavuno: Miezi ${_selectedTemplate.durationMonths} · Faida kwa Mtaji: ${roi.toStringAsFixed(1)}%',
                    style: AppText.small,
                  ),
                  const Divider(height: AppSpacing.xl),
                  _CostBreakdownRow(
                    label: 'Jumla ya Mapato (Gross):',
                    value: formatTsh(grossRevenue),
                    isBold: true,
                  ),
                  const SizedBox(height: 6),
                  _CostBreakdownRow(
                    label: 'Jumla ya Gharama:',
                    value: formatTsh(totalCost),
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Itemized Costs
            Text('Mgawanyo wa Gharama (${_acres.toStringAsFixed(1)} Ekari)', style: AppText.h3),
            const SizedBox(height: AppSpacing.sm),
            MkCard(
              shadow: AppShadows.soft,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _CostBreakdownRow(label: 'Mbegu & Miche', value: formatTsh(seedCost)),
                  const Divider(),
                  _CostBreakdownRow(label: 'Mbolea (DAP/UREA/CAN)', value: formatTsh(fertCost)),
                  const Divider(),
                  _CostBreakdownRow(label: 'Viuatilifu na Dawa', value: formatTsh(pestCost)),
                  const Divider(),
                  _CostBreakdownRow(label: 'Vibarua na Shughuli', value: formatTsh(laborCost)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // AI Agronomist Advice
            Text('Ushauri wa Mtaalamu (Agronomist Advice)', style: AppText.h3),
            const SizedBox(height: AppSpacing.sm),
            MkCard(
              color: AppColors.surfaceAlt,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.psychology_outlined,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      _selectedTemplate.aiAdvice,
                      style: AppText.body,
                    ),
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

class _CostBreakdownRow extends StatelessWidget {
  const _CostBreakdownRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? AppText.bodyStrong : AppText.body,
        ),
        Text(
          value,
          style: isBold
              ? AppText.bodyStrong.copyWith(color: AppColors.ink)
              : AppText.body,
        ),
      ],
    );
  }
}
