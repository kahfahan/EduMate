import 'package:flutter/material.dart';

enum CalendarFormat { month, twoWeeks, week }

enum StartingDayOfWeek { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class CalendarStyle {
  final BoxDecoration? selectedDecoration;
  final BoxDecoration? todayDecoration;
  final int markersMaxCount;
  final BoxDecoration? markerDecoration;
  final double markersAnchor;
  final bool outsideDaysVisible;

  const CalendarStyle({
    this.selectedDecoration,
    this.todayDecoration,
    this.markersMaxCount = 3,
    this.markerDecoration,
    this.markersAnchor = 0.7,
    this.outsideDaysVisible = true,
  });
}

class HeaderStyle {
  final bool formatButtonVisible;
  final bool titleCentered;
  final TextStyle? titleTextStyle;

  const HeaderStyle({
    this.formatButtonVisible = true,
    this.titleCentered = false,
    this.titleTextStyle,
  });
}

bool isSameDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

class TableCalendar extends StatefulWidget {
  final DateTime firstDay;
  final DateTime lastDay;
  final DateTime focusedDay;
  final CalendarFormat calendarFormat;
  final StartingDayOfWeek startingDayOfWeek;
  final List<dynamic> Function(DateTime)? eventLoader;
  final bool Function(DateTime)? selectedDayPredicate;
  final void Function(DateTime, DateTime)? onDaySelected;
  final void Function(CalendarFormat)? onFormatChanged;
  final void Function(DateTime)? onPageChanged;
  final CalendarStyle? calendarStyle;
  final HeaderStyle? headerStyle;

  const TableCalendar({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.focusedDay,
    this.calendarFormat = CalendarFormat.month,
    this.startingDayOfWeek = StartingDayOfWeek.sunday,
    this.eventLoader,
    this.selectedDayPredicate,
    this.onDaySelected,
    this.onFormatChanged,
    this.onPageChanged,
    this.calendarStyle,
    this.headerStyle,
  }) : super(key: key);

  @override
  State<TableCalendar> createState() => _TableCalendarState();
}

class _TableCalendarState extends State<TableCalendar> {
  late DateTime _focusedDay;
  late CalendarFormat _calendarFormat;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.focusedDay;
    _calendarFormat = widget.calendarFormat;
  }

