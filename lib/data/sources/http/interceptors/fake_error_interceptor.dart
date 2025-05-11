import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/core/log/logger.dart';

class FakeErrorInterceptor extends Interceptor {
  int _count = 0;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final authException = FakeAuthErrorException(
      'FakeAuthErrorInterceptor: Simulating error #$_count',
      response.requestOptions,
    );

    final netWorkException = DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.sendTimeout,
    );
    _count++;
    if (_count <= 2) {
      logger.w('FakeErrorInterceptor: Simulating error #$_count');
      // 第二位置引数のcallFollowingErrorInterceptorをtrueにすると
      // 次のInterceptorに進む
      handler.reject(netWorkException, true);
    } else if (_count == 11) {
      logger.w('FakeErrorInterceptor: Simulating error #$_count');
      handler.reject(authException, true);
    } else if (_count == 12) {
      logger.w('FakeErrorInterceptor: Simulating error #$_count');
      handler.reject(authException, true);
    } else if (_count == 20) {
      logger.i('FakeErrorInterceptor: Simulating count reset');
      _count = 0;
      handler.next(response);
    } else {
      // 正常であれば次のInterceptorに進む
      handler.next(response);
    }
  }
}

// Fakeの認証エラーのException
class FakeAuthErrorException extends DioException implements Exception {
  FakeAuthErrorException(String message, RequestOptions? requestOptions)
      : super(
          message: message,
          requestOptions: requestOptions ?? RequestOptions(),
        );

  @override
  String toString() {
    return 'FakeAuthErrorException: $message';
  }
}
