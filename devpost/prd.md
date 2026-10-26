---
doc: prd
status: approved
---

# LibreY — Product Requirements

LibreY is a familiar, lively social feed for people who want entertaining browsing to leave them with something to learn.
Source: `scope.md > The Unique Kernel`, `scope.md > Who It's For`.

## The Core Journey

1. On first use, a reader sees a brief notice that some posts may be AI-generated, then can choose areas of interest such as economics, computer science, or arts. Topic selection can be skipped.
2. The reader lands on **For You**, a mixed feed that starts from their chosen topics. The feed contains mostly concise, text-led posts, with some image posts and a few longer articles. Posts use varied formats and a natural, fun voice rather than formal or visibly machine-written copy.
3. While browsing, the reader’s dwell time and clicks inform For You. It gradually tests other topics and reduces topics the reader consistently passes over.
4. A reader can open a post in full view, see which book it comes from, follow that book from the top of the view, open the source book at the cited passage, or ask the AI for more context and follow-up answers.
5. The reader can switch to **Following** to see posts from books they follow. If they follow none, they see an empty state.

Source: `scope.md > The Core Loop`, `scope.md > The POC Boundary`.

## Screens and Layout

- **Onboarding:** A brief AI-content notice and optional topic selection.
- **Feed:** For You and Following tabs above the posts. Desktop uses a sidebar; mobile has a top “more” bar. Posts are separated with light dashed dividers where space allows.
- **Full post:** Opens when a reader selects a post, with a back button at the top left, book-follow action at the top, post details, and the post’s AI context/chat control.
- **Book reader:** Opens from a book-sourced post at the relevant chapter and highlighted passage. The reader can return using the normal back action.

The feed should feel familiar to social-media readers, with a light, uncluttered layout that adapts between desktop and mobile.
Source: `scope.md > Inspiration & Identity`, `scope.md > The Core Loop`.

- **Acceptance criteria**
  - [ ] At desktop width, the feed has the requested sidebar and For You/Following tabs.
  - [ ] At mobile width, navigation uses the top “more” bar and the same feed tabs remain available.
  - [ ] Posts are visually distinct, with light dashed separators where appropriate.

## Look and Feel

- Minimal, smooth, and light to use, with consistent, comfortable spacing and established design conventions.
- Familiar social-feed layout, but not crowded. Use subtle dashed separators between posts where appropriate.
- Most post copy is concise, conversational, and fun; only a few posts are longer articles. Avoid robotic phrasing and conspicuous AI-style wording.
- Make images a minority of feed cards; text remains primary.
- AI provenance should not dominate every card. Explain at onboarding that some posts may be AI-generated and show provenance in the post’s details.
- **Acceptance criteria**
  - [ ] Before entering the feed, onboarding tells readers some posts may be AI-generated.
  - [ ] A post’s details indicate whether it was AI-generated without placing a prominent AI label on every feed card.

Source: `scope.md > Inspiration & Identity`; further direction from the PRD interview.

## Features and Behavior

### Topic Onboarding and For You

- Readers can choose interests such as economics, computer science, and arts, or skip topic selection.
- For You starts with posts related to the selected interests. Opening posts and spending time in them increases a topic's local affinity; passing earlier posts to open a later one lowers affinity for the skipped topics.
- The feed remains varied across the selected areas and includes occasional exploration outside a reader’s initial choices.
- Topic affinity persists in this browser. The exact signal weights and dwell threshold are not product requirements; the observable behavior is that engagement influences later recommendations, while every sixth slot can introduce a topic outside the selected interests and no book repeats within three cards.
- **Acceptance criteria**
  - [ ] Onboarding allows selecting topics or skipping directly to For You.
  - [ ] For You initially includes posts related to selected topics; after the reader engages with one topic and passes over another, a later feed shows the described adjustment.
  - [ ] The feed preserves a discovery slot and avoids repeating a book within three cards.

Source: `scope.md > The Core Loop`, `scope.md > The POC Boundary`.

### Book-Following Feed

- A reader can follow a book from the top of its full-post view.
- Following contains posts only from books the reader follows.
- Before the reader follows any books, Following displays an empty state; it does not offer a follow action there. The follow action is on a book’s full-post view.
- **Acceptance criteria**
  - [ ] Following a book from its full-post view changes the action’s state and that book’s posts appear in Following.
  - [ ] Posts from books that are not followed do not appear in Following.
  - [ ] With no followed books, Following shows an empty state.

Source: `scope.md > The Core Loop`; book following was clarified during the PRD interview.

### Grounded, Varied Posts

- The initial feed is made up of AI-generated posts grounded in real public-domain books. Each post has a traceable source passage; quoted text matches the source exactly.
- The feed includes the six proposed post kinds:
  - **Insight:** A short, punchy analysis of a passage.
  - **Quote:** A striking excerpt, reproduced exactly.
  - **Word:** A less common word with a definition and context.
  - **Thread:** A short, multi-part breakdown.
  - **Quiz:** A question with answer choices; after choosing, the reader sees the correct answer and an explanation.
  - **Debate:** A claim with agree/disagree voting.
