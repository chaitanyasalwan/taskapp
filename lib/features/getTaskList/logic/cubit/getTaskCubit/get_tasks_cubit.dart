import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';
import 'package:taskapp/features/getTaskList/data/repository/get_all_tasks_repo.dart';
part 'get_tasks_state.dart';

class GetTasksCubit extends Cubit<GetTasksState> {
  final GetTasksListRepo _getTasksListRepo;
  GetTasksCubit(this._getTasksListRepo) : super(GetTasksLoading()) {
    fetchTaskList();
  }
  void fetchTaskList() async {
    try {
    
      List<TaskListResponseModel> taskList =
          await _getTasksListRepo.getTaskList();
   
      emit(GetTasksSuccess(taskList));
      // emit(GetTasksInitial());
    } on DioException catch (e) {
      emit(GetTasksError(e));
    }
  }

  
}
