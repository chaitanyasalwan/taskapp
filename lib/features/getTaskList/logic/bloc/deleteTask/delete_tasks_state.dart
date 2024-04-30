part of 'delete_tasks_bloc.dart';

abstract class DeleteTasksState extends Equatable {
   final TaskListResponseModel? task;
  final DioException? error;
  const DeleteTasksState({this.error,this.task});
  
  @override
  List<Object> get props => [task!, error!];
}



class DeleteTasksInitial extends DeleteTasksState {
  DeleteTasksInitial();
}

class DeleteTasksLoading extends DeleteTasksState {
  DeleteTasksLoading();
}

class DeleteTasksSuccess extends DeleteTasksState {
  const DeleteTasksSuccess(TaskListResponseModel task) : super(task: task);
}

class DeleteTasksError extends DeleteTasksState {
  const DeleteTasksError(DioException error) : super(error: error);
}
