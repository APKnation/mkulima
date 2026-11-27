import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:mkulima/app.dart';

void main() {
  testWidgets('onboarding, login and main tabs render', (WidgetTester tester) async {
    await tester.pumpWidget(const MkulimaApp());
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Ruka'), findsOneWidget);
    await tester.tap(find.text('Ruka'));
    await tester.pumpAndSettle();

    expect(find.text('Karibu tena'), findsOneWidget);
    await tester.tap(find.text('Endelea'));
    await tester.pumpAndSettle();

    expect(find.text('Thibitisha namba'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();
    await tester.tap(find.text('Thibitisha na ingia'));
    await tester.pumpAndSettle();

    expect(find.text('Nyumbani'), findsOneWidget);

    for (final tab in ['Kategoria', 'Soko', 'Jamii', 'Wasifu']) {
      await tester.tap(find.text(tab).last);
      await tester.pumpAndSettle();
    }
  });
}
