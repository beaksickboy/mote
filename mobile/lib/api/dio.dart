import 'package:dio/dio.dart';

class DioProvider {
  Dio dio;

  DioProvider() {
    BaseOptions _options = BaseOptions(
      baseUrl: "https://jsonplaceholder.typicode.com/",
    );
    dio = Dio(_options);

    dio.interceptors.add(CustomInterceptor());
  }
}

class CustomInterceptor extends Interceptor {
  @override
  Future onResponse(Response response) {
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    return super.onError(err);
  }

  @override
  Future onRequest(RequestOptions options) {
    options.headers = {"Authorization": "Token"};
    return super.onRequest(options);
  }
}

// dioBase.
