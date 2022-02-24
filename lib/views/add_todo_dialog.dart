import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todofirebase/models/firebase_bloc.dart';
import 'package:todofirebase/models/todo_bloc.dart';

class AddTodoDialog extends StatefulWidget {
  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  String taskName = '';
  String taskDesc = '';
  DateTime? date;
  String? parentTask;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<TodoBloc>(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      alignment: Alignment.center,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text(
                  'Add New Task',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                TextField(
                  onChanged: (value) => taskName = value,
                  decoration: InputDecoration(
                      hintText: 'Task Name',
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 0.5),
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => taskDesc = value,
                  decoration: InputDecoration(
                      hintText: 'Task Description',
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 0.5),
                          borderRadius: BorderRadius.circular(10))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Parent Task'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: DropdownButton<String?>(
                          value: parentTask,
                          items: [
                            const DropdownMenuItem(
                              alignment: Alignment.centerLeft,
                              child: Text('No Parent Task'),
                              value: null,
                            ),
                            ...bloc.todos.map((todo) => DropdownMenuItem(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    todo['taskname'].length >= 20
                                        ? todo['taskname'].substring(0, 20)
                                        : todo['taskname'],
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  value: todo['taskname'],
                                ))
                          ],
                          onChanged: (String? parent) {
                            setState(() {
                              parentTask = parent;
                            });
                          }),
                    ),
                  ],
                ),
                if (date == null)
                  TextButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialEntryMode: DatePickerEntryMode.calendar,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 3650)))
                            .then((value) {
                          setState(() {
                            date = value;
                          });
                        });
                      },
                      child: const Text('Add Date'))
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Selected date is  : ' +
                          formatDate(date!, [yyyy, '-', mm, '-', dd])),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              date = null;
                            });
                          },
                          child: const Text('Remove Date'))
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          if (taskName.trim() == '' || taskDesc.trim() == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please Enter Task Name and Description'),
                                    duration: Duration(milliseconds: 850)));
                          } else {
                            bloc
                                .addNewTodo({
                                  'taskname': taskName.trim(),
                                  'taskdescription': taskDesc.trim(),
                                  'duedate': date == null
                                      ? 'No Date'
                                      : formatDate(
                                          date!, [yyyy, '-', mm, '-', dd]),
                                  'parenttask': parentTask == null
                                      ? 'No Parent Task'
                                      : parentTask!,
                                  'done': 'On Scheduele'
                                })
                                .whenComplete(() =>
                                    BlocProvider.of<FireBaseBloc>(context)
                                        .updateTasks(bloc.todos))
                                .whenComplete(() => Navigator.pop(context))
                                .whenComplete(() =>
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text('Task added successfully'),
                                            duration:
                                                Duration(milliseconds: 850))));
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Task')),
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        label: const Text('Cancel',
                            style: TextStyle(color: Colors.red))),
                  ],
                )
              ])),
    );
  }
}
