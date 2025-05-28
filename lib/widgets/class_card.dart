import 'package:flutter/material.dart';

class ClassCard extends StatelessWidget {
  final String title;
  final String time;
  final String teacher;
  final IconData icon;

  const ClassCard({
    super.key,
    required this.title,
    required this.time,
    required this.teacher,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon, color: Colors.white), backgroundColor: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$time\n$teacher'),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Arahkan ke detail class
        },
      ),
    );
  }
}
