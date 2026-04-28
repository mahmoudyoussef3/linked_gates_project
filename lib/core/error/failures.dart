abstract class Failure implements Exception {
  const Failure(this.message);

  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}
