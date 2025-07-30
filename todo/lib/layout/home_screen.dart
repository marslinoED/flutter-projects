import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/cubit/todo_cubit.dart';
import 'package:todo/shared/cubit/todo_states.dart';
import 'package:todo/shared/colors/color.dart';


// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDateController = TextEditingController();
  TextEditingController taskTimeController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    print("HOT RELOADED");
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          
          AppCubit cubit = AppCubit.get(context);

          return  Scaffold(
            key: scaffoldKey,
            backgroundColor: adjustColorLightness(staticBaseColor, darkMode - 0.05),
            appBar: _buildAppBar(),
            body: _buildBody(cubit),
            bottomNavigationBar: _buildBottomNavigationBar(cubit),
            floatingActionButton: _buildFloatingActionButton(cubit),
          
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: adjustColorLightness(staticBaseColor, darkMode - 0.1),
      elevation: 1,
      shadowColor:  staticBaseColor,
      toolbarHeight: 50,
      title: Text('Home Screen', style: TextStyle(color: staticBaseColor,),),
    );
  }

  Widget _buildBody(cubit) {
    return cubit.screens[cubit.currentScreen].screen;
  }

  BottomNavigationBar _buildBottomNavigationBar(cubit){
    return BottomNavigationBar(
      backgroundColor: adjustColorLightness(staticBaseColor, darkMode - 0.1),
      fixedColor: staticSecondColor,
      unselectedItemColor: staticBaseColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: 'Tasks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.done),
          label: 'Done',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.archive),
          label: 'Archived',
        ),
      ],
      currentIndex: cubit.currentScreen,
      onTap: (index){
        cubit.changeIndex(index);
      },
    );
  }

  FloatingActionButton _buildFloatingActionButton(cubit){
    return FloatingActionButton(
      backgroundColor: staticSecondColor,
      child: cubit.floatingButtonIcon,
      shape: CircleBorder(),
      elevation: 20,
      foregroundColor: adjustColorLightness(staticBaseColor, darkMode - 0.05),
      onPressed: () {
      if (cubit.bottomSheetIsOpen) {
        if (formKey.currentState!.validate()) { // التحقق من المدخلات
          cubit.insertToDatabase(
            title: taskTitleController.text,
            date: taskDateController.text,
            time: taskTimeController.text,
          );
            taskTitleController.clear();
            taskDateController.clear();
            taskTimeController.clear();
          
             
        }
      } else {
        scaffoldKey.currentState?.showBottomSheet((context) {
          return _buildBottomSheet(context);
        }).closed.then((value) {
          cubit.changeFloatingSheetState(
            ishow: false,
            icon: Icon(Icons.add),
          );
        });
            cubit.changeFloatingSheetState(
            ishow: true,
            icon: Icon(Icons.save),
          );
      }
    },

    );
  }

  Widget _buildBottomSheet(context){
    return Form(
      key: formKey,
      child: Container(
        decoration: BoxDecoration(
          color: adjustColorLightness(staticBaseColor, darkMode - 0.1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              cursorColor: staticBaseColor,
              controller: taskTitleController,
              style: TextStyle(color: staticBaseColor),
              decoration: InputDecoration(
      
                labelText: 'Task Title',
                labelStyle: TextStyle(color: staticSecondColor),
                prefixIcon: Icon(Icons.title, color: staticSecondColor,),
      
                enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: staticSecondColor),
                ),
      
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: staticBaseColor),
                  borderRadius: BorderRadius.circular(10),
                ),
      
              ),
              validator: (value) { 
                  if (value == null || value.isEmpty) {
                    return 'Task Title must not be empty';
                  }
                  return null;
                },
              
            ),
            
            SizedBox(height: 20,),

            TextFormField(
              cursorColor: staticBaseColor,
              controller: taskDateController,
              readOnly: true,
              onTap: (){
                showDatePicker(
                  context: context, 
                  initialDate: DateTime.now(), 
                  firstDate: DateTime(2000), 
                  lastDate: DateTime(2100),
                ).then((value) {
                  taskDateController.text = DateFormat('yyyy-MM-dd').format(value!).toString();
                  });

              },
              style: TextStyle(color: staticBaseColor),
              decoration: InputDecoration(
      
                labelText: 'Task Date',
                labelStyle: TextStyle(color: staticSecondColor),
                prefixIcon: Icon(Icons.date_range, color: staticSecondColor,),
      
                enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: staticSecondColor),
                ),
      
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: staticBaseColor),
                  borderRadius: BorderRadius.circular(10),
                ),
      
              ),
              validator: (value) { 
                  if (value == null || value.isEmpty) {
                    return 'Task Date must not be empty';
                  }
                  return null;
                },
              
            ),

            SizedBox(height: 20,),

            TextFormField(
              cursorColor: staticBaseColor,
              controller: taskTimeController,
              readOnly: true,
              onTap: (){
                showTimePicker(
                  context: context, 
                  initialTime: TimeOfDay.now(),
                ).then((value) {
                  if (value != null) {
                    taskTimeController.text = value.format(context).toString();
                    
                  }
                });

              },
              style: TextStyle(color: staticBaseColor),
              decoration: InputDecoration(
      
                labelText: 'Task Time',
                labelStyle: TextStyle(color: staticSecondColor),
                prefixIcon: Icon(Icons.hourglass_bottom, color: staticSecondColor,),
      
                enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: staticSecondColor),
                ),
      
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: staticBaseColor),
                  borderRadius: BorderRadius.circular(10),
                ),
      
              ),
              validator: (value) { 
                  if (value == null || value.isEmpty) {
                    return 'Task Time must not be empty';
                  }
                  return null;
                },
              
            ),

          ],
        ),
      ),
    );
  }

}

