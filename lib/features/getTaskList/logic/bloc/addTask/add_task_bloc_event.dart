part of 'add_task_bloc_bloc.dart';

abstract class AddTaskBlocEvent extends Equatable {
  final TaskListRequestModel? model;
  const AddTaskBlocEvent({this.model});
  @override
  List<Object> get props => [model!];
}

class AddTaskEvent extends AddTaskBlocEvent {
  const AddTaskEvent(TaskListRequestModel model) : super(model: model);
}
