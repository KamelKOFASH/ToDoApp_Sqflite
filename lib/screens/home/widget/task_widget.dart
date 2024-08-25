import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/data/sqldb.dart';
import 'package:to_do_app/models/tasks_model.dart';
import 'package:to_do_app/screens/home/home_screen.dart';

class TaskWidget extends StatefulWidget {
  final TasksModel task;
  final int index;

  TaskWidget({
    super.key,
    required this.task,
    required this.index,
  });

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  final List<Color> colors = [
    const Color(0xff253745),
    const Color(0xff4A5C6A),
  ];

  final Sqldb sqldb = Sqldb();

  @override
  Widget build(BuildContext context) {
    String formattedDate = 'No Date';
    String formattedTime = 'No Time';

    if (widget.task.date != null && widget.task.date!.isNotEmpty) {
      try {
        DateTime date = DateTime.parse(widget.task.date!);
        formattedDate = DateFormat('MMM d, yyyy').format(date);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    if (widget.task.time != null && widget.task.time!.isNotEmpty) {
      try {
        final parsedTime = DateFormat('HH:mm').parse(widget.task.time!);
        formattedTime = DateFormat('h:mm a').format(parsedTime);
      } catch (e) {
        print('Error parsing time: $e');
      }
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return EditTaskSheet(
              task: widget.task,
              index: widget.index,
            );
          },
        );
        print('======${widget.task.time}=========');
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: colors[widget.index % colors.length],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.1),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
        child: ListTile(
          leading: GestureDetector(
            onTap: () async {
              setState(() {
                widget.task.isDone = widget.task.isDone == 0 ? 1 : 0;
              });

              await sqldb.updateData(
                "UPDATE tasks SET isDone = ? WHERE id = ?",
                [widget.task.isDone, widget.task.id],
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey,
                  width: 1.5,
                ),
              ),
              child: Icon(
                widget.task.isDone == 0 ? Icons.check : Icons.check_circle,
                color: widget.task.isDone == 1
                    ? const Color(0xff258745)
                    : Colors.grey,
              ),
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.task.content ?? 'No Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      decoration: widget.task.isDone == 1
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.task.priority ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.task.title ?? 'No title',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    decoration: widget.task.isDone == 1
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Color(0xffFFADAD),
                      ),
                    ),
                    Text(
                      formattedTime,
                      style: const TextStyle(
                        color: Color(0xffFFADAD),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EditTaskSheet extends StatefulWidget {
  final TasksModel task;
  final int index;

  const EditTaskSheet({
    required this.task,
    required this.index,
  });

  @override
  _EditTaskSheetState createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends State<EditTaskSheet> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? priority;
  final Sqldb sqldb = Sqldb();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    contentController = TextEditingController(text: widget.task.content);
    selectedDate =
        widget.task.date != null ? DateTime.parse(widget.task.date!) : null;
    selectedTime = widget.task.time != null
        ? TimeOfDay.fromDateTime(DateFormat("HH:mm").parse(widget.task.time!))
        : null;
    priority = widget.task.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                    child: Text(selectedDate != null
                        ? DateFormat('MMM d, yyyy').format(selectedDate!)
                        : 'Select Date'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: selectedTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Text(selectedTime != null
                        ? selectedTime!.format(context)
                        : 'Select Time'),
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: priority,
              items: ['Low', 'Medium', 'High'].map((String priority) {
                return DropdownMenuItem<String>(
                  value: priority,
                  child: Text(priority),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  priority = newValue;
                });
              },
              decoration: const InputDecoration(labelText: 'Priority'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                widget.task.title = titleController.text;
                widget.task.content = contentController.text;
                widget.task.date = selectedDate?.toIso8601String();
                widget.task.time = selectedTime != null
                    ? "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}"
                    : null;
                widget.task.priority = priority;

                // Update task in the database using parameterized query
                await sqldb.updateData(
                  "UPDATE tasks SET task = ?, content = ?, date = ?, time = ?, priority = ? WHERE id = ?",
                  [
                    widget.task.title,
                    widget.task.content,
                    widget.task.date,
                    widget.task.time,
                    widget.task.priority,
                    widget.task.id,
                  ],
                );

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
