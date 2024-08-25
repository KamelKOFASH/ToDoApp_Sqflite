import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do_app/data/sqldb.dart';
import 'package:to_do_app/models/tasks_model.dart';
import 'package:to_do_app/screens/home/widget/task_widget.dart';
import 'package:to_do_app/utils/app_colors.dart';
import 'package:to_do_app/utils/app_str.dart';
import 'package:to_do_app/utils/constants.dart';

class BuildHomeBody extends StatefulWidget {
  const BuildHomeBody({
    super.key,
    required this.textTheme,
  });

  final TextTheme textTheme;

  @override
  State<BuildHomeBody> createState() => _BuildHomeBodyState();
}

class _BuildHomeBodyState extends State<BuildHomeBody> {
  String _selectedFilter = 'All Tasks';
  Sqldb sqldb = Sqldb();
  late Future<List<TasksModel>> tasksFuture;

  @override
  void initState() {
    super.initState();
    tasksFuture = _getAllTasks();
  }

  Future<List<TasksModel>> _getAllTasks() async {
    final List<Map<String, dynamic>> maps =
        await sqldb.readData('SELECT * FROM tasks');
    return List.generate(maps.length, (i) {
      return TasksModel.fromMap(maps[i]);
    });
  }

  Future<List<TasksModel>> _getPendingTasks() async {
    final List<Map<String, dynamic>> maps =
        await sqldb.readData('SELECT * FROM tasks WHERE isDone = 0');
    return List.generate(maps.length, (i) {
      return TasksModel.fromMap(maps[i]);
    });
  }

  Future<List<TasksModel>> _getCompletedTasks() async {
    final List<Map<String, dynamic>> maps =
        await sqldb.readData('SELECT * FROM tasks WHERE isDone = 1');
    return List.generate(maps.length, (i) {
      return TasksModel.fromMap(maps[i]);
    });
  }

  void _filterAllTasks(String filter) {
    setState(() {
      _selectedFilter = filter;
      tasksFuture = _getAllTasks();
    });
  }

  void _filterPendingTasks(String filter) {
    setState(() {
      _selectedFilter = filter;
      tasksFuture = _getPendingTasks();
    });
  }

  void _filterCompletedTasks(String filter) {
    setState(() {
      _selectedFilter = filter;
      tasksFuture = _getCompletedTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          // * Custom App Bar
          FutureBuilder<List<TasksModel>>(
            future: tasksFuture,
            builder: (BuildContext context, AsyncSnapshot<List<TasksModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primaryColor),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                final List<TasksModel> tasks = snapshot.data!;
                return Container(
                  width: double.infinity,
                  height: 100,
                  margin: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          value: checkDoneTask(tasks) / valueOfTheIndicator(tasks),
                          backgroundColor: Colors.grey,
                          valueColor: const AlwaysStoppedAnimation(
                            AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        children: [
                          const Text(
                            AppStr.mainTitle,
                            style: TextStyle(
                              fontSize: 50,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            AppStr.mainSubtitle,
                            style: widget.textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Container(); // Empty container if no data
              }
            },
          ),
          // * Divider
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Divider(
              thickness: 2,
              indent: 100,
            ),
          ),
          // * Filter Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => setState(() {
                  _filterAllTasks('All Tasks');
                }),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: _selectedFilter == 'All Tasks'
                      ? AppColors.primaryColor
                      : Colors.white,
                ),
                child: Text(
                  'All',
                  style: TextStyle(
                    color: _selectedFilter == 'All Tasks'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _filterPendingTasks('Pending Tasks'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: _selectedFilter == 'Pending Tasks'
                      ? AppColors.primaryColor
                      : Colors.white,
                ),
                child: Text(
                  'Pending',
                  style: TextStyle(
                    color: _selectedFilter == 'Pending Tasks'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _filterCompletedTasks('Completed Tasks'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: _selectedFilter == 'Completed Tasks'
                      ? AppColors.primaryColor
                      : Colors.white,
                ),
                child: Text(
                  'Completed',
                  style: TextStyle(
                    color: _selectedFilter == 'Completed Tasks'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          // * Todo List
          Expanded(
            child: FutureBuilder<List<TasksModel>>(
              future: tasksFuture,
              builder: (BuildContext context,
                  AsyncSnapshot<List<TasksModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final List<TasksModel> tasks = snapshot.data!;
                  return ListView.builder(
                    itemCount: tasks.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(tasks[index].id.toString()),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) async {
                          await sqldb.deleteData(tasks[index].id!);
                        },
                        background: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delete_outline, color: Colors.grey),
                            Text(
                              AppStr.deleteTask,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        child: TaskWidget(index: index, task: tasks[index]),
                      );
                    },
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeIn(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(
                            lottieUrl,
                            animate: true,
                          ),
                        ),
                      ),
                      FadeInUp(
                        child: const Text(AppStr.doneAllTask),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int checkDoneTask(List<TasksModel> task) {
    int i = 0;
    for (TasksModel doneTasks in task) {
      if (doneTasks.isDone == 1) {
        i++;
      }
    }
    return i;
  }

  dynamic valueOfTheIndicator(List<TasksModel> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3; // Default value to avoid division by zero
    }
  }
}
