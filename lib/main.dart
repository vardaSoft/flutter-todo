/// Main entry point for the Flutter Todo application
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/todo/presentation/views/todo_home_page.dart';

void main() {
  runApp(const ProviderScope(child: TodoApp()));
}
