import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';
import 'otp_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phone = TextEditingController(text: '+255 754 712 884');
  String? _error;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  void _continue() {
    final digits = _phone.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 9) {
      setState(() => _error = 'Weka namba sahihi ya simu');
      return;
    }
    setState(() => _error = null);
    pushScreen(context, OtpScreen(phone: _phone.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: AppColors.heroGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppShadows.card,
                ),
                child: const Icon(
                  Icons.agriculture_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Text('Karibu tena', style: AppText.display),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Ingia kwa namba yako ya simu ili kuendelea na shughuli zako za kilimo.',
                style: AppText.body,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                style: AppText.h3,
                decoration: InputDecoration(
                  labelText: 'Namba ya simu',
                  hintText: '+255 7XX XXX XXX',
                  prefixIcon: const Icon(Icons.phone_iphone_rounded),
                  errorText: _error,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 15,
                    color: AppColors.muted,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Tutatuma msimbo wa kuthibitisha kwa SMS. Hutalipiwi.',
                      style: AppText.small,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
              MkButton(
                label: 'Endelea',
                trailingIcon: Icons.arrow_forward_rounded,
                onPressed: _continue,
              ),
              const SizedBox(height: AppSpacing.md),
              Center(
                child: TextButton(
                  onPressed: () => pushScreen(context, const RegisterScreen()),
                  child: const Text('Huna akaunti? Sajili hapa'),
                ),
              ),
              const SizedBox(height: AppSpacing.huge),
              Center(
                child: Text(
                  'Kwa kuendelea unakubali masharti ya matumizi\nna sera ya faragha ya Mkulima App.',
                  textAlign: TextAlign.center,
                  style: AppText.small,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
