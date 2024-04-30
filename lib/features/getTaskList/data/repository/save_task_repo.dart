import 'dart:convert';

import 'package:taskapp/core/api/api_settings.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_request_model.dart';
import 'package:taskapp/features/getTaskList/data/models/task_list_response_model.dart';

class SaveTaskRepo {
  final _api = API();
  SaveTaskRepo();
  Future<TaskListResponseModel> saveTask(TaskListRequestModel model) async {
    try {
      final response = await _api.getdio
          .post('/getTasklist', data: jsonEncode(model.toJson()));
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      return TaskListResponseModel.fromJson(apiResponse.data);
    } catch (e) {
      throw e;
    }
  }
}
