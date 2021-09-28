enum ErrorStatus { systemError, httpError }

class RequestResponse<T> {
  bool isDone;
  int statusCode;
  ErrorStatus errorStatus;
  T result;
  String errorMessage;
  Exception exception;
  RequestResponse(
      {this.isDone,
        this.statusCode,
        this.errorStatus,
        this.result,
        this.errorMessage});
}