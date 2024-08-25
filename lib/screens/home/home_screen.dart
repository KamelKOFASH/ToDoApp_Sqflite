import 'package:flutter/material.dart';
import 'package:to_do_app/data/sqldb.dart';
import 'package:to_do_app/screens/home/components/fab.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:to_do_app/screens/home/components/custom_drawer.dart';
import 'package:to_do_app/screens/home/components/home_body.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:to_do_app/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  Sqldb sqflite = Sqldb();
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: Fab(),
      body: SliderDrawer(
        // * Slider App Bar
        appBar: SliderAppBar(
          title: const Text(''),
          drawerIconColor: Colors.black,
          trailing: IconButton(
            iconSize: 30,
            icon: const Icon(
              Icons.delete_forever_outlined,
              color: Colors.black,
            ),
            onPressed: () async {
              final result = await PanaraConfirmDialog.show(
                context,
                title: "Delete Confirmation",
                message: "Are you sure you want to delete all tasks?",
                confirmButtonText: "Yes",
                cancelButtonText: "No",
                onTapCancel: () {
                  Navigator.of(context)
                      .pop(false); // ! Return false if canceled
                },
                onTapConfirm: () {
                  Navigator.of(context).pop(true); // ? Return true if confirmed
                },
                panaraDialogType: PanaraDialogType.custom,
                color: AppColors.primaryColor,
              );

              if (result == true) {
                // ? Perform delete operation
                sqflite.deleteAll();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ));
              }
            },
          ),
        ),
        // * Slider Drawer
        slider: CustomDrawer(),
        // * Main Body
        child: BuildHomeBody(
          textTheme: textTheme,
        ),
      ),
    );
  }
}
