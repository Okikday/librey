import 'package:flutter/material.dart';

import '../data/demo_content_repository.dart';
import '../data/user_preferences.dart';
import '../models/post.dart';
import 'book_reader_screen.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({
    super.key,
    required this.post,
    required this.repository,
    required this.preferences,
  });

  final Post post;
  final DemoContentRepository repository;
  final UserPreferences preferences;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.preferences.followedBookIds().contains(widget.post.bookId);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.repository.bookFor(widget.post);
    final passage = widget.repository.passageFor(widget.post);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to feed',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Post'),
        centerTitle: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
            children: [
              Row(
                children: [
                  const Icon(Icons.menu_book_rounded, color: Color(0xFF426A52)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '${book.author} · ${book.subject}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFF758078)),
                        ),
                      ],
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: _toggleFollowState,
                    child: Text(_isFollowing ? 'Following' : 'Follow'),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                widget.post.kind.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF426A52),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.post.body,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  height: 1.42,
                  letterSpacing: -0.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'This post was ${widget.post.aiGenerated ? 'AI-generated' : 'reader-created'}.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF7C857D)),
              ),
              const SizedBox(height: 26),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          BookReaderScreen(book: book, passage: passage),
                    ),
                  );
                },
                icon: const Icon(Icons.menu_book_outlined),
                label: const Text('Open source book'),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  side: const BorderSide(color: Color(0xFFDCE5DC)),
                  foregroundColor: const Color(0xFF34533F),
                ),
              ),
              const SizedBox(height: 26),
              Text(
                'The passage behind this post',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                '${book.title} · ${passage.section}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF7C857D)),
              ),
              const SizedBox(height: 12),
              Text(
                widget.post.evidenceQuote,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleFollowState() async {
    final nextValue = !_isFollowing;
    await widget.preferences.setFollowedBook(widget.post.bookId, nextValue);
    if (!mounted) return;
    setState(() => _isFollowing = nextValue);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nextValue ? 'Following ${widget.repository.bookFor(widget.post).title}' : 'Unfollowed ${widget.repository.bookFor(widget.post).title}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
