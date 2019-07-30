import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../app.dart';
import '../config.dart';
import '../util/log_util.dart';

class ApiResponse<T> {
  int code;
  T data;
  String message;

  ApiResponse(this.code, this.data, this.message);

  ApiResponse.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        message = json['message'],
        data = json['data'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> result = new Map();
    result['code'] = this.code;
    result['message'] = this.message;
    result['data'] = this.data;
    return result;
  }

  @override
  String toString() {
    return 'code: $code ,message: $message,data:$data';
  }
}

/**
 * http请求封装类
 */
class HttpUtil {
  /// 标识是否用native方式请求
  static final bool _isNative = true;

  static final ContentType _FORM =
      ContentType.parse("application/x-www-form-urlencoded");

  static final String _AUTHORIZATION = "Authorization";

  static final String _PATH = "auth/oauth/token";
  static final String _INIT_TOKEN = "Basic cWlhbm1vOnFpYW5tbw==";

  static final int _TIMEOUT_CONNECT = 30 * 1000;
  static final int _TIMEOUT_RECEIVE = 60 * 1000;

  static final String GET = "get";
  static final String POST = "post";

  static HttpUtil _httpUtil;

  /// 网络请求dart实现
  Dio _dio;

  /// 网络请求平台实现
  MethodChannel _methodChannel;

  static HttpUtil get instance {
    return _getInstance();
  }

  static HttpUtil _getInstance() {
    if (_httpUtil == null) {
      _httpUtil = new HttpUtil();
    }
    return _httpUtil;
  }

  HttpUtil() {
    if (!_isNative) {
      _dio = new Dio(_initOpions());
      _dio.interceptors.add(new TokenInterceptor());
      _dio.interceptors.add(new LogInterceptor());
    } else {
      _methodChannel = new MethodChannel('NativeHttpRequest');
    }
  }

  BaseOptions _initOpions() {
    return new BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: _TIMEOUT_CONNECT,
      receiveTimeout: _TIMEOUT_RECEIVE,
    );
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic> queryParameters,
  }) async {
    return _request(
      path,
      method: GET,
      queryParameters: queryParameters,
    );
  }

  Future<T> post<T>(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
  }) async {
    return _request(
      path,
      method: POST,
      data: data,
      queryParameters: queryParameters,
    );
  }

  Future<T> _request<T>(
    String path, {
    String method,
    data,
    Map<String, dynamic> queryParameters,
  }) async {
    method = method ?? GET;
    Options options = new Options(
        method: method,
        contentType: method == GET ? _FORM : ContentType.json,
        responseType: ResponseType.plain);

    if (!_isNative) {
      Response response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      LogUtil.i("------http result: $response");
      if (response.statusCode == 200) {
        ApiResponse<T> apiResponse =
            ApiResponse.fromJson(json.decode(response.data));
        if (apiResponse.code == 0) {
          return apiResponse.data;
        } else {
          throw ResultException(apiResponse.message);
        }
      } else {
        throw RequestException(response.statusCode, response.statusMessage);
      }
    } else {
      Map<String, dynamic> arg = new Map();
      arg["path"] = path;
      arg["method"] = method;
      if (queryParameters != null) {
        arg["queryParameters"] = queryParameters;
      }
      if (data != null) {
        arg["data"] = data;
      }
      String result =
          await _methodChannel.invokeMethod<String>("doHttpRequest", arg);
      LogUtil.i("----native--http result: $result");
      ApiResponse<T> apiResponse = ApiResponse.fromJson(json.decode(result));
      return apiResponse.data;
    }
  }
}

/*
 TokenInterceptor 拦截请求，添加token
 */
class TokenInterceptor extends InterceptorsWrapper {
  @override
  onRequest(RequestOptions options) {
    if (options.uri.toString().contains(HttpUtil._PATH)) {
      Map<String, dynamic> newHeaders = options.headers ?? new Map();
      newHeaders[HttpUtil._AUTHORIZATION] = HttpUtil._INIT_TOKEN;
      options.headers = newHeaders;
      return super.onRequest(options);
    }
    Map<String, dynamic> newHeaders = options.headers ?? new Map();
    newHeaders[HttpUtil._AUTHORIZATION] = AppInfoHelper.instance.getAppToken();
    options.headers = newHeaders;
    return super.onRequest(options);
  }
}

/// 请求异常 exception
class RequestException implements Exception {
  final int code;
  final String message;

  RequestException(this.code, this.message);

  @override
  String toString() {
    return 'RequestException{code: $code, message: $message}';
  }
}

/// 请求结果异常 exception
class ResultException implements Exception {
  final String message;

  ResultException(this.message);

  @override
  String toString() {
    return 'ResultException{message: $message}';
  }
}

/// 请求结果异常 exception
class NetworkErrorHelper {
  static String getMessage(Exception e) {
    if (e == null) return "";
    if (e is DioError) {
      if (e.type == DioErrorType.DEFAULT) {
        if (e.error is SocketException) {
          return "网络异常，请检查网络后重新尝试";
        }
      }
      Response response = e.response;
      if (response == null) {
        return e.toString();
      }
      return processCode(response.statusCode);
    } else if (e is RequestException) {
      return processCode(e.code);
    } else if (e is ResultException) {
      return e.message;
    } else if (e is FormatException) {
      return "数据解析异常";
    } else {
      return "未知异常";
    }
  }

  static String processCode(int code) {
    if (code == 504) {
      return "请求超时，请检查网络后重新尝试";
    } else if (code == 401) {
//        notificationExitApp();
      return "登录失效，请退出应用重新登录";
    } else {
      return "错误码：$code";
    }
  }
}
