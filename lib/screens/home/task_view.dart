import 'package:flutter/material.dart';
import 'package:to_do_app/screens/home/components/bottom_buttons.dart';
import 'package:to_do_app/screens/home/widget/add_task_form_field.dart';
import 'package:to_do_app/screens/home/widget/add_task_title.dart';
import 'package:to_do_app/screens/home/widget/task_view_app_bar.dart';
import 'package:to_do_app/utils/app_colors.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? _priority; // Made _priority nullable

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        // backgroundColor: const Color(0xffCCD0CF),
        // * App Bar
        appBar: const TaskViewAppBar(),
        // * Body
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // * Head Title
                const AddTaskTitle(),
                Text(
                  'What are you planning👋?',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                // * Title
                CustomTextField(
                  controller: titleController,
                  hintText: 'Enter task title',
                ),
                const SizedBox(height: 10),
                // * Description
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Enter task description',
                  isDescription: true,
                ),
                // * Calender and Time
                _buildCalenderAndTime(context),
                const SizedBox(height: 20),
                // * priority
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: SizedBox(
                    height: 50,
                    width: 100,
                    child: DropdownButton<String>(
                      hint: const Text('Priority'),
                      dropdownColor: AppColors.primaryColor,
                      value: _priority,
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconSize: 24,
                      elevation: 16,
                      borderRadius: BorderRadius.circular(16),
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                      underline: Container(
                        height: 3,
                        color: Colors.grey,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _priority = newValue; // Update _priority directly
                        });
                      },
                      items: <String>['High', 'Medium', 'Low']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                // * Icons
                // _iconButton(Icons.alarm),
                // * Bottom Buttons
                BottomButtons(
                  titleController: titleController,
                  contentController: descriptionController,
                  selectedDate: selectedDate,
                  selectedTime: selectedTime,
                  priority: _priority,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildCalenderAndTime(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // * Time
          Flexible(
            child: GestureDetector(
              onTap: () async {
                selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  
                );
                setState(() {});
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedTime != null
                          ? selectedTime!.format(context)
                          : 'Time',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const Icon(Icons.access_alarms_outlined),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // * Date
          Flexible(
            child: GestureDetector(
              onTap: () async {
                selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                setState(() {

                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate != null
                          ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                          : 'Date',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const Icon(Icons.calendar_month_outlined),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _iconButton(IconData icon) {
  //   return GestureDetector(
  //     onTap: () => _selectIcon(icon),
  //     child: Container(
  //       width: 40,
  //       height: 40,
  //       decoration: BoxDecoration(
  //         color: Colors.grey[200],
  //         shape: BoxShape.circle,
  //       ),
  //       child: Center(
  //         child: Icon(
  //           icon,
  //           color: _selectedIcon == icon ? Colors.blue : Colors.black,
  //           size: 24,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
