import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../services/auth_service.dart';
import 'add_task_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final taskService = TaskService();
  final authService = AuthService();

  List<Task> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    setState(() => isLoading = true);

    try {
      final result = await taskService.getTasks();
      setState(() => tasks = result);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading tasks: $e')),
        );
      }
    }

    setState(() => isLoading = false);
  }

  void toggleTask(Task task) async {
    await taskService.toggleTask(task.id, !task.isDone);
    loadTasks();
  }

  void deleteTask(String taskId) async {
    await taskService.deleteTask(taskId);
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())

          : tasks.isEmpty
              ? const Center(
                  child: Text(
                    'No tasks yet!\nTap + to add one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )

              : ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return ListTile(
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (_) => toggleTask(task),
                      ),

                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                          color: task.isDone ? Colors.grey : Colors.black,
                        ),
                      ),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteTask(task.id),
                      ),
                    );
                  },
                ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
          loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
