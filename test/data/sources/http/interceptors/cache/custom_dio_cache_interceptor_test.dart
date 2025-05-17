import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/cache/custom_dio_cache_interceptor.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/cache/dio_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';

import '../../../../../_mock/mock.mocks.dart';

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
    late Dio dio;
    late int fetchCount;
    late CustomDioCacheInterceptor customDioCacheInterceptor;

    setUp(() {
      container = ProviderContainer();
      dio = Dio();
      fetchCount = 0;

      customDioCacheInterceptor =
          container.read(customDioCacheInterceptorProvider);

      dio.interceptors.add(customDioCacheInterceptor);

      DioAdapter(dio: dio).onGet(
        '/test_api/test',
        (server) {
          fetchCount++;
          server.reply(200, {'message': 'mocked response'});
        },
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('同じリクエストはキャッシュが使われ fetch されない', () async {
      // 初回
      final res1 = await dio.get<Map<String, dynamic>>('/test_api/test');
      expect(res1.data?['message'], 'mocked response');

      // 2回目
      final res2 = await dio.get<Map<String, dynamic>>('/test_api/test');
      expect(res2.data?['message'], 'mocked response');

      // キャッシュを使っているので fetchCount は 1 のまま
      expect(fetchCount, 1);
    });
  });
}
