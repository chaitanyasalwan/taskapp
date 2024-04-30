part of 'delete_tasks_bloc.dart';

abstract class DeleteTasksEvent extends Equatable {
  final String? id;
  const DeleteTasksEvent({this.id});
  @override
  List<Object> get props => [id!];
}


class DeleteEvent extends DeleteTasksEvent {
  const DeleteEvent(String id) : super(id: id);
}
