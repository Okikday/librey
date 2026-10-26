class Post {
  const Post({
    required this.id,
    required this.bookId,
    required this.passageId,
    required this.kind,
    required this.body,
    required this.evidenceQuote,
    required this.aiGenerated,
    this.question,
    this.options = const [],
    this.correctOptionIndex,
    this.explanation,
    this.threadParts = const [],
    this.isArticle = false,
    this.imageAsset,
    this.imageAttribution,
    this.contextSummary,
    this.sampleQuestion,
    this.sampleAnswer,
    this.answerBasis,
  });

  final String id;
  final String bookId;
  final String passageId;
  final String kind;
  final String body;
  final String evidenceQuote;
  final bool aiGenerated;
  final String? question;
  final List<String> options;
  final int? correctOptionIndex;
  final String? explanation;
  final List<String> threadParts;
  final bool isArticle;
  final String? imageAsset;
  final String? imageAttribution;
  final String? contextSummary;
  final String? sampleQuestion;
  final String? sampleAnswer;
  final String? answerBasis;

  factory Post.fromJson(Map<String, dynamic> json) {
    final aiGenerated = json['aiGenerated'];
    if (aiGenerated is! bool) {
      throw const FormatException('Post field "aiGenerated" must be a bool.');
    }
    final isArticle = json['isArticle'] ?? false;
    if (isArticle is! bool) {
      throw const FormatException('Post field "isArticle" must be a bool.');
    }
    return Post(
      id: _requiredString(json, 'id'),
      bookId: _requiredString(json, 'bookId'),
      passageId: _requiredString(json, 'passageId'),
      kind: _requiredString(json, 'kind'),
      body: _requiredString(json, 'body'),
      evidenceQuote: _requiredString(json, 'evidenceQuote'),
      aiGenerated: aiGenerated,
      question: _optionalString(json, 'question'),
      options: _optionalStringList(json, 'options'),
      correctOptionIndex: _optionalInt(json, 'correctOptionIndex'),
      explanation: _optionalString(json, 'explanation'),
      threadParts: _optionalStringList(json, 'threadParts'),
      isArticle: isArticle,
      imageAsset: _optionalString(json, 'imageAsset'),
      imageAttribution: _optionalString(json, 'imageAttribution'),
      contextSummary: _optionalString(json, 'contextSummary'),
      sampleQuestion: _optionalString(json, 'sampleQuestion'),
      sampleAnswer: _optionalString(json, 'sampleAnswer'),
      answerBasis: _optionalString(json, 'answerBasis'),
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

String? _optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! String || value.isEmpty) {
    throw FormatException('Post field "$key" must be a non-empty string.');
  }
  return value;
}

List<String> _optionalStringList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return const [];
  if (value is! List<dynamic> ||
      value.any((item) => item is! String || item.isEmpty)) {
    throw FormatException(
      'Post field "$key" must be a list of non-empty strings.',
    );
  }
  return List<String>.unmodifiable(value.cast<String>());
}

int? _optionalInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! int) {
    throw FormatException('Post field "$key" must be an integer.');
  }
  return value;
}
