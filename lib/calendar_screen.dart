import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'custom_drawer.dart';
import 'textform.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now(); // focusedDate 상태 변수 선언
  final List<Map<String, String>> tasks = [];
  final TextEditingController taskController = TextEditingController();

  void _loadTasks() {
    setState(() {
      // DB연결 도저히못하겠음
    });
  }

  void _addTask(String task) {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add({
          'date': selectedDate.toIso8601String(),
          'task': task,
        });
      });
      taskController.clear();
      _loadTasks();
    } else {
      _showAlertDialog();
    }
  }

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

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      selectedDate = selectedDay;
      focusedDate = focusedDay;
    });
    _loadTasks();
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
        .where((task) => isSameDay(DateTime.parse(task['date']!), selectedDate))
        .toList();

    String currentYearMonth = DateFormat.yMMMM('ko_KR').format(focusedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('To_do List'),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () {
                  setState(() {
                    focusedDate =
                        DateTime(focusedDate.year, focusedDate.month - 1);
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () {
                  setState(() {
                    focusedDate =
                        DateTime(focusedDate.year, focusedDate.month + 1);
                  });
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              currentYearMonth,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TableCalendar(
            onDaySelected: onDaySelected,
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
                  .where(
                      (task) => isSameDay(DateTime.parse(task['date']!), day))
                  .toList();
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
                  color: Colors.orange,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dailyTasks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      title: Text(dailyTasks[index]['task']!),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            tasks.remove(dailyTasks[index]);
                          });
                        },
                      ),
                    ),
                  ),
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
