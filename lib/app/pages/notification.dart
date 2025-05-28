import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:edu_mate/theme.dart';

class NotificationHelper {
  final BuildContext context;

  NotificationHelper(this.context);

  void showNotificationDetail(Map<String, dynamic> notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification['type']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification['type']),
                    size: 24,
                    color: _getNotificationColor(notification['type']),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    notification['title'],
                    style: AppTheme.subheadingStyle.copyWith(fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.grey),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              notification['message'],
              style: AppTheme.bodyStyle.copyWith(
                fontSize: 16,
                color: AppTheme.darkBlue,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, MMM d, yyyy • h:mm a').format(notification['time']),
                  style: AppTheme.bodyStyle.copyWith(
                    fontSize: 14,
                    color: AppTheme.grey.withOpacity(0.8),
                  ),
                ),
                if (_getActionForNotificationType(notification['type']) != null)
                  ElevatedButton(
                    onPressed: () {
                      _handleNotificationAction(notification);
                      Navigator.pop(context);
                    },
                    child: Text(
                      _getActionForNotificationType(notification['type']) ?? '',
                      style: AppTheme.buttonTextStyle,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'assignment':
        return Icons.assignment;
      case 'grade':
        return Icons.grading;
      case 'announcement':
        return Icons.campaign;
      case 'event':
        return Icons.event;
      case 'reminder':
        return Icons.alarm;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'assignment':
        return Colors.orange;
      case 'grade':
        return Colors.green;
      case 'announcement':
        return Colors.red;
      case 'event':
        return Colors.purple;
      case 'reminder':
        return Colors.blue;
      default:
        return AppTheme.primaryBlue;
    }
  }

  String? _getActionForNotificationType(String type) {
    switch (type) {
      case 'assignment':
        return 'View Assignment';
      case 'grade':
        return 'View Grade';
      case 'announcement':
        return 'Read More';
      case 'event':
        return 'View Event';
      case 'reminder':
        return 'Set Reminder';
      default:
        return null;
    }
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    switch (notification['type']) {
      case 'assignment':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigating to assignment details...')),
        );
        break;
      case 'grade':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigating to grade details...')),
        );
        break;
      case 'announcement':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigating to announcement details...')),
        );
        break;
      case 'event':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigating to event details...')),
        );
        break;
      case 'reminder':
        _showReminderOptions(notification);
        break;
      default:
        break;
    }
  }

  void _showReminderOptions(Map<String, dynamic> notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('30 minutes before'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reminder set for 30 minutes before')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('1 hour before'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reminder set for 1 hour before')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('1 day before'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reminder set for 1 day before')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.alarm_add),
              title: const Text('Custom time'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Custom reminder option selected')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
