import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:mkulima/app.dart';
import 'package:mkulima/core/state/app_state.dart';
import 'package:mkulima/core/widgets/product_card.dart';
import 'package:mkulima/features/community/community_screen.dart';

void main() {
  testWidgets('detail screens open from the signed-in shell', (
    WidgetTester tester,
  ) async {
    final state = AppState(signedIn: true);
    state.completeOnboarding();

    await tester.pumpWidget(MkulimaApp(state: state));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Nyumbani'), findsOneWidget);

    await tester.ensureVisible(find.text('Bei za soko').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bei za soko').first);
    await tester.pumpAndSettle();
    expect(
      find.text('Bei elekezi, si bei za mazungumzo ya moja kwa moja'),
      findsOneWidget,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Miongozo').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Miongozo').first);
    await tester.pumpAndSettle();
    expect(find.text('Soma bila mtandao'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Shamba langu').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Shamba langu').first);
    await tester.pumpAndSettle();
    expect(find.text('Kazi na kumbusho'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Soko').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ProductGridCard).first);
    await tester.pumpAndSettle();
    expect(find.text('Wasiliana na mfuzaji'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Jamii').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CommunityPostCard).first);
    await tester.pumpAndSettle();
    expect(find.text('Mazungumzo'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.takeException(), isNull);
  });
}
