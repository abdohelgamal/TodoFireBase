import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todofirebase/controllers/firebase_bloc.dart';
import 'package:todofirebase/controllers/todo_bloc.dart';
import 'package:todofirebase/views/view_todo.dart';

class TasksList extends StatelessWidget {
  final Map todo;
  final int index;
  TasksList(this.todo, this.index);

  @override
  Widget build(BuildContext context) {
    var todoBloc = BlocProvider.of<TodoBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          isThreeLine: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TodoView(todo, index)));
          },
          tileColor: Colors.lightBlue.shade100,
          enabled: true,
          horizontalTitleGap: 30,
          title: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: Text(
              todo['taskname'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),
          ),
          subtitle: Text(
            todo['taskdescription'],
            softWrap: true,
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: 14, color: Colors.blue[800]),
          ),
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 90,
                child: Text(
                  todo['duedate'],
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.greenAccent[700],
                      fontWeight: FontWeight.w700),
                ),
              ),
              InkWell(
                  splashColor: Colors.red,
                  radius: 10,
                  onTap: () {
                    todoBloc.removeTodo(todo).then((value) =>
                        BlocProvider.of<FireBaseBloc>(context)
                            .updateTasks(todoBloc.todos));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Task removed successfully'),
                        duration: Duration(milliseconds: 850)));
                  },
                  child: const Icon(
                    Icons.remove,
                    color: Colors.red,
                    size: 30,
                  ))
            ],
          ),
          trailing: SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    todo['parenttask'],
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, color: Colors.blue[800]),
                  ),
                  Text(
                    todo['done'],
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, color: Colors.blue[800]),
                  ),
                ],
              ))),
    );
  }
}
