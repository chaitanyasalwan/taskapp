import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_request_model.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';
import 'package:taskapp/features/getTaskList/data/repository/save_task_repo.dart';

part 'add_task_bloc_event.dart';
part 'add_task_bloc_state.dart';

class AddTaskBlocBloc extends Bloc<AddTaskBlocEvent, AddTaskBlocState> {
  final SaveTaskRepo _saveTaskRepo;
  AddTaskBlocBloc(this._saveTaskRepo) : super(AddTaskBlocInitial()) {
    on<AddTaskEvent>((event, emit) async {
      emit(AddTaskBlocLoading());
      try {
        TaskListResponseModel model =
            await _saveTaskRepo.saveTask(event.model!);
        emit(AddTaskSuccess(model));
      } on DioException catch (e) {
        emit(AddTaskError(e));
      }
    });
  }
}
