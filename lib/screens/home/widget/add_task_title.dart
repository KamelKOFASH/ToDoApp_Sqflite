import 'package:flutter/material.dart';

class AddTaskTitle extends StatelessWidget {
  const AddTaskTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 30,
              child: Divider(
                thickness: 2,
              ),
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Add New ',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextSpan(
                  text: 'Task',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ]),
            ),
            const SizedBox(
              width: 30,
              child: Divider(
                thickness: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
