import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:librey/app.dart';
import 'package:librey/data/demo_content_repository.dart';
import 'package:librey/screens/post_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Finder feedTab(String label) => find.descendant(
    of: find.byWidgetPredicate((widget) => widget is SegmentedButton),
    matching: find.text(label),
  );

  Finder detailScrollable() => find
      .descendant(
        of: find.byType(PostDetailScreen),
        matching: find.byType(Scrollable),
      )
      .first;

  testWidgets(
    'reader can choose topics, follow a book, and open its exact source',
    (tester) async {
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

      await tester.tap(feedTab('Following'));
      await tester.pumpAndSettle();
      expect(find.text('No followed books yet'), findsOneWidget);

      await tester.tap(feedTab('For You'));
      await tester.pumpAndSettle();
      expect(find.text('No followed books yet'), findsNothing);
      expect(find.textContaining('Big scientific puzzles'), findsOneWidget);
      final darwinPost = find.textContaining('Big scientific puzzles');
      await tester.ensureVisible(darwinPost);
      await tester.tap(
        find.ancestor(of: darwinPost, matching: find.byType(InkWell)).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Post'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Open source book'),
        300,
        scrollable: detailScrollable(),
      );
      expect(find.text('Open source book'), findsOneWidget);

      await tester.tap(find.text('Follow'));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Back to feed'));
      await tester.pumpAndSettle();

      await tester.tap(feedTab('Following'));
      await tester.pumpAndSettle();
      expect(find.text('On the Origin of Species'), findsWidgets);
      expect(find.textContaining('A boy got tired of opening'), findsNothing);
      expect(find.textContaining('A 2,000-year-old call-out'), findsNothing);

      await tester.tap(find.textContaining('Big scientific puzzles'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Open source book'),
        300,
        scrollable: detailScrollable(),
      );
      expect(find.text('Open source book'), findsOneWidget);

      await tester.tap(find.text('Open source book'));
      await tester.pumpAndSettle();
      expect(find.text('Introduction'), findsOneWidget);
      expect(
        find.textContaining('afforded the best and safest clue'),
        findsOneWidget,
      );

      await tester.tap(find.byTooltip('Back to post'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Back to feed'));
      await tester.pumpAndSettle();
      await tester.tap(feedTab('Following'));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Big scientific puzzles'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Following'));
      await tester.pumpAndSettle();
      final updatedPreferences = await SharedPreferences.getInstance();
      expect(
        updatedPreferences.getStringList('librey_followed_books'),
        isEmpty,
      );
      await tester.tap(find.byTooltip('Back to feed'));
      await tester.pumpAndSettle();
      expect(find.text('No followed books yet'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(LibreYApp(content: Future.value(repository)));
      await tester.pumpAndSettle();
      expect(find.text('Choose what sparks your curiosity'), findsNothing);
      expect(find.text('For You'), findsWidgets);

      final savedPreferences = await SharedPreferences.getInstance();
      expect(savedPreferences.getStringList('librey_selected_topics'), [
        'Science',
      ]);
      expect(savedPreferences.getBool('librey_onboarding_complete'), isTrue);
      expect(savedPreferences.getStringList('librey_followed_books'), isEmpty);
    },
  );
}
