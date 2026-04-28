import 'package:dio/dio.dart';

import '../utils/constants.dart';

class DioClient {
  DioClient()
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConstants.baseUrl,
          connectTimeout: AppConstants.connectTimeout,
          receiveTimeout: AppConstants.receiveTimeout,
          responseType: ResponseType.json,
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  final Dio _dio;

  Dio get dio => _dio;
}
