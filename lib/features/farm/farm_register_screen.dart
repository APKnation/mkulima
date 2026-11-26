import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import '../../data/models/farm.dart';
import '../../data/seed/misc_seed.dart';

const _cropOptions = [
  'Mahindi',
  'Mpunga',
  'Mtama',
  'Ngano',
  'Alizeti',
  'Mboga',
  'Matunda',
  'Mihogo',
  'Viazi',
  'Kahawa',
];

const _livestockOptions = [
  'Kuku',
  'Ng\'ombe',
  'Mbuzi',
  'Kondoo',
  'Nguruwe',
  'Samaki',
  'Nyuki',
];

class FarmRegisterScreen extends StatefulWidget {
  const FarmRegisterScreen({super.key});

  @override
  State<FarmRegisterScreen> createState() => _FarmRegisterScreenState();
}

class _FarmRegisterScreenState extends State<FarmRegisterScreen> {
  late final AppState _state;
  late final TextEditingController _name;
  late final TextEditingController _ward;
  late final TextEditingController _size;
  late final TextEditingController _sales;
  late final TextEditingController _goal;
  late String _region;
  late final Set<String> _crops;
  late final Set<String> _livestock;
  String? _error;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _state = AppScope.read(context);
    final farm = _state.farm;
    _name = TextEditingController(text: farm.name);
    _ward = TextEditingController(text: farm.ward);
    _size = TextEditingController(text: farm.sizeHa.toString());
    _sales = TextEditingController(text: farm.monthlySales.round().toString());
    _goal = TextEditingController(text: farm.goal);
    _region = regionsSeed.contains(farm.region) ? farm.region : regionsSeed.first;
    _crops = {
      for (final crop in farm.crops)
        _cropOptions.contains(crop) ? crop : _cropOptions.first,
    };
    _livestock = {
      for (final stock in farm.livestock)
        if (_livestockOptions.any((item) => stock.startsWith(item)))
          _livestockOptions.firstWhere((item) => stock.startsWith(item)),
    };
  }

  @override
  void dispose() {
    _name.dispose();
    _ward.dispose();
    _size.dispose();
    _sales.dispose();
    _goal.dispose();
    super.dispose();
  }

  void _save() {
    final size = double.tryParse(_size.text.trim());
    final sales = double.tryParse(_sales.text.replaceAll(',', '').trim());
    if (_name.text.trim().length < 3) {
      setState(() => _error = 'Weka jina la shamba');
      return;
    }
    if (size == null || size <= 0) {
      setState(() => _error = 'Weka ukubwa sahihi wa shamba kwa hekta');
      return;
    }
    setState(() => _error = null);

    final current = _state.farm;
    _state.registerFarm(
      Farm(
        name: _name.text.trim(),
        region: _region,
        ward: _ward.text.trim().isEmpty ? current.ward : _ward.text.trim(),
        sizeHa: size,
        crops: _crops.toList(),
        livestock: _livestock.toList(),
        goal: _goal.text.trim().isEmpty ? current.goal : _goal.text.trim(),
        monthlySales: sales ?? current.monthlySales,
        tasks: current.tasks,
        activities: current.activities,
        expenses: current.expenses,
      ),
    );
    Navigator.of(context).pop();
    showAppSnack(context, 'Taarifa za shamba zimehifadhiwa');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Taarifa za shamba')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.page,
          0,
          AppSpacing.page,
          AppSpacing.xxxl,
        ),
        children: [
          Text(
            'Taarifa hizi hutusaidia kukupa bei, miongozo na ushauri unaofaa eneo lako.',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Jina la shamba',
              prefixIcon: Icon(Icons.agriculture_outlined),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _size,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Ukubwa (hekta)'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextField(
                  controller: _sales,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Mauzo ya mwezi',
                    prefixText: 'TSh ',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _region,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Mkoa',
              prefixIcon: Icon(Icons.place_outlined),
            ),
            items: [
              for (final region in regionsSeed)
                DropdownMenuItem(value: region, child: Text(region)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _region = value);
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _ward,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Kata / Kijiji',
              prefixIcon: Icon(Icons.holiday_village_outlined),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Mazao unayolima', style: AppText.h3),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final crop in _cropOptions)
                FilterChip(
                  label: Text(crop),
                  selected: _crops.contains(crop),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _crops.add(crop);
                    } else {
                      _crops.remove(crop);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text('Mifugo unayofuga', style: AppText.h3),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final stock in _livestockOptions)
                FilterChip(
                  label: Text(stock),
                  selected: _livestock.contains(stock),
                  onSelected: (selected) => setState(() {
                    if (selected) {
                      _livestock.add(stock);
                    } else {
                      _livestock.remove(stock);
                    }
                  }),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          TextField(
            controller: _goal,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Lengo la msimu huu',
              prefixIcon: Icon(Icons.flag_outlined),
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
            label: 'Hifadhi taarifa',
            icon: Icons.save_outlined,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
