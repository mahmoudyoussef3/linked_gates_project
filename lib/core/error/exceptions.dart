import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;

  const AppException(this.message);

  factory AppException.fromDio(DioException e) {
    return AppException(
      e.response?.data?['message'] ??
      e.message ??
      'Something went wrong',
    );
  }


}