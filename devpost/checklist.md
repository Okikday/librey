---
doc: checklist
status: approved
---

# Build Checklist

Build mode: fast

## Slices

- [x] **1. Browse a grounded post and open its real book passage**
  Becomes usable: A running Flutter Web app opens to a readable, responsive feed of bundled posts and opens a selected post at its exact, highlighted passage in a focused reader.
  Why now: This is LibreY’s distinctive feed-to-source promise. It comes first so the first working increment proves the kernel rather than building generic scaffolding. Project setup, responsive shell, bundled data, and source verification are included in this vertical slice.
  PRD ref: `prd.md > The Core Journey`, `prd.md > Screens and Layout`, `prd.md > Grounded, Varied Posts`, `prd.md > Full Post, AI Context, and Source Reading`
  Spec ref: `spec.md > Stack`, `spec.md > Where It Runs and How Someone Tries It`, `spec.md > Look and Feel`, `spec.md > Components`, `spec.md > Data Model`, `spec.md > File Structure`, `spec.md > External Services and Dependencies`, `spec.md > Important Failure Modes`, `spec.md > What Was Simplified and Why`
  Build: Bootstrap the Flutter Web project and dependencies; add the responsive app shell, book/post/passage models, bundled Gutenberg source excerpts, a small text-led feed, post detail, and reader passage highlighting with source link. Add a source integrity test that checks post references and exact supporting quotes. Do not include learner-profile or curriculum files in project commits.
  Verify (mechanical): Run `flutter analyze` and `flutter test`; run `flutter run -d web-server --web-port 7357` and confirm the app serves successfully at `http://localhost:7357`.
  Learner check: Open the local app, choose a post, then open its source. Check that the post feels like a natural feed item and that the highlighted passage is the real text behind it.
  Commit: `Build grounded feed and source reader`

- [x] **2. Choose interests and follow books across visits**
  Becomes usable: First-use readers can choose topics or skip, select For You or Following, follow a book from its full post, and retain topic/follow choices in this browser.
  Why now: These choices personalize the reader’s next visit and give Following its clear book-based meaning; they build on the working post and source from slice 1.
  PRD ref: `prd.md > The Core Journey`, `prd.md > Screens and Layout`, `prd.md > Topic Onboarding and For You`, `prd.md > Book-Following Feed`, `prd.md > States and Boundaries`
  Spec ref: `spec.md > Stack`, `spec.md > Where It Runs and How Someone Tries It`, `spec.md > Components`, `spec.md > Data Model`, `spec.md > Important Failure Modes`
  Build: Add the AI-content onboarding notice and optional topic selection, For You/Following tabs, full-post follow/unfollow action, strict followed-book filtering, an empty Following state, and browser-local preference persistence. Handle storage failure with a visible notice and temporary defaults.
  Verify (mechanical): Run `flutter analyze` and `flutter test`; test selecting/skipping topics, following/unfollowing a book, strict Following filtering, empty Following, and preference restoration with a browser-storage test or supported test harness.
  Learner check: Select a topic, follow a book from its full post, reload, and open Following. Confirm the choices remain on this browser and only followed-book posts appear; then unfollow and inspect the empty state.
  Commit: `Add onboarding and book following`

- [ ] **3. Interact with varied posts and the prepared AI demo**
  Becomes usable: The feed includes all six post kinds, a minority of attributed image cards, a few longer posts, working poll/quiz/debate interactions, and a clearly labelled prepared-answer panel on every post.
  Why now: The core source path and reader choices are already usable. This adds the entertaining variety and post-level interactions without introducing a server or implying live AI.
  PRD ref: `prd.md > Grounded, Varied Posts`, `prd.md > Full Post, AI Context, and Source Reading`, `prd.md > States and Boundaries`, `prd.md > Look and Feel`
  Spec ref: `spec.md > Look and Feel`, `spec.md > Components`, `spec.md > Data Model`, `spec.md > External Services and Dependencies`, `spec.md > Important Failure Modes`, `spec.md > What Was Simplified and Why`
  Build: Add and verify fixtures for insight, quote, word, thread, quiz, and debate; add interactive poll and debate votes plus quiz answer reveal; bundle a few verified images with attribution and a few longer articles; add a typed-question UI that displays passage-specific prepared sample answers and identifies book-derived versus broader-knowledge answers. Make clear that typed text is not interpreted by a live model.
  Verify (mechanical): Run `flutter analyze` and `flutter test`; check fixtures cover every post kind, quotes match their source exactly, image attribution is present, poll/debate votes register, quiz answers reveal correctly, and prepared responses show the sample and source-basis labels.
  Learner check: Try a poll and quiz, open the AI panel on a post, type a question, and inspect the sample/source labels. Confirm the feed still feels mostly text-led and natural.
  Commit: `Add post interactions and AI demo`

- [ ] **4. Adapt For You and verify the complete responsive journey**
  Becomes usable: For You visibly adjusts its balanced, discovery-preserving order from topic choices, post opens, dwell, and repeated skips; the complete experience is verified at desktop and mobile sizes.
  Why now: Ranking needs the topics and engagement interactions from earlier slices. Keeping it last avoids building a recommender before there is a real feed to rank, while still completing the approved demo behavior.
  PRD ref: `prd.md > The Core Journey`, `prd.md > Screens and Layout`, `prd.md > Topic Onboarding and For You`, `prd.md > Book-Following Feed`, `prd.md > Grounded, Varied Posts`, `prd.md > Full Post, AI Context, and Source Reading`
  Spec ref: `spec.md > The Core Journey Through the System`, `spec.md > Look and Feel`, `spec.md > Components`, `spec.md > Data Model`, `spec.md > Verification Approach`
  Build: Implement the local demo-sized feed ranker with selected-topic starting relevance, open/dwell engagement, repeated-skip reductions, a discovery mix, and stable Following filtering. Persist topic signals locally, refine responsive desktop sidebar/mobile top bar and feed tabs, then connect the full onboarding-to-source journey.
  Verify (mechanical): Run `flutter analyze` and `flutter test`; run the web app and verify desktop and narrow/mobile layouts. Tests must demonstrate topic selection affecting initial order, positive engagement raising a topic, repeated skips lowering it, discovery remaining available, and Following excluding non-followed books.
  Learner check: Use the app at desktop and phone-sized widths. Complete onboarding or skip it, browse and open a post, inspect its passage, try Following, and check whether For You responds to the browsing signals as described.
  Commit: `Add adaptive feed and verify core journey`

## Hands-on Checkpoints

- [x] Early usable behavior explored — after slice 1, try the grounded feed-to-source journey and share design/content feedback before onboarding and ranking are added.
- [ ] Final kick-the-tires exploration and feedback completed — after slice 4, explore the complete desktop and mobile journey, including awkward or empty states.

## Final Review

- [ ] Final review complete — feedback resolved and learner confirms ready to ship

## Code Tour and App Map

- [ ] Learning activity complete — connect the learner’s agent-workflow goal to one actual planning decision, test, or implementation path
- [ ] Optional edit and transfer reflection addressed — offered/declined/already covered/not applicable as appropriate
- [ ] `devpost/app-map.html` generated from finished code, checked, and shown, including a project-grounded practice to reuse

Activity and evidence: [record actual activity, evidence, and any unfinished work]
Route and stops: [record actual paths and symbols visited, or reference-only route]
Edit outcome: [record tried/kept/reverted/declined/not applicable and verification]
Reflection: [record offered/answered/declined/already covered]
Activity mode: [record live app/editor, static fallback, focused alternative, prior practice, or recap]

## Revisions
