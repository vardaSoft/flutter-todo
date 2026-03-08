/// Local storage utilities
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _storageKey = 'flutter_todo_tasks';

  static Future<List<dynamic>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_storageKey);
    if (tasksJson == null) return [];
    return List.from(jsonDecode(tasksJson));
  }

  static Future<void> saveTasks(List<dynamic> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(tasks));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
