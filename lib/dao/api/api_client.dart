part of main_class.dao.api;

typedef JsonDecoder<T> = T Function(Map<String, dynamic> json);
typedef JsonEncoder<T> = Map<String, dynamic> Function(T json);

typedef ErrorHandler = Future<dynamic> Function(DioException error);

class ApiClient {
  final String basePath;
  final Dio dio;
  final ErrorHandler? errorHandler;

  ApiClient({required this.basePath, required this.dio, this.errorHandler});

  factory ApiClient.withDefaultHeaders({
    required String basePath,
    required Map<String, String> Function() defaultHeaderesSupplier,
  }) {
    return ApiClient(
        basePath: basePath,
        dio: new Dio()
          ..interceptors
              .add(new InterceptorsWrapper(onRequest: (options, handler) {
            options.headers.addAll(defaultHeaderesSupplier());
            handler.next(options);
          })));
  }

  Future<O> get<O>(
    String path, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParams,
    JsonDecoder<O>? fromJson,
  }) async {
    try {
      Response resp = await dio.get(
        "$basePath$path",
        queryParameters: queryParams ?? {},
        options: Options(
          headers: headers ?? {},
        ),
      );

      return resp.data != null && fromJson != null
          ? fromJson(resp.data)
          : resp.data;
    } on DioException catch (error) {
      if (errorHandler != null) {
        await errorHandler!(error);
      }

      rethrow;
    }
  }

  Future<O> post<I, O>(
    String path, {
    I? body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    JsonDecoder<O>? fromJson,
    JsonEncoder<I>? toJson,
  }) async {
    try {
      Response resp = await dio.post(
        "$basePath$path",
        data: body != null && toJson != null ? toJson(body) : body,
        queryParameters: queryParams ?? {},
        options: Options(
          headers: headers ?? {},
        ),
      );

      return resp.data != null && fromJson != null
          ? fromJson(resp.data)
          : resp.data;
    } on DioException catch (error) {
      if (errorHandler != null) {
        await errorHandler!(error);
      }

      rethrow;
    }
  }

  Future<O> put<I, O>(
    String path, {
    I? body,
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    JsonDecoder<O>? fromJson,
    JsonEncoder<I>? toJson,
  }) async {
    try {
      Response resp = await dio.put(
        "$basePath$path",
        data: body != null && toJson != null ? toJson(body) : body,
        queryParameters: queryParams ?? {},
        options: Options(
          headers: headers ?? {},
        ),
      );

      return resp.data != null && fromJson != null
          ? fromJson(resp.data)
          : resp.data;
    } on DioException catch (error) {
      if (errorHandler != null) {
        await errorHandler!(error);
      }

      rethrow;
    }
  }

  Future<O> delete<O>(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    JsonDecoder<O>? fromJson,
  }) async {
    try {
      Response resp = await dio.delete(
        "$basePath$path",
        queryParameters: queryParams ?? {},
        options: Options(
          headers: headers ?? {},
        ),
      );

      return resp.data != null && fromJson != null
          ? fromJson(resp.data)
          : resp.data;
    } on DioException catch (error) {
      if (errorHandler != null) {
        await errorHandler!(error);
      }

      rethrow;
    }
  }
}
