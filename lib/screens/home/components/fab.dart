import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/screens/home/task_view.dart';
import 'package:to_do_app/utils/app_colors.dart';

class Fab extends StatelessWidget {
  Fab({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => const TaskView()));
      },
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      // ignore: prefer_const_constructors
      child: const Center(
          child: Icon(
        Icons.add,
        color: Colors.white,
      )),
    );
  }
}
