import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// fetchの中でDioExceptionをthrowするためのテスト用HttpClientAdapter
///
/// DioExceptionをthrowすることで、リトライの挙動を確認するために使用
class RetryCheckAdapter implements HttpClientAdapter {
  RetryCheckAdapter({
    required this.dio,
    required this.onAttempt,
    required this.dioException,
  }) {
    dio.httpClientAdapter = this;
  }

  final Dio dio;
  final void Function(int attempt) onAttempt;
  final DioException dioException;

  int _internalAttempt = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    _internalAttempt++;
    onAttempt(_internalAttempt);

    throw dioException;
  }
}
