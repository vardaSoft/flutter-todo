import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/task_model.dart';
import '../providers/task_provider.dart';

/// Main application widget
class TodoApp extends ConsumerWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const TodoHomePage(),
    );
  }
}

/// Home page with task list and add functionality
class TodoHomePage extends ConsumerStatefulWidget {
  const TodoHomePage({super.key});

  @override
  ConsumerState<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends ConsumerState<TodoHomePage> {
  final TextEditingController _controller = TextEditingController();
  late final Future<void> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(tasksProvider.notifier).loadTasks();
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(hintText: 'Enter task title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                await ref.read(tasksProvider.notifier).addTask(
                  TaskModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _controller.text,
                    description: '',
                    createdAt: DateTime.now(),
                  ),
                );
                _controller.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.appName),
      ),
      body: FutureBuilder<void>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: Key(task.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) async {
                  await ref.read(tasksProvider.notifier).deleteTask(task.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task deleted')),
                  );
                },
                child: ListTile(
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) async {
                      await ref.read(tasksProvider.notifier).toggleTaskCompletion(task.id);
                    },
                  ),
                  title: Text(
                    task.title,
                    style: task.isCompleted
                        ? const TextStyle(decoration: TextDecoration.lineThrough)
                        : null,
                  ),
                  subtitle: Text(task.description),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
