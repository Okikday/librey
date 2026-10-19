class Passage {
  const Passage({
    required this.id,
    required this.bookId,
    required this.section,
    required this.text,
  });

  final String id;
  final String bookId;
  final String section;
  final String text;

  factory Passage.fromJson(Map<String, dynamic> json) {
    return Passage(
      id: _requiredString(json, 'id'),
      bookId: _requiredString(json, 'bookId'),
      section: _requiredString(json, 'section'),
      text: _requiredString(json, 'text'),
    );
  }
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! String || value.isEmpty) {
    throw FormatException('Passage field "$key" must be a non-empty string.');
  }
  return value;
}
