import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:librey/data/demo_content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bundled posts cite exact text in a real book passage', () async {
    final repository = await DemoContentRepository.load();

    expect(repository.books, hasLength(3));
    expect(repository.posts.length, greaterThanOrEqualTo(15));
    expect(
      repository.posts.map((post) => post.kind),
      containsAll([
        'Insight',
        'Quote',
        'Word',
        'Thread',
        'Quiz',
        'Debate',
        'Poll',
      ]),
    );
    expect(
      repository.posts.where((post) => post.isArticle).length,
      greaterThanOrEqualTo(2),
    );
    expect(
      repository.posts.where((post) => post.imageAsset != null).length,
      lessThan(repository.posts.length ~/ 3),
    );
    for (final post in repository.posts) {
      final book = repository.bookFor(post);
      final passage = repository.passageFor(post);
      expect(book.id, post.bookId);
      expect(passage.bookId, book.id);
      expect(passage.text, contains(post.evidenceQuote));
      expect(Uri.parse(book.sourceUrl).host, 'www.gutenberg.org');
      expect(post.contextSummary, isNotEmpty);
      expect(post.sampleQuestion, isNotEmpty);
      expect(post.sampleAnswer, isNotEmpty);
      expect(post.answerBasis, anyOf('book', 'broader knowledge'));
      if (post.kind == 'Quote') {
        expect(post.body, post.evidenceQuote);
      }
      if (post.imageAsset case final imageAsset?) {
        expect(post.imageAttribution, isNotEmpty);
        expect(
          (await rootBundle.load(imageAsset)).lengthInBytes,
          greaterThan(0),
        );
      }
    }
  });
}
