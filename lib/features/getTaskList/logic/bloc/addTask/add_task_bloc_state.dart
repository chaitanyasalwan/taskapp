part of 'add_task_bloc_bloc.dart';


abstract class AddTaskBlocState extends Equatable {
  final TaskListResponseModel? task;
  final DioException? error;
  const AddTaskBlocState({this.error,this.task});
  
  @override
  List<Object> get props => [task!, error!];
}
class AddTaskBlocInitial extends AddTaskBlocState {
  AddTaskBlocInitial();
}
class AddTaskBlocLoading extends AddTaskBlocState {
  AddTaskBlocLoading();
}
 class AddTaskSuccess extends AddTaskBlocState{
  const AddTaskSuccess(TaskListResponseModel task):super(task: task);
 }

 class AddTaskError extends AddTaskBlocState{
  const AddTaskError(DioException error):super(error: error);
 }


