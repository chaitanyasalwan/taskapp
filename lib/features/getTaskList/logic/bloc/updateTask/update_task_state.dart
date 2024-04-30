part of 'update_task_bloc.dart';

abstract class UpdateTaskState extends Equatable {
   final TaskListResponseModel? task;
  final DioException? error;
  const UpdateTaskState({this.error,this.task});
  
  @override
  List<Object> get props => [task!, error!];
}


class UpdateTaskInitial extends UpdateTaskState {
  UpdateTaskInitial();
}

class UpdateTaskLoading extends UpdateTaskState {
  UpdateTaskLoading();
}

class UpdateTaskSuccess extends UpdateTaskState {
  const UpdateTaskSuccess(TaskListResponseModel task) : super(task: task);
}

class UpdateTaskError extends UpdateTaskState {
  const UpdateTaskError(DioException error) : super(error: error);
}
