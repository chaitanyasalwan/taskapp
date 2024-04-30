import 'dart:convert';

import 'package:taskapp/core/api/api_settings.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_request_model.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';

class EditTaskRepo {
  final _api = API();
  EditTaskRepo();
  Future<TaskListResponseModel> editTask(TaskListRequestModel model, String id) async {
    try {
      final response = await _api.getdio
          .put('/getTasklist/$id', data: jsonEncode(model.toJson()));
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      return TaskListResponseModel.fromJson(apiResponse.data);
    } catch (e) {
      throw e;
    }
  }
}
