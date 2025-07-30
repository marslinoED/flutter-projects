import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do/shared/models/navigator_bar_model.dart';
import 'package:to_do/widgets/tasks_archived_screen.dart';
import 'package:to_do/widgets/tasks_done_screen.dart';
import 'package:to_do/widgets/tasks_new_screen.dart';
import 'todo_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';


class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentScreen = 0;
  List<NavigatorBarModel> screens = [
    NavigatorBarModel(
      label: 'Tasks',
      screen: NewTasksScreen(),
    ),
    NavigatorBarModel(
      label: 'Done',
      screen: TasksDoneScreen(),
    ),
    NavigatorBarModel(
      label: 'Archived',
      screen: TasksArchivedScreen(),
    ),
  ];

  void changeIndex(int index){
    currentScreen = index;
    emit(AppChangeBottomNavBarState());
  }

  
  Database? database;
  String path = "todo.db";
  List<Map> tasks = [];



  void createDatabase() async {
    var databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'todo.db');

    openDatabase(
      dbPath,
      version: 1,
      onCreate: (database, version) {
        print("DB Created");
        database.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)',
        ).then((value) {
          print("Table Created");
        }).catchError((error) {
          print("Error: Creating Table - $error");
        });
      },
      onOpen: (database) {
        getDataFromDatabase(database).then((value) {
          tasks = value;
          print(tasks);
          emit(AppGetDatabaseState());
        });
        print("DB Opened");
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    required String title, 
    required String date, 
    required String time }) async
  {
    await database?.transaction((txn)
      {
        txn.rawInsert(
          'INSERT INTO tasks (title, date, time, status) VALUES(?, ?, ?, ?)', 
          [title, date, time, 'new'] // تمرير القيم كمصفوفة
        ).then((value){
          emit(AppInsertDatabaseState());
          print('Inserted $value succsfully');

          getDataFromDatabase(database).then((value){
            tasks = value;
            print(tasks);
            emit(AppGetDatabaseState());
          });

        }).catchError((error){
          print("Error: Inserting, $error");
        });
        return Future.value();
      }
    );
  }

  void updateData(
    {
      required String status,
      required int id,
    }
    ) async
    {
      database?.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        [status, id],
        ).then((value)
        {
          getDataFromDatabase(database).then((value){
            tasks = value;
            print(tasks);
            emit(AppGetDatabaseState());
          });
          emit(AppUpdateDatabaseState());
        });
    }

  void deleteData(
    {
      required int id,
    }
    ) async
    {
      database?.rawUpdate(
        'DELETE FROM tasks WHERE id = ?',
        [id],
        ).then((value)
        {
          getDataFromDatabase(database).then((value){
            tasks = value;
            print(tasks);
            emit(AppGetDatabaseState());
          });
          emit(AppDeleteDatabaseState());
        });
    }


  Future<List<Map>> getDataFromDatabase(database) async
  {
    return await database!.rawQuery('SELECT * FROM tasks');

  }




  Icon floatingButtonIcon = Icon(Icons.add);
  bool bottomSheetIsOpen = false;

  void changeFloatingSheetState({
    required bool ishow,
    required Icon icon,
  })
  {
    bottomSheetIsOpen = ishow;
    floatingButtonIcon = icon;
    emit(AppChangeFloatingSheetState());
  }
  

}