  @override
  void didUpdateWidget(TableCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusedDay != widget.focusedDay) {
      _focusedDay = widget.focusedDay;
    }
    if (oldWidget.calendarFormat != widget.calendarFormat) {
      _calendarFormat = widget.calendarFormat;
    }
  }

  List<DateTime> _getDaysInRange(DateTime start, DateTime end) {
    List<DateTime> days = [];
    DateTime current = start;
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  List<DateTime> _getVisibleDays() {
    switch (_calendarFormat) {
      case CalendarFormat.month:
        return _getMonthDays();
      case CalendarFormat.twoWeeks:
        return _getTwoWeeksDays();
      case CalendarFormat.week:
        return _getWeekDays();
    }
  }

  List<DateTime> _getMonthDays() {
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final lastDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
    
    int startOffset = _getStartingDayOffset(firstDayOfMonth.weekday);
    final startDate = firstDayOfMonth.subtract(Duration(days: startOffset));
    
    int endOffset = 6 - lastDayOfMonth.weekday;
    if (widget.startingDayOfWeek == StartingDayOfWeek.monday) {
      endOffset = (7 - lastDayOfMonth.weekday) % 7;
    }
    final endDate = lastDayOfMonth.add(Duration(days: endOffset));
    
    return _getDaysInRange(startDate, endDate);
  }

  List<DateTime> _getTwoWeeksDays() {
    final startOfWeek = _getStartOfWeek(_focusedDay);
    final endOfTwoWeeks = startOfWeek.add(const Duration(days: 13));
    return _getDaysInRange(startOfWeek, endOfTwoWeeks);
  }

  List<DateTime> _getWeekDays() {
    final startOfWeek = _getStartOfWeek(_focusedDay);
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return _getDaysInRange(startOfWeek, endOfWeek);
  }

  DateTime _getStartOfWeek(DateTime date) {
    int startingDay = widget.startingDayOfWeek == StartingDayOfWeek.monday ? 1 : 7;
    int currentDay = date.weekday;
    int daysToSubtract = (currentDay - startingDay) % 7;
    return date.subtract(Duration(days: daysToSubtract));
  }

  int _getStartingDayOffset(int weekday) {
    if (widget.startingDayOfWeek == StartingDayOfWeek.monday) {
      return (weekday - 1) % 7;
    } else {
      return weekday % 7;
    }
  }

  List<String> _getWeekdayHeaders() {
    if (widget.startingDayOfWeek == StartingDayOfWeek.monday) {
      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    } else {
      return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    }
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _goToPreviousPage() {
    DateTime newFocusedDay;
    switch (_calendarFormat) {
      case CalendarFormat.month:
        newFocusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1, _focusedDay.day);
        break;
      case CalendarFormat.twoWeeks:
        newFocusedDay = _focusedDay.subtract(const Duration(days: 14));
        break;
      case CalendarFormat.week:
        newFocusedDay = _focusedDay.subtract(const Duration(days: 7));
        break;
    }
    
    setState(() {
      _focusedDay = newFocusedDay;
    });
    
    widget.onPageChanged?.call(newFocusedDay);
  }

  void _goToNextPage() {
    DateTime newFocusedDay;
    switch (_calendarFormat) {
      case CalendarFormat.month:
        newFocusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1, _focusedDay.day);
        break;
      case CalendarFormat.twoWeeks:
        newFocusedDay = _focusedDay.add(const Duration(days: 14));
        break;
      case CalendarFormat.week:
        newFocusedDay = _focusedDay.add(const Duration(days: 7));
        break;
    }
    
    setState(() {
      _focusedDay = newFocusedDay;
    });
    
    widget.onPageChanged?.call(newFocusedDay);
  }

  @override
  Widget build(BuildContext context) {
    final visibleDays = _getVisibleDays();
    final weekdayHeaders = _getWeekdayHeaders();
    
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildWeekdayHeader(weekdayHeaders),
          const SizedBox(height: 8),
          _buildCalendarGrid(visibleDays),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: _goToPreviousPage,
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          _getMonthYearString(_focusedDay),
          style: widget.headerStyle?.titleTextStyle ?? 
                 const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: _goToNextPage,
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeader(List<String> weekdays) {
    return Row(
      children: weekdays.map((day) => Expanded(
        child: Center(
          child: Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCalendarGrid(List<DateTime> days) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final day = days[index];
        return _buildDayCell(day);
      },
    );
  }

  Widget _buildDayCell(DateTime day) {
    final isSelected = widget.selectedDayPredicate?.call(day) ?? false;
    final isToday = isSameDay(day, DateTime.now());
    final isOutsideMonth = day.month != _focusedDay.month;
    final events = widget.eventLoader?.call(day) ?? [];
    
    if (isOutsideMonth && !(widget.calendarStyle?.outsideDaysVisible ?? true)) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        widget.onDaySelected?.call(day, _focusedDay);
      },
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: _getDayDecoration(isSelected, isToday),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                color: _getDayTextColor(isSelected, isToday, isOutsideMonth),
                fontWeight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (events.isNotEmpty) _buildEventMarkers(events.length),
          ],
        ),
      ),
    );
  }

  BoxDecoration? _getDayDecoration(bool isSelected, bool isToday) {
    if (isSelected) {
      return widget.calendarStyle?.selectedDecoration ?? 
             const BoxDecoration(
               color: Colors.blue,
               shape: BoxShape.circle,
             );
    } else if (isToday) {
      return widget.calendarStyle?.todayDecoration ?? 
             BoxDecoration(
               color: Colors.blue.withOpacity(0.3),
               shape: BoxShape.circle,
             );
    }
    return null;
  }

  Color _getDayTextColor(bool isSelected, bool isToday, bool isOutsideMonth) {
    if (isSelected) {
      return Colors.white;
    } else if (isOutsideMonth) {
      return Colors.grey.withOpacity(0.5);
    } else if (isToday) {
      return Colors.blue;
    }
    return Colors.black87;
  }

  Widget _buildEventMarkers(int eventCount) {
    final maxMarkers = widget.calendarStyle?.markersMaxCount ?? 3;
    final displayCount = eventCount > maxMarkers ? maxMarkers : eventCount;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(displayCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1),
          width: 4,
          height: 4,
          decoration: widget.calendarStyle?.markerDecoration ?? 
                     const BoxDecoration(
                       color: Colors.blue,
                       shape: BoxShape.circle,
                     ),
        );
      }),
    );
  }
}