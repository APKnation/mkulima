import 'dart:async';

import 'package:material_ui/material_ui.dart';

import 'core/state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/login_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/shell/main_shell.dart';
import 'features/splash/splash_screen.dart';

/// Application root: owns [AppState] and routes between the three top-level
/// states — launch, onboarding and the signed-in shell.
class MkulimaApp extends StatefulWidget {
  const MkulimaApp({super.key, this.state});

  /// Injectable for tests and previews.
  final AppState? state;

  @override
  State<MkulimaApp> createState() => _MkulimaAppState();
}

class _MkulimaAppState extends State<MkulimaApp> {
  late final AppState _state = widget.state ?? AppState();

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'Mkulima',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const _RootGate(),
      ),
    );
  }
}

class _RootGate extends StatefulWidget {
  const _RootGate();

  @override
  State<_RootGate> createState() => _RootGateState();
}

class _RootGateState extends State<_RootGate> {
  Timer? _timer;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 1900), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) return const SplashScreen();

    final state = AppScope.of(context);
    if (!state.onboarded) return const OnboardingScreen();
    if (!state.signedIn) return const LoginScreen();
    return const MainShell();
  }
}
