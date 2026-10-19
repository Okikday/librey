import 'package:flutter/material.dart';

import '../data/demo_content_repository.dart';
import '../models/post.dart';
import '../widgets/dashed_divider.dart';
import '../widgets/post_card.dart';
import 'post_detail_screen.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key, required this.repository});

  final DemoContentRepository repository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth >= 960;
            return Row(
              children: [
                if (desktop) const _DesktopSidebar(),
                Expanded(
                  child: Column(
                    children: [
                      if (!desktop) const _MobileTopBar(),
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 690),
                            child: _FeedColumn(
                              posts: repository.posts,
                              repository: repository,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FeedColumn extends StatelessWidget {
  const _FeedColumn({required this.posts, required this.repository});

  final List<Post> posts;
  final DemoContentRepository repository;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'For You',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'A little scroll. A little wiser.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6E776F),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 58,
                height: 3,
                decoration: BoxDecoration(
                  color: const Color(0xFF426A52),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const DashedDivider(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final book = repository.bookFor(post);
              return Column(
                children: [
                  PostCard(
                    post: post,
                    book: book,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => PostDetailScreen(
                            post: post,
                            repository: repository,
                          ),
                        ),
                      );
                    },
                  ),
                  if (index != posts.length - 1) const DashedDivider(),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xFFE8ECE8))),
      ),
      padding: const EdgeInsets.fromLTRB(28, 30, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Brand(),
          const SizedBox(height: 42),
          const _NavigationItem(
            icon: Icons.dynamic_feed_outlined,
            label: 'For You',
            selected: true,
          ),
          const SizedBox(height: 10),
          Text(
            'GOOD TO KNOW',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFF929A93),
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            'Real books. Fresh perspectives.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF778078)),
          ),
        ],
      ),
    );
  }
}

class _MobileTopBar extends StatelessWidget {
  const _MobileTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 14, 8),
      child: Row(
        children: [
          const _Brand(compact: true),
          const Spacer(),
          PopupMenuButton<String>(
            tooltip: 'More',
            icon: const Icon(Icons.more_horiz),
            onSelected: (_) {
              showAboutDialog(
                context: context,
                applicationName: 'LibreY',
                applicationVersion: 'Preview',
                children: const [
                  Text('A lively feed grounded in real public-domain books.'),
                ],
              );
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'about', child: Text('About LibreY')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 34 : 38,
          height: compact ? 34 : 38,
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0E8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: Color(0xFF426A52),
            size: 21,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'LibreY',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEAF1EA) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: selected ? const Color(0xFF426A52) : const Color(0xFF778078),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: selected
                  ? const Color(0xFF304D3C)
                  : const Color(0xFF616B63),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
