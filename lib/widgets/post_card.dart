import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.book,
    required this.onTap,
  });

  final Post post;
  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open post from ${book.title}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: _subjectColor(book.subject),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _subjectIcon(book.subject),
                      color: const Color(0xFF426A52),
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 11),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${book.id.replaceAll('-', '')} · ${book.subject}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFF7C857D)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    post.kind,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF718173),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                post.body,
                maxLines: post.isArticle ? 6 : null,
                overflow: post.isArticle ? TextOverflow.ellipsis : null,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.55,
                  letterSpacing: -0.1,
                ),
              ),
              if (post.imageAsset case final imageAsset?) ...[
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imageAsset,
                    width: double.infinity,
                    height: 205,
                    fit: BoxFit.cover,
                    semanticLabel: 'Original illustration for ${book.title}',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  post.imageAttribution!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF7C857D),
                  ),
                ),
              ],
              if (post.kind == 'Thread' && post.threadParts.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  '${post.threadParts.length} parts · Open to read the thread',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF426A52),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.menu_book_outlined,
                    size: 16,
                    color: Color(0xFF718173),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'From ${book.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: const Color(0xFF718173),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 17,
                    color: Color(0xFF718173),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _subjectColor(String subject) {
    return switch (subject) {
      'Science' => const Color(0xFFE5F0E8),
      'Economics' => const Color(0xFFF2EBDD),
      _ => const Color(0xFFECE8F1),
    };
  }

  IconData _subjectIcon(String subject) {
    return switch (subject) {
      'Science' => Icons.eco_outlined,
      'Economics' => Icons.account_balance_outlined,
      _ => Icons.self_improvement_outlined,
    };
  }
}
