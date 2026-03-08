/// Task repository implementation
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getTasks();
  Future<void> saveTasks(List<TaskModel> tasks);
  Future<void> addTask(TaskModel task);
  Future<void> deleteTask(String id);
  Future<void> updateTask(TaskModel task);
}

class TaskRepositoryImpl implements TaskRepository {
  static const String _storageKey = 'flutter_todo_tasks';

  @override
  Future<List<TaskModel>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString(_storageKey);
    if (tasksJson == null) return [];
    
    final List<dynamic> tasksList = List.from(jsonDecode(tasksJson));
    return tasksList.map((e) => TaskModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, tasksJson);
  }

  @override
  Future<void> addTask(TaskModel task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  @override
  Future<void> deleteTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((task) => task.id == id);
    await saveTasks(tasks);
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }
}
