import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/client/base_option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pub_dev_http_client.g.dart';

@riverpod
Dio pubDevHttpClient(Ref ref) {
  final dio = Dio(baseOptions);
  return dio;
}
