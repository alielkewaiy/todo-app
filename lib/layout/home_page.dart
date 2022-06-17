import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app1/shared/componenrs/components.dart';
import 'package:todo_app1/shared/cubit/cubit.dart';
import 'package:todo_app1/shared/cubit/states.dart';

class HomePage extends StatelessWidget {
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();
  GlobalKey<FormState> formKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          DateTime date = DateTime(2022, 12, 24);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.screensTitles[cubit.currentIndex]),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,

                statusBarIconBrightness:
                    Brightness.light, // For Android (dark icons)
              ),
            ),
            body: cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                    Navigator.pop(context);
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) => Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter The Title';
                                      }
                                      return null;
                                    },
                                    controller: titleController,
                                    labelText: 'Title',
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  defaultTextField(
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter The Time';
                                      }
                                      return null;
                                    },
                                    controller: timeController,
                                    labelText: 'Time',
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  defaultTextField(
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: date,
                                              firstDate: DateTime(2022),
                                              lastDate: DateTime(2030))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter The Date';
                                      }
                                      return null;
                                    },
                                    controller: dateController,
                                    labelText: 'Date',
                                  )
                                ],
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheet(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.buttonIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNavBar(index);
              },
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archive'),
              ],
            ),
          );
        },
      ),
    );
  }
}