- Include poll cards with voting in the first demo. A vote produces a visible selected/recorded state.
- Include some text-and-image posts and a few longer, article-like posts, but keep text-led short posts in the majority.
- Reader-submitted posts and their AI review are not part of this version.
- **Acceptance criteria**
  - [ ] The initial feed visibly contains all six post kinds, with short text posts in the majority, some text-and-image posts, and at least one longer article-like post.
  - [ ] Each displayed post identifies a real public-domain book and a passage supporting its content; any quoted passage matches the book text exactly.
  - [ ] A reader can vote in a poll or choose agree/disagree on a debate and see their choice registered.
  - [ ] A reader can select a quiz answer and then see the correct answer and an explanation.

Source: `scope.md > The Unique Kernel`, `scope.md > The POC Boundary`, `scope.md > Later`.

### Full Post, AI Context, and Source Reading

- Selecting a card opens its full post, with a top-left back button.
- The full view identifies the source book and provides **Open source book**. Selecting it opens the relevant chapter and highlights the passage behind the post.
- The AI control is available on every post. It first reveals a summary/more context, then provides a chat field for typed follow-up questions.
- Answers can explain the source book or draw on broader knowledge. When an answer goes beyond the cited book, it says so clearly.
- If a post has no direct book source, its source action offers similar books. No non-book posts are planned for the initial feed, so this fallback is not part of the core demo journey.
- **Acceptance criteria**
  - [ ] Selecting a feed card opens its full-post view, and the top-left back action returns to the prior feed.
  - [ ] Selecting **Open source book** displays the cited chapter and highlights the supporting passage.
  - [ ] On every post, the AI control reveals more context and accepts a typed follow-up question.
  - [ ] If an AI answer uses broader knowledge rather than the cited book, the answer identifies that distinction.
  - [ ] If the source cannot be opened, the reader sees an explicit unavailable state rather than a substitute passage.

Source: `scope.md > The Core Loop`, `scope.md > What "Working" Looks Like`; AI context and source behavior were clarified during the PRD interview.

## States and Boundaries

- **First use:** The reader sees the AI-content notice and may choose topics or skip. Skipping is allowed.
- **For You:** Starts with topic-relevant posts; browsing signals gradually influence subsequent recommendations.
- **Following with no followed books:** Show an empty state. The reader follows books from their full-post views.
- **Quiz or poll answered:** Show the answer/explanation for a quiz, or results for a poll.
- **Source unavailable:** Clearly indicate that the source could not be opened; do not substitute a different passage or imply that it verifies the post.
- **AI answer beyond the source:** Clearly identify the answer as broader knowledge rather than book-derived.
- **Out of scope:** Rooms/chat, reader submissions and AI review, and a production-scale ranking system.

## Product Decisions

- The core is an entertaining, knowledge-rich feed with a verifiable path to the book, not a formal reading app.
- The initial feed is text-led but includes some image cards and a few longer articles.
- Readers may skip interest selection. For You adapts from topic choices and dwell/click behavior; it tests other options and gradually reduces topics the reader skips.
- Following is limited to books the reader chose to follow. Follow is available on a book’s full-post view, not in the Following tab.
- Every post offers AI context and typed follow-up questions. Book-derived and broader-knowledge answers are distinguished.
- AI provenance is disclosed during onboarding and in post details, without making AI labels visually dominate the feed.
- Reader-submitted content, rooms, and chat rooms are excluded from this proof of concept.

## What We're Building

- A minimal, responsive onboarding and feed experience with optional topic selection, For You and Following, and desktop/mobile navigation.
- A varied, predominantly text feed grounded in a small collection of real public-domain books, with the six proposed post kinds, poll voting, some image cards, and occasional longer articles.
- A For You feed that starts from interests and demonstrates gradual adjustment based on dwell/click signals.
- Book following from the full-post view and an empty Following state.
- Full-post views with AI summaries and typed follow-up chat, including clear identification when an answer goes beyond its book source.
- A source reader that opens the exact chapter and highlighted passage.

## Deferred From the POC

- Reader-submitted academic posts and AI review, to keep the initial experience centered on discovering and reading grounded posts.
- Comments, likes, saves, social profile features, and other community interactions; they are not needed to demonstrate the feed-to-source journey.
- A production-scale recommendation system with extensive behavioral signals, precise ranking rules, and long-term account history. The proof demonstrates the learner-described topic and dwell/click feedback loop only.
- Rooms and chat rooms, explicitly excluded from LibreY.
- A larger library, richer community features, and a full vocabulary study system.

## Possible Later Enhancements

- Expand the recommendation model with additional signals and more detailed diversity controls.
- Allow reader-created academic posts and review them for source support.
- Expand the post library, social interactions, study tools, and topic/book communities.

## Non-Goals

- LibreY is not an ungrounded AI-content feed; posts in the initial feed must point to real public-domain book text.
- The initial version is not a full social network with user-generated posts, comments, or rooms.
- The first release does not promise a polished, production-scale personalization algorithm.
- AI-generated writing should not be presented as human-authored; readers are informed during onboarding and can see provenance in post details.

## Open Questions

- **Resolved in `spec.md`:** The demo uses *The Origin of Species*, *The Wealth of Nations*, and *Meditations*, with bundled exact passages.
- **Resolved in `spec.md`:** A few locally bundled public-domain/openly licensed images will include their attribution.
- **Resolved in `spec.md`:** Skipping topics starts a balanced mix of the bundled subjects.
- **Resolved in `spec.md`:** A local demo-sized ranking uses selected topics, post opens, dwell, and repeated skips, with a discovery mix.
- **Resolved in `spec.md`:** Topic choices, followed books, and For You topic signals persist in the current browser, without accounts or cross-device sync.
