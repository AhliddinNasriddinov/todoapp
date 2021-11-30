import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/task.dart';
import 'package:todoapp/databasehelper.dart';

class AddTaskList extends StatefulWidget {

  final Function? updateTaskList;

  const AddTaskList({this.updateTaskList});

  @override
  _AddTaskListState createState() => _AddTaskListState();
}

class _AddTaskListState extends State<AddTaskList> {
  final _formkeys = GlobalKey<FormState>();
  String?  _title = '';
  DateTime _date = DateTime.now();
  String _priorty = 'Low';
  TextEditingController _dateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  final List<String> _priortes = ['Low', 'Medium', 'High'];

  headleDatePicer() async {
    final date = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    if (date != _date) {
      setState(() {
        _date = date as DateTime;
      });
      _dateController.text = _dateFormat.format(date!);
    }
  }

  sumbit () {

    if (_formkeys.currentState!.validate()){
      _formkeys.currentState!.save();

      Task task = Task(title: _title,date: _date,priorty: _priorty);
      DatabaseHelper.instance.insertTask(task);
      if (widget.updateTaskList != null) widget.updateTaskList!();
      Navigator.pop(context);
    }


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("salom"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            child: Column(
              children: [
                Form(
                  key: _formkeys,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        onSaved: (input) => _title = input,
                        validator: (input) => input!.trim().isEmpty ? 'Plase enter task title' : null,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                        ),
                        readOnly: true,
                        onTap: headleDatePicer,
                        controller: _dateController,
                      ),
                      DropdownButtonFormField(
                        icon: Icon(Icons.arrow_drop_down),
                        decoration: const InputDecoration(
                          labelText: 'Priorty',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _priorty = value as String;
                          });
                        },
                        items: _priortes.map((values) {
                          return DropdownMenuItem<dynamic>(
                            value: values,
                            child: Text(
                              values,
                              style: TextStyle(),
                            ),
                          );
                        }).toList(),
                        value: _priorty,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    sumbit();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
