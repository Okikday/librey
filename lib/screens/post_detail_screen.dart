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
  int? _selectedOptionIndex;
  bool _showPreparedAnswer = false;
  final _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.preferences.followedBookIds().contains(
      widget.post.bookId,
    );
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
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
              if (widget.post.imageAsset case final imageAsset?) ...[
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imageAsset,
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.cover,
                    semanticLabel: 'Original illustration for ${book.title}',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.post.imageAttribution!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF7C857D),
                  ),
                ),
              ],
              if (widget.post.threadParts.isNotEmpty) ...[
                const SizedBox(height: 18),
                for (
                  var index = 0;
                  index < widget.post.threadParts.length;
                  index++
                )
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFFE8F0E8),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Color(0xFF34533F),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(widget.post.threadParts[index])),
                      ],
                    ),
                  ),
              ],
              if (const {'Poll', 'Quiz', 'Debate'}.contains(widget.post.kind))
                _PostInteractionPanel(
                  post: widget.post,
                  selectedOptionIndex: _selectedOptionIndex,
                  onOptionSelected: (index) =>
                      setState(() => _selectedOptionIndex = index),
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
              const SizedBox(height: 20),
              _PreparedAnswerPanel(
                post: widget.post,
                controller: _questionController,
                showAnswer: _showPreparedAnswer,
                onShowAnswer: () => setState(() => _showPreparedAnswer = true),
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
          nextValue
              ? 'Following ${widget.repository.bookFor(widget.post).title}'
              : 'Unfollowed ${widget.repository.bookFor(widget.post).title}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _PostInteractionPanel extends StatelessWidget {
  const _PostInteractionPanel({
    required this.post,
    required this.selectedOptionIndex,
    required this.onOptionSelected,
  });

  final Post post;
  final int? selectedOptionIndex;
  final ValueChanged<int> onOptionSelected;

  @override
  Widget build(BuildContext context) {
    final isQuiz = post.kind == 'Quiz';
    final answered = selectedOptionIndex != null;
    final correct = isQuiz && selectedOptionIndex == post.correctOptionIndex;

    return Card(
      color: const Color(0xFFF4F7F2),
      margin: const EdgeInsets.only(top: 24),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              post.question ?? 'Choose an answer',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            for (var index = 0; index < post.options.length; index++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton(
                  onPressed: isQuiz && answered
                      ? null
                      : () => onOptionSelected(index),
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    backgroundColor: selectedOptionIndex == index
                        ? const Color(0xFFE0ECE1)
                        : Colors.white,
                  ),
                  child: Text(post.options[index]),
                ),
              ),
            if (answered)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  isQuiz
                      ? '${correct ? 'That’s right.' : 'Not quite.'} ${post.explanation}'
                      : post.kind == 'Poll'
                      ? 'Vote recorded: ${post.options[selectedOptionIndex!]}'
                      : 'Your vote: ${post.options[selectedOptionIndex!]}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF34533F),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PreparedAnswerPanel extends StatelessWidget {
  const _PreparedAnswerPanel({
    required this.post,
    required this.controller,
    required this.showAnswer,
    required this.onShowAnswer,
  });

  final Post post;
  final TextEditingController controller;
  final bool showAnswer;
  final VoidCallback onShowAnswer;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF4F7F2),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Ask the book',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Prepared demo only: your question is not interpreted by a live AI.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF6E776F)),
            ),
            const SizedBox(height: 12),
            Text(
              'Passage context',
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(post.contextSummary!),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Ask a follow-up question',
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: FilledButton.tonal(
                onPressed: onShowAnswer,
                child: const Text('Show prepared sample'),
              ),
            ),
            if (showAnswer) ...[
              const Divider(height: 24),
              Text(
                'Prepared sample · ${post.answerBasis == 'book' ? 'From the book' : 'Broader knowledge'}',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF34533F),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(post.sampleAnswer!),
              const SizedBox(height: 8),
              Text(
                'Example question: ${post.sampleQuestion}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF6E776F)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
