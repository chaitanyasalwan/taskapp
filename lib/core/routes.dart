import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';
import 'package:taskapp/features/getTaskList/data/repository/delete_task_repo.dart';
import 'package:taskapp/features/getTaskList/data/repository/edit_task_repo.dart';
import 'package:taskapp/features/getTaskList/data/repository/get_all_tasks_repo.dart';
import 'package:taskapp/features/getTaskList/data/repository/save_task_repo.dart';
import 'package:taskapp/features/getTaskList/logic/bloc/addTask/add_task_bloc_bloc.dart';
import 'package:taskapp/features/getTaskList/logic/bloc/deleteTask/delete_tasks_bloc.dart';
import 'package:taskapp/features/getTaskList/logic/bloc/updateTask/update_task_bloc.dart';
import 'package:taskapp/features/getTaskList/logic/cubit/getTaskCubit/get_tasks_cubit.dart';
import 'package:taskapp/features/getTaskList/presentation/views/addTaskListScreen.dart';
import 'package:taskapp/features/getTaskList/presentation/views/editTasksScreen.dart';
import 'package:taskapp/features/getTaskList/presentation/views/taskListScreen.dart';

class Routes {
  static Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case TaskListPage.routeName:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
          providers: [ 
              BlocProvider(
                create: (context) => DeleteTasksBloc(DeleteTaskRepo()),
              ),
               BlocProvider(
                create: (context) => UpdateTaskBloc(EditTaskRepo()),
              ),
               BlocProvider(
                create: (context) => GetTasksCubit(GetTasksListRepo()),
              ),
            ],
            child: TaskListPage(),
          ),
        );
      case AddTaskScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AddTaskBlocBloc(SaveTaskRepo()),
            child: AddTaskScreen(),
          ),
        );
      case EditTaskScreen.routeName:
         TaskListResponseModel arguments = settings.arguments as TaskListResponseModel;
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
       providers: [
              BlocProvider(
                create: (context) => DeleteTasksBloc(DeleteTaskRepo()),
              ),
               BlocProvider(
                create: (context) => UpdateTaskBloc(EditTaskRepo()),
              ),
            
            ],
            child: EditTaskScreen(model: arguments,),
          ),
        );
    }
  }
}
