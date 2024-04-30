import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';
import 'package:taskapp/features/getTaskList/data/repository/get_all_tasks_repo.dart';

part 'get_task_by_id_state.dart';

class GetTaskByIdCubit extends Cubit<GetTaskByIdState> {
   final GetTasksListRepo _getTasksListRepo;
  GetTaskByIdCubit(this._getTasksListRepo) : super(GetTaskByIdInitial()) {}

   void fetchTaskListByid(String id) async {
    try {
      TaskListResponseModel taskList =
          await _getTasksListRepo.getTaskListbyid(id);
      
      emit(GetTasksIdSuccess(taskList));
      // emit(GetTasksInitial());
    } on DioException catch (e) {
      emit(GetTasksError(e));
    }
  }
}
