import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/client/base_option.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poke_api_http_client.g.dart';

@Riverpod(keepAlive: true)
Dio pokeApiHttpClient(Ref ref) {
  final dio = Dio(baseOptions);
  return dio;
}
