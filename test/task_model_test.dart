// Test file for task model
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo/features/todo/data/models/task_model.dart';

void main() {
  group('TaskModel', () {
    test('should create a task with all fields', () {
      final task = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime(2024, 1, 1),
      );

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.isCompleted, false);
    });

    test('should convert to JSON and back', () {
      final task = TaskModel(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        createdAt: DateTime(2024, 1, 1),
      );

      final json = task.toJson();
      final restored = TaskModel.fromJson(json);

      expect(restored.id, task.id);
      expect(restored.title, task.title);
      expect(restored.description, task.description);
    });

    test('should copy with updated values', () {
      final task = TaskModel(
        id: '1',
        title: 'Original',
        description: 'Description',
        createdAt: DateTime(2024, 1, 1),
      );

      final updated = task.copyWith(title: 'Updated');

      expect(updated.title, 'Updated');
      expect(updated.id, '1');
    });
  });
}
