import 'package:flutter/material.dart';
import 'package:edu_mate/theme.dart';
import '../models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    if (task.isCompleted) {
      statusColor = Colors.green;
    } else if (task.isPriority) {
      statusColor = task.progress < 0.5 ? AppTheme.errorRed : Colors.orange;
    } else {
      statusColor = AppTheme.accentBlue;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted ? Colors.green.withOpacity(0.1) : Colors.transparent,
                  border: Border.all(
                    color: statusColor,
                    width: 2,
                  ),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 12, color: Colors.green)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkBlue,
                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              if (task.isPriority && !task.isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.flag, size: 12, color: AppTheme.errorRed),
                      const SizedBox(width: 4),
                      Text(
                        'Priority',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.errorRed,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.subject, style: TextStyle(fontSize: 14, color: AppTheme.grey)),
                const SizedBox(height: 4),
                Text(
                  task.dueDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: task.isCompleted ? Colors.green : statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!task.isCompleted) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: task.progress,
                    backgroundColor: AppTheme.lightGrey,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(task.progress * 100).toInt()}% completed',
                    style: TextStyle(fontSize: 12, color: AppTheme.grey),
                  ),
                ],
              ],
            ),
          ),
          if (!task.isCompleted)
            Padding(
              padding: const EdgeInsets.only(top: 12, left: 32),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Add Notes'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      side: BorderSide(color: AppTheme.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, color: AppTheme.grey),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
