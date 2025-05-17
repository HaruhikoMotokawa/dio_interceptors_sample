import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/core/constant/constants.dart';
import 'package:dio_interceptors_sample/core/log/logger.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'retry_interceptor.g.dart';

@Riverpod(keepAlive: true)
RetryInterceptor retryInterceptor(
  Ref ref,
  Dio dio, {
  FutureOr<bool> Function(DioException, int)? retryEvaluator,
}) {
  return RetryInterceptor(
    dio: dio,
    retryEvaluator: retryEvaluator,
    logPrint: logger.d,
    retryDelays: Constants.dioRetryDelays,
  );
}
