import 'package:flutter/material.dart';

import 'data/demo_content_repository.dart';
import 'screens/feed_screen.dart';

class LibreYApp extends StatelessWidget {
  const LibreYApp({super.key, required this.content});

  final Future<DemoContentRepository> content;

  static const _ink = Color(0xFF202923);
  static const _leaf = Color(0xFF426A52);

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
        future: content,
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
          return FeedScreen(repository: repository);
        },
      ),
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
