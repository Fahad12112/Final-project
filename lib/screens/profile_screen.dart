import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final authService = AuthService();
  final taskService = TaskService();

  int totalTasks = 0;
  int doneTasks = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  void loadStats() async {
    try {
      final tasks = await taskService.getTasks();
      setState(() {
        totalTasks = tasks.length;
        doneTasks = tasks.where((t) => t.isDone).length;
      });
    } catch (_) {}

    setState(() => isLoading = false);
  }

  void logout() async {
    await authService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 15),

                  Text(
                    authService.client.auth.currentUser?.email ?? 'Unknown',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 30),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Text(
                            'Task Stats',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '$totalTasks',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('Total'),
                                ],
                              ),

                              Column(
                                children: [
                                  Text(
                                    '$doneTasks',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const Text('Done'),
                                ],
                              ),

                              Column(
                                children: [
                                  Text(
                                    '${totalTasks - doneTasks}',
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const Text('Remaining'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: logout,
                      child: const Text('Log Out'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
