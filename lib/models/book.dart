class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.subject,
    required this.sourceUrl,
  });

  final String id;
  final String title;
  final String author;
  final String subject;
  final String sourceUrl;

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: _requiredString(json, 'id'),
      title: _requiredString(json, 'title'),
      author: _requiredString(json, 'author'),
      subject: _requiredString(json, 'subject'),
      sourceUrl: _requiredString(json, 'sourceUrl'),
    );
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Book field "$key" must be a non-empty string.');
  }
  return value;
}
