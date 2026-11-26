import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../../core/state/app_state.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/ui_helpers.dart';
import '../../core/widgets/mk_button.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phone});

  final String phone;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _seconds = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_seconds <= 1) {
        timer.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _verify() {
    if (_controller.text.length < 4) {
      showAppSnack(
        context,
        'Weka msimbo wa tarakimu 4',
        isError: true,
        icon: Icons.error_outline_rounded,
      );
      return;
    }
    AppScope.read(context).signIn(widget.phone);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thibitisha namba')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.page),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('Weka msimbo wa uthibitisho', style: AppText.h1),
              const SizedBox(height: AppSpacing.sm),
              Text.rich(
                TextSpan(
                  text: 'Tumetuma msimbo wa tarakimu 4 kwa ',
                  children: [
                    TextSpan(
                      text: widget.phone,
                      style: AppText.bodyStrong,
                    ),
                  ],
                ),
                style: AppText.body,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              GestureDetector(
                onTap: () => _focus.requestFocus(),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: 0,
                      child: TextField(
                        controller: _controller,
                        focusNode: _focus,
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _verify(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (var i = 0; i < 4; i++)
                          Container(
                            width: 68,
                            height: 72,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md),
                              border: Border.all(
                                color: i == _controller.text.length
                                    ? AppColors.primary
                                    : AppColors.line,
                                width: i == _controller.text.length ? 1.8 : 1,
                              ),
                              boxShadow: AppShadows.soft,
                            ),
                            child: Text(
                              i < _controller.text.length
                                  ? _controller.text[i]
                                  : '',
                              style: AppText.h1.copyWith(fontSize: 26),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              MkButton(
                label: 'Thibitisha na ingia',
                onPressed: _controller.text.length == 4 ? _verify : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: _seconds > 0
                    ? Text(
                        'Tuma tena msimbo baada ya sekunde $_seconds',
                        style: AppText.small,
                      )
                    : TextButton.icon(
                        onPressed: () {
                          _controller.clear();
                          _startTimer();
                          showAppSnack(context, 'Msimbo mpya umetumwa kwa SMS');
                        },
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('Tuma tena msimbo'),
                      ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.infoSoft,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Kwa majaribio unaweza kutumia msimbo wowote wa tarakimu 4.',
                        style: AppText.small.copyWith(color: AppColors.info),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
