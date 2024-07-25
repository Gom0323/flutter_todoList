import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'custom_drawer.dart';
import 'diary_textform.dart'; // 입력 폼 위젯 파일 불러오기
import 'api_service.dart'; // ApiService 파일 불러오기

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  final TextEditingController diaryController = TextEditingController();
  final Map<DateTime, Map<String, dynamic>> diaryTasks = {};
  final ApiService apiService = ApiService(); // ApiService 인스턴스 생성
  String selectedWeather = '맑음'; // 초기 날씨 상태
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _loadDiaryTasks();
  }

  void _loadDiaryTasks() async {
    try {
      final fetchedTasks = await apiService.fetchDiaryTasks();
      setState(() {
        diaryTasks.clear();
        for (var task in fetchedTasks) {
          DateTime date = DateTime.parse(task['date']);
          diaryTasks[date] = {
            'id': task['id'], // 추가된 부분
            'entry': task['entry'],
            'weather': task['weather'],
          };
        }
      });
    } catch (e) {
      print('Failed to load diary tasks: $e');
    }
  }

  void _saveDiaryTask() async {
    final existingTask = diaryTasks[selectedDate];
    if (existingTask != null) {
      _updateDiaryTask(existingTask['id'], diaryController.text);
    } else {
      final newTask = {
        'date': selectedDate.toIso8601String(),
        'entry': diaryController.text,
        'weather': selectedWeather,
      };
      try {
        await apiService.addDiaryTask(newTask);
        _loadDiaryTasks();
      } catch (e) {
        print('Failed to save diary task: $e');
      }
    }
  }

  void _updateDiaryTask(int id, String entry) async {
    final updatedTask = {
      'date': selectedDate.toIso8601String(),
      'entry': entry,
      'weather': selectedWeather,
    };
    try {
      await apiService.updateDiaryTask(id, updatedTask);
      _loadDiaryTasks();
    } catch (e) {
      print('Failed to update diary task: $e');
    }
  }

  void _deleteDiaryTask(int id) async {
    try {
      await apiService.deleteDiaryTask(id);
      _loadDiaryTasks();
    } catch (e) {
      print('Failed to delete diary task: $e');
    }
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      selectedDate = selectedDay;
      focusedDate = focusedDay;
    });
    diaryController.text = diaryTasks[selectedDate]?['entry'] ?? '';
    selectedWeather = diaryTasks[selectedDate]?['weather'] ?? '맑음';
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void dispose() {
    diaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String currentYearMonth = DateFormat.yMMMM('ko_KR').format(focusedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary'),
        actions: [
          IconButton(
            icon: Icon(_calendarFormat == CalendarFormat.month
                ? Icons.calendar_view_month
                : Icons.calendar_view_week),
            onPressed: () {
              setState(() {
                _calendarFormat = _calendarFormat == CalendarFormat.month
                    ? CalendarFormat.week
                    : CalendarFormat.month;
              });
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              currentYearMonth,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TableCalendar(
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week',
            },
            onDaySelected: onDaySelected,
            onPageChanged: (focusedDay) {
              setState(() {
                focusedDate = focusedDay;
              });
            },
            headerVisible: false,
            selectedDayPredicate: (date) {
              return isSameDay(selectedDate, date);
            },
            focusedDay: focusedDate,
            firstDay: DateTime(2023, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            daysOfWeekHeight: 30,
            eventLoader: (day) {
              return diaryTasks.containsKey(day) ? [diaryTasks[day]] : [];
            },
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                switch (day.weekday) {
                  case 1:
                    return const Center(
                      child: Text('월'),
                    );
                  case 2:
                    return const Center(
                      child: Text('화'),
                    );
                  case 3:
                    return const Center(
                      child: Text('수'),
                    );
                  case 4:
                    return const Center(
                      child: Text('목'),
                    );
                  case 5:
                    return const Center(
                      child: Text('금'),
                    );
                  case 6:
                    return const Center(
                      child: Text('토'),
                    );
                  case 7:
                    return const Center(
                      child: Text(
                        '일',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                }
                return null;
              },
              defaultBuilder: (context, date, _) => Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey, width: 1.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              selectedBuilder: (context, date, _) => Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              todayBuilder: (context, date, _) => Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  DiaryInputForm(
                    controller: diaryController,
                    selectedWeather: selectedWeather,
                    onWeatherChanged: (String? newValue) {
                      setState(() {
                        selectedWeather = newValue!;
                      });
                    },
                    onSave: _saveDiaryTask,
                    onDelete: () {
                      int taskId = diaryTasks[selectedDate]?['id'] as int;
                      _deleteDiaryTask(taskId);
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildDiaryList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiaryList() {
    List<Widget> diaryListItems = [];

    diaryTasks.forEach((date, task) {
      diaryListItems.add(
        ListTile(
          title: Text(DateFormat.yMMMMd('ko_KR').format(date)),
          subtitle: Text(task['entry']),
          trailing: Text(task['weather']),
          onTap: () {
            setState(() {
              selectedDate = date;
              diaryController.text = task['entry'];
              selectedWeather = task['weather'];
            });
          },
        ),
      );
    });

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: diaryListItems,
    );
  }
}
