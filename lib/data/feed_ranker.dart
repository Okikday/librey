import '../models/post.dart';

class FeedRanker {
  const FeedRanker();

  List<Post> rank({
    required List<Post> posts,
    required String Function(Post post) subjectFor,
    required Set<String> selectedTopics,
    required Map<String, double> topicScores,
  }) {
    final remaining = posts.indexed.toList();
    final ranked = <Post>[];
    final topicAffinity = <String, double>{
      for (final entry in topicScores.entries) entry.key: entry.value,
      for (final topic in selectedTopics) topic: (topicScores[topic] ?? 0) + 3,
    };

    while (remaining.isNotEmpty) {
      final isDiscoverySlot = (ranked.length + 1) % 6 == 0;
      final recentBookIds = ranked
          .skip((ranked.length - 2).clamp(0, ranked.length))
          .map((post) => post.bookId)
          .toSet();
      var candidates = remaining
          .where((entry) => !recentBookIds.contains(entry.$2.bookId))
          .toList();
      if (candidates.isEmpty) {
        candidates = List.of(remaining);
      }

      if (isDiscoverySlot) {
        final outsideInterests = candidates
            .where((entry) => !selectedTopics.contains(subjectFor(entry.$2)))
            .toList();
        if (outsideInterests.isNotEmpty) {
          candidates = outsideInterests;
        } else if (selectedTopics.isEmpty && topicAffinity.isNotEmpty) {
          final strongestTopic = topicAffinity.entries
              .reduce((left, right) => left.value >= right.value ? left : right)
              .key;
          final outsideTopTopic = candidates
              .where((entry) => subjectFor(entry.$2) != strongestTopic)
              .toList();
          if (outsideTopTopic.isNotEmpty) {
            candidates = outsideTopTopic;
          }
        }
      }

      candidates.sort((left, right) {
        final leftScore = topicAffinity[subjectFor(left.$2)] ?? 0;
        final rightScore = topicAffinity[subjectFor(right.$2)] ?? 0;
        final scoreOrder = rightScore.compareTo(leftScore);
        return scoreOrder == 0 ? left.$1.compareTo(right.$1) : scoreOrder;
      });
      final next = candidates.first;
      ranked.add(next.$2);
      remaining.remove(next);
    }

    return List.unmodifiable(ranked);
  }
}
