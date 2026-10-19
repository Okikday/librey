import 'package:flutter_test/flutter_test.dart';
import 'package:librey/data/demo_content_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('bundled posts cite exact text in a real book passage', () async {
    final repository = await DemoContentRepository.load();

    expect(repository.books, hasLength(3));
    expect(repository.posts, hasLength(3));
    for (final post in repository.posts) {
      final book = repository.bookFor(post);
      final passage = repository.passageFor(post);
      expect(book.id, post.bookId);
      expect(passage.bookId, book.id);
      expect(passage.text, contains(post.evidenceQuote));
      expect(Uri.parse(book.sourceUrl).host, 'www.gutenberg.org');
    }
  });
}
