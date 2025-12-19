import '../error/exceptions.dart';
import '../error/failures.dart';

Failure handleException(Exception exception) {
  if (exception is ServerException) {
    return ServerFailure(exception.message);
  } else if (exception is CacheException) {
    return CacheFailure(exception.message);
  } else if (exception is NetworkException) {
    return NetworkFailure(exception.message);
  } else if (exception is AuthException) {
    return AuthFailure(exception.message);
  } else {
    return ServerFailure('An unexpected error occurred: ${exception.toString()}');
  }
}

String getErrorMessage(Failure failure) {
  return failure.message;
}


