import 'package:flutter/material.dart';

import 'data/demo_content_repository.dart';
import 'data/user_preferences.dart';
import 'screens/feed_screen.dart';
import 'screens/onboarding_screen.dart';

class LibreYApp extends StatefulWidget {
  const LibreYApp({super.key, required this.content});

  final Future<DemoContentRepository> content;

  @override
  State<LibreYApp> createState() => _LibreYAppState();
}

class _LibreYAppState extends State<LibreYApp> {
  late final Future<UserPreferences> _preferencesFuture;

  @override
  void initState() {
    super.initState();
    _preferencesFuture = UserPreferences.load();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LibreY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _leaf,
          surface: const Color(0xFFFCFDFB),
        ),
        scaffoldBackgroundColor: const Color(0xFFFCFDFB),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: _ink,
          displayColor: _ink,
        ),
      ),
      home: FutureBuilder<DemoContentRepository>(
        future: widget.content,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const _LoadingScreen();
          }
          if (snapshot.hasError) {
            return _ContentErrorScreen(error: snapshot.error!);
          }
          final repository = snapshot.data;
          if (repository == null) {
            return const _ContentErrorScreen(
              error: 'Bundled content did not load.',
            );
          }

          return FutureBuilder<UserPreferences>(
            future: _preferencesFuture,
            builder: (context, preferencesSnapshot) {
              if (preferencesSnapshot.connectionState != ConnectionState.done) {
                return const _LoadingScreen();
              }
              if (preferencesSnapshot.hasError) {
                return _ContentErrorScreen(
                  error: preferencesSnapshot.error ?? 'Preferences did not load.',
                );
              }
              final preferences = preferencesSnapshot.data;
              if (preferences == null) {
                return const _ContentErrorScreen(
                  error: 'Preferences did not load.',
                );
              }
              return _AppShell(repository: repository, preferences: preferences);
            },
          );
        },
      ),
    );
  }

  static const _ink = Color(0xFF202923);
  static const _leaf = Color(0xFF426A52);
}

class _AppShell extends StatefulWidget {
  const _AppShell({required this.repository, required this.preferences});

  final DemoContentRepository repository;
  final UserPreferences preferences;

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  late bool _showOnboarding;

  @override
  void initState() {
    super.initState();
    _showOnboarding = !widget.preferences.isOnboardingComplete();
  }

  Future<void> _handleOnboardingComplete(Set<String> selectedTopics) async {
    await widget.preferences.saveSelectedTopics(selectedTopics);
    await widget.preferences.setOnboardingComplete(true);
    if (mounted) {
      setState(() => _showOnboarding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return OnboardingScreen(
        preferences: widget.preferences,
        onComplete: _handleOnboardingComplete,
      );
    }
    return FeedScreen(
      repository: widget.repository,
      preferences: widget.preferences,
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class _ContentErrorScreen extends StatelessWidget {
  const _ContentErrorScreen({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 36),
                  const SizedBox(height: 16),
                  Text(
                    'LibreY could not load its book feed.',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(error.toString(), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
