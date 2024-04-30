import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class API {
  final Dio _dio = Dio();
  API() {
    _dio.options.baseUrl = "https://662fcfe743b6a7dce310d33b.mockapi.io/api/";
    _dio.options.validateStatus = (status) {
      return status! <= 500;
    };
        _dio.interceptors.add(PrettyDioLogger(
        requestBody: true,
        request: true,
        requestHeader: true,
        responseBody: true));
  }
  Dio get getdio {
    return _dio;
  }
}

class ApiResponse {
  dynamic data;

  ApiResponse({
    this.data,
  });
  factory ApiResponse.fromResponse(Response response) {
     final data = response.data as Map<String, dynamic>;
    return ApiResponse(
      data: data,
    );
  }
}
