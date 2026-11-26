import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../data/models/product.dart';
import '../../data/seed/misc_seed.dart';

const _units = [
  'kilo',
  'gunia',
  'lita',
  'kuku',
  'tray',
  'kimoja',
  'fundo',
  'chupa',
  'kizinga',
  'ziara',
];

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _quantity = TextEditingController();
  final _location = TextEditingController();
  final _description = TextEditingController();
  final _minOrder = TextEditingController();

  String? _categoryId;
  String? _subcategoryId;
  String _unit = 'kilo';
  String? _region;
  bool _organic = false;
  bool _negotiable = true;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    _quantity.dispose();
    _location.dispose();
    _description.dispose();
    _minOrder.dispose();
    super.dispose();
  }

  void _submit() {
    final state = AppScope.read(context);
    final category = state.repo.category(_categoryId);
    final subcategory =
        state.repo.subcategory(_categoryId ?? '', _subcategoryId);
    final price = double.tryParse(_price.text.replaceAll(',', '').trim());

    if (_name.text.trim().length < 3) {
      setState(() => _error = 'Weka jina la bidhaa');
      return;
    }
    if (category == null || subcategory == null) {
      setState(() => _error = 'Chagua kategoria na aina ya bidhaa');
      return;
    }
    if (price == null || price <= 0) {
      setState(() => _error = 'Weka bei sahihi');
      return;
    }
    if (_region == null) {
      setState(() => _error = 'Chagua mkoa');
      return;
    }
    if (_quantity.text.trim().isEmpty) {
      setState(() => _error = 'Eleza kiasi kilichopo');
      return;
    }
    setState(() => _error = null);

    state.addProduct(
      Product(
        id: 'mine-${DateTime.now().microsecondsSinceEpoch}',
        name: _name.text.trim(),
        categoryId: category.id,
        subcategoryId: subcategory.id,
        subcategoryName: subcategory.name,
        description: _description.text.trim().isEmpty
            ? '${_name.text.trim()} kutoka ${_location.text.trim().isEmpty ? state.user.ward : _location.text.trim()}, $_region. '
                'Wasiliana na mfuzaji kwa maelezo zaidi.'
            : _description.text.trim(),
        price: price,
        unit: _unit,
        quantityLabel: _quantity.text.trim(),
        location: _location.text.trim().isEmpty
            ? state.user.ward
            : _location.text.trim(),
        region: _region!,
        sellerName: state.user.name,
        sellerPhone: state.user.phone,
        sellerType: state.user.role,
        listedAt: 'Leo',
        imageAsset: category.imageAsset,
        rating: 0,
        reviewCount: 0,
        verified: state.user.verified,
        organic: _organic,
        negotiable: _negotiable,
        minOrder: int.tryParse(_minOrder.text.trim()),
      ),
    );

    Navigator.of(context).pop();
    showAppSnack(context, 'Bidhaa yako imetangazwa sokoni');
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final category = state.repo.category(_categoryId);

    return Scaffold(
      appBar: AppBar(title: const Text('Tangaza bidhaa')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          Text(
            'Weka taarifa sahihi ili wanunuzi wakupate haraka.',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Jina la bidhaa *',
              hintText: 'Mfano: Nyanya za Chamwino',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _categoryId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Kategoria *'),
            hint: const Text('Chagua kategoria'),
            items: [
              for (final item in state.repo.categories)
                DropdownMenuItem(value: item.id, child: Text(item.name)),
            ],
            onChanged: (value) => setState(() {
              _categoryId = value;
              _subcategoryId = null;
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _subcategoryId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Aina ya bidhaa *'),
            hint: const Text('Chagua aina'),
            items: [
              if (category != null)
                for (final sub in category.subcategories)
                  DropdownMenuItem(value: sub.id, child: Text(sub.name)),
            ],
            onChanged: category == null
                ? null
                : (value) => setState(() => _subcategoryId = value),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Bei (TSh) *',
                    prefixIcon: Icon(Icons.payments_outlined),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _unit,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Kwa'),
                  items: [
                    for (final unit in _units)
                      DropdownMenuItem(value: unit, child: Text(unit)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _unit = value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _quantity,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Kiasi kilichopo *',
              hintText: 'Mfano: Gunia 20 · 10 yapo',
              prefixIcon: Icon(Icons.inventory_2_outlined),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _location,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: 'Kata / Kijiji',
                    hintText: state.user.ward,
                    prefixIcon: const Icon(Icons.holiday_village_outlined),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _region,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Mkoa *'),
                  hint: const Text('Mkoa'),
                  items: [
                    for (final region in regionsSeed)
                      DropdownMenuItem(value: region, child: Text(region)),
                  ],
                  onChanged: (value) => setState(() => _region = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _minOrder,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Agizo la chini (hiari)',
              hintText: 'Mfano: 10',
              prefixIcon: Icon(Icons.shopping_basket_outlined),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _description,
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Maelezo ya bidhaa',
              hintText: 'Ubora, msimu, jinsi ya kuhifadhi, n.k.',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          MkCard(
            shadow: const [],
            color: AppColors.surfaceAlt,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                SwitchListTile(
                  value: _organic,
                  onChanged: (value) => setState(() => _organic = value),
                  contentPadding: EdgeInsets.zero,
                  title: Text('Bidhaa asilia', style: AppText.bodyStrong),
                  subtitle: Text(
                    'Iliyopandwa bila kemikali za viwandani',
                    style: AppText.small,
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  value: _negotiable,
                  onChanged: (value) => setState(() => _negotiable = value),
                  contentPadding: EdgeInsets.zero,
                  title: Text('Bei inajadiliwa', style: AppText.bodyStrong),
                  subtitle: Text(
                    'Wanunuzi wanaweza kuwasiliana kujadili',
                    style: AppText.small,
                  ),
                ),
              ],
            ),
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              _error!,
              style: AppText.small.copyWith(color: AppColors.danger),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          MkButton(
            label: 'Tangaza bidhaa',
            icon: Icons.campaign_rounded,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
