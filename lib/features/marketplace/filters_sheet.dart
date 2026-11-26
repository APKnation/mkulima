import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/product.dart';
import '../../data/seed/misc_seed.dart';

class FiltersSheet extends StatefulWidget {
  const FiltersSheet({super.key, required this.initial});

  final ProductFilter initial;

  @override
  State<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<FiltersSheet> {
  late String? _region = widget.initial.region;
  late bool _limitPrice = widget.initial.maxPrice != null;
  late double _maxPrice = widget.initial.maxPrice ?? 50000;
  late ProductSort _sort = widget.initial.sort;
  late bool _availableOnly = widget.initial.availableOnly;
  late bool _verifiedOnly = widget.initial.verifiedOnly;

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
            SheetHeader(
              title: 'Vichujio vya hali ya juu',
              subtitle: 'Punguza matokeo hadi unayohitaji',
              trailing: TextButton(
                onPressed: () => setState(() {
                  _region = null;
                  _limitPrice = false;
                  _maxPrice = 50000;
                  _sort = ProductSort.newest;
                  _availableOnly = false;
                  _verifiedOnly = false;
                }),
                child: const Text('Weka upya'),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Mkoa', style: AppText.h3),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String>(
              initialValue: _region,
              isExpanded: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.place_outlined),
                hintText: 'Mikoa yote',
              ),
              items: [
                for (final region in regionsSeed)
                  DropdownMenuItem(value: region, child: Text(region)),
              ],
              onChanged: (value) => setState(() => _region = value),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(child: Text('Kikomo cha bei', style: AppText.h3)),
                Switch(
                  value: _limitPrice,
                  onChanged: (value) => setState(() => _limitPrice = value),
                ),
              ],
            ),
            if (_limitPrice) ...[
              Text(
                'Hadi ${formatTsh(_maxPrice)}',
                style: AppText.bodyStrong.copyWith(color: AppColors.primaryDark),
              ),
              Slider(
                value: _maxPrice,
                min: 500,
                max: 100000,
                divisions: 199,
                label: formatTsh(_maxPrice),
                onChanged: (value) => setState(() => _maxPrice = value),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text('Panga kwa', style: AppText.h3),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final sort in ProductSort.values)
                  ChoiceChip(
                    label: Text(sort.label),
                    selected: _sort == sort,
                    onSelected: (_) => setState(() => _sort = sort),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            MkCard(
              shadow: const [],
              color: AppColors.surfaceAlt,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _availableOnly,
                    onChanged: (value) =>
                        setState(() => _availableOnly = value),
                    contentPadding: EdgeInsets.zero,
                    title: Text('Bidhaa zilizopo tu', style: AppText.bodyStrong),
                    subtitle: Text(
                      'Onyesha bidhaa zilizopo sokoni sasa',
                      style: AppText.small,
                    ),
                  ),
                  const Divider(),
                  SwitchListTile(
                    value: _verifiedOnly,
                    onChanged: (value) => setState(() => _verifiedOnly = value),
                    contentPadding: EdgeInsets.zero,
                    title: Text('Wauzaji waliothibitishwa', style: AppText.bodyStrong),
                    subtitle: Text(
                      'Onyesha wauzaji wenye uthibitisho pekee',
                      style: AppText.small,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            MkButton(
              label: 'Tumia vichujio',
              icon: Icons.filter_alt_rounded,
              onPressed: () {
                Navigator.of(context).pop(
                  widget.initial.copyWith(
                    region: _region,
                    clearRegion: _region == null,
                    maxPrice: _maxPrice,
                    clearMaxPrice: !_limitPrice,
                    sort: _sort,
                    availableOnly: _availableOnly,
                    verifiedOnly: _verifiedOnly,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
