import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'custom_dio_cache_interceptor.g.dart';

@Riverpod(keepAlive: true)
DioCacheInterceptor dioCacheInterceptor(Ref ref) {
  return DioCacheInterceptor(
    options: CacheOptions(
      store: MemCacheStore(),
      maxStale: const Duration(minutes: 10),
      allowPostMethod: true,
    ),
  );
}

class CustomDioCacheInterceptor extends Interceptor {
  CustomDioCacheInterceptor(this.ref);

  final Ref ref;

  DioCacheInterceptor get _interceptor => ref.read(dioCacheInterceptorProvider);

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
