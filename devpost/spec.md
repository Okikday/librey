---
doc: spec
status: approved
---

# LibreY — Technical Spec

## How This Works, In Plain Language

LibreY will be a Flutter web app that runs in a browser on the learner’s computer. A small set of book passages, prepared posts, and images ships with the app, so the feed and reader work without a content server. The app keeps the reader’s chosen topics, followed books, and browsing signals in that browser only.

The feed sorts those prepared posts using a small local score: the selected topics guide the starting mix, opening a post or spending time on it raises that topic’s score, and repeatedly passing posts lowers it. A few posts from other topics remain in the mix for discovery.

The AI button will be a clearly marked demo, not a live AI service. It accepts a typed question and displays a prepared, passage-specific sample answer. This keeps the interaction available without an API key or server, but it does not understand arbitrary questions. Each post still points to a real book passage, and the reader can open that passage in LibreY.

This shape uses the learner’s Flutter experience, keeps the demo reliable offline, and avoids accounts, hosting, an AI key, and a production recommendation system.

## The Core Journey Through the System

PRD ref: `prd.md > The Core Journey`.

1. **First visit:** `OnboardingScreen` explains AI provenance and lets the reader pick topics or skip. `ReaderPreferencesStore` saves the choice in this browser.
2. **For You:** `DemoContentRepository` loads the bundled book and post data. `FeedRanker` uses topic choices and saved local engagement signals to order the feed.
3. **Browse and interact:** `FeedScreen` renders `PostCard` widgets. Opening a card, dwelling on it, or answering a poll, quiz, or debate updates the app state; the ranking service records relevant topic signals.
4. **Full post:** `PostDetailScreen` shows the complete card, book follow action, provenance details, and AI demo panel. Following a book updates the saved preferences.
5. **Ask a question:** `DemoAiPanel` accepts text and displays a prepared sample response associated with the post. The response is explicitly marked as a demo sample, not a live model answer.
6. **Open the source:** `BookReaderScreen` looks up the post’s `passageId`, shows the matching section with the cited passage highlighted, and offers the original Project Gutenberg source link.
7. **Following:** The feed filters to followed book IDs. If none are followed, `FollowingEmptyState` explains that the feed is empty; readers follow books from their full-post views.

## Stack

