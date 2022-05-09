import 'package:dio/dio.dart';

class DioHelper {
  static Dio? _dio;

  static init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getData({
    String? lang = 'en',
    String? token,
    required String url,
    Map<String, dynamic>? query,
  }) async {
    _dio!.options.headers = {
      'Content-type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await _dio!.get(
      url,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    String? lang = 'en',
    String? token,
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    _dio!.options.headers = {
      'Content-type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await _dio!.post(
      url,
      data: data,
      queryParameters: query,
    );
  }

  static Future<Response> putData({
    String? lang = 'en',
    String? token,
    required String url,
    required dynamic data,
    Map<String, dynamic>? query,
  }) async {
    _dio!.options.headers = {
      'Content-type': 'application/json',
      'lang': lang,
      'Authorization': token,
    };
    return await _dio!.put(
      url,
      data: data,
      queryParameters: query,
    );
  }
}
