import 'package:flutter/material.dart';
import 'package:todo/shared/colors/color.dart';
import 'package:todo/shared/cubit/todo_cubit.dart';
class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key, 
    this.taskId,
    this.taskTitle, 
    this.taskDate, 
    this.taskTime,
    this.taskStatus,
    });  
  final int? taskId;
  final String? taskTitle;
  final String? taskDate;
  final String? taskTime;
  final String? taskStatus;


  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(taskId.toString()),
      onDismissed: (direction) => AppCubit.get(context).deleteData(id: taskId!),
      
      background: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Icon(Icons.delete, color: Colors.white, size: 30),
        ),
      ),
      secondaryBackground: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.red,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(Icons.delete, color: Colors.white, size: 30),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(68, 238, 238, 238),
            ),
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blue,
                  child: Text('${taskTime}',  style: TextStyle(color: adjustColorLightness(staticBaseColor, darkMode),), textAlign: TextAlign.center,),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    
                    children: [
                      Flexible(
                        child: Text('$taskTitle',  
                        style: TextStyle(color: adjustColorLightness(staticBaseColor, darkMode), 
                          fontWeight: FontWeight.bold, 
                          fontSize: 17
                          ),
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1, 
                        softWrap: false,),
                        ),
                     
                      Flexible(
                        child: Text('$taskDate',  
                        style: TextStyle(color: adjustColorLightness(staticBaseColor, lightMode),),
                        overflow: TextOverflow.ellipsis, 
                        maxLines: 1, 
                        softWrap: false,),
                        ),
                     
                    ],
                  ),
                ),
      
                IconButton(
                  onPressed: (){           
                    taskStatus == 'done' ? AppCubit.get(context).updateData(status: 'new', id: taskId!) :       
                    AppCubit.get(context).updateData(status: 'done', id: taskId!);
                    
                  }, 
                  icon: taskStatus == 'done' ? Icon(Icons.radio_button_checked) : Icon(Icons.radio_button_unchecked),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: (){
                    taskStatus == 'archive' ? AppCubit.get(context).updateData(status: 'new', id: taskId!) :
                    AppCubit.get(context).updateData(status: 'archive', id: taskId!);
                    
                  }, 
                  icon: taskStatus == 'archive' ? Icon(Icons.unarchive) : Icon(Icons.archive),
                  color: Colors.blue,
                ),
      
                
              ],
            ),
        ),
      ),
    );
  }
}