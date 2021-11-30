import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:todoapp/add_task_screen.dart';
import 'package:todoapp/databasehelper.dart';
import 'package:todoapp/task.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late Future<List<Task>> _taskList;
  final DateFormat _dateFormater = DateFormat('MMM dd, yyyy');

  Widget _builderItem(Task task) {
    return Container(
      child: ListTile(
        // selected: true,
        title: Text(task.title!),
        subtitle: Text(_dateFormater.format(task.date)),
        trailing: Checkbox(
          value: task.status == 0 ? false : true,
          onChanged: (bool? value) {

            if (value != null) task.status = value ? 1 : 0;
            DatabaseHelper.instance.updateTask(task);

            setState(() {});

          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    updateTaskList();
  }

  updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My App"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      AddTaskList(
                        updateTaskList: updateTaskList,
                      )
              )
          );

        },
      ),
      body: FutureBuilder(
        future: _taskList,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return _builderItem(snapshot.data[index]);
                });
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
