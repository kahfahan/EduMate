import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:edu_mate/theme.dart';

//displays the schedule screen within the app's navigation.
class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ScheduleScreen();
  }
}

//event
class Event {
  final String id;
  final String title;
  final String startTime;
  final String endTime;
  final String teacher;
  final String location;
  final Color color;
  final IconData icon;

  Event({
    required this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.teacher,
    required this.location,
    required this.color,
    required this.icon,
  });
}

//subject with associated metadata.
class Subject {
  final String name;
  final String teacher;
  final String location;
  final Color color;
  final IconData icon;

  Subject({
    required this.name,
    required this.teacher,
    required this.location,
    required this.color,
    required this.icon,
  });
}

/// A screen that displays a calendar and list of events.
class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  bool isWeekView = true;
  Map<String, List<Event>> events = {};
  Color selectedColor = AppTheme.primaryBlue;

  final List<Subject> subjects = [
    Subject(name: 'Mathematics', teacher: 'Mrs. Fatimah Zahr', location: 'Room 101', color: Colors.blue, icon: Icons.calculate),
    Subject(name: 'Science', teacher: 'Mr. Robert Stevens', location: 'Room 203', color: Colors.green, icon: Icons.science),
    Subject(name: 'Literature', teacher: 'Mrs. Emma Wilson', location: 'Room 105', color: Colors.orange, icon: Icons.book),
    Subject(name: 'History', teacher: 'Mr. John Anderson', location: 'Room 302', color: Colors.purple, icon: Icons.history_edu),
    Subject(name: 'Art', teacher: 'Ms. Sarah Johnson', location: 'Room 401', color: Colors.pink, icon: Icons.brush),
    Subject(name: 'Physical Education', teacher: 'Ms. Jennifer Smith', location: 'Gymnasium', color: Colors.cyan, icon: Icons.sports_soccer),
    Subject(name: 'Music', teacher: 'Mr. David Lee', location: 'Room 402', color: Colors.red, icon: Icons.music_note),
  ];

  final List<Color> colorOptions = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.purple,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    initializeEvents();
  }

  /// Initializes events for the current week.
  void initializeEvents() {
    final startOfWeek = getStartOfWeek(currentDate);
    for (var i = 0; i < 5; i++) {
      final date = startOfWeek.add(Duration(days: i));
      final dateKey = getDateKey(date);
      events[dateKey] = generateDayEvents(i);
    }
  }

  /// Generates events for a specific day based on the day index (0-4 for Monday-Friday).
  List<Event> generateDayEvents(int dayIndex) {
    const schedules = [
      [0, 1, 2], // Monday: Math, Science, Literature
      [3, 4, 5], // Tuesday: History, Art, PE
      [0, 6, 1], // Wednesday: Math, Music, Science
      [2, 3, 5], // Thursday: Literature, History, PE
      [0, 1, 4], // Friday: Math, Science, Art
    ];

    const times = [
      ['08:00', '09:30'],
      ['10:00', '11:30'],
      ['13:00', '14:30'],
    ];

    return schedules[dayIndex].asMap().entries.map((entry) {
      final index = entry.key;
      final subject = subjects[entry.value];
      return Event(
        id: '${DateTime.now().millisecondsSinceEpoch}$index',
        title: subject.name,
        startTime: times[index][0],
        endTime: times[index][1],
        teacher: subject.teacher,
        location: subject.location,
        color: subject.color,
        icon: subject.icon,
      );
    }).toList();
  }

  /// Returns the start of the week (Monday) for a given date.
  DateTime getStartOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return date.subtract(Duration(days: daysFromMonday));
  }

  /// Formats a date as a key (YYYY-MM-DD).
  String getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Checks if the given date is today.
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Checks if two dates are the same day.
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  /// Updates the selected date.
  void selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  /// Changes the displayed month.
  void changeMonth(int direction) {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + direction, 1);
      initializeEvents();
    });
  }

  /// Changes the displayed week.
  void changeWeek(int direction) {
    setState(() {
      currentDate = currentDate.add(Duration(days: 7 * direction));
      initializeEvents();
    });
  }

  /// Toggles between week and month view.
  void toggleView() {
    setState(() {
      isWeekView = !isWeekView;
    });
  }

  /// Shows the dialog to add a new event.
  void showAddEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(
        selectedDate: selectedDate,
        colorOptions: colorOptions,
        onEventAdded: (event) {
          setState(() {
            final dateKey = getDateKey(selectedDate);
            events[dateKey] ??= [];
            events[dateKey]!.add(event);
          });
        },
      ),
    );
  }

  /// Shows a confirmation dialog to delete an event.
  void deleteEvent(String eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final dateKey = getDateKey(selectedDate);
                events[dateKey]?.removeWhere((event) => event.id == eventId);
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  /// Shows a notification with the given message.
  void showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildCalendarSection(),
              const SizedBox(height: 16),
              Expanded(child: _buildEventsSection()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddEventDialog,
        backgroundColor: AppTheme.primaryBlue,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  /// Builds the header section with title and view/filter buttons.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppTheme.primaryBlue, size: 24),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: toggleView,
                  icon: const Icon(Icons.calendar_view_month, size: 18),
                  label: Text(isWeekView ? 'Month' : 'Week'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.white,
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppTheme.primaryBlue, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => showNotification('Filter options coming soon!'),
                  icon: const Icon(Icons.filter_list, size: 18),
                  label: const Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.white,
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppTheme.primaryBlue, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the calendar section (week or month view).
  Widget _buildCalendarSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => isWeekView ? changeWeek(-1) : changeMonth(-1),
                icon: const Icon(Icons.chevron_left, color: AppTheme.primaryBlue, size: 24),
              ),
              Text(
                isWeekView
                    ? 'Week of ${DateFormat('MMM d, yyyy').format(getStartOfWeek(currentDate))}'
                    : DateFormat('MMMM yyyy').format(currentDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              IconButton(
                onPressed: () => isWeekView ? changeWeek(1) : changeMonth(1),
                icon: const Icon(Icons.chevron_right, color: AppTheme.primaryBlue, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 16),
          isWeekView ? _buildWeekView() : _buildMonthView(),
        ],
      ),
    );
  }

  /// Builds the week view calendar.
  Widget _buildWeekView() {
    final startOfWeek = getStartOfWeek(currentDate);
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

    return Row(
      children: List.generate(5, (index) {
        final date = startOfWeek.add(Duration(days: index));
        final isSelected = isSameDate(date, selectedDate);
        final today = isToday(date);

        return Expanded(
          child: GestureDetector(
            onTap: () => selectDate(date),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryBlue
                    : today
                        ? AppTheme.primaryBlue.withOpacity(0.2)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    weekDays[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppTheme.white : AppTheme.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppTheme.white : AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                      color: events[getDateKey(date)]?.isNotEmpty == true
                          ? (isSelected ? AppTheme.white : AppTheme.primaryBlue)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  /// Builds the month view calendar.
  Widget _buildMonthView() {
    final firstDay = DateTime(currentDate.year, currentDate.month, 1);
    final lastDay = DateTime(currentDate.year, currentDate.month + 1, 0);
    final startWeekday = firstDay.weekday - 1;
    final totalDays = lastDay.day;

    final dayWidgets = <Widget>[];

    for (var i = 0; i < startWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (var day = 1; day <= totalDays; day++) {
      final date = DateTime(currentDate.year, currentDate.month, day);
      final isSelected = isSameDate(date, selectedDate);
      final today = isToday(date);
      final hasEvents = events[getDateKey(date)]?.isNotEmpty == true;

      dayWidgets.add(
        GestureDetector(
          onTap: () => selectDate(date),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryBlue
                  : today
                      ? AppTheme.primaryBlue.withOpacity(0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppTheme.white : AppTheme.primaryBlue,
                  ),
                ),
                if (hasEvents)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.white : AppTheme.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: dayWidgets,
    );
  }

  /// Builds the events section for the selected date.
  Widget _buildEventsSection() {
    final dateKey = getDateKey(selectedDate);
    final dayEvents = events[dateKey] ?? [];
    final isWeekendOrMonday = selectedDate.weekday == 1 || selectedDate.weekday == 6 || selectedDate.weekday == 7;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                DateFormat('EEEE, MMM d').format(selectedDate),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const Spacer(),
              if (dayEvents.isNotEmpty && !isWeekendOrMonday)
                Text(
                  '${dayEvents.length} event${dayEvents.length > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.grey,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isWeekendOrMonday
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.weekend,
                          size: 48,
                          color: AppTheme.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Classes on Weekend, enjoy your weekend!',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.grey,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : dayEvents.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_note,
                              size: 48,
                              color: AppTheme.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No events scheduled',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppTheme.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap + to add a new event',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.grey,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: dayEvents.length,
                        itemBuilder: (context, index) {
                          return _buildEventCard(dayEvents[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  /// Builds a card for a single event.
  Widget _buildEventCard(Event event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: event.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: event.color.withOpacity(0.3)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: event.color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(event.icon, color: AppTheme.white, size: 24),
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryBlue,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: AppTheme.grey),
                const SizedBox(width: 4),
                Text(
                  '${event.startTime} - ${event.endTime}',
                  style: const TextStyle(
                    color: AppTheme.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.person, size: 14, color: AppTheme.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.teacher,
                    style: const TextStyle(
                      color: AppTheme.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: AppTheme.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location,
                    style: const TextStyle(
                      color: AppTheme.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => deleteEvent(event.id),
          icon: const Icon(Icons.delete_outline, color: AppTheme.errorRed),
        ),
      ),
    );
  }
}

/// A dialog for adding a new event.
class AddEventDialog extends StatefulWidget {
  final DateTime selectedDate;
  final List<Color> colorOptions;
  final Function(Event) onEventAdded;

  const AddEventDialog({
    Key? key,
    required this.selectedDate,
    required this.colorOptions,
    required this.onEventAdded,
  }) : super(key: key);

  @override
  _AddEventDialogState createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  final _titleController = TextEditingController();
  final _teacherController = TextEditingController();
  final _locationController = TextEditingController();
  String _startTime = '08:00';
  String _endTime = '09:30';
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.book;

  final List<IconData> iconOptions = [
    Icons.book,
    Icons.science,
    Icons.calculate,
    Icons.brush,
    Icons.music_note,
    Icons.sports_soccer,
    Icons.history_edu,
    Icons.public,
    Icons.computer,
    Icons.edit,
  ];

  final List<String> timeSlots = [
    '07:00', '07:30', '08:00', '08:30', '09:00', '09:30',
    '10:00', '10:30', '11:00', '11:30', '12:00', '12:30',
    '13:00', '13:30', '14:00', '14:30', '15:00', '15:30',
    '16:00', '16:30', '17:00', '17:30', '18:00', '18:30',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _teacherController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Add New Event',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryBlue,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _teacherController,
              decoration: InputDecoration(
                labelText: 'Teacher/Instructor',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Start Time',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _startTime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: timeSlots.map((time) {
                          return DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _startTime = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'End Time',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _endTime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: timeSlots.map((time) {
                          return DropdownMenuItem(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _endTime = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Color',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: widget.colorOptions.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: _selectedColor == color
                          ? Border.all(color: AppTheme.primaryBlue, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Icon',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: iconOptions.map((icon) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = icon;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _selectedIcon == icon
                          ? AppTheme.primaryBlue.withOpacity(0.2)
                          : AppTheme.lightGrey,
                      borderRadius: BorderRadius.circular(8),
                      border: _selectedIcon == icon
                          ? Border.all(color: AppTheme.primaryBlue, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Icon(icon, color: AppTheme.primaryBlue),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter an event title')),
              );
              return;
            }

            final newEvent = Event(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              title: _titleController.text.trim(),
              startTime: _startTime,
              endTime: _endTime,
              teacher: _teacherController.text.trim(),
              location: _locationController.text.trim(),
              color: _selectedColor,
              icon: _selectedIcon,
            );
            widget.onEventAdded(newEvent);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            foregroundColor: AppTheme.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Add Event'),
        ),
      ],
    );
  }
}