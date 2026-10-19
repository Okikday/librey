import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/book.dart';
import '../models/passage.dart';
import '../models/post.dart';

class DemoContentRepository {
  DemoContentRepository({
    required this.books,
    required this.passages,
    required this.posts,
  }) : _booksById = {for (final book in books) book.id: book},
       _passagesById = {for (final passage in passages) passage.id: passage};

  final List<Book> books;
  final List<Passage> passages;
  final List<Post> posts;
  final Map<String, Book> _booksById;
  final Map<String, Passage> _passagesById;

  static Future<DemoContentRepository> load() async {
    final books = _decodeList(
      await rootBundle.loadString('assets/data/books.json'),
      Book.fromJson,
      'books',
    );
    final passages = _decodeList(
      await rootBundle.loadString('assets/data/passages.json'),
      Passage.fromJson,
      'passages',
    );
    final posts = _decodeList(
      await rootBundle.loadString('assets/data/posts.json'),
      Post.fromJson,
      'posts',
    );
    final repository = DemoContentRepository(
      books: books,
      passages: passages,
      posts: posts,
    );
    repository.validate();
    return repository;
  }

  Book bookFor(Post post) => _booksById[post.bookId]!;

  Passage passageFor(Post post) => _passagesById[post.passageId]!;

  void validate() {
    _requireUnique(books.map((book) => book.id), 'book');
    _requireUnique(passages.map((passage) => passage.id), 'passage');
    _requireUnique(posts.map((post) => post.id), 'post');

    for (final passage in passages) {
      if (!_booksById.containsKey(passage.bookId)) {
        throw FormatException(
          'Passage "${passage.id}" references missing book "${passage.bookId}".',
        );
      }
    }
    for (final post in posts) {
      final book = _booksById[post.bookId];
      final passage = _passagesById[post.passageId];
      if (book == null || passage == null || passage.bookId != post.bookId) {
        throw FormatException(
          'Post "${post.id}" must reference an existing passage in its book.',
        );
      }
      if (!passage.text.contains(post.evidenceQuote)) {
        throw FormatException(
          'Post "${post.id}" evidence quote does not match its source passage.',
        );
      }
    }
  }

  static List<T> _decodeList<T>(
    String source,
    T Function(Map<String, dynamic>) parse,
    String label,
  ) {
    final decoded = jsonDecode(source);
    if (decoded is! List<dynamic>) {
      throw FormatException('Bundled $label data must be a JSON list.');
    }
    return decoded
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw FormatException(
              'Each item in bundled $label data must be an object.',
            );
          }
          return parse(item);
        })
        .toList(growable: false);
  }

  static void _requireUnique(Iterable<String> ids, String label) {
    final seen = <String>{};
    for (final id in ids) {
      if (!seen.add(id)) {
        throw FormatException('Duplicate $label id "$id" in bundled content.');
      }
    }
  }
}
