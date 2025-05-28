import 'package:flutter/material.dart';

class UpcomingClassBanner extends StatelessWidget {
  const UpcomingClassBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Mrs. Fatimah Zahr', style: TextStyle(color: Colors.white)),
          Text('Math Class', style: TextStyle(color: Colors.white)),
          Text('starting soon', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Make sure your assignment was all done', style: TextStyle(color: Colors.white70)),
          Text('check here →', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
