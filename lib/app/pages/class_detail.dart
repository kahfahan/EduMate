import 'package:flutter/material.dart';
import 'package:edu_mate/theme.dart';

class ClassDetailPage extends StatelessWidget {
  final String subject;
  final String time;
  final String teacher;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final String status;
  final String room;

  const ClassDetailPage({
    Key? key,
    required this.subject,
    required this.time,
    required this.teacher,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.status,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  const SizedBox(height: 20),
                  _buildClassInfoCard(),
                  const SizedBox(height: 20),
                  _buildTeacherInfoCard(),
                  const SizedBox(height: 20),
                  _buildUpcomingAssignmentsCard(),
                  const SizedBox(height: 20),
                  _buildClassNotesCard(),
                  const SizedBox(height: 20),
                  _buildActionButtons(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.lightBlue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppTheme.primaryBlue,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                Text(
                  'Class Details',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.grey.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status == 'current' 
                ? Colors.green.withOpacity(0.1)
                : AppTheme.lightGrey,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: status == 'current' ? Colors.green : AppTheme.grey,
                width: 1,
              ),
            ),
            child: Text(
              status == 'current' ? 'LIVE' : 'UPCOMING',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: status == 'current' ? Colors.green : AppTheme.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Class Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(Icons.access_time, 'Time', time),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.location_on, 'Location', room),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.calendar_today, 'Duration', '1.5 hours'),
        ],
      ),
    );
  }

  Widget _buildTeacherInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Teacher Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                child: const Icon(
                  Icons.person,
                  color: AppTheme.primaryBlue,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teacher,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 30, 38, 104),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$subject Teacher',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.grey.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 4),
                        const Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(124 reviews)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.grey.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  // Message teacher
                },
                icon: const Icon(
                  Icons.message,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAssignmentsCard() {
    final assignments = [
      {'title': 'Algebra Quiz', 'due': 'Due Tomorrow', 'progress': 0.0},
      {'title': 'Problem Set #3', 'due': 'Due in 3 days', 'progress': 0.6},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Assignments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 16),
          ...assignments.map((assignment) => _buildAssignmentItem(
            assignment['title'] as String,
            assignment['due'] as String,
            assignment['progress'] as double,
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildClassNotesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Class Notes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              IconButton(
                onPressed: () {
                  // Add note
                },
                icon: const Icon(
                  Icons.add,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightBlue.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryBlue.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Topic: Introduction to Quadratic Equations',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Remember to practice the formula: ax² + bx + c = 0\nHomework: Complete exercises 1-10 on page 45',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.grey.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: status == 'current' ? () {
              // Join class
            } : null,
            icon: Icon(status == 'current' ? Icons.video_call : Icons.schedule),
            label: Text(status == 'current' ? 'Join Class' : 'Scheduled'),
            style: ElevatedButton.styleFrom(
              backgroundColor: status == 'current' 
                ? AppTheme.primaryBlue 
                : AppTheme.lightGrey,
              foregroundColor: status == 'current' 
                ? AppTheme.white 
                : AppTheme.grey,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryBlue, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.grey.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 30, 38, 104),
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildMaterialItem(String title, String type, String size) {
    IconData getFileIcon(String type) {
      switch (type.toLowerCase()) {
        case 'pdf':
          return Icons.picture_as_pdf;
        case 'doc':
          return Icons.description;
        case 'mp4':
          return Icons.play_circle_filled;
        default:
          return Icons.insert_drive_file;
      }
    }

    Color getFileColor(String type) {
      switch (type.toLowerCase()) {
        case 'pdf':
          return Colors.red;
        case 'doc':
          return Colors.blue;
        case 'mp4':
          return Colors.orange;
        default:
          return AppTheme.grey;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            getFileIcon(type),
            color: getFileColor(type),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 30, 38, 104),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$type • $size',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.grey.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Download file
            },
            icon: const Icon(
              Icons.download,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentItem(String title, String due, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 30, 38, 104),
                ),
              ),
              Text(
                due,
                style: TextStyle(
                  fontSize: 12,
                  color: progress == 0.0 ? AppTheme.errorRed : AppTheme.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.lightGrey,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress == 0.0
                  ? AppTheme.errorRed
                  : progress < 0.7
                      ? Colors.orange
                      : Colors.green,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 4),
          Text(
            progress == 0.0 
              ? 'Not started' 
              : '${(progress * 100).toInt()}% completed',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.grey.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}