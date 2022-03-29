import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todofirebase/controllers/firebase_bloc.dart';
import 'package:todofirebase/controllers/todo_bloc.dart';
import 'package:todofirebase/views/components/select_parent_row.dart';

class AddTodoDialog extends StatefulWidget {
  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDesc = TextEditingController();
  DateTime? date;
  String? parentTask;
  void setParentTask(String? newVal)
  {parentTask = newVal;}

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
                ),SizedBox(height: 20,),
                TextField(
                controller:taskName ,
                  decoration: InputDecoration(
                      hintText: 'Task Name',
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 0.5),
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 20),
                TextField(
               controller: taskDesc,
                  decoration: InputDecoration(
                      hintText: 'Task Description',
                      border: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 0.5),
                          borderRadius: BorderRadius.circular(10))),
                ),
                SelectParentRow(bloc.todos, parentTask,setParentTask),
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
                          if (taskName.text.trim() == '' || taskDesc.text.trim() == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please Enter Task Name and Description'),
                                    duration: Duration(milliseconds: 850)));
                          } else {
                            bloc
                                .addNewTodo({
                                  'taskname': taskName.text.trim(),
                                  'taskdescription': taskDesc.text.trim(),
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
