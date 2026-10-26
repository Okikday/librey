import 'package:flutter/material.dart';

import '../data/demo_content_repository.dart';
import '../data/user_preferences.dart';
import '../models/post.dart';
import '../widgets/dashed_divider.dart';
import '../widgets/post_card.dart';
import 'post_detail_screen.dart';

enum FeedTab { forYou, following }

class FeedScreen extends StatefulWidget {
  const FeedScreen({
    super.key,
    required this.repository,
    required this.preferences,
  });

  final DemoContentRepository repository;
  final UserPreferences preferences;

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  FeedTab _activeTab = FeedTab.forYou;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final desktop = constraints.maxWidth >= 960;
            return Row(
              children: [
                if (desktop)
                  _DesktopSidebar(
                    activeTab: _activeTab,
                    onTabSelected: (tab) => setState(() => _activeTab = tab),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      if (!desktop)
                        _MobileTopBar(
                          activeTab: _activeTab,
                          onTabSelected: (tab) =>
                              setState(() => _activeTab = tab),
                        ),
                      Expanded(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 690),
                            child: _FeedColumn(
                              activeTab: _activeTab,
                              repository: widget.repository,
                              preferences: widget.preferences,
                              onTabSelected: (tab) =>
                                  setState(() => _activeTab = tab),
                              onPostReturned: () => setState(() {}),
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
  const _FeedColumn({
    required this.activeTab,
    required this.repository,
    required this.preferences,
    required this.onTabSelected,
    required this.onPostReturned,
  });

  final FeedTab activeTab;
  final DemoContentRepository repository;
  final UserPreferences preferences;
  final ValueChanged<FeedTab> onTabSelected;
  final VoidCallback onPostReturned;

  List<Post> _postsForTab() {
    final selectedTopics = preferences.selectedTopics();
    final followedBooks = preferences.followedBookIds();

    if (activeTab == FeedTab.following) {
      final followedPosts = repository.posts
          .where((post) => followedBooks.contains(post.bookId))
          .toList(growable: false);
      return followedPosts;
    }

    final orderedPosts = List<Post>.of(repository.posts);
    if (selectedTopics.isEmpty) {
      return orderedPosts;
    }

    orderedPosts.sort((left, right) {
      final leftMatch = selectedTopics.contains(
        repository.bookFor(left).subject,
      );
      final rightMatch = selectedTopics.contains(
        repository.bookFor(right).subject,
      );
      if (leftMatch == rightMatch) {
        return 0;
      }
      return leftMatch ? -1 : 1;
    });
    return orderedPosts;
  }

  @override
  Widget build(BuildContext context) {
    final posts = _postsForTab();
    final title = activeTab == FeedTab.forYou ? 'For You' : 'Following';
    final subtitle = activeTab == FeedTab.forYou
        ? 'A little scroll. A little wiser.'
        : 'Books you follow, in one place.';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 26, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6E776F),
                ),
              ),
              const SizedBox(height: 14),
              SegmentedButton<FeedTab>(
                segments: const [
                  ButtonSegment<FeedTab>(
                    value: FeedTab.forYou,
                    label: Text('For You'),
                  ),
                  ButtonSegment<FeedTab>(
                    value: FeedTab.following,
                    label: Text('Following'),
                  ),
                ],
                selected: {activeTab},
                onSelectionChanged: (selection) =>
                    onTabSelected(selection.first),
                showSelectedIcon: false,
              ),
            ],
          ),
        ),
        const DashedDivider(),
        Expanded(
          child: posts.isEmpty
              ? _FollowingEmptyState(activeTab: activeTab)
              : ListView.builder(
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
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => PostDetailScreen(
                                  post: post,
                                  repository: repository,
                                  preferences: preferences,
                                ),
                              ),
                            );
                            if (context.mounted) {
                              onPostReturned();
                            }
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

class _FollowingEmptyState extends StatelessWidget {
  const _FollowingEmptyState({required this.activeTab});

  final FeedTab activeTab;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.bookmark_border_rounded,
              size: 42,
              color: Color(0xFF6E776F),
            ),
            const SizedBox(height: 18),
            Text(
              activeTab == FeedTab.following
                  ? 'No followed books yet'
                  : 'Nothing matched this view',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              activeTab == FeedTab.following
                  ? 'Follow a book from its full post, and its reading feed will appear here.'
                  : 'Try switching back to For You for a broader mix.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF697669)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  const _DesktopSidebar({required this.activeTab, required this.onTabSelected});

  final FeedTab activeTab;
  final ValueChanged<FeedTab> onTabSelected;

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
          GestureDetector(
            onTap: () => onTabSelected(FeedTab.forYou),
            child: _NavigationItem(
              icon: Icons.dynamic_feed_outlined,
              label: 'For You',
              selected: activeTab == FeedTab.forYou,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => onTabSelected(FeedTab.following),
            child: _NavigationItem(
              icon: Icons.bookmark_outline,
              label: 'Following',
              selected: activeTab == FeedTab.following,
            ),
          ),
          const SizedBox(height: 18),
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
  const _MobileTopBar({required this.activeTab, required this.onTabSelected});

  final FeedTab activeTab;
  final ValueChanged<FeedTab> onTabSelected;

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
      width: 160,
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
