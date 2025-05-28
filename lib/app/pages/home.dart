import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:edu_mate/theme.dart';
import 'package:edu_mate/app/pages/tasks.dart';
import 'package:edu_mate/app/pages/profile.dart';
import 'package:edu_mate/app/pages/schedule.dart';
import 'package:edu_mate/app/pages/class_detail.dart';

class HomePage extends StatefulWidget {
  final String name;
  final int grade;

  const HomePage({
    Key? key,
    required this.name,
    required this.grade,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    const ClassesPage(),
    const SchedulePage(),
    const TasksPage(),
    const ProfilePage(),
  ];

  String _getGradeSuffix(int grade) {
    if (grade == 1) return 'st';
    if (grade == 2) return 'nd';
    if (grade == 3) return 'rd';
    return 'th';
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _pages[_selectedIndex],
            ),
            _buildBottomNavBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primaryBlue,
                child: const Icon(Icons.person, color: AppTheme.white),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello ${widget.name}!',
                    style: AppTheme.subheadingStyle,
                  ),
                  Text(
                    '${widget.grade}${_getGradeSuffix(widget.grade)} Grade',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: const [
              Icon(Icons.calendar_today, color: AppTheme.primaryBlue),
              SizedBox(width: 16),
              Icon(Icons.notifications_none, color: AppTheme.primaryBlue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Home', 0),
          _buildNavItem(Icons.book, 'Classes', 1),
          _buildNavItem(Icons.calendar_today, 'Schedule', 2),
          _buildNavItem(Icons.assignment, 'Tasks', 3),
          _buildNavItem(Icons.person, 'Profile', 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? AppTheme.primaryBlue : AppTheme.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppTheme.primaryBlue : AppTheme.grey,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: [
          const SizedBox(height: 10),
          _buildUpcomingOrCurrentClass(context),
          const SizedBox(height: 20),
          _buildTodaysClassesTitle(),
          const SizedBox(height: 10),
          _buildClassCards(context),
          const SizedBox(height: 15),
          _buildUpcomingItems(context),
        ],
      ),
    );
  }

  Widget _buildUpcomingOrCurrentClass(BuildContext context) {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    final currentTimeInMinutes = currentHour * 60 + currentMinute;

    final classes = [
      {
        'subject': 'Mathematics',
        'time': '08:00 - 09:30 AM',
        'teacher': 'Mrs. Fatimah Zahr',
        'startHour': 8,
        'startMinute': 0,
        'endHour': 9,
        'endMinute': 30,
      },
      {
        'subject': 'Science',
        'time': '10:00 - 11:30 AM',
        'teacher': 'Mr. Robert Stevens',
        'startHour': 10,
        'startMinute': 0,
        'endHour': 11,
        'endMinute': 30,
      },
      {
        'subject': 'Literature',
        'time': '01:00 - 02:30 PM',
        'teacher': 'Mrs. Emma Wilson',
        'startHour': 13,
        'startMinute': 0,
        'endHour': 14,
        'endMinute': 30,
      },
    ];

    Map<String, dynamic>? currentClass;
    Map<String, dynamic>? nextClass;

    for (var classItem in classes) {
      final startTimeInMinutes = (classItem['startHour'] as int?)! * 60 + (classItem['startMinute'] as int?)!;
      final endTimeInMinutes = (classItem['endHour'] as int?)! * 60 + (classItem['endMinute'] as int?)!;

      if (currentTimeInMinutes >= startTimeInMinutes && currentTimeInMinutes <= endTimeInMinutes) {
        currentClass = classItem;
      } else if (startTimeInMinutes > currentTimeInMinutes && nextClass == null) {
        nextClass = classItem;
      }
    }

    if (currentClass != null) {
      final endTimeInMinutes = (currentClass['endHour'] as int?)! * 60 + (currentClass['endMinute'] as int?)!;
      final remainingMinutes = endTimeInMinutes - currentTimeInMinutes;
      return _buildCurrentClassCard(
        context: context,
        subject: currentClass['subject'] as String,
        teacher: currentClass['teacher'] as String,
        time: currentClass['time'] as String,
        remainingMinutes: remainingMinutes,
      );
    } else if (nextClass != null) {
      return _buildUpcomingClassCard(
        context: context,
        subject: nextClass['subject'] as String,
        teacher: nextClass['teacher'] as String,
        time: nextClass['time'] as String,
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'No more classes today',
          style: TextStyle(
            color: AppTheme.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }
  }

  Widget _buildCurrentClassCard({
    required BuildContext context,
    required String subject,
    required String teacher,
    required String time,
    required int remainingMinutes,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 37, 47, 118), Color.fromARGB(255, 34, 45, 125)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 35, 42, 88).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppTheme.white.withOpacity(0.2),
                child: const Icon(Icons.person, color: AppTheme.white, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                teacher,
                style: const TextStyle(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subject,
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 15,
            ),
          ),
          const Text(
            'in progress',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$remainingMinutes minutes remaining',
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 12,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassDetailPage(
                    subject: subject,
                    time: time,
                    teacher: teacher,
                    icon: Icons.calculate,
                    color: Colors.blue.shade100,
                    iconColor: const Color.fromARGB(255, 47, 54, 100),
                    status: 'current',
                    room: 'Room 101',
                  ),
                ),
              );
            },
            child: const Row(
              children: [
                Text(
                  'view details',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: AppTheme.white, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingClassCard({
    required BuildContext context,
    required String subject,
    required String teacher,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color.fromARGB(255, 37, 47, 118), Color.fromARGB(255, 34, 45, 125)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 35, 42, 88).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppTheme.white.withOpacity(0.2),
                child: const Icon(Icons.person, color: AppTheme.white, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                teacher,
                style: const TextStyle(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subject,
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 15,
            ),
          ),
          const Text(
            'starting soon',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Make sure your assignment was all done',
            style: TextStyle(
              color: AppTheme.white,
              fontSize: 12,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/tasks');
            },
            child: const Row(
              children: [
                Text(
                  'check here',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward, color: AppTheme.white, size: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysClassesTitle() {
    return const Text(
      'Today\'s Class',
      style: AppTheme.subheadingStyle,
    );
  }

  Widget _buildClassCards(BuildContext context) {
    final now = DateTime.now();
    final currentHour = now.hour;
    final currentMinute = now.minute;
    final currentTimeInMinutes = currentHour * 60 + currentMinute;

    final classes = [
      {
        'subject': 'Mathematics',
        'time': '08:00 - 09:30 AM',
        'teacher': 'Mrs. Fatimah Zahr',
        'icon': Icons.calculate,
        'color': Colors.blue.shade100,
        'iconColor': const Color.fromARGB(255, 47, 54, 100),
        'startHour': 8,
        'startMinute': 0,
        'endHour': 9,
        'endMinute': 30,
        'room': 'Room 101',
      },
      {
        'subject': 'Science',
        'time': '10:00 - 11:30 AM',
        'teacher': 'Mr. Robert Stevens',
        'icon': Icons.science,
        'color': Colors.green.shade100,
        'iconColor': Colors.green,
        'startHour': 10,
        'startMinute': 0,
        'endHour': 11,
        'endMinute': 30,
        'room': 'Lab 201',
      },
      {
        'subject': 'Literature',
        'time': '01:00 - 02:30 PM',
        'teacher': 'Mrs. Emma Wilson',
        'icon': Icons.book,
        'color': Colors.orange.shade100,
        'iconColor': Colors.orange,
        'startHour': 13,
        'startMinute': 0,
        'endHour': 14,
        'endMinute': 30,
        'room': 'Room 105',
      },
    ];

    return Column(
      children: classes.map((classItem) {
        final startTimeInMinutes = (classItem['startHour'] as int?)! * 60 + (classItem['startMinute'] as int?)!;
        final endTimeInMinutes = (classItem['endHour'] as int?)! * 60 + (classItem['endMinute'] as int?)!;
        final isCurrent = currentTimeInMinutes >= startTimeInMinutes && currentTimeInMinutes <= endTimeInMinutes;

        return _buildClassCard(
          context: context,
          subject: classItem['subject'] as String,
          time: classItem['time'] as String,
          teacher: classItem['teacher'] as String,
          icon: classItem['icon'] as IconData,
          color: classItem['color'] as Color,
          iconColor: classItem['iconColor'] as Color,
          isCurrent: isCurrent,
          room: classItem['room'] as String,
        );
      }).toList(),
    );
  }

  Widget _buildClassCard({
    required BuildContext context,
    required String subject,
    required String time,
    required String teacher,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required bool isCurrent,
    required String room,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClassDetailPage(
              subject: subject,
              time: time,
              teacher: teacher,
              icon: icon,
              color: color,
              iconColor: iconColor,
              status: isCurrent ? 'current' : 'upcoming',
              room: room,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(12),
          border: isCurrent ? Border.all(color: AppTheme.primaryBlue, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: AppTheme.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
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
                    Row(
                      children: [
                        Text(
                          subject,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 30, 38, 104),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'LIVE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(fontSize: 14, color: AppTheme.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      teacher,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.grey.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_ios, color: AppTheme.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingItems(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Tasks',
          style: AppTheme.subheadingStyle,
        ),
        const SizedBox(height: 10),
        _buildTaskCard(context, title: 'Math Assignment', dueDate: 'Due Tomorrow', progress: 0.7),
        const SizedBox(height: 10),
        _buildTaskCard(context, title: 'Science Project', dueDate: 'Due in 3 days', progress: 0.3),
        const SizedBox(height: 10),
        _buildTaskCard(context, title: 'Literature Essay', dueDate: 'Due next week', progress: 0.1),
        const SizedBox(height: 20),
        _buildViewAllButton(context),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTaskCard(BuildContext context, {
    required String title,
    required String dueDate,
    required double progress,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/tasks');
      },
      child: Container(
        padding: const EdgeInsets.all(12),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 38, 46, 108),
                  ),
                ),
                Text(
                  dueDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: progress < 0.5 ? AppTheme.errorRed : AppTheme.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.lightGrey,
              valueColor: AlwaysStoppedAnimation<Color>(
                progress < 0.3
                    ? AppTheme.errorRed
                    : progress < 0.7
                        ? Colors.orange
                        : Colors.green,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toInt()}% completed',
              style: TextStyle(fontSize: 12, color: AppTheme.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewAllButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tasks');
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'View All Tasks',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward, size: 16, color: AppTheme.primaryBlue),
          ],
        ),
      ),
    );
  }
}

class ClassesPage extends StatelessWidget {
  const ClassesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildPageTitle(),
            const SizedBox(height: 20),
            _buildCurrentClassCard(context),
            const SizedBox(height: 20),
            _buildAllClassesTitle(),
            const SizedBox(height: 15),
            _buildAllClassCards(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Row(
      children: [
        const Icon(
          Icons.book,
          color: AppTheme.primaryBlue,
          size: 28,
        ),
        const SizedBox(width: 12),
        const Text(
          "Today's Classes",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentClassCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 37, 47, 118),
            Color.fromARGB(255, 34, 45, 125)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 35, 42, 88).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calculate,
                  color: AppTheme.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current Class',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Mathematics',
                      style: TextStyle(
                        color: AppTheme.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppTheme.white.withOpacity(0.2),
                child: const Icon(Icons.person, color: AppTheme.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'Mrs. Fatimah Zahr',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, color: AppTheme.white, size: 18),
              const SizedBox(width: 8),
              const Text(
                '08:00 - 09:30 AM',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              const Text(
                '64 min remaining',
                style: TextStyle(
                  color: AppTheme.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Joining Mathematics class')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.white,
                foregroundColor: AppTheme.primaryBlue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Join Class',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllClassesTitle() {
    return const Text(
      'All Classes Today',
      style: AppTheme.subheadingStyle,
    );
  }

  Widget _buildAllClassCards(BuildContext context) {
    final classes = [
      {
        'subject': 'Mathematics',
        'time': '08:00 - 09:30 AM',
        'teacher': 'Mrs. Fatimah Zahr',
        'icon': Icons.calculate,
        'color': Colors.blue.shade100,
        'iconColor': const Color.fromARGB(255, 47, 54, 100),
        'status': 'current',
        'room': 'Room 101',
      },
      {
        'subject': 'Science',
        'time': '10:00 - 11:30 AM',
        'teacher': 'Mr. Robert Stevens',
        'icon': Icons.science,
        'color': Colors.green.shade100,
        'iconColor': Colors.green,
        'status': 'upcoming',
        'room': 'Lab 201',
      },
      {
        'subject': 'Literature',
        'time': '01:00 - 02:30 PM',
        'teacher': 'Mrs. Emma Wilson',
        'icon': Icons.book,
        'color': Colors.orange.shade100,
        'iconColor': Colors.orange,
        'status': 'upcoming',
        'room': 'Room 105',
      },
      {
        'subject': 'History',
        'time': '03:00 - 04:30 PM',
        'teacher': 'Mr. David Johnson',
        'icon': Icons.history_edu,
        'color': Colors.purple.shade100,
        'iconColor': Colors.purple,
        'status': 'upcoming',
        'room': 'Room 203',
      },
    ];

    return Column(
      children: classes.map((classItem) => _buildDetailedClassCard(
        context: context,
        subject: classItem['subject'] as String,
        time: classItem['time'] as String,
        teacher: classItem['teacher'] as String,
        icon: classItem['icon'] as IconData,
        color: classItem['color'] as Color,
        iconColor: classItem['iconColor'] as Color,
        status: classItem['status'] as String,
        room: classItem['room'] as String,
      )).toList(),
    );
  }

  Widget _buildDetailedClassCard({
    required BuildContext context,
    required String subject,
    required String time,
    required String teacher,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required String status,
    required String room,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: status == 'current'
            ? Border.all(color: AppTheme.primaryBlue, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            subject,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 30, 38, 104),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: status == 'current'
                                  ? Colors.green.withOpacity(0.1)
                                  : AppTheme.lightGrey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status == 'current' ? 'LIVE' : 'UPCOMING',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: status == 'current'
                                    ? Colors.green
                                    : AppTheme.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: AppTheme.grey, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.person,
                              color: AppTheme.grey, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            teacher,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.grey.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: AppTheme.grey, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            room,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.grey.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClassDetailPage(
                            subject: subject,
                            time: time,
                            teacher: teacher,
                            icon: icon,
                            color: color,
                            iconColor: iconColor,
                            status: status,
                            room: room,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'View Details',
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: status == 'current'
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Joining $subject class')),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: status == 'current'
                          ? AppTheme.primaryBlue
                          : AppTheme.lightGrey,
                      foregroundColor: status == 'current'
                          ? AppTheme.white
                          : AppTheme.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      status == 'current' ? 'Join Now' : 'Scheduled',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}