import 'package:flutter_test/flutter_test.dart';
import 'package:librey/app.dart';
import 'package:librey/data/demo_content_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('reader can choose topics, follow a book, and open its exact source', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    final repository = await DemoContentRepository.load();
    await tester.pumpWidget(LibreYApp(content: Future.value(repository)));
    await tester.pumpAndSettle();

    expect(find.text('A little scroll. A little wiser.'), findsOneWidget);
    await tester.tap(find.text('Science'));
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('For You'), findsWidgets);
    expect(find.text('On the Origin of Species'), findsWidgets);

    await tester.tap(find.textContaining('Big scientific puzzles'));
    await tester.pumpAndSettle();
    expect(find.text('Open source book'), findsOneWidget);

    await tester.tap(find.text('Follow'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Back to feed'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Following'));
    await tester.pumpAndSettle();
    expect(find.text('On the Origin of Species'), findsWidgets);

    await tester.tap(find.textContaining('Big scientific puzzles'));
    await tester.pumpAndSettle();
    expect(find.text('Open source book'), findsOneWidget);

    await tester.tap(find.text('Open source book'));
    await tester.pumpAndSettle();
    expect(find.text('Introduction'), findsOneWidget);
    expect(
      find.textContaining('afforded the best and safest clue'),
      findsOneWidget,
    );
  });
}
