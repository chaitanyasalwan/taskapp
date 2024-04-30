part of 'get_tasks_cubit.dart';

abstract class GetTasksState extends Equatable {
  final List<TaskListResponseModel>? taskList;
  final TaskListResponseModel? task;
  final DioException? error;
  const GetTasksState({this.taskList, this.error, this.task});
  @override
  List<Object> get props => [taskList!, error!];
}

class GetTasksInitial extends GetTasksState {
  const GetTasksInitial();
}

class GetTasksLoading extends GetTasksState {
  const GetTasksLoading();
}

class GetTasksSuccess extends GetTasksState {
  const GetTasksSuccess(List<TaskListResponseModel> tasksList)
      : super(taskList: tasksList);
}

class GetTasksIdSuccess extends GetTasksState {
  const GetTasksIdSuccess(TaskListResponseModel task) : super(task: task);
}

class GetTasksError extends GetTasksState {
  const GetTasksError(DioException error) : super(error: error);
}
