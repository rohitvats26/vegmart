import 'package:dio/dio.dart';
import 'package:vegmart/core/constants/app_constants.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  Future<Response> post(String path, dynamic data) async {
    return _dio.post(path, data: data);
  }
}