import 'package:dio_interceptors_sample/core/constant/constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// テスト実行前に一番最初に実行される
///
/// ここで細かい設定を行える
///
/// https://api.flutter.dev/flutter/flutter_test/
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  /// テストするときにリトライの時間をすべて0にする
  Constants.dioRetryDelays = [
    Duration.zero,
    Duration.zero,
    Duration.zero,
  ];

  await testMain();
}
