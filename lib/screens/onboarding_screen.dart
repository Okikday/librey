import 'package:flutter/material.dart';

import '../data/user_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.preferences,
    required this.onComplete,
  });

  final UserPreferences preferences;
  final Future<void> Function(Set<String> selectedTopics) onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final Set<String> _selectedTopics;
  bool _saving = false;

  static const List<String> _topicOptions = [
    'Science',
    'Economics',
    'Philosophy',
    'History',
    'Arts',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTopics = widget.preferences.selectedTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F1EA),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 42,
                    color: Color(0xFF426A52),
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'A little scroll. A little wiser.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'Every post is grounded in a real public-domain book passage. Some are AI-generated, but each one points back to the source that proves it.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF667267),
                    height: 1.55,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 26),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose what sparks your curiosity',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _topicOptions.map((topic) {
                    final isSelected = _selectedTopics.contains(topic);
                    return FilterChip(
                      label: Text(topic),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTopics.add(topic);
                          } else {
                            _selectedTopics.remove(topic);
                          }
                        });
                      },
                      selectedColor: const Color(0xFFDFEDE1),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF426A52)
                            : const Color(0xFFE0E7E0),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : _skipOnboarding,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFFD9E2D9)),
                        ),
                        child: const Text('Skip'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _saving ? null : _completeOnboarding,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF426A52),
                        ),
                        child: _saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Continue'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    setState(() => _saving = true);
    try {
      await widget.onComplete(_selectedTopics);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _skipOnboarding() async {
    setState(() {
      _selectedTopics.clear();
      _saving = true;
    });
    try {
      await widget.onComplete(_selectedTopics);
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}
