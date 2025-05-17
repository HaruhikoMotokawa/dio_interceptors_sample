import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/retry/retry_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_retry_interceptor.g.dart';

@Riverpod(keepAlive: true)
NetworkRetryInterceptor networkRetryInterceptor(Ref ref, Dio dio) =>
    NetworkRetryInterceptor(ref, dio);

class NetworkRetryInterceptor extends Interceptor {
  NetworkRetryInterceptor(this.ref, this.dio);

  final Ref ref;
  final Dio dio;

  RetryInterceptor get _interceptor => ref.read(retryInterceptorProvider(dio));

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
