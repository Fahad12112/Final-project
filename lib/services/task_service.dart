import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task.dart';

class TaskService {
  final client = Supabase.instance.client;
  String get userId => client.auth.currentUser!.id;

  Future<List<Task>> getTasks() async {
    final data = await client
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at');

    return (data as List).map((row) => Task.fromJson(row)).toList();
  }

  Future<void> addTask(String title) async {
    await client.from('tasks').insert({
      'user_id': userId,
      'title': title,
      'is_done': false,
    });
  }

  Future<void> toggleTask(String taskId, bool isDone) async {
    await client
        .from('tasks')
        .update({'is_done': isDone}).eq('id', taskId);
  }

  Future<void> deleteTask(String taskId) async {
    await client.from('tasks').delete().eq('id', taskId);
  }
}
