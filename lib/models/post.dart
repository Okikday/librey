class Post {
  const Post({
    required this.id,
    required this.bookId,
    required this.passageId,
    required this.kind,
    required this.body,
    required this.evidenceQuote,
    required this.aiGenerated,
  });

  final String id;
  final String bookId;
  final String passageId;
  final String kind;
  final String body;
  final String evidenceQuote;
  final bool aiGenerated;

  factory Post.fromJson(Map<String, dynamic> json) {
    final aiGenerated = json['aiGenerated'];
    if (aiGenerated is! bool) {
      throw const FormatException('Post field "aiGenerated" must be a bool.');
    }
    return Post(
      id: _requiredString(json, 'id'),
      bookId: _requiredString(json, 'bookId'),
      passageId: _requiredString(json, 'passageId'),
      kind: _requiredString(json, 'kind'),
      body: _requiredString(json, 'body'),
      evidenceQuote: _requiredString(json, 'evidenceQuote'),
      aiGenerated: aiGenerated,
    );
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Post field "$key" must be a non-empty string.');
  }
  return value;
}
