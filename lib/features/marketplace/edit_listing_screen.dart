import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import '../../core/widgets/mk_card.dart';
import '../../core/widgets/product_photo_picker.dart';
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

/// Edit an existing listing — pre-fills all fields from [product].
/// Returns the updated [Product] on save via [Navigator.pop].
class EditListingScreen extends StatefulWidget {
  const EditListingScreen({super.key, required this.product});

  final Product product;

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  late final TextEditingController _name;
  late final TextEditingController _price;
  late final TextEditingController _quantity;
  late final TextEditingController _location;
  late final TextEditingController _description;
  late final TextEditingController _minOrder;

  late String _unit;
  late String? _region;
  late String _selectedImage;
  late bool _organic;
  late bool _negotiable;
  late bool _available;
  String? _error;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _name = TextEditingController(text: p.name);
    _price = TextEditingController(text: p.price.round().toString());
    _quantity = TextEditingController(text: p.quantityLabel);
    _location = TextEditingController(text: p.location);
    _description = TextEditingController(text: p.description);
    _minOrder = TextEditingController(
        text: p.minOrder != null ? p.minOrder.toString() : '');
    _unit = _units.contains(p.unit) ? p.unit : _units.first;
    _region = p.region;
    _selectedImage = p.imageAsset;
    _organic = p.organic;
    _negotiable = p.negotiable;
    _available = p.available;
  }

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

  void _save() {
    final price = double.tryParse(_price.text.replaceAll(',', '').trim());

    if (_name.text.trim().length < 3) {
      setState(() => _error = 'Weka jina la bidhaa (herufi 3+)');
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

    final updated = widget.product.copyWith(
      name: _name.text.trim(),
      price: price,
      unit: _unit,
      quantityLabel: _quantity.text.trim(),
      location: _location.text.trim().isEmpty
          ? widget.product.location
          : _location.text.trim(),
      region: _region!,
      imageAsset: _selectedImage,
      description: _description.text.trim().isEmpty
          ? widget.product.description
          : _description.text.trim(),
      organic: _organic,
      negotiable: _negotiable,
      available: _available,
      minOrder: int.tryParse(_minOrder.text.trim()),
      clearMinOrder: _minOrder.text.trim().isEmpty,
    );

    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hariri bidhaa'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Hifadhi'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          AppSpacing.md,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          ProductPhotoPicker(
            selectedAsset: _selectedImage,
            buttonLabel: 'Badilisha picha',
            onSelected: (asset) => setState(() => _selectedImage = asset),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Status toggle ──────────────────────────────────────────────
          MkCard(
            shadow: const [],
            color: _available ? AppColors.primarySoft : AppColors.surfaceAlt,
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md, vertical: 4),
            child: SwitchListTile(
              value: _available,
              onChanged: (v) => setState(() => _available = v),
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primary,
              title: Text(
                _available ? 'Inauzwa sasa' : 'Imesimamishwa',
                style: AppText.bodyStrong.copyWith(
                  color: _available ? AppColors.primary : AppColors.muted,
                ),
              ),
              subtitle: Text(
                _available
                    ? 'Wanunuzi wanaweza kuiona sokoni'
                    : 'Haionekani sokoni kwa sasa',
                style: AppText.small,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Product name ───────────────────────────────────────────────
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Jina la bidhaa *',
              hintText: 'Mfano: Mahindi ya Mbeya',
              prefixIcon: Icon(Icons.grass_rounded),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Price + unit ───────────────────────────────────────────────
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Bei (TSh) *',
                    hintText: '50,000',
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
                  onChanged: (v) {
                    if (v != null) setState(() => _unit = v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Quantity ───────────────────────────────────────────────────
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

          // ── Location + region ──────────────────────────────────────────
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
                  onChanged: (v) => setState(() => _region = v),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Min order ─────────────────────────────────────────────────
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

          // ── Description ────────────────────────────────────────────────
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

          // ── Toggles ────────────────────────────────────────────────────
          MkCard(
            shadow: const [],
            color: AppColors.surfaceAlt,
            padding:
                const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                SwitchListTile(
                  value: _organic,
                  onChanged: (v) => setState(() => _organic = v),
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.turquoise,
                  title: Row(
                    children: [
                      const Icon(Icons.eco_rounded,
                          size: 16, color: AppColors.turquoise),
                      const SizedBox(width: 6),
                      Text('Bidhaa asilia', style: AppText.bodyStrong),
                    ],
                  ),
                  subtitle: Text(
                    'Iliyopandwa bila kemikali za viwandani',
                    style: AppText.small,
                  ),
                ),
                const Divider(),
                SwitchListTile(
                  value: _negotiable,
                  onChanged: (v) => setState(() => _negotiable = v),
                  contentPadding: EdgeInsets.zero,
                  activeColor: AppColors.primary,
                  title:
                      Text('Bei inajadiliwa', style: AppText.bodyStrong),
                  subtitle: Text(
                    'Wanunuzi wanaweza kuwasiliana kujadili bei',
                    style: AppText.small,
                  ),
                ),
              ],
            ),
          ),

          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.dangerSoft,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      size: 16, color: AppColors.danger),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _error!,
                      style: AppText.small.copyWith(color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),
          MkButton(
            label: 'Hifadhi mabadiliko',
            icon: Icons.check_rounded,
            onPressed: _save,
          ),
          const SizedBox(height: AppSpacing.md),
          MkButton(
            label: 'Futa bidhaa hii',
            icon: Icons.delete_outline_rounded,
            variant: MkButtonVariant.outline,
            onPressed: () async {
              final confirm = await showConfirmDialog(
                context,
                title: 'Futa bidhaa?',
                message:
                    'Bidhaa hii itafutwa kabisa. Huwezi kuirejesha.',
                confirmLabel: 'Futa',
                destructive: true,
              );
              if (confirm == true && context.mounted) {
                AppScope.read(context).removeProduct(widget.product.id);
                // pop edit screen then pop to listings
                Navigator.of(context).pop();
                showAppSnack(context, '${widget.product.name} imefutwa');
              }
            },
          ),
        ],
      ),
    );
  }
}
