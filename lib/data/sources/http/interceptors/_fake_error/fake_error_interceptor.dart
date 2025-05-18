import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/core/log/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fake_error_interceptor.g.dart';

@Riverpod(keepAlive: true)
FakeErrorInterceptor fakeErrorInterceptor(Ref ref) => FakeErrorInterceptor();

class FakeErrorInterceptor extends Interceptor {
  int _count = 0;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final netWorkException = DioException(
      requestOptions: response.requestOptions,
      response: response,
      type: DioExceptionType.badCertificate,
    );

    final authException = DioException.badResponse(
      statusCode: 401,
      requestOptions: response.requestOptions,
      response: Response(
        requestOptions: response.requestOptions,
        statusCode: 401,
        data: response.data,
      ),
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
