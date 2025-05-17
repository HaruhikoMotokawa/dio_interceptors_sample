import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/_fake_error/fake_error_interceptor.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/retry/auth_error_retry_interceptor.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/retry/retry_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../../../_mock/mock.mocks.dart';

void main() {
  late ProviderContainer container;
  late AuthErrorRetryInterceptor interceptor;

  final mockRetryInterceptor = MockRetryInterceptor();
  final mockRequestHandler = MockRequestInterceptorHandler();
  final mockResponseHandler = MockResponseInterceptorHandler();
  final mockErrorHandler = MockErrorInterceptorHandler();
  final mockDio = MockDio();

  setUp(() {
    reset(mockRetryInterceptor);
    reset(mockRequestHandler);
    reset(mockResponseHandler);
    reset(mockErrorHandler);
    reset(mockDio);

    container = ProviderContainer(
      overrides: [
        retryInterceptorProvider(
          mockDio,
          retryEvaluator: AuthErrorRetryInterceptor.retryEvaluator,
        ).overrideWithValue(mockRetryInterceptor),
      ],
    );

    interceptor = container.read(authErrorRetryInterceptorProvider(mockDio));
  });

  group('onRequest', () {
    test('リトライインターセプターにリクエストを渡す', () async {
      final requestOptions = RequestOptions(path: '/test_api/test');

      interceptor.onRequest(requestOptions, mockRequestHandler);

      verify(mockRetryInterceptor.onRequest(requestOptions, mockRequestHandler))
          .called(1);
    });
  });
  group('onResponse', () {
    test('リトライインターセプターにレスポンスを渡す', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test_api/test'),
        data: 'test',
      );

      interceptor.onResponse(response, mockResponseHandler);

      verify(mockRetryInterceptor.onResponse(response, mockResponseHandler))
          .called(1);
    });
  });
  group('onError', () {
    test('リトライインターセプターにエラーを渡す', () async {
      final exception = FakeAuthErrorException(
        'message',
        RequestOptions(path: '/test_api/test'),
      );

      interceptor.onError(exception, mockErrorHandler);

      verify(mockRetryInterceptor.onError(exception, mockErrorHandler))
          .called(1);
    });
  });

  group('リトライの挙動テスト', () {
    /// 全体テストとは別のcontainerを使う
    late ProviderContainer container;
    late Dio dio;
    late List<int> callCount;
    late AuthErrorRetryInterceptor authErrorRetryInterceptor;

    setUp(() {
      callCount = <int>[];
      dio = Dio();
      container = ProviderContainer();

      authErrorRetryInterceptor =
          container.read(authErrorRetryInterceptorProvider(dio));
    });

    tearDown(() {
      container.dispose();
    });

    test('FakeAuthErrorException の場合、3回リトライされる', () async {
      // 毎回 FakeAuthErrorException を投げる Interceptor を追加
      dio.interceptors.addAll(
        [
          // FakeAuthErrorException を投げる Interceptorを追加
          InterceptorsWrapper(
            onRequest: (options, handler) {
              // リトライのカウントを追加
              callCount.add(1);
              handler.reject(
                FakeAuthErrorException('auth error', options),
                true,
              );
            },
          ),
          // AuthErrorRetryInterceptor を追加
          authErrorRetryInterceptor,
        ],
      );

      // 処理を実行し、最終的にFakeAuthErrorExceptionがスローされることを確認
      await expectLater(
        dio.get<dynamic>('/test_api/test'),
        throwsA(isA<FakeAuthErrorException>()),
      );

      // リトライ3回 + 初回 = 4回呼ばれている
      expect(callCount.length, 4);
    });
    test('DioException の場合は何もしない', () async {
      dio.interceptors.addAll(
        [
          // DioException を投げる Interceptorを追加
          InterceptorsWrapper(
            onRequest: (options, handler) {
              callCount.add(1);
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.sendTimeout,
                ),
                true,
              );
            },
          ),
          // AuthErrorRetryInterceptor を追加
          authErrorRetryInterceptor,
        ],
      );
      // 処理を実行し、最終的にDioExceptionがスローされることを確認
      await expectLater(
        dio.get<dynamic>('/test_api/test'),
        throwsA(isA<DioException>()),
      );

      // リトライは行われないので、1回だけ呼ばれているはず
      expect(callCount.length, 1);
    });
  });
}
