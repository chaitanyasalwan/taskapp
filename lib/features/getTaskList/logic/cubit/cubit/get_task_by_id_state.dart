part of 'get_task_by_id_cubit.dart';

sealed class GetTaskByIdState extends Equatable {
  const GetTaskByIdState({ this.error, this.task});
  final TaskListResponseModel? task;
  final DioException? error;
  @override
  List<Object> get props => [];
}

final class GetTaskByIdInitial extends GetTaskByIdState {}


class GetTasksError extends GetTaskByIdState {
  const GetTasksError(DioException error) : super(error: error);
}

class GetTasksIdSuccess extends GetTaskByIdState {
  const GetTasksIdSuccess(TaskListResponseModel task) : super(task: task);
}


class GetTasksLoading extends GetTaskByIdState {
  const GetTasksLoading();
}
