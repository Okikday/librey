import 'package:flutter_test/flutter_test.dart';
import 'package:librey/app.dart';
import 'package:librey/data/demo_content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('reader can open a feed post and its exact source', (
    tester,
  ) async {
    final repository = await DemoContentRepository.load();
    await tester.pumpWidget(LibreYApp(content: Future.value(repository)));
    await tester.pumpAndSettle();

    expect(find.text('For You'), findsOneWidget);
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
