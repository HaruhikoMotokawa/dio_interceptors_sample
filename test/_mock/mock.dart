import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<DioCacheInterceptor>(),
  MockSpec<RequestInterceptorHandler>(),
  MockSpec<ResponseInterceptorHandler>(),
  MockSpec<ErrorInterceptorHandler>(),
  MockSpec<RetryInterceptor>(),
  MockSpec<Dio>(),
])
void main() {}
