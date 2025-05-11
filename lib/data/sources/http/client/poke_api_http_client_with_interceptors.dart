import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/client/base_option.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/custom_dio_cache_interceptor.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/fake_error_interceptor.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/retry/auth_error_retry_interceptor.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/retry/network_retry_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poke_api_http_client_with_interceptors.g.dart';

@Riverpod(keepAlive: true)
Dio pokeApiHttpClientWithInterceptors(Ref ref) {
  final dio = Dio(baseOptions);
  // Interceptorsを追加
  dio.interceptors.addAll([
    // 今回はテストのために例外を投げるインターセプターを追加
    if (kDebugMode) ...[
      FakeErrorInterceptor(),
    ],

    // ここにInterceptorを追加
    NetworkRetryInterceptor(ref, dio),
    AuthErrorRetryInterceptor(ref, dio),
    CustomDioCacheInterceptor(ref),
  ]);

  return dio;
}
