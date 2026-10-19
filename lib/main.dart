import 'package:flutter/material.dart';

import 'app.dart';
import 'data/demo_content_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(LibreYApp(content: DemoContentRepository.load()));
}
