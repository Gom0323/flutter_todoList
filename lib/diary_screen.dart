import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'custom_drawer.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  DateTime selectedDate = DateTime.now();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary'),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          TableCalendar(
            onDaySelected: onDaySelected,
            selectedDayPredicate: (date) {
              return isSameDay(selectedDate, date);
            },
            focusedDay: selectedDate,
            firstDay: DateTime(2023),
            lastDay: DateTime(2030),
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
              selectedBuilder: (context, date, _) => Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 1.5)),
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              todayBuilder: (context, date, _) => Container(
                margin: const EdgeInsets.all(4.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 1.5)),
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: diaryController,
              decoration: const InputDecoration(
                labelText: '일기 작성',
              ),
              maxLines: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedWeather,
              items: <String>['맑음', '흐림', '비', '눈', '바람']
                  .map<DropdownMenuItem<String>>((String value) {
                Icon icon;
                switch (value) {
                  case '맑음':
                    icon = const Icon(Icons.wb_sunny);
                    break;
                  case '흐림':
                    icon = const Icon(Icons.cloud);
                    break;
                  case '비':
                    icon = const Icon(Icons.beach_access);
                    break;
                  case '눈':
                    icon = const Icon(Icons.ac_unit);
                    break;
                  case '바람':
                    icon = const Icon(Icons.air);
                    break;
                  default:
                    icon = const Icon(Icons.help);
                }
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      icon,
                      const SizedBox(width: 8),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedWeather = newValue!;
                });
              },
            ),
          ),
          ElevatedButton(
            onPressed: _saveDiaryEntry,
            child: const Text('저장'),
          ),
          ElevatedButton(
            onPressed: () {
              _deleteDiaryEntry(selectedDate);
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
