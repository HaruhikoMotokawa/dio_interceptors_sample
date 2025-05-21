import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_cache_interceptor.g.dart';

@Riverpod(keepAlive: true)
DioCacheInterceptor dioCacheInterceptor(Ref ref) {
  return DioCacheInterceptor(
    options: CacheOptions(
      store: MemCacheStore(),
      maxStale: const Duration(minutes: 10),
    ),
  );
}
