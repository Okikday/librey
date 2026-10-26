import 'package:flutter_test/flutter_test.dart';
import 'package:librey/data/demo_content_repository.dart';
import 'package:librey/data/feed_ranker.dart';
import 'package:librey/data/user_preferences.dart';
import 'package:librey/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late DemoContentRepository repository;
  late FeedRanker ranker;

  setUpAll(() async {
    repository = await DemoContentRepository.load();
    ranker = const FeedRanker();
  });

  List<Post> rank({
    Set<String> selectedTopics = const {},
    Map<String, double> topicScores = const {},
  }) {
    return ranker.rank(
      posts: repository.posts,
      subjectFor: (post) => repository.bookFor(post).subject,
      selectedTopics: selectedTopics,
      topicScores: topicScores,
    );
  }

  test('selected interests affect the initial order', () {
    final posts = rank(selectedTopics: {'Economics'});

    expect(repository.bookFor(posts.first).subject, 'Economics');
    expect(
      posts.take(5).map((post) => post.bookId).toSet(),
      contains('wealth-of-nations'),
    );
  });

  test('positive engagement raises a topic in the ranked feed', () {
    final baseline = rank(selectedTopics: {'Economics'});
    final engaged = rank(
      selectedTopics: {'Economics'},
      topicScores: {'Science': 6},
    );

    expect(
      engaged.indexWhere((post) => post.bookId == 'origin-of-species'),
      lessThan(
        baseline.indexWhere((post) => post.bookId == 'origin-of-species'),
      ),
    );
  });

  test('repeated skips lower a topic without removing it from For You', () {
    final baseline = rank(selectedTopics: {'Economics'});
    final skipped = rank(
      selectedTopics: {'Economics'},
      topicScores: {'Economics': -8},
    );

    expect(
      skipped.indexWhere((post) => post.bookId == 'wealth-of-nations'),
      greaterThan(
        baseline.indexWhere((post) => post.bookId == 'wealth-of-nations'),
      ),
    );
    expect(skipped.any((post) => post.bookId == 'wealth-of-nations'), isTrue);
  });

  test('reserves discovery and avoids repeating a book within three cards', () {
    final posts = rank(selectedTopics: {'Economics'});

    expect(repository.bookFor(posts[5]).subject, isNot('Economics'));
    for (var index = 0; index < 15; index++) {
      expect(
        posts.skip(index).take(3).map((post) => post.bookId).toSet(),
        hasLength(3),
      );
    }
  });

  test('unselected topics also keep a discovery mix after engagement', () {
    final posts = rank(topicScores: {'Science': 8});

    expect(repository.bookFor(posts[5]).subject, isNot('Science'));
  });

  test(
    'topic engagement is bounded and persists between preference loads',
    () async {
      SharedPreferences.setMockInitialValues({});
      final preferences = await UserPreferences.load();
      await preferences.recordTopicSignal('Science', 12);
      await preferences.recordTopicSignal('Philosophy', -12);

      final reloaded = await UserPreferences.load();
      expect(reloaded.topicScores(), {'Science': 8, 'Philosophy': -8});
    },
  );
}
