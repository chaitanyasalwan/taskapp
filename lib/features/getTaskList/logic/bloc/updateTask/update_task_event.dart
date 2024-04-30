part of 'update_task_bloc.dart';

abstract class UpdateTaskEvent extends Equatable {
 final String? id;
 final TaskListRequestModel? model;
  const UpdateTaskEvent({this.id, this.model});
  @override
  List<Object> get props => [id!,model!];
}
class UpdateEvent extends UpdateTaskEvent {
  const UpdateEvent(String id, TaskListRequestModel model) : super(id: id, model: model);
}
