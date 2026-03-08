import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/task_model.dart';
import '../data/repositories/task_repository.dart';

/// Provider for the task repository
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepositoryImpl();
});

/// Provider for the list of tasks
final tasksProvider = StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  final repository = ref.watch(taskRepositoryProvider);
  return TaskNotifier(repository);
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  final TaskRepository _repository;

  TaskNotifier(this._repository) : super([]);

  Future<void> loadTasks() async {
    state = await _repository.getTasks();
  }

  Future<void> addTask(TaskModel task) async {
    await _repository.addTask(task);
    state = [...state, task];
  }

  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    state = [...state.where((task) => task.id != id)];
  }

  Future<void> toggleTaskCompletion(String id) async {
    final task = state.firstWhere((t) => t.id == id);
    final updatedTask = task.copyWith(
      isCompleted: !task.isCompleted,
      completedAt: task.isCompleted ? null : DateTime.now(),
    );
    await _repository.updateTask(updatedTask);
    state = [
      for (final t in state)
        if (t.id == id) updatedTask else t,
    ];
  }
}
