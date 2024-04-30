import 'package:taskapp/core/api/api_settings.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';

class GetTasksListRepo {
  final _api = API();
  GetTasksListRepo();
  Future<List<TaskListResponseModel>> getTaskList() async {
    try {
      final response = await _api.getdio.get('/getTasklist');
      // ApiResponse apiResponse = ApiResponse.fromResponse(response);
      List<dynamic> taskList = response.data;
      return taskList.map((e) => TaskListResponseModel.fromJson(e)).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<TaskListResponseModel> getTaskListbyid(String id) async {
    try {
      final response = await _api.getdio.get('/getTasklist/$id');
      ApiResponse apiResponse = ApiResponse.fromResponse(response);

      return TaskListResponseModel.fromJson(apiResponse.data);
    } catch (e) {
      throw e;
    }
  }
}
