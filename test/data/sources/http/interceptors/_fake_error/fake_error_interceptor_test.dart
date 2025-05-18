import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/interceptors/_fake_error/fake_error_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';

import '../../../../../_mock/mock.mocks.dart';

void main() {
  late ProviderContainer container;
  late FakeErrorInterceptor interceptor;

  final mockResponseHandler = MockResponseInterceptorHandler();

  setUp(() {
    reset(mockResponseHandler);

    container = ProviderContainer();

    interceptor = container.read(fakeErrorInterceptorProvider);
  });

  tearDown(() {
    container.dispose();
  });

  group('onResponse', () {
    test('レスポンスが１回目と２回目の時に DioException をスローする', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test_api/test'),
        data: 'test',
      );

      // 1回目のレスポンスで DioException がスローされることを確認
      interceptor.onResponse(response, mockResponseHandler);
      verify(
        mockResponseHandler.reject(
          argThat(isA<DioException>()),
          true,
        ),
      ).called(1);

      // 2回目のレスポンスで DioException がスローされることを確認
      interceptor.onResponse(response, mockResponseHandler);
      verify(
        mockResponseHandler.reject(
          argThat(isA<DioException>()),
          true,
        ),
      ).called(1);

      // 3回目のレスポンスで正常に処理されることを確認
      interceptor.onResponse(response, mockResponseHandler);
      verify(mockResponseHandler.next(response)).called(1);
    });

    test('レスポンスが１１回目と１２回目の時に DioExceptionType.badResponse をスローする', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test_api/test'),
        data: 'test',
      );

      // レスポンスを１０回実行
      const count = 10;
      for (var i = 0; i < count; i++) {
        interceptor.onResponse(response, mockResponseHandler);
      }

      // ここまでの呼び出しでrejectが２回呼ばれることを確認
      verify(
        mockResponseHandler.reject(
          argThat(
            isA<DioException>()
                .having((e) => e.type, 'type', DioExceptionType.badCertificate),
          ),
          true,
        ),
      ).called(2);

      // ここまでの呼び出しでnextが8回呼ばれることを確認
      verify(mockResponseHandler.next(response)).called(8);

      // 11回目のレスポンスで DioExceptionType.badResponse がスローされることを確認
      interceptor.onResponse(response, mockResponseHandler);
      verify(
        mockResponseHandler.reject(
          argThat(
            isA<DioException>()
                .having((e) => e.type, 'type', DioExceptionType.badResponse)
                .having((e) => e.response?.statusCode, 'statusCode', 401),
          ),
          true,
        ),
      ).called(1);

      // 12回目のレスポンスで DioExceptionType.badResponse がスローされることを確認
      interceptor.onResponse(response, mockResponseHandler);
      verify(
        mockResponseHandler.reject(
          argThat(
            isA<DioException>()
                .having((e) => e.type, 'type', DioExceptionType.badResponse)
                .having((e) => e.response?.statusCode, 'statusCode', 401),
          ),
          true,
        ),
      ).called(1);

      // 13回目のレスポンスで正常に処理されることを確認
      interceptor.onResponse(response, mockResponseHandler);
      verify(mockResponseHandler.next(response)).called(1);
    });

    test('レスポンスが２０回目の時にカウントがリセットされることを確認', () async {
      final response = Response(
        requestOptions: RequestOptions(path: '/test_api/test'),
        data: 'test',
      );

      // レスポンスを２０回実行
      const count = 20;
      for (var i = 0; i < count; i++) {
        interceptor.onResponse(response, mockResponseHandler);
      }

      // ここまでの呼び出しでrejectが４回呼ばれることを確認
      verify(
        mockResponseHandler.reject(
          any,
          true,
        ),
      ).called(4);

      //ここまでの呼び出しでnextが１６回呼ばれることを確認
      verify(mockResponseHandler.next(response)).called(16);

      // ２０回目のレスポンスでカウントがリセットされ、
      // １回目のレスポンスと同じように DioException がスローされることを確認
      interceptor.onResponse(response, mockResponseHandler);
      verify(
        mockResponseHandler.reject(
          argThat(isA<DioException>()),
          true,
        ),
      ).called(1);
    });
  });
}
