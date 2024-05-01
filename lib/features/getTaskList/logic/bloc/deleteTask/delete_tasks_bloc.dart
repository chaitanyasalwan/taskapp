import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';
import 'package:taskapp/features/getTaskList/data/repository/delete_task_repo.dart';


part 'delete_tasks_event.dart';
part 'delete_tasks_state.dart';

class DeleteTasksBloc extends Bloc<DeleteTasksEvent, DeleteTasksState> {
  final DeleteTaskRepo _deleteTaskRepo;
  
  DeleteTasksBloc(this._deleteTaskRepo, )
      : super(DeleteTasksInitial()) {
    on<DeleteTasksEvent>((event, emit) async {
      emit(DeleteTasksLoading());
      try {
        TaskListResponseModel model =
            await _deleteTaskRepo.deleteTask(event.id!);
        emit(DeleteTasksSuccess(model));
        
      } on DioException catch (e) {
        emit(DeleteTasksError(e));
      }
    });
  }
 
}
