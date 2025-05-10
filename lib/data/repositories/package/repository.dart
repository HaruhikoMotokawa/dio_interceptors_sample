import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/data/sources/http/client/pub_dev_http_client.dart';
import 'package:dio_interceptors_sample/domain/models/package_names_response.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PackageRepository {
  PackageRepository(this.ref);
  final Ref ref;

  static const _popularPackagesEndpoint = 'package-name-completion-data';
  static const _allPackagesEndpoint = 'package-names';

  Dio get _dio => ref.read(pubDevHttpClientProvider);

  /// 人気パッケージを取得する
  Future<List<String>> fetchPopularPackages() async {
    final response =
        await _dio.get<Map<String, dynamic>>(_popularPackagesEndpoint);

    if (response.data case final data?) {
      final responseBody = PackageNamesResponse.fromJson(data);
      return responseBody.packages;
    }
    return [];
  }

  /// 全パッケージを取得する
  Future<List<String>> fetchAllPackages() async {
    final response = await _dio.get<Map<String, dynamic>>(_allPackagesEndpoint);

    if (response.data case final data?) {
      final responseBody = PackageNamesResponse.fromJson(data);
      return responseBody.packages;
    }
    return [];
  }
}
