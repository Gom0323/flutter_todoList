import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'custom_drawer.dart';
import 'diary_textform.dart'; // 입력 폼 위젯 파일 불러오기

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  final TextEditingController diaryController = TextEditingController();
  final Map<DateTime, Map<String, String>> diaryEntries = {};
  String selectedWeather = '맑음'; // 초기 날씨 상태

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      selectedDate = selectedDay;
    });
    diaryController.text = diaryEntries[selectedDate]?['entry'] ?? '';
    selectedWeather = diaryEntries[selectedDate]?['weather'] ?? '맑음';
  }

  void _saveDiaryEntry() {
    setState(() {
      diaryEntries[selectedDate] = {
        'entry': diaryController.text,
        'weather': selectedWeather,
      };
    });
  }

  void _deleteDiaryEntry(DateTime date) {
    setState(() {
      diaryEntries.remove(date);
    });
    if (isSameDay(date, selectedDate)) {
      diaryController.clear();
      selectedWeather = '맑음';
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    String currentYearMonth = DateFormat.yMMMM('ko_KR').format(focusedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary'),
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
              return diaryEntries.containsKey(day) ? [diaryEntries[day]] : [];
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
            child: SingleChildScrollView(
              child: DiaryInputForm(
                controller: diaryController,
                selectedWeather: selectedWeather,
                onWeatherChanged: (String? newValue) {
                  setState(() {
                    selectedWeather = newValue!;
                  });
                },
                onSave: _saveDiaryEntry,
                onDelete: () {
                  _deleteDiaryEntry(selectedDate);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
