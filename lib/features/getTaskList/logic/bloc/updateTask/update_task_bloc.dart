import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_request_model.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';
import 'package:taskapp/features/getTaskList/data/repository/edit_task_repo.dart';


part 'update_task_event.dart';
part 'update_task_state.dart';

class UpdateTaskBloc extends Bloc<UpdateTaskEvent, UpdateTaskState> {

  final EditTaskRepo _editTaskRepo;
  UpdateTaskBloc(this._editTaskRepo) : super(UpdateTaskInitial()) {
    on<UpdateTaskEvent>((event, emit) async {
      emit(UpdateTaskLoading());
      try {
        TaskListResponseModel model =
            await _editTaskRepo.editTask(event.model!, event.id!);
        emit(UpdateTaskSuccess(model));
      } on DioException catch (e) {
        emit(UpdateTaskError(e));
      }
    });
  }
}
