import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app1/shared/componenrs/components.dart';
import 'package:todo_app1/shared/cubit/cubit.dart';
import 'package:todo_app1/shared/cubit/states.dart';

class DoneTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, states) {},
      builder: (context, states) {
        var tasks = AppCubit.get(context).doneTasks;
        return ConditionalBuilder(
            condition: tasks.isNotEmpty,
            builder: (context) => ListView.separated(
                itemBuilder: (context, index) =>
                    tasksBuildItem(tasks[index], context),
                separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: Colors.grey,
                      width: double.infinity,
                    ),
                itemCount: tasks.length),
            fallback: (context) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Text(
                        "No Tasks Yet, Please Add Some Tasks ",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ));
      },
    );
  }
}