- **Flutter 3.44.6 stable / Dart 3.12.2** — versions available in the project environment when this spec was written. Flutter Web is the agreed platform and uses the learner’s existing Flutter experience. Verify the installed SDK and generated web support at the first build step.
  - Docs: [Flutter Web](https://docs.flutter.dev/platform-integration/web)
- **Flutter Material 3** — built into Flutter; provides responsive layout primitives and standard accessible controls without adding a UI framework.
  - Docs: [Material components for Flutter](https://docs.flutter.dev/ui/widgets/material)
- **`shared_preferences`** — small local-only values for topics, follows, and topic engagement scores. Use the current supported async/cache API rather than the legacy API. It is not a database and is not suitable for critical data.
  - Docs: [shared_preferences](https://pub.dev/packages/shared_preferences)
- **`url_launcher`** — opens a book’s original Gutenberg page in the browser.
  - Docs: [url_launcher](https://pub.dev/packages/url_launcher)
- **Flutter SDK test tools** — widget and data tests; no additional test package is required.

Package versions should be resolved to current Flutter-compatible releases during setup and recorded in `pubspec.lock`. Confirm both plugins work on Web before building on them.

## Where It Runs and How Someone Tries It

- **Runtime:** Local Flutter Web app in a desktop or mobile-sized browser viewport. No server, account, or API key is needed.
- **Environment:** Flutter 3.44.6 stable and Dart 3.12.2 were available in the workspace at spec time. No secrets or environment files are required.
- **Start and record:**
  ```sh
  flutter pub get
  flutter run -d chrome
  ```
  Open the local URL printed by Flutter. If Chrome is not available as a Flutter device, run `flutter run -d web-server --web-port 7357` and open `http://localhost:7357`.
- For the required demo video, show topic selection or skipping, For You, a post interaction, the book source highlight, and the Following state. Use a narrow browser viewport for the mobile layout.
- A short demo video and public GitHub repository are required for submission. Deployment is optional and was not chosen; the local app is sufficient to record and demonstrate the proof of concept.

## Look and Feel

- Use Flutter Material 3 with a light, restrained palette, comfortable standard spacing, and a readable sans-serif system font; avoid a dense or generic AI-dashboard appearance.
- Keep cards familiar and easy to scan like a social feed. Use subtle dashed dividers between cards and reserve images for a minority of posts.
- Use responsive layout constraints: desktop navigation in a sidebar; mobile navigation in a top “more” bar; keep For You and Following visible at both sizes.
- Keep post copy conversational and natural. Put AI provenance in onboarding and post details rather than making it a dominant badge on every card.
- These are implementation translations of `prd.md > Look and Feel` and `scope.md > Inspiration & Identity`; no palette, font family, or visual reference beyond those preferences was selected.

## Components

### `LibreYApp`

Owns the app theme, initial route, and transitions between onboarding, feed, full post, and reader.
PRD ref: `prd.md > Screens and Layout`.

### `ResponsiveNavigation`

Uses a desktop sidebar and mobile top “more” navigation while preserving For You and Following tabs at both sizes.
PRD ref: `prd.md > Screens and Layout`, `prd.md > Look and Feel`.

### `OnboardingScreen`

Shows the notice that some posts are AI-generated and lets the reader choose topics or skip. Saves topic selection before opening the feed.
PRD ref: `prd.md > Topic Onboarding and For You`, `prd.md > Look and Feel`.

### `FeedScreen`

Owns the For You/Following selection and renders the ordered or filtered list. Records visible-card timing and post opens for For You signals.
PRD ref: `prd.md > Topic Onboarding and For You`, `prd.md > Book-Following Feed`.

### `PostCard`

Displays a text-led, image, article-like, or one of the six post kinds. Selecting a card opens its full-post view.
PRD ref: `prd.md > Screens and Layout`, `prd.md > Grounded, Varied Posts`.

### `PostInteraction`

Shows the interactive controls and result state for polls, quizzes, and debate votes.
PRD ref: `prd.md > Grounded, Varied Posts`, `prd.md > States and Boundaries`.

### `PostDetailScreen`

Shows the full post, book identity, follow/unfollow action, provenance details, and source action. Its back button returns to the previous feed tab and scroll position.
PRD ref: `prd.md > Full Post, AI Context, and Source Reading`, `prd.md > Book-Following Feed`.

### `DemoAiPanel`

Accepts a typed follow-up and displays the prepared sample response linked to that post. Clearly labels responses as prepared demo samples and does not claim to call a live model or understand arbitrary prompts.
PRD ref: `prd.md > Full Post, AI Context, and Source Reading`.

### `BookReaderScreen`

Displays the passage’s book, section/chapter label, surrounding excerpt, and visibly highlighted cited text. Provides an external link to the book’s Project Gutenberg page. If bundled passage data is missing, show an explicit unavailable state rather than a different passage.
PRD ref: `prd.md > Full Post, AI Context, and Source Reading`.

### `FollowingEmptyState`

Explains that Following contains posts only from followed books. It has no follow action; readers follow a book from its full-post view.
PRD ref: `prd.md > Book-Following Feed`, `prd.md > States and Boundaries`.

### `DemoContentRepository`

Loads bundled book, passage, post, poll, quiz, debate, image, and prepared AI-response fixtures. Exposes lookups by stable IDs so each post’s source remains unambiguous.
PRD ref: `prd.md > Grounded, Varied Posts`, `prd.md > Full Post, AI Context, and Source Reading`.

### `FeedRanker`

Builds For You order from selected topics and local engagement signals. Keep a discovery mix of other subjects and lower a topic’s score when the reader repeatedly passes its posts. Following bypasses ranking and filters strictly to followed book IDs.
PRD ref: `prd.md > Topic Onboarding and For You`, `prd.md > Book-Following Feed`.

### `ReaderPreferencesStore`

Reads and writes the reader’s topics, followed book IDs, and For You topic signals using `shared_preferences`. Handles first launch with no preferences. If reading or writing fails, shows a notice that settings may not persist and continues with temporary defaults.
PRD ref: `prd.md > Topic Onboarding and For You`, `prd.md > Book-Following Feed`, `prd.md > States and Boundaries`.

## Data Model

All book and post content is bundled and read-only; reader state is stored locally in the current browser.

- **Book:** stable ID, title, author, subject, Project Gutenberg URL, and passage IDs.
- **Passage:** stable ID, book ID, section/chapter label, exact source text, and a surrounding excerpt used by the reader. The exact text is the text highlighted in the reader.
- **Post:** stable ID, book ID, passage ID, post kind, text or thread parts, AI provenance, a verbatim supporting evidence quote, optional image asset/attribution, and optional poll/quiz/debate data. Every post must reference an existing book and passage; the evidence quote must occur character-for-character in that passage.
- **Prepared AI response:** post ID, optional matching sample prompt, answer text, source basis (`book` or `broader knowledge`), and a “prepared demo response” marker. These answers are static fixture data.
- **Local reader state:** selected topic IDs, followed book IDs, and per-topic engagement scores. Poll/quiz selections and open chat text may remain in memory for the current app session; they are not account data and need not sync.
- **Image attribution:** image asset path, source page, creator, and license/attribution text.

`shared_preferences` is browser-local and best-effort, not a secure store or cross-device database. If it is empty or unavailable, use unselected topics, no followed books, and the balanced all-subject starting feed.

## Verification Approach

- Run `flutter analyze` and `flutter test`.
- `demo_content_test.dart` checks that every post references a real bundled book and passage, every evidence quote occurs exactly in its passage, every required post kind has a demo fixture, and prepared answers identify whether they use the book or broader knowledge.
- `feed_ranker_test.dart` checks that selected topics influence initial order, engagement can raise a topic, repeated skips can lower it, discovery remains available, and Following excludes non-followed books.
- `core_journey_test.dart` checks optional onboarding, opening a post and returning, poll/quiz/debate selection states, opening a cited passage, the AI demo label and prepared response, book following, and empty Following.
- Check the feed at desktop and mobile viewport widths to verify the sidebar/top-bar layouts and visible For You/Following tabs.

## File Structure

```text
librey/
├── pubspec.yaml
├── pubspec.lock
├── assets/
│   ├── data/
│   │   ├── books.json
│   │   ├── passages.json
│   │   ├── posts.json
│   │   └── image_attributions.json
│   └── images/
│       └── ...                 # Locally bundled, attributed images
├── lib/
│   ├── main.dart               # Flutter entry point
│   ├── app.dart                # Theme and app/navigation shell
│   ├── models/
│   │   ├── book.dart
│   │   ├── passage.dart
│   │   └── post.dart
│   ├── data/
│   │   └── demo_content_repository.dart
│   ├── state/
│   │   ├── reader_preferences_store.dart
│   │   └── feed_ranker.dart
│   ├── screens/
│   │   ├── onboarding_screen.dart
│   │   ├── feed_screen.dart
│   │   ├── post_detail_screen.dart
│   │   └── book_reader_screen.dart
│   └── widgets/
│       ├── responsive_navigation.dart
│       ├── post_card.dart
│       ├── post_interaction.dart
│       ├── demo_ai_panel.dart
│       └── following_empty_state.dart
├── test/
│   ├── demo_content_test.dart
│   ├── feed_ranker_test.dart
│   └── core_journey_test.dart
└── devpost/                    # Planning docs; learner profile is git-ignored
```

## External Services and Dependencies

- **Project Gutenberg:** source for public-domain text only; no runtime API calls. Use short exact passages from [The Origin of Species](https://www.gutenberg.org/ebooks/1228), [The Wealth of Nations](https://www.gutenberg.org/ebooks/3300), and [Meditations](https://www.gutenberg.org/ebooks/2680). Store each title’s source URL, edition/section, and exact passage in the bundled data. Verify the selected text and applicable Gutenberg terms during content preparation.
  - Project Gutenberg information: [https://www.gutenberg.org/help/](https://www.gutenberg.org/help/)
- **Images:** source a few public-domain or openly licensed images from [Wikimedia Commons](https://commons.wikimedia.org/) or [Openverse](https://openverse.org/). Verify each image’s license and attribution, bundle it locally, and include source, creator, and license in the attribution data. No runtime image API.
- **`shared_preferences`:** local browser storage for small preference values; no account, sync, or sensitive data. Docs: [https://pub.dev/packages/shared_preferences](https://pub.dev/packages/shared_preferences).
- **`url_launcher`:** opens source book pages in the browser; no key or paid service. Docs: [https://pub.dev/packages/url_launcher](https://pub.dev/packages/url_launcher).
- **AI service:** none in the POC. Prepared answer fixtures replace live model calls; no API credentials are collected or shipped.

## Important Failure Modes

- **Local preferences are missing or unreadable** → an empty store means first use; if reading or writing fails, show a notice that settings may not persist and continue with temporary defaults, rather than silently treating writes as durable.
- **A post points to a missing passage or quote that does not match its bundled source** → fail the content test and do not show a substitute source as verification.
- **An external Gutenberg page cannot open** → keep the bundled passage readable and show an explicit message if the external link cannot be launched.
- **A reader expects a real AI answer** → the panel labels each response as a prepared demo sample and explains that arbitrary prompts are not interpreted by a live model.

## What Was Simplified and Why

- **Bundled, pre-prepared feed posts and passages** instead of generating the feed at runtime — keeps content available offline and each source checkable without a backend.
- **A prepared-response chat demonstration** instead of a live AI service — avoids API credentials, cost, network failures, and a server while preserving the visible interaction. Responses are explicitly identified as samples.
- **A local topic-score feed** instead of a production recommender — demonstrates topic, open, and dwell signals without accounts, server history, or a complex ranking service.
- **Three books with a few curated passages each** instead of a complete searchable library — enough to show subject variety and the tap-to-source loop in a short demo.
- **Votes and chat remain session-only** — the POC demonstrates the interaction without building a server-backed social system.

## Decisions and Open Issues

- **Learner choice:** Flutter Web is the agreed platform because it fits the responsive browser experience and the learner’s Flutter background.
- **Learner choice:** Use prepared AI-response samples for the POC rather than requiring a paid or potentially unreliable free AI service. The learner agreed that typed input will not be understood by a live model and that responses must be clearly identified as samples.
- **Learner choice:** Topic choices and follows persist locally in the browser, without accounts or device sync.
- **Learner choice:** Use the three demo titles from the original pitch and bundle short exact passages so the demo reader does not depend on a network.
- **Learner choice:** Bundle openly licensed/public-domain images with attribution, rather than using a runtime image service.
- **Learner choice:** A local browser demo is sufficient; no deployment target was selected.
- **Implementation detail derived from the PRD:** For You uses local topic scores from chosen interests, post opens, and dwell; it keeps a small discovery mix and lowers topics repeatedly skipped. This is a demo approximation, not production personalization.
- **Implementation detail derived from the PRD:** The no-topic starting feed uses a balanced mix of the subjects available in the bundled data.
- **Learning question clarified:** The learner asked whether prepared AI replies were acceptable or a free live alternative was needed. The distinction was clarified: prepared sample answers avoid service/API setup, but cannot understand arbitrary typed questions; the learner accepted this limitation when the UI labels responses as samples.
- **Open during build, not blocking approval:** Verify current plugin web support and APIs, check citations and exact Gutenberg passages, confirm each image license/attribution, and validate the responsive breakpoints in a browser.
