import 'package:sqflite/sqflite.dart';
import 'package:todofirebase/models/todo_model.dart';

class Dbcontroller {
  Dbcontroller(){
    createDataBase();
  }
  late Database database;
  String tableName = 'TestData';
  createDataBase() async {
    String databasesPath = await getDatabasesPath();
    databasesPath = databasesPath + '/mydatabase.db';
    await openDatabase(databasesPath, version: 1).then((data) {
      database = data;
      database.transaction((txn) async {
        return await txn.execute(
            '''CREATE TABLE IF NOT EXISTS $tableName (id integer primary key autoincrement, taskname text, description text, duedate text , parenttask text , done text)''');
      });
    });
  }

  void insertMultipleRecords(List<Map<String, dynamic>> list) {
    Batch batch = database.batch();
    list.forEach((element) {
      batch.insert(tableName, element);
    });
    batch.commit();
  }

  Future<void> deleteAllRecords() async {
    await database.delete(tableName);
  }

  Future<void> insertIntoDataBase(Todo todo) async {
    await database.insert(tableName, todo.toJson());
  }

  Future<void> editTodoRecord(Todo todo) async {
    await database.update(tableName, todo.toJson(), where: 'id = ${todo.id}');
  }

  Future<void> markRecordAsDone(int id) async {
    await database.update(tableName, {'done': 'done'}, where: 'id = $id');
  }

  Future<void> removeFromDataBase(int id) async {
    await database.delete(tableName, where: 'id = $id');
  }

  Future<List<Map<String, Object?>>> getData() async {
    return await database.query(tableName);
  }
}
