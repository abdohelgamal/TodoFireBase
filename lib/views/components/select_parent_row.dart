import 'package:flutter/material.dart';

class SelectParentRow extends StatefulWidget {
  SelectParentRow(this.items, this.parentTask, this.parentSetter, {Key? key})
      : super(key: key);
  List items;
  String? parentTask;
  void Function(String?) parentSetter;
  @override
  State<SelectParentRow> createState() => _SelectParentRowState();
}

class _SelectParentRowState extends State<SelectParentRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Parent Task'),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.45,
          child: DropdownButton<String?>(
              value: widget.parentTask,
              items: [
                const DropdownMenuItem(
                  alignment: Alignment.centerLeft,
                  value: null,
                  child: Text('No Parent Task'),
                ),
                ...widget.items.map((todo) => DropdownMenuItem(
                      alignment: Alignment.centerLeft,
                      value: todo['taskname'],
                      child: Text(
                        todo['taskname'].length >= 20
                            ? todo['taskname'].substring(0, 20)
                            : todo['taskname'],
                        overflow: TextOverflow.fade,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ))
              ],
              onChanged: (String? parent) {
                setState(() {
                  widget.parentTask = parent;
                  widget.parentSetter(parent);
                });
              }),
        ),
      ],
    );
  }
}
