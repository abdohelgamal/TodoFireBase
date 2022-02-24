class Todo {
  String taskName;
  String taskDescription;
  String dueDate;
  String parentTask;
  bool done;
  int id;
  Todo(
      {required this.id,
      required this.taskName,
      required this.taskDescription,
      required this.dueDate,
      required this.parentTask,
      this.done = false});
  Map<String, String> toJson() {
    return {
      'duedate': dueDate,
      'taskname': taskName,
      'description': taskDescription,
      'parenttask': parentTask,
      'done': done ? 'done' : 'On Schedule'
    };
  }
}
