import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:taskapp/core/utils/colors.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_request_model.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';
import 'package:taskapp/features/getTaskList/data/repository/get_all_tasks_repo.dart';
import 'package:taskapp/features/getTaskList/logic/bloc/deleteTask/delete_tasks_bloc.dart';
import 'package:taskapp/features/getTaskList/logic/bloc/updateTask/update_task_bloc.dart';
import 'package:taskapp/features/getTaskList/logic/cubit/getTaskCubit/get_tasks_cubit.dart';
import 'package:taskapp/features/getTaskList/logic/provider/task_filter_provider.dart';
import 'package:taskapp/features/getTaskList/presentation/views/addTaskListScreen.dart';
import 'package:taskapp/features/getTaskList/presentation/views/editTasksScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskapp/features/getTaskList/presentation/widgets/loading.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});
  static const String routeName = "tasklist";

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late List<bool> checkboxStates;
  int? index;

  @override
  void initState() {
    checkboxStates = [];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeleteTasksBloc deleteTasksBloc = BlocProvider.of<DeleteTasksBloc>(context);

    UpdateTaskBloc updatebloc = BlocProvider.of<UpdateTaskBloc>(context);
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: AppBar(
        backgroundColor: tdBGColor,
        title: Text(
          'Task List',
          style: GoogleFonts.ptSans(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          _buildFilterButton(context),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(
            context,
            AddTaskScreen.routeName,
          );
        },
        child: Fab(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _openCustomDateSelector(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    child: Row(
                      children: [
                        Icon(Icons.sort),
                        Text('Custom Date'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Consumer<TaskFilterProvider>(
              builder: (context, provider, _) {
                if (provider.selectedDate != null) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tasks for ${provider.selectedDate!.day}/${provider.selectedDate!.month}/${provider.selectedDate!.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            Expanded(
              child: BlocConsumer<GetTasksCubit, GetTasksState>(
                listener: (context, state) {
                  if (state is GetTasksSuccess) {
                    var task = state.taskList!.length;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$task Tasks Fetched'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else if (state is GetTasksError) {
                    var error = state.error!.message;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error Occured $error'),
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is GetTasksSuccess) {
                    final taskList = Provider.of<TaskFilterProvider>(context)
                        .applyFilter(state.taskList!);
                    return _buildTaskList(
                        taskList, deleteTasksBloc, updatebloc);
                  } else if (state is GetTasksLoading) {
                    return Center(
                        child: SpinKitCubeGrid(
                      color: MyColors.primaryColor,
                      size: 60,
                    ));
                  } else if (state is GetTasksError) {
                    return Center(child: Text(state.error!.message!));
                  }

                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCustomDateSelector(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      Provider.of<TaskFilterProvider>(context, listen: false)
          .setSelectedDate(selectedDate);
    }
  }

  Widget _buildFilterButton(BuildContext context) {
    return PopupMenuButton<TaskFilter>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: TaskFilter.all,
          child: Text('All'),
        ),
        PopupMenuItem(
          value: TaskFilter.today,
          child: Text('Today'),
        ),
        PopupMenuItem(
          value: TaskFilter.thisMonth,
          child: Text('This Month'),
        ),
        PopupMenuItem(
          value: TaskFilter.completed,
          child: Text('Completed'),
        ),
      ],
      onSelected: (filter) {
        Provider.of<TaskFilterProvider>(context, listen: false)
            .setFilter(filter);
        // Apply filter logic here
      },
      icon: Icon(Icons.filter_list),
    );
  }

  Widget _buildTaskList(List<TaskListResponseModel>? taskList,
      DeleteTasksBloc bloc, UpdateTaskBloc updatebloc) {
    if (taskList!.isNotEmpty) {
      if (checkboxStates.isEmpty) {
        checkboxStates = List.filled(taskList.length ?? 0, false);
        for (int i = 0; i < taskList.length; i++) {
          checkboxStates[i] = taskList[i].taskStatus ?? false;
        }
      }

      return AnimationLimiter(
        child: ListView.separated(
            itemBuilder: (context, index) {
              var task = taskList[index];
        
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 1000),
                child: SlideAnimation(
                  verticalOffset: 80,
                  child: FadeInAnimation(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, EditTaskScreen.routeName,
                              arguments: task);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        tileColor: Colors.white,
                        leading: BlocConsumer<UpdateTaskBloc, UpdateTaskState>(
                          listener: (context, state) {
                            if (state is UpdateTaskSuccess && mounted) {
                              final updatedTask = state.task;
                              final updatedTaskId = updatedTask!.id;
                              // Find the index of the task with the updated ID
                              final taskIndex = taskList
                                  .indexWhere((task) => task.id == updatedTaskId);
                              if (taskIndex != -1) {
                                // Update checkbox state only for the matching task
                                setState(() {
                                  checkboxStates[taskIndex] =
                                      updatedTask.taskStatus ?? false;
                                });
                              }
                            
                              Navigator.of(context, rootNavigator: true).pop();
                            } else if (state is UpdateTaskError) {
                              Navigator.of(context, rootNavigator: true).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (state is UpdateTaskLoading) {
                                showLoadingDialog(context);
                            }
                          },
                          builder: (context, state) {
                            return Checkbox(
                              activeColor: MyColors.primaryColor,
                              value: checkboxStates[index],
                              onChanged: (value) {
                                TaskListRequestModel model = TaskListRequestModel(
                                    createdAt: task.createdAt,
                                    dueDate: task.dueDate,
                                    taskDescription: task.taskDescription,
                                    taskStatus: value,
                                    taskTitle: task.taskTitle);
                                updatebloc.add(UpdateEvent(task.id!, model));
                                // Handle checkbox change here
                              },
                            );
                          },
                        ),
                        title: Text(task.taskTitle!,style: TextStyle(overflow: TextOverflow.ellipsis,),maxLines: 1,),
                        subtitle: Text(task.taskDescription!,style: TextStyle(overflow: TextOverflow.ellipsis,),maxLines: 1,),
                        trailing: BlocConsumer<DeleteTasksBloc, DeleteTasksState>(
                          listener: (context, state) {
                            if (state is DeleteTasksSuccess) {
                              
                              final deletedTaskId = state.task!.id;
                              setState(() {
                                taskList
                                    .removeWhere((task) => task.id == deletedTaskId);
                              });
                          
                              Navigator.of(context, rootNavigator: true).pop();
                            } else if (state is DeleteTasksLoading) {
                              showLoadingDialog(context);
                            } else {
                              Navigator.of(context, rootNavigator: true).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failiure'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () {
                                bloc.add(DeleteEvent(task.id!));
                              },
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 10,
              );
            },
            itemCount: taskList.length),
      );
    } else {
      return Center(
        child: Column(
          children: [
            Lottie.asset(
              'assets/lottie/noth.json', // Replace 'animation.json' with the path to your Lottie animation file
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
            Text(
              'Add Tasks',
              style:
                  GoogleFonts.ptSans(fontSize: 20, fontWeight: FontWeight.w600),
            )
          ],
        ),
      );
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Make the dialog transparent
          elevation: 0, // Remove the shadow
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white, // Add a background color if needed
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SpinKitFadingCube(
                    color: Colors.blue, // Customize the color of the spinner
                    size: 50.0, // Customize the size of the spinner
                  ),
                  SizedBox(height: 20.0),
                  Text('Loading...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class Fab extends StatelessWidget {
  const Fab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
        borderRadius: BorderRadius.circular(15),
        elevation: 20,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
              color: MyColors.primaryColor,
              borderRadius: BorderRadius.circular(15)),
          child: Center(
              child: Icon(
            Icons.add,
            color: Colors.white,
          )),
        ));
  }
}
