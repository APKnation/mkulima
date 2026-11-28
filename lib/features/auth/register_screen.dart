import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import '../../data/seed/misc_seed.dart';
import 'interests_selection_screen.dart';

const _roles = [
  'Mkulima binafsi',
  'Mfugaji',
  'Mnunuzi / Mfanyabiashara',
  'Chama cha ushirika',
  'Muuzaji wa pembejeo',
];

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController(text: '+255 ');
  final _ward = TextEditingController();
  String? _region;
  String _role = _roles.first;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _ward.dispose();
    super.dispose();
  }

  void _submit() {
    if (_name.text.trim().length < 3) {
      setState(() => _error = 'Weka jina lako kamili');
      return;
    }
    if (_phone.text.replaceAll(RegExp(r'[^0-9]'), '').length < 9) {
      setState(() => _error = 'Weka namba sahihi ya simu');
      return;
    }
    if (_region == null) {
      setState(() => _error = 'Chagua mkoa wako');
      return;
    }
    setState(() => _error = null);

    final phone = _phone.text.trim();
    final state = AppScope.read(context);
    state.updateProfile(
      state.user.copyWith(
        name: _name.text.trim(),
        phone: phone,
        region: _region,
        ward: _ward.text.trim().isEmpty ? state.user.ward : _ward.text.trim(),
        role: _role,
      ),
    );
    pushScreen(context, InterestsSelectionScreen(phone: phone));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sajili akaunti')),
      body: SafeArea(
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
              Text(
                'Taarifa chache tu ili tuanze. Unaweza kubadilisha baadaye.',
                style: AppText.body,
              ),
              const SizedBox(height: AppSpacing.xl),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Jina kamili',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Namba ya simu',
                  prefixIcon: Icon(Icons.phone_iphone_rounded),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: _region,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Mkoa',
                  prefixIcon: Icon(Icons.place_outlined),
                ),
                hint: const Text('Chagua mkoa'),
                items: [
                  for (final region in regionsSeed)
                    DropdownMenuItem(value: region, child: Text(region)),
                ],
                onChanged: (value) => setState(() => _region = value),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _ward,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Kata / Kijiji (hiari)',
                  prefixIcon: Icon(Icons.holiday_village_outlined),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                initialValue: _role,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Wewe ni nani?',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                items: [
                  for (final role in _roles)
                    DropdownMenuItem(value: role, child: Text(role)),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _role = value);
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  _error!,
                  style: AppText.small.copyWith(color: AppColors.danger),
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              MkButton(
                label: 'Fungua akaunti',
                icon: Icons.check_circle_outline_rounded,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
