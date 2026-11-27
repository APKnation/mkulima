import 'package:material_ui/material_ui.dart';

/// Central design tokens for Mkulima App.
///
/// Every screen consumes these tokens instead of hard-coded values so the
/// product keeps one consistent, organic agricultural identity.
abstract final class AppColors {
  static const primary = Color(0xFF499A13);
  static const primaryDark = Color(0xFF2E6B09);
  static const primaryDeep = Color(0xFF1C4305);
  static const primarySoft = Color(0xFFEDF6E4);
  static const secondary = Color(0xFFBBDC12);
  static const accent = Color(0xFFE4B028);
  static const accentSoft = Color(0xFFFDF4DB);
  static const turquoise = Color(0xFF00E0BA);
  static const turquoiseSoft = Color(0xFFE2FBF5);

  static const ink = Color(0xFF14210D);
  static const inkSoft = Color(0xFF44523C);
  static const muted = Color(0xFF77856F);
  static const bg = Color(0xFFF6F8F1);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFF1F5EC);
  static const line = Color(0xFFE5EBDD);

  static const danger = Color(0xFFD1463C);
  static const dangerSoft = Color(0xFFFCEAE8);
  static const success = Color(0xFF2E9B57);
  static const successSoft = Color(0xFFE7F6EC);
  static const info = Color(0xFF2C7FB8);
  static const infoSoft = Color(0xFFE8F3FA);

  static const shadow = Color(0x140F2A05);

  static const heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3F8C10), Color(0xFF255C08)],
  );

  static const goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0C34E), Color(0xFFD9A118)],
  );

  static const turquoiseGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF12E8C4), Color(0xFF00A98C)],
  );

  static const softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF3F9EC), Color(0xFFEAF3E0)],
  );
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  static const huge = 40.0;

  /// Standard horizontal page padding.
  static const page = 18.0;
}

abstract final class AppRadius {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const xl = 24.0;
  static const xxl = 30.0;
  static const pill = 999.0;
}

abstract final class AppShadows {
  static const card = <BoxShadow>[
    BoxShadow(color: Color(0x0F14210D), blurRadius: 18, offset: Offset(0, 6)),
  ];
  static const soft = <BoxShadow>[
    BoxShadow(color: Color(0x0A14210D), blurRadius: 10, offset: Offset(0, 3)),
  ];
  static const floating = <BoxShadow>[
    BoxShadow(color: Color(0x1A14210D), blurRadius: 28, offset: Offset(0, 12)),
  ];
}

/// Typography scale. Sizes are intentionally generous for outdoor readability.
abstract final class AppText {
  static const display = TextStyle(
    fontSize: 30,
    height: 1.15,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    color: AppColors.ink,
  );
  static const h1 = TextStyle(
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
    color: AppColors.ink,
  );
  static const h2 = TextStyle(
    fontSize: 19,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AppColors.ink,
  );
  static const h3 = TextStyle(
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );
  static const body = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.inkSoft,
  );
  static const bodyStrong = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );
  static const small = TextStyle(
    fontSize: 12.5,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.muted,
  );
  static const label = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.inkSoft,
  );
  static const overline = TextStyle(
    fontSize: 10.5,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.9,
    color: AppColors.muted,
  );
  static const button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
  );
}

ThemeData buildAppTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: AppColors.primarySoft,
    onPrimaryContainer: AppColors.primaryDeep,
    secondary: AppColors.secondary,
    onSecondary: AppColors.primaryDeep,
    secondaryContainer: Color(0xFFF1F8D2),
    onSecondaryContainer: Color(0xFF3C4D06),
    tertiary: AppColors.accent,
    onTertiary: Color(0xFF3D2C02),
    tertiaryContainer: AppColors.accentSoft,
    onTertiaryContainer: Color(0xFF6A4A05),
    error: AppColors.danger,
    onError: Colors.white,
    errorContainer: AppColors.dangerSoft,
    onErrorContainer: Color(0xFF7C1D17),
    surface: AppColors.surface,
    onSurface: AppColors.ink,
    onSurfaceVariant: AppColors.inkSoft,
    outline: AppColors.line,
    outlineVariant: AppColors.line,
    surfaceContainerHighest: AppColors.surfaceAlt,
    surfaceContainerHigh: Color(0xFFF4F7EF),
    surfaceContainer: Color(0xFFF8FAF4),
    shadow: AppColors.shadow,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    splashFactory: InkSparkle.splashFactory,
  );

  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      displaySmall: AppText.display,
      headlineSmall: AppText.h1,
      titleLarge: AppText.h2,
      titleMedium: AppText.h3,
      bodyMedium: AppText.body,
      bodySmall: AppText.small,
      labelLarge: AppText.button,
      labelMedium: AppText.label,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.ink,
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      titleTextStyle: AppText.h2,
      iconTheme: IconThemeData(color: AppColors.ink, size: 22),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.line,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      hintStyle: AppText.body.copyWith(color: AppColors.muted),
      labelStyle: AppText.label,
      helperStyle: AppText.small,
      errorStyle: AppText.small.copyWith(color: AppColors.danger),
      prefixIconColor: AppColors.muted,
      suffixIconColor: AppColors.muted,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(54),
        textStyle: AppText.button,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        minimumSize: const Size.fromHeight(52),
        textStyle: AppText.button,
        side: const BorderSide(color: AppColors.line, width: 1.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryDark,
        textStyle: AppText.label.copyWith(
          fontSize: 13,
          color: AppColors.primaryDark,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primarySoft,
      side: const BorderSide(color: AppColors.line),
      labelStyle: AppText.label,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      shape: const StadiumBorder(),
      showCheckmark: false,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      titleTextStyle: AppText.h2,
      contentTextStyle: AppText.body,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.primaryDeep,
      contentTextStyle: AppText.body.copyWith(color: Colors.white),
      actionTextColor: AppColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? Colors.white
            : Colors.white,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? AppColors.primary
            : const Color(0xFFD8E0D0),
      ),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.primary,
      inactiveTrackColor: AppColors.primarySoft,
      thumbColor: AppColors.primary,
      overlayColor: AppColors.primary.withValues(alpha: 0.12),
      valueIndicatorColor: AppColors.primaryDark,
      trackHeight: 4,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: AppColors.primarySoft,
      circularTrackColor: AppColors.primarySoft,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: AppColors.primaryDark,
      unselectedLabelColor: AppColors.muted,
      indicatorColor: AppColors.primary,
      dividerColor: Colors.transparent,
      labelStyle: AppText.label.copyWith(fontSize: 13),
      unselectedLabelStyle: AppText.label.copyWith(
        fontSize: 13,
        color: AppColors.muted,
      ),
      indicatorSize: TabBarIndicatorSize.label,
    ),
  );
}
