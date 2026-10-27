# LibreY

LibreY is a Flutter Web proof of concept for a reading feed grounded in public-domain books. Readers can browse short posts, interact with polls and quizzes, and open the source passage behind a post.

## Features

- A bundled feed of 18 posts from three books: *On the Origin of Species*, *The Wealth of Nations*, and *Meditations*.
- Six post kinds: Insight, Quote, Word, Thread, Quiz, and Debate, plus poll cards.
- Exact evidence quotes and passage links checked against bundled book text.
- A reader that highlights the cited passage and links to the book on Project Gutenberg.
- Topic-based For You ordering with local engagement signals, discovery slots, and book diversity.
- Following by book, with preferences stored in the current browser.
- A prepared-answer demonstration on post details. It does not call a live AI model or interpret typed questions.
- Responsive desktop and mobile layouts.

This prototype has no account system, backend, live AI service, persistent votes, or rooms/chat. Quiz and poll selections are temporary.

## Requirements

- Flutter 3.44.6 or a compatible stable release
- Dart 3.12.2 or a compatible version

## Run locally

From the repository root:

```sh
flutter pub get
flutter run -d chrome
```

Flutter prints the local app URL. If Chrome is not available as a Flutter device, use the web-server target instead:

```sh
flutter run -d web-server --web-port 7357
```

Then open <http://localhost:7357>.

## Verify

Run static analysis and the test suite:

```sh
flutter analyze
flutter test
```

Tests cover source and quote integrity, feed ranking and diversity, post interactions, the core reader journey, and desktop/mobile layout rendering.

## Project structure

- `assets/data/` — bundled books, passages, and post fixtures.
- `assets/images/` — original bundled illustrations with attribution in the post data.
- `lib/data/` — content repository, browser preferences, and feed ranking.
- `lib/screens/` — onboarding, feed, post detail, and source reader screens.
- `lib/widgets/` — reusable feed components.
- `test/` — content, ranking, interaction, journey, and responsive-layout tests.
- `devpost/app-map.html` — offline guide to the app flow and code locations.

All feed content and source passages are bundled; the app makes no runtime content or AI API calls. Book source pages link to Project Gutenberg:

- <https://www.gutenberg.org/ebooks/1228>
- <https://www.gutenberg.org/ebooks/3300>
- <https://www.gutenberg.org/ebooks/2680>

## License

This project is licensed under the [MIT License](LICENSE).
