import 'package:flutter_bloc/flutter_bloc.dart';

class TodoBloc extends Cubit<List<Map<String, dynamic>>> {
  TodoBloc() : super(List.empty());

  List<Map<String, dynamic>> todos = [];

  void insertTodos(List<Map<String, dynamic>> list) {
    todos = list;
    emit(todos);
  }

  void getTasksFromFireBase(List<Map<String, dynamic>> newTasks) {
    todos = newTasks;
    emit(todos);
  }

  Future<void> addNewTodo(Map<String, dynamic> todo) async {
    todos = List.from(todos);
    todos.add(todo);
    emit(todos);
  }

  Future<void> editTodo(Map<String, dynamic> todo, int index) async {
    todos = List.from(todos);
    todos[index] = todo;
    emit(todos);
  }

  Future<void> markTodoAsDone(int index) async {
    todos = List.from(todos);
    todos[index]['done'] = 'Done';
    emit(todos);
  }

  Future<void> removeTodo(Map todo) async {
    todos = List.from(todos);
    todos.remove(todo);
    emit(todos);
  }

  void deleteAllTasks() {
    todos = List.empty();
    emit(todos);
  }
}
