import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// `Dio` の `fetch` 呼び出しを監視・制御するテスト用の `HttpClientAdapter`。
///
/// 主に以下の用途に使用される：
/// - `fetch` の呼び出し回数をカウントして、リトライの挙動を確認する
/// - 任意の `DioException` をスローすることで、エラーケースをシミュレートする
/// - 任意のレスポンスデータを返すことで、成功ケースをテストする

class FetchBehaviorTestAdapter implements HttpClientAdapter {
  FetchBehaviorTestAdapter({
    required this.onAttempt,
    this.responseData,
    this.dioException,
  });

  final void Function(int attempt) onAttempt;
  final String? responseData;
  final DioException? dioException;

  int _internalAttempt = 0;

  // 特に必要ないが、HttpClientAdapterのインターフェースに合わせるために実装
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

    if (dioException case final dioException?) {
      throw dioException;
    } else {
      return ResponseBody.fromString(
        responseData ?? 'success',
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
          'cache-control': ['public, max-age=120'], // ★ここが重要！
        },
      );
    }
  }
}
