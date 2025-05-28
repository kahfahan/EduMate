class TaskModel {
  final String title;
  final String subject;
  final String dueDate;
  final bool isCompleted;
  final bool isPriority;
  final double progress;

  TaskModel({
    required this.title,
    required this.subject,
    required this.dueDate,
    required this.isCompleted,
    required this.isPriority,
    required this.progress,
  });
}
