import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:librey/app.dart';
import 'package:librey/data/demo_content_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('feed adapts from desktop to mobile width', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({
      'librey_onboarding_complete': true,
    });

    final repository = await DemoContentRepository.load();
    await tester.pumpWidget(LibreYApp(content: Future.value(repository)));
    await tester.pumpAndSettle();

    expect(find.text('For You'), findsWidgets);
    expect(find.text('Following'), findsWidgets);
    expect(find.text('LibreY'), findsOneWidget);
    expect(find.text('Real books. Fresh perspectives.'), findsOneWidget);
    expect(tester.takeException(), isNull);

    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.text('For You'), findsWidgets);
    expect(find.text('Following'), findsWidgets);
    expect(find.text('LibreY'), findsOneWidget);
    expect(find.byTooltip('More'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
