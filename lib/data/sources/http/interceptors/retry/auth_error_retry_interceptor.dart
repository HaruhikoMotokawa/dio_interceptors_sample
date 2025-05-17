import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/_fake_error/fake_error_interceptor.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/retry/retry_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_error_retry_interceptor.g.dart';

@Riverpod(keepAlive: true)
AuthErrorRetryInterceptor authErrorRetryInterceptor(Ref ref, Dio dio) =>
    AuthErrorRetryInterceptor(ref, dio);

class AuthErrorRetryInterceptor extends Interceptor {
  AuthErrorRetryInterceptor(this.ref, this.dio);

  final Ref ref;
  final Dio dio;

  RetryInterceptor get _interceptor =>
      ref.read(retryInterceptorProvider(dio, retryEvaluator: retryEvaluator));

  bool retryEvaluator(DioException error, int attempt) {
    if (error is FakeAuthErrorException) {
      return true;
    }

    return false;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _interceptor.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _interceptor.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _interceptor.onError(err, handler);
  }
}
