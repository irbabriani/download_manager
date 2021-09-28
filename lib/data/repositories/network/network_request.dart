import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:my_flutter_structure/data/error/exceptions.dart';
import 'package:my_flutter_structure/data/repositories/network/request_response.dart';

enum RequestType {
  post,
  get,
  put,
  delete,
}

class NetworkRequest {
  static const STATUS_OK = 200;
  static const STATUS_CREATED = 201;

  final Map<String, dynamic> _jsonHeaders = {
    "Content-type": "application/json",
  };

  final Dio dio;
  final RequestType type;
  final String address;
  final dynamic body;
  Map<String, dynamic> headers;
  final List<int> listBody;
  final String plainBody;

  NetworkRequest(this.type, this.address,
      {required this.dio,
      this.body,
      required this.plainBody,
      required this.listBody,
      required this.headers});

  Future<RequestResponse> getResult() async {
    Response response;
    headers ??= _jsonHeaders;
    try {
      switch (type) {
        case RequestType.post:
          response = await dio.post(
            address,
            options: Options(headers: headers),
            data: plainBody ?? body ?? listBody
          );
          break;
        case RequestType.get:
          response = await dio.get(address,
            options: Options(headers: headers),);
          break;
        case RequestType.put:
          response = await dio.put(address,
              data: body ?? plainBody ?? listBody,
            options: Options(headers: headers),);
          break;
        case RequestType.delete:
          response = await dio.delete(address,
            options: Options(headers: headers),);
          break;
      }

      if (response.statusCode != STATUS_OK) {
        throw HttpRequestException();
      }
      var res = jsonEncode(response.data);
      // print(res);
      return new RequestResponse(
          isDone: true, statusCode: response.statusCode, result: response.data);
    } catch (exception) {
      if (exception is HttpRequestException) {
        return RequestResponse(
            isDone: false,
            statusCode: response.statusCode,
            errorStatus: ErrorStatus.httpError,
            errorMessage:
                response.statusCode.toString() + " : " + response.data);
      } else {
        return RequestResponse(
            isDone: false,
            statusCode: -1,
            errorStatus: ErrorStatus.systemError,
            errorMessage: "System Error :" + exception.toString());
      }
    }
  }
}
