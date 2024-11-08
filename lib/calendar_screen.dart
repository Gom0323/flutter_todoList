import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'custom_drawer.dart';
import 'textform.dart';
import 'api_service.dart';
import 'task_item.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  final List<Map<String, dynamic>> tasks = [];
  final TextEditingController taskController = TextEditingController();
  final ApiService apiService = ApiService();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    try {
      final tasksData = await apiService.fetchCalendarTasks();
      setState(() {
        tasks.clear();
        tasks.addAll(tasksData);
      });
    } catch (e) {
      print('Failed to load tasks: $e');
    }
  }

  void _addTask(String task) async {
    if (taskController.text.isNotEmpty) {
      final newTask = {
        'date': selectedDate.toIso8601String(),
        'task': task,
        'isCompleted': 0,
      };
      try {
        await apiService.addCalendarTask(newTask);
        _loadTasks();
        taskController.clear();
      } catch (e) {
        print('Failed to add task: $e');
      }
    } else {
      _showAlertDialog();
    }
  }

  void _updateTask(int id, String task) async {
    if (task.isNotEmpty) {
      final updatedTask = {
        'date': DateFormat('yyyy-MM-dd').format(selectedDate),
        'task': task,
        'isCompleted': 0,
      };
      try {
        await apiService.updateCalendarTask(id, updatedTask);
        _loadTasks();
      } catch (e) {
        print('Failed to update task: $e');
      }
    }
  }

  void _deleteTask(int id) async {
    try {
      await apiService.deleteCalendarTask(id);
      _loadTasks();
    } catch (e) {
      print('Failed to delete task: $e');
    }
  }

  void _toggleTaskCompletion(int id, bool isCompleted) async {
    final task = tasks.firstWhere((element) => element['id'] == id,
        orElse: () => <String, dynamic>{});

    if (task.isNotEmpty) {
      final updatedTask = {
        'date': task['date'], // 기존 date 값을 유지
        'task': task['task'], // 기존 task 값을 유지
        'isCompleted': isCompleted ? 1 : 0,
      };

      try {
        await apiService.updateCalendarTask(id, updatedTask);
        _loadTasks();
      } catch (e) {
        print('Failed to update task: $e');
      }
    } else {
      print('Task not found for id $id'); // 디버깅을 위해 로그 추가
    }
  }

  // 빈칸으로 입력시 알림
  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('내용을 입력해주세요'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(Map<String, dynamic> task) {
    TextEditingController editController =
        TextEditingController(text: task['task']);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('할 일 수정'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: '수정할 내용 입력'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('저장'),
              onPressed: () {
                Navigator.of(context).pop();
                int taskId =
                    task['id'] is int ? task['id'] : int.parse(task['id']);
                _updateTask(taskId, editController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      selectedDate = selectedDay;
      focusedDate = focusedDay;
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dailyTasks = tasks
        .where((task) => isSameDay(DateTime.parse(task['date']), selectedDate))
        .toList();

    String currentYearMonth = DateFormat.yMMMM('ko_KR').format(focusedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To_do List'),
        actions: [
          // 한달씩 or 일주일씩 보는 기능
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
          // 현재 연월
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                currentYearMonth,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
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
              return tasks
                  .where((task) => isSameDay(DateTime.parse(task['date']), day))
                  .toList();
            },
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                switch (day.weekday) {
                  case 1:
                    return const Center(child: Text('월'));
                  case 2:
                    return const Center(child: Text('화'));
                  case 3:
                    return const Center(child: Text('수'));
                  case 4:
                    return const Center(child: Text('목'));
                  case 5:
                    return const Center(child: Text('금'));
                  case 6:
                    return const Center(child: Text('토'));
                  case 7:
                    return const Center(
                        child: Text('일', style: TextStyle(color: Colors.red)));
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
              // 할일 추가될때 숫자로 몇개있는지 표시
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '${events.length}',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10.0,
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
            child: ListView.builder(
              itemCount: dailyTasks.length,
              itemBuilder: (context, index) {
                final task = dailyTasks[index];
                return TaskItem(
                  task: task,
                  onDelete: _deleteTask,
                  onEdit: _showEditDialog,
                  onToggle: _toggleTaskCompletion,
                );
              },
            ),
          ),
          const Divider(height: 1.0),
          Textform(
            controller: taskController,
            onAdd: () {
              _addTask(taskController.text);
            },
          ),
        ],
      ),
    );
  }
}
