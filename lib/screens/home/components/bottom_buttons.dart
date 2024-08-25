import 'package:flutter/material.dart';
import 'package:to_do_app/data/sqldb.dart';
import 'package:to_do_app/models/tasks_model.dart';
import 'package:to_do_app/screens/home/home_screen.dart';
import 'package:to_do_app/utils/app_colors.dart';

class BottomButtons extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final String? priority;

  BottomButtons({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.selectedDate,
    required this.selectedTime,
    required this.priority,
  });

  final Sqldb sqldb = Sqldb();

  String? _timeToString(TimeOfDay? time) {
  if (time == null) return null;
  return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Cancel Task'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              backgroundColor: Colors.grey[200],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              // * Add task action
              if (titleController.text.isNotEmpty &&
                  contentController.text.isNotEmpty) {
                TasksModel task = TasksModel(
                  title: titleController.text,
                  content: contentController.text,
                  date: selectedDate?.toIso8601String(),
                  time: _timeToString(selectedTime),
                  priority: priority,
                );
                await sqldb.insertData(task);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  )
                ); // ? Close the form after saving
                print(
                    'Task added: ${task.title} - ${task.content} - ${task.date} - ${task.time} - ${task.priority}');
              } else {
                // Show an error if fields are empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Task',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              backgroundColor: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
