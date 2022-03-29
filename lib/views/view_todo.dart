import 'package:flutter/material.dart';
import 'package:todofirebase/controllers/functions.dart';
import 'package:todofirebase/controllers/firebase_bloc.dart';
import 'package:todofirebase/controllers/todo_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_format/date_format.dart';

class TodoView extends StatefulWidget {
  TodoView(this.todo, this.index);
  Map todo;
  int index;
  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  bool editingMode = false;
  late String name;
  late String description;
  late String parentTask;
  late String date;
  late TextEditingController newName;
  late TextEditingController newDescription;
  late String newDate;
  late String newParent;
  late String done;
  TextStyle txtStyle =
      const TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
  TextStyle txtSpanStyle = const TextStyle(
      fontSize: 20, color: Colors.redAccent, fontWeight: FontWeight.w400);
  late TodoBloc todoBloc;
  @override
  void initState() {
    todoBloc = BlocProvider.of<TodoBloc>(context);
    newName = TextEditingController(text: widget.todo['taskname']);
    newDescription =
        TextEditingController(text: widget.todo['taskdescription']);
    description = widget.todo['taskdescription'];
    done = widget.todo['done'];
    name = widget.todo['taskname'];
    date = widget.todo['duedate'];
    newDate = date;

    parentTask = widget.todo['parenttask'];
    newParent = parentTask;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              done = 'Done';
              todoBloc.markTodoAsDone(widget.index).then((value) =>
                  BlocProvider.of<FireBaseBloc>(context)
                      .updateTasks(todoBloc.todos));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('The task has been marked as done'),
                duration: Duration(milliseconds: 850),
              ));
            });
          },
          label: const Text('Mark as done')),
      appBar: AppBar(
        actions: (editingMode == false)
            ? ([
                IconButton(
                    color: Colors.blueAccent[700],
                    onPressed: () {
                      setState(() {
                        editingMode = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('you can start editing the task now'),
                          duration: Duration(milliseconds: 850)));
                    },
                    icon: const Icon(Icons.edit))
              ])
            : ([
                IconButton(
                    iconSize: 30,
                    color: Colors.blueAccent[700],
                    onPressed: () {
                      setState(() {
                        editingMode = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Editing canceled'),
                          duration: Duration(milliseconds: 850)));
                    },
                    icon: const Icon(Icons.close)),
                IconButton(
                    icon: const Icon(Icons.check),
                    iconSize: 30,
                    color: Colors.blueAccent[700],
                    onPressed: () {
                      if (validate(
                          newName.text.trim(), newDescription.text.trim())) {
                        todoBloc.editTodo({
                          'taskname': newName.text.trim(),
                          'taskdescription': newDescription.text.trim(),
                          'duedate': newDate,
                          'parenttask': newParent,
                          'done': done
                        }, widget.index).then((value) =>
                            BlocProvider.of<FireBaseBloc>(context)
                                .updateTasks(todoBloc.todos));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'The task has been edited successfully'),
                                duration: Duration(milliseconds: 850)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter all missing data'),
                                duration: Duration(milliseconds: 850)));
                      }
                    })
              ]),
        elevation: 0,
        foregroundColor: Colors.blue[600],
        title: Text(widget.todo['taskname'],
            style: const TextStyle(
              fontSize: 30,
            )),
        centerTitle: true,
        backgroundColor: Colors.blue[200],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 30,
          color: Colors.blueAccent[700],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: editingMode == false
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                                TextSpan(text: 'Task Name :   ', children: [
                                  TextSpan(text: name, style: txtSpanStyle)
                                ]),
                                style: txtStyle),
                            Text.rich(
                              TextSpan(
                                  text: 'Task Description :   ',
                                  children: [
                                    TextSpan(
                                        text: description, style: txtSpanStyle)
                                  ],
                                  style: txtStyle),
                            ),
                            Text.rich(
                              TextSpan(
                                  text: 'Task Due Date :   ',
                                  children: [
                                    TextSpan(text: date, style: txtSpanStyle)
                                  ],
                                  style: txtStyle),
                            ),
                            Text.rich(
                              TextSpan(
                                  text: 'Task Parent Task :   ',
                                  children: [
                                    TextSpan(
                                        text: parentTask, style: txtSpanStyle)
                                  ],
                                  style: txtStyle),
                            ),
                            Text(done, style: txtSpanStyle)
                          ]),
                    ],
                  )
                : Column(
                    children: [
                      TextField(
                        controller: newName,
                        decoration:
                            const InputDecoration(helperText: 'Enter new name'),
                      ),
                      TextField(
                        controller: newDescription,
                        decoration: const InputDecoration(
                            helperText: 'Enter new description'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Parent Task'),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: DropdownButton<String>(
                                value: newParent,
                                items: [
                                  const DropdownMenuItem(
                                    alignment: Alignment.centerLeft,
                                    child: Text('No Parent Task'),
                                    value: 'No Parent Task',
                                  ),
                                  ...todoBloc.todos.map((todo) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        todo['taskname'].length >= 20
                                            ? todo['taskname'].substring(0, 20)
                                            : todo['taskname'],
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      value: todo['taskname'],
                                    );
                                  }).toList()
                                    ..removeWhere(
                                        (element) => element.value == name)
                                ],
                                onChanged: (parent) {
                                  setState(() {
                                    newParent = parent!;
                                  });
                                }),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Selected date is  : ' + newDate),
                          TextButton(
                              onPressed: () {
                                if (newDate == 'No Date') {
                                  showDatePicker(
                                          context: context,
                                          initialEntryMode:
                                              DatePickerEntryMode.calendar,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now()
                                              .add(const Duration(days: 3650)))
                                      .then((value) {
                                    setState(() {
                                      if (value != null) {
                                        newDate = formatDate(value, [
                                          yyyy,
                                          '-',
                                          mm,
                                          '-',
                                          dd,
                                        ]);
                                      }
                                    });
                                  });
                                } else {
                                  setState(() {
                                    newDate = 'No Date';
                                  });
                                }
                              },
                              child: newDate == 'No Date'
                                  ? const Text('Add Date')
                                  : const Text('Remove Date'))
                        ],
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
