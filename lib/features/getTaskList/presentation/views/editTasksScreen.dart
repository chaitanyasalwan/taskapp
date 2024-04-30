import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Import intl package for date formatting
import 'package:taskapp/features/getTaskList/data/models/task_list_request_model.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';
import 'package:taskapp/features/getTaskList/data/repository/get_all_tasks_repo.dart';
import 'package:taskapp/features/getTaskList/logic/bloc/deleteTask/delete_tasks_bloc.dart';
import 'package:taskapp/features/getTaskList/logic/bloc/updateTask/update_task_bloc.dart';
import 'package:taskapp/features/getTaskList/logic/cubit/cubit/get_task_by_id_cubit.dart';

import 'package:taskapp/features/getTaskList/presentation/views/taskListScreen.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskListResponseModel model;
  EditTaskScreen({required this.model});
  static const String routeName = "edittask";
  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late String _title;
  late String _description;
  late DateTime _dueDate;
  bool _isChecked = false;
  final GetTaskByIdCubit getTasksCubit = GetTaskByIdCubit(GetTasksListRepo());
  @override
  void initState() {
    super.initState();
    getTasksCubit.fetchTaskListByid(widget.model.id!);
  }

  @override
  void dispose() {
    getTasksCubit.close();
    super.dispose();
  }

  void _selectDueDate() async {
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
  }

  @override
  Widget build(BuildContext context) {
    DeleteTasksBloc deleteTasksBloc = BlocProvider.of<DeleteTasksBloc>(context);

    UpdateTaskBloc updatebloc = BlocProvider.of<UpdateTaskBloc>(context);
    return BlocProvider(
      create: (context) => getTasksCubit,
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          Navigator.pushReplacementNamed(
            context,
            TaskListPage.routeName,
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Edit Task'),
          ),
          body: BlocConsumer<GetTaskByIdCubit, GetTaskByIdState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is GetTasksIdSuccess) {
                _title = state.task!.taskTitle!;
                _description = state.task!.taskDescription!;
                _dueDate = DateTime.tryParse(state.task!.dueDate!)!;
                _isChecked = state.task!.taskStatus!;
              }
            },
            builder: (context, state) {
              if (state is GetTasksIdSuccess) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        initialValue: _title,
                        decoration: InputDecoration(labelText: 'Title'),
                        onChanged: (value) => _title = value,
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        initialValue: _description,
                        decoration: InputDecoration(labelText: 'Description'),
                        onChanged: (value) => _description = value,
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Text('Due Date: '),
                          TextButton(
                            onPressed: _selectDueDate,
                            child:
                                Text(DateFormat('yyyy-MM-dd').format(_dueDate)),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      BlocConsumer<UpdateTaskBloc, UpdateTaskState>(
                        listener: (context, state) {
                          if (state is UpdateTaskSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Updated'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (state is UpdateTaskError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Updated'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is UpdateTaskLoading) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Center(
                            child: ElevatedButton(
                              onPressed: () {
                                TaskListRequestModel model =
                                    TaskListRequestModel(
                                        createdAt: widget.model.createdAt!,
                                        dueDate: _dueDate.toString(),
                                        taskDescription: _description,
                                        taskStatus: _isChecked,
                                        taskTitle: _title);
                                updatebloc
                                    .add(UpdateEvent(widget.model.id!, model));
                              },
                              child: Text('Save Changes'),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 16.0),
                      BlocConsumer<DeleteTasksBloc, DeleteTasksState>(
                        listener: (context, state) {
                          if (state is DeleteTasksSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Deleted'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacementNamed(
                              context,
                              TaskListPage.routeName,
                            );
                          } else if (state is DeleteTasksError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error'),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.red,
                              ),
                            );
                            Navigator.pushReplacementNamed(
                              context,
                              TaskListPage.routeName,
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is DeleteTasksLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Center(
                            child: ElevatedButton(
                              onPressed: () {
                                deleteTasksBloc
                                    .add(DeleteEvent(widget.model.id!));
                              },
                              child: Text('Delete Task'),
                            ),
                          );
                        },
                      ),
                      Center(
                        child: Column(
                          children: [
                            Checkbox(
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                              value: _isChecked,
                            ),
                            Text('Status')
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
