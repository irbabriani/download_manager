enum ErrorStatus { systemError, httpError }

class RequestResponse<T> {
  bool isDone=false;
  int? statusCode;
  ErrorStatus? errorStatus;
  T result;
  String errorMessage;
  late Exception exception;
  RequestResponse(
      {required this.isDone,
        required this.statusCode,
        required this.errorStatus,
        required this.result,
        required this.errorMessage});
}