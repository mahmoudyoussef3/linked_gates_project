import 'package:dio/dio.dart';

class ServerException implements Exception {
  const ServerException(this.message);

  final String message;

  factory ServerException.fromDio(DioException error) {
    final statusCode = error.response?.statusCode;
    final statusMessage = error.response?.statusMessage;
    final message =
        statusMessage ?? error.message ?? 'Unexpected error occurred';
    if (statusCode != null) {
      return ServerException('Request failed ($statusCode): $message');
    }
    return ServerException(message);
  }
}
