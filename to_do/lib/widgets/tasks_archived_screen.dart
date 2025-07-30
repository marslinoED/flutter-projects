import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/shared/colors/color.dart';
import 'package:to_do/shared/cubit/todo_cubit.dart';
import 'package:to_do/shared/cubit/todo_states.dart';
import 'package:to_do/shared/widgets/task_widget.dart';
class TasksArchivedScreen extends StatelessWidget {
  const TasksArchivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,state) {},

      builder: (context, state)
      {
        var tasks = AppCubit.get(context).tasks;
        int newTasksCount = tasks.where((task) => task['status'] == "archive").length;
        return newTasksCount == 0 ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu, size: 100, color: adjustColorLightness(staticSecondColor, lightMode - 0.1),),
              Text('No Archived Tasks', style: TextStyle(color: adjustColorLightness(staticSecondColor, lightMode - 0.1), fontSize: 20),),
            ],
          ),
        ) : 
        ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return tasks[index]['status'] == 'archive' ? TaskWidget(
            taskId: tasks[index]['id'],
            taskTitle: tasks[index]['title'],
            taskDate: tasks[index]['date'],
            taskTime: tasks[index]['time'],
            taskStatus: tasks[index]['status'],
          ) : SizedBox();
        }
        );
      }, 

      );
    }
}