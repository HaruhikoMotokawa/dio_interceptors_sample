import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/retry/auth_error_retry_interceptor.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/retry/retry_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../../../_mock/mock.mocks.dart';
import '../../../../../test_util/fetch_behavior_test_adapter.dart';

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
      verifyNever(mockResponseHandler.next(any));
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
      verifyNever(mockErrorHandler.next(any));
    });
  });
  group('onError', () {
    test('リトライインターセプターにエラーを渡す', () async {
      final exception = DioException(
        requestOptions: RequestOptions(path: '/test_api/test'),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test_api/test'),
          statusCode: 401,
        ),
      );

      interceptor.onError(exception, mockErrorHandler);

      verify(mockRetryInterceptor.onError(exception, mockErrorHandler))
          .called(1);
      verifyNever(mockRequestHandler.next(any));
    });
  });

  group('リトライの挙動テスト', () {
    /// 全体テストとは別のcontainerを使う
    late ProviderContainer container;
    late AuthErrorRetryInterceptor authErrorRetryInterceptor;
    late Dio dio;
    late int fetchCount;

    const path = '/test_api/test';
    setUp(() {
      container = ProviderContainer();
      fetchCount = 0;

      dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      authErrorRetryInterceptor =
          container.read(authErrorRetryInterceptorProvider(dio));

      dio.interceptors.add(authErrorRetryInterceptor);
    });

    tearDown(() {
      container.dispose();
    });

    test('DioExceptionType.badResponse の場合、3回リトライされる', () async {
      // 検証用のHttpClientAdapterを作成
      final adapter = FetchBehaviorTestAdapter(
        onAttempt: (attempt) {
          fetchCount = attempt;
        },
        dioException: DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: path),
            statusCode: 401,
          ),
        ),
      );

      // Dioにアダプターを設定
      dio.httpClientAdapter = adapter;

      // 処理を実行し、最終的にDioExceptionがスローされることを確認
      await expectLater(
        dio.get<String>(path),
        throwsA(
          isA<DioException>()
              .having((e) => e.response?.statusCode, 'statusCode', 401)
              .having(
                (e) => e.type,
                'type',
                DioExceptionType.badResponse,
              ),
        ),
      );

      // 初回１ + リトライ3回 = ４回行われている
      expect(fetchCount, equals(4));
    });
    test('DioExceptionType.badResponse以外 の場合は何もしない', () async {
      // 検証用のHttpClientAdapterを作成
      final adapter = FetchBehaviorTestAdapter(
        onAttempt: (attempt) {
          fetchCount = attempt;
        },
        dioException: DioException(
          requestOptions: RequestOptions(path: path),
          type: DioExceptionType.connectionTimeout,
          response: Response(
            requestOptions: RequestOptions(path: path),
          ),
        ),
      );

      // Dioにアダプターを設定
      dio.httpClientAdapter = adapter;

      // 処理を実行し、最終的にDioExceptionがスローされることを確認
      await expectLater(
        dio.get<String>(path),
        throwsA(
          isA<DioException>().having(
            (e) => e.type,
            'type',
            DioExceptionType.connectionTimeout,
          ),
        ),
      );

      // リトライは行われないので、1回だけ呼ばれる
      expect(fetchCount, equals(1));
    });
  });
}
