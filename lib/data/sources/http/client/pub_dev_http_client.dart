import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pub_dev_http_client.g.dart';

@riverpod
Dio pubDevHttpClient(Ref ref) {
  const baseUrl = 'https://pub.dev/api/';
  final dio = Dio(BaseOptions(baseUrl: baseUrl));
  return dio;
}
