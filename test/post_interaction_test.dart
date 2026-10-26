import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:librey/app.dart';
import 'package:librey/data/demo_content_repository.dart';
import 'package:librey/screens/post_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  testWidgets('quiz reveals its answer and prepared AI sample labels', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'librey_onboarding_complete': true,
    });

    final repository = await DemoContentRepository.load();
    await tester.pumpWidget(LibreYApp(content: Future.value(repository)));
    await tester.pumpAndSettle();

    final quizPost = find.textContaining(
      'According to Darwin’s passage, why is there a struggle for existence?',
    );
    await tester.scrollUntilVisible(
      quizPost,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    final quizCard = find
        .ancestor(of: quizPost, matching: find.byType(InkWell))
        .first;
    await tester.ensureVisible(quizCard);
    await tester.pumpAndSettle();
    await tester.tap(quizCard);
    await tester.pumpAndSettle();

    final correctAnswer = find.text(
      'More individuals are born than can survive',
    );
    await scrollToTarget(tester, correctAnswer, detailScrollable());
    await tester.tap(correctAnswer.hitTestable());
    await tester.pumpAndSettle();
    expect(
      find.textContaining('That’s right. Darwin says many more individuals'),
      findsOneWidget,
    );

    final sampleButton = find.text('Show prepared sample');
    await scrollToTarget(tester, sampleButton, detailScrollable());
    final visibleSampleButton = sampleButton.hitTestable();
    await tester.tap(visibleSampleButton);
    await tester.pumpAndSettle();
    expect(
      find.textContaining(
        'Darwin links the number of individuals born to the struggle',
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining('Prepared sample · From the book'),
      findsOneWidget,
    );
    expect(
      find.textContaining('The passage says more individuals are born'),
      findsOneWidget,
    );
    expect(find.textContaining('not interpreted by a live AI'), findsOneWidget);
  });
}
