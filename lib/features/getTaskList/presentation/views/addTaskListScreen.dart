import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_request_model.dart';
import 'package:taskapp/features/getTaskList/logic/bloc/addTask/add_task_bloc_bloc.dart';
import 'package:taskapp/features/getTaskList/presentation/views/taskListScreen.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
  static const String routeName = "addtask";
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AddTaskBlocBloc saveTaskBloc = BlocProvider.of<AddTaskBlocBloc>(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Navigator.pushReplacementNamed(
          context,
          TaskListPage.routeName,
        );

        // your function / logic / dialog
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Task'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Text('Due Date: '),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _dueDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _dueDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        '${_dueDate.year}-${_dueDate.month}-${_dueDate.day}',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                BlocConsumer<AddTaskBlocBloc, AddTaskBlocState>(
                  listener: (context, state) {
                    if (state is AddTaskSuccess) {
                    Navigator.pushReplacementNamed(
                        context,
                        TaskListPage.routeName,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AddTaskBlocLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            TaskListRequestModel model = TaskListRequestModel(
                                createdAt: DateTime.now().toString(),
                                dueDate: _dueDate.toString(),
                                taskDescription: _descriptionController.text,
                                taskStatus: false,
                                taskTitle: _titleController.text);
                            saveTaskBloc.add(AddTaskEvent(model));
                            // Go back to previous screen
                          }
                        },
                        child: Text('Save Task'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
