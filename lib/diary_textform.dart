import 'package:flutter/material.dart';

class DiaryInputForm extends StatelessWidget {
  final TextEditingController controller;
  final String selectedWeather;
  final ValueChanged<String?> onWeatherChanged;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  const DiaryInputForm({
    super.key,
    required this.controller,
    required this.selectedWeather,
    required this.onWeatherChanged,
    required this.onSave,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
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
              onChanged: onWeatherChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onSave,
                  child: const Text('저장'),
                ),
                ElevatedButton(
                  onPressed: onDelete,
                  child: const Text('삭제'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
