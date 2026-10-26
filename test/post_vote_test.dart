import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:librey/app.dart';
import 'package:librey/data/demo_content_repository.dart';
import 'package:librey/screens/feed_screen.dart';
import 'package:librey/screens/post_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Finder feedScrollable() => find
      .descendant(
        of: find.byType(FeedScreen),
        matching: find.byType(Scrollable),
      )
      .first;

  Finder detailScrollable() => find
      .descendant(
        of: find.byType(PostDetailScreen),
        matching: find.byType(Scrollable),
      )
      .first;

  Future<void> scrollToTarget(
    WidgetTester tester,
    Finder target,
    Finder scrollable,
  ) async {
    final visibleTarget = target.hitTestable();
    for (
      var attempt = 0;
      attempt < 10 && visibleTarget.evaluate().isEmpty;
      attempt++
    ) {
      await tester.drag(scrollable, const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    expect(visibleTarget, findsOneWidget);
  }

  testWidgets('polls and debates record the reader’s selected vote', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'librey_onboarding_complete': true,
    });

    final repository = await DemoContentRepository.load();
    await tester.pumpWidget(LibreYApp(content: Future.value(repository)));
    await tester.pumpAndSettle();

    final pollPost = find.textContaining(
      'What was the boy trying to save with his improvised mechanism?',
    );
    await scrollToTarget(tester, pollPost, feedScrollable());
    await tester.tap(pollPost.hitTestable());
    await tester.pumpAndSettle();

    final pollOption = find.text('His labour');
    await scrollToTarget(tester, pollOption, detailScrollable());
    await tester.tap(pollOption.hitTestable());
    await tester.pumpAndSettle();
    expect(find.textContaining('Vote recorded: His labour'), findsOneWidget);

    await tester.tap(find.byTooltip('Back to feed'));
    await tester.pumpAndSettle();
    final debatePost = find.textContaining(
      'A reminder to act can be more useful than another promise to start tomorrow.',
    );
    await scrollToTarget(tester, debatePost, feedScrollable());
    await tester.tap(debatePost.hitTestable());
    await tester.pumpAndSettle();

    final debateOption = find.text('Agree');
    await scrollToTarget(tester, debateOption, detailScrollable());
    await tester.tap(debateOption.hitTestable());
    await tester.pumpAndSettle();
    expect(find.text('Your vote: Agree'), findsOneWidget);
  });
}
