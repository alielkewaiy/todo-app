import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app1/modules/archive_tasks/archive.dart';
import 'package:todo_app1/modules/done_tasks/done.dart';
import 'package:todo_app1/modules/new_tasks/new.dart';
import 'package:todo_app1/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialAppStates());
  static AppCubit get(context) => BlocProvider.of(context);
  late Database database;
  bool isBottomSheet = false;
  IconData buttonIcon = Icons.edit;
  int currentIndex = 0;
  List screens = [NewTasks(), DoneTasks(), ArchivedTasks()];
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];
  List<String> screensTitles = ['New Tasks ', 'Done Tasks', 'Archive Tasks'];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarState());
  }

  void changeBottomSheet({required bool isShow, required IconData icon}) {
    isBottomSheet = isShow;
    buttonIcon = icon;
    emit(ChangeBottomSheetState());
  }

  void createDatabase() {
    openDatabase('todo1.db', version: 1, onCreate: (database, version) {
      print('database created ');
      database
          .execute(
              'CREATE TABLE tasks  (id INTEGER PRIMARY KEY,title TEXT,time TEXT ,date TEXT,status TEXT) ')
          .then((value) {
        print('table created');
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      print('database open');
    }).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  void insertToDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('new raw inserted');
        emit(InsertDatabaseState());
        getDataFromDatabase(database);
      });
      return Future.value(true);
    });
  }

  void getDataFromDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      print(newTasks);
      print('done tasks$doneTasks');
      print('archived tasks $newTasks');
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({required String status, required int id}) async {
    database.rawUpdate(
        'UPDATE tasks SET status=? WHERE id=?', ['$status', id]).then((value) {
      emit(AppUpdateDatabaseState());
      getDataFromDatabase(database);
    });
  }

  void deleteData({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }
}
