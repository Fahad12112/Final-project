class Task {
  final String id;
  final String userId;
  final String title;
  final bool isDone;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.isDone,
  });


  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      isDone: json['is_done'] ?? false,
    );
  }
}
