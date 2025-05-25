import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/cache/custom_dio_cache_interceptor.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/cache/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../../../_mock/mock.mocks.dart';
import '../../../../../test_util/fetch_behavior_test_adapter.dart';

void main() {
  late ProviderContainer container;
  late CustomDioCacheInterceptor interceptor;

  final mockDioCacheInterceptor = MockDioCacheInterceptor();
  final mockRequestHandler = MockRequestInterceptorHandler();
  final mockResponseHandler = MockResponseInterceptorHandler();
  final mockErrorHandler = MockErrorInterceptorHandler();

  setUp(() {
    reset(mockDioCacheInterceptor);
    reset(mockRequestHandler);
    reset(mockResponseHandler);
    reset(mockErrorHandler);

    container = ProviderContainer(
      overrides: [
        dioCacheInterceptorProvider.overrideWithValue(mockDioCacheInterceptor),
      ],
    );

    interceptor = container.read(customDioCacheInterceptorProvider);
  });

  tearDown(() {
    container.dispose();
  });
  group('onRequest', () {
    test('DioCacheInterceptor のonRequestが呼ばれる', () async {
      final requestOptions = RequestOptions(path: '/test_api/test');

      // リクエストを実行
      interceptor.onRequest(requestOptions, mockRequestHandler);

      // DioCacheInterceptor の onRequest が呼ばれたことを確認
      verify(
        mockDioCacheInterceptor.onRequest(
          requestOptions,
          mockRequestHandler,
        ),
      ).called(1);

      // 通常のリクエストハンドラーが呼ばれないことを確認
      verifyNever(mockResponseHandler.next(any));
    });
  });

  group('onResponse', () {
    test('DioCacheInterceptor のonResponseが呼ばれる', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test_api/test'),
        data: 'test',
      );

      // レスポンスを実行
      interceptor.onResponse(response, mockResponseHandler);

      // DioCacheInterceptor の onResponse が呼ばれたことを確認
      verify(
        mockDioCacheInterceptor.onResponse(
          response,
          mockResponseHandler,
        ),
      ).called(1);

      // 通常のレスポンスハンドラーが呼ばれないことを確認
      verifyNever(mockRequestHandler.next(any));
    });
  });
  group('onError', () {
    test('DioCacheInterceptor のonErrorが呼ばれる', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/test_api/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test_api/test'),
          data: 'test',
        ),
      );

      // エラーを実行
      interceptor.onError(dioException, mockErrorHandler);

      // DioCacheInterceptor の onError が呼ばれたことを確認
      verify(
        mockDioCacheInterceptor.onError(
          dioException,
          mockErrorHandler,
        ),
      ).called(1);

      // 通常のエラーハンドラーが呼ばれないことを確認
      verifyNever(mockRequestHandler.next(any));
    });
  });
  group('キャッシュの挙動確認', () {
    /// 全体テストとは別のcontainerを使う
    late ProviderContainer container;
    late CustomDioCacheInterceptor customDioCacheInterceptor;
    late Dio dio;
    late FetchBehaviorTestAdapter dioHttpClientAdapter;
    late int fetchCount;

    const path = '/test_api/test';
    const mockedResponse = 'mocked response';

    setUp(() {
      container = ProviderContainer();
      fetchCount = 0;
      dio = Dio(BaseOptions(baseUrl: 'https://example.com'));

      dioHttpClientAdapter = FetchBehaviorTestAdapter(
        onAttempt: (attempt) {
          fetchCount = attempt;
        },
        responseData: mockedResponse,
      );

      customDioCacheInterceptor =
          container.read(customDioCacheInterceptorProvider);

      // customDioCacheInterceptor をDioに追加
      dio.interceptors.add(customDioCacheInterceptor);

      // FetchBehaviorTestAdapterをDioのHttpClientAdapterに設定
      dio.httpClientAdapter = dioHttpClientAdapter;
    });

    tearDown(() {
      container.dispose();
    });

    test('同じリクエストはキャッシュが使われ fetch されない', () async {
      // 初回
      final res1 = await dio.get<String>(path);
      expect(res1.data, mockedResponse);

      // 2回目
      final res2 = await dio.get<String>(path);
      expect(res2.data, mockedResponse);

      // キャッシュを使っているので fetchCount は 1 のまま
      expect(fetchCount, equals(1));
    });
    test('異なるリクエストはキャッシュが使われず fetch される', () async {
      // 初回
      final res1 = await dio.get<String>(path);
      expect(res1.data, mockedResponse);

      // 異なるリクエスト
      final res2 = await dio.get<String>('/test_api/another_test');
      // 異なるリクエストでもレスポンスは同じになるように今回はモックされている
      expect(res2.data, mockedResponse);

      // 異なるリクエストなので fetchCount は 2 になる
      expect(fetchCount, equals(2));
    });
  });
}
