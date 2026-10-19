import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/book.dart';
import '../models/passage.dart';

class BookReaderScreen extends StatelessWidget {
  const BookReaderScreen({
    super.key,
    required this.book,
    required this.passage,
  });

  final Book book;
  final Passage passage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back to post',
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(28, 22, 28, 48),
            children: [
              Text(
                book.author.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF768078),
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                passage.section,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'The highlighted words are the passage behind the post.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF768078),
                ),
              ),
              const SizedBox(height: 24),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F5F0),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE6EAE2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: SelectableText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: passage.text,
                          style: const TextStyle(
                            color: Color(0xFF292F2A),
                            backgroundColor: Color(0xFFFFEDB7),
                            height: 1.8,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => _openSource(context),
                icon: const Icon(Icons.open_in_new),
                label: const Text('View original on Project Gutenberg'),
                style: OutlinedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 15,
                  ),
                  foregroundColor: const Color(0xFF34533F),
                  side: const BorderSide(color: Color(0xFFDCE5DC)),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Project Gutenberg eBook · ${book.title}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF849087),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openSource(BuildContext context) async {
    try {
      final opened = await launchUrl(
        Uri.parse(book.sourceUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!opened && context.mounted) {
        _showLinkError(context);
      }
    } on PlatformException {
      if (context.mounted) {
        _showLinkError(context);
      }
    }
  }

  void _showLinkError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('The Project Gutenberg page could not be opened.'),
      ),
    );
  }
}
