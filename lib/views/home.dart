import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todofirebase/controllers/firebase_bloc.dart';
import 'package:todofirebase/controllers/todo_bloc.dart';
import 'package:todofirebase/views/add_todo_dialog.dart';
import 'package:todofirebase/views/initial_interface.dart';
import 'package:todofirebase/views/components/tasks_listview.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TodoBloc todoBloc;
  @override
  void initState() {
    todoBloc = BlocProvider.of<TodoBloc>(context);
    BlocProvider.of<FireBaseBloc>(context).getTasks().then((value) {
      print(value.data());
      if (value.data()!['tasks'] != []) {
        for (Map<String, dynamic> task in value.data()!['tasks']) {
          todoBloc.addNewTodo(task);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  BlocProvider.of<FireBaseBloc>(context)
                      .logout()
                      .whenComplete(() => todoBloc.deleteAllTasks())
                      .whenComplete(() => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InitialPage())));
                },
                icon: const Icon(Icons.logout))
          ],
          foregroundColor: Colors.blue[600],
          title: const Text('Todo App',
              style: TextStyle(
                fontSize: 30,
              )),
          centerTitle: true,
          backgroundColor: Colors.blue[200],
          elevation: 0,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[300],
          isExtended: true,
          splashColor: Colors.grey,
          child: Icon(
            Icons.add,
            color: Colors.lightBlue[700],
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AddTodoDialog();
                });
          },
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: BlocConsumer<TodoBloc, List<Map<String, dynamic>>>(
            listener: (BuildContext context, state) {},
            builder: (context, state) {
              return Column(children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: ListView.builder(padding: const EdgeInsets.symmetric(vertical: 40),
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          todoBloc.todos.isEmpty ? 1 : todoBloc.todos.length,
                      itemBuilder: (context, index) => todoBloc.todos.isEmpty
                          ? const Center(
                              child: Text(
                                'No To-Do Tasks Has Been Added Yet',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700),
                              ),
                            )
                          : TasksList(todoBloc.todos[index], index)),
                ),
              ]);
            },
          ),
        )));
  }
}
