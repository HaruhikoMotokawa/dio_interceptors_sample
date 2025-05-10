import 'package:dio_interceptors_sample/data/repositories/package/repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
PackageRepository packageRepository(Ref ref) => PackageRepository(ref);

@riverpod
Future<List<String>> popularPackages(Ref ref) =>
    ref.read(packageRepositoryProvider).fetchPopularPackages();

@riverpod
Future<List<String>> allPackages(Ref ref) =>
    ref.read(packageRepositoryProvider).fetchAllPackages();
