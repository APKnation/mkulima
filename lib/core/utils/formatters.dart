/// Formatting helpers shared across the app.
///
/// Prices are displayed in Tanzanian Shillings, e.g. `TSh 2,500`.
String formatTsh(num value, {bool decimals = false}) {
  final rounded = value.round();
  final text = _groupDigits(rounded.abs().toString());
  final sign = rounded < 0 ? '-' : '';
  return 'TSh $sign$text';
}

String formatNumber(num value) => _groupDigits(value.round().toString());

String _groupDigits(String digits) {
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// Compact form for dashboard cards (e.g. 1.2M, 850K).
String formatCompact(num value) {
  if (value >= 1000000) {
    final v = value / 1000000;
    return '${v.toStringAsFixed(v >= 10 ? 0 : 1)}M';
  }
  if (value >= 1000) {
    final v = value / 1000;
    return '${v.toStringAsFixed(v >= 100 ? 0 : 1)}K';
  }
  return value.round().toString();
}

String formatPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}

String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return 'M';
  if (parts.length == 1) {
    return parts.first.substring(0, 1).toUpperCase();
  }
  return (parts.first.substring(0, 1) + parts[1].substring(0, 1))
      .toUpperCase();
}

String todayLabel() {
  const months = [
    'Jan', 'Feb', 'Mac', 'Apr', 'Mei', 'Jun',
    'Jul', 'Ago', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  final now = DateTime.now();
  return '${now.day} ${months[now.month - 1]} ${now.year}';
}

String greetingForNow() {
  final hour = DateTime.now().hour;
  if (hour < 12) return 'Habari za asubuhi';
  if (hour < 17) return 'Habari za mchana';
  return 'Habari za jioni';
}
