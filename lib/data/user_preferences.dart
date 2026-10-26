import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  UserPreferences._(this._prefs);

  final SharedPreferences _prefs;

  static const _onboardingCompleteKey = 'librey_onboarding_complete';
  static const _selectedTopicsKey = 'librey_selected_topics';
  static const _followedBooksKey = 'librey_followed_books';

  static Future<UserPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    return UserPreferences._(prefs);
  }

  bool isOnboardingComplete() =>
      _prefs.getBool(_onboardingCompleteKey) ?? false;

  Future<void> setOnboardingComplete(bool value) async {
    await _prefs.setBool(_onboardingCompleteKey, value);
  }

  Set<String> selectedTopics() {
    final topics = _prefs.getStringList(_selectedTopicsKey) ?? const <String>[];
    return topics.toSet();
  }

  Future<void> saveSelectedTopics(Set<String> topics) async {
    final ordered = topics.toList()..sort();
    await _prefs.setStringList(_selectedTopicsKey, ordered);
  }

  Set<String> followedBookIds() {
    final ids = _prefs.getStringList(_followedBooksKey) ?? const <String>[];
    return ids.toSet();
  }

  Future<void> setFollowedBook(String bookId, bool followed) async {
    final ids = followedBookIds();
    if (followed) {
      ids.add(bookId);
    } else {
      ids.remove(bookId);
    }
    final ordered = ids.toList()..sort();
    await _prefs.setStringList(_followedBooksKey, ordered);
  }
}
