import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_search_field.dart';
import '../../core/widgets/product_card.dart';
import '../../data/models/product.dart';
import 'filters_sheet.dart';
import 'product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.openFilters = false});

  final bool openFilters;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  ProductFilter _filter = const ProductFilter();

  static const _suggestions = [
    'Mahindi',
    'Nyanya',
    'Kuku',
    'Asali',
    'Parachichi',
    'Mbolea',
    'Tilapia',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.openFilters) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openFilters());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openFilters() async {
    final result = await showAppSheet<ProductFilter>(
      context,
      child: FiltersSheet(initial: _filter),
    );
    if (result != null && mounted) setState(() => _filter = result);
  }

  void _search(String value) {
    setState(() => _filter = _filter.copyWith(query: value));
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final results = state.filter(_filter);
    final hasQuery = _filter.query.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Tafuta sokoni')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.page,
              0,
              AppSpacing.page,
              AppSpacing.md,
            ),
            child: MkSearchField(
              controller: _controller,
              autofocus: true,
              onChanged: _search,
              onFilter: _openFilters,
              onClear: () {
                _controller.clear();
                _search('');
              },
            ),
          ),
          if (_filter.activeCount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.page,
                0,
                AppSpacing.page,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Text(
                    'Vichujio ${_filter.activeCount} vimetumika',
                    style: AppText.small,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(
                      () => _filter = ProductFilter(query: _filter.query),
                    ),
                    child: const Text('Ondoa vichujio'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: !hasQuery && _filter.activeCount == 0
                ? _Suggestions(onSelect: (value) {
                    _controller.text = value;
                    _search(value);
                  })
                : results.isEmpty
                    ? _NoResults(query: _filter.query)
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.page,
                          0,
                          AppSpacing.page,
                          AppSpacing.xxxl,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: Text(
                              'Matokeo ${results.length}',
                              style: AppText.small,
                            ),
                          ),
                          for (final product in results) ...[
                            ProductCard(
                              product: product,
                              favorite: state.isFavorite(product.id),
                              onFavorite: () =>
                                  state.toggleFavorite(product.id),
                              onTap: () => pushScreen(
                                context,
                                ProductDetailScreen(product: product),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                          ],
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({required this.onSelect});

  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.lg,
        AppSpacing.page,
        AppSpacing.xxxl,
      ),
      children: [
        Text('Tafuta kwa haraka', style: AppText.h2),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final suggestion in _SearchScreenState._suggestions)
              ActionChip(
                avatar: const Icon(
                  Icons.search_rounded,
                  size: 15,
                  color: AppColors.primaryDark,
                ),
                label: Text(suggestion),
                onPressed: () => onSelect(suggestion),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('Kidokezo', style: AppText.h2),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.lightbulb_outline_rounded,
                color: AppColors.primaryDark,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Tafuta kwa jina la zao, mkoa au jina la muuzaji — kwa mfano "Mbeya" au "Asali".',
                  style: AppText.body,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: AppColors.surfaceAlt,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 38,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Hakuna matokeo', style: AppText.h2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              query.isEmpty
                  ? 'Badilisha vichujio ili kupata bidhaa zaidi.'
                  : 'Hatukupata bidhaa kwa "$query". Jaribu jina lingine au badilisha kategoria.',
              textAlign: TextAlign.center,
              style: AppText.body,
            ),
          ],
        ),
      ),
    );
  }
}
