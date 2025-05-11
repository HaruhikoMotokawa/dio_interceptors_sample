import 'package:dio/dio.dart';
import 'package:dio_interceptors_sample/core/log/logger.dart';
import 'package:dio_interceptors_sample/data/sources/http/client/poke_api_http_client.dart';
import 'package:dio_interceptors_sample/data/sources/http/client/poke_api_http_client_with_interceptors.dart';
import 'package:dio_interceptors_sample/domain/api_models/pokemon_list_response.dart';
import 'package:dio_interceptors_sample/domain/api_models/pokemon_named_api_resource.dart';
import 'package:dio_interceptors_sample/domain/api_models/pokemon_species.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PokeRepository {
  PokeRepository(this.ref);
  final Ref ref;

  static const _pokemonEndpoint = 'pokemon';
  static const _queryParameters = {
    'limit': 1500, // 全件取得するため適当に大きな値を指定
    'offset': 0,
  };

  Dio get _dio => ref.read(pokeApiHttpClientProvider);
  Dio get _dioWithInterceptors =>
      ref.read(pokeApiHttpClientWithInterceptorsProvider);

  /// 【キャッシュなし】ポケモンのリストを取得する
  Future<List<PokemonNamedApiResource>> fetchList() async {
    final response = await _dio.get<Map<String, dynamic>>(
      _pokemonEndpoint,
      queryParameters: _queryParameters,
    );

    if (response.data case final data?) {
      final responseBody = PokemonListResponse.fromJson(data);
      return responseBody.results;
    }
    return [];
  }

  /// 【キャッシュあり】ポケモンのリストを取得する
  Future<List<PokemonNamedApiResource>> fetchListWithCache() async {
    try {
      final response = await _dioWithInterceptors.get<Map<String, dynamic>>(
        _pokemonEndpoint,
        queryParameters: _queryParameters,
      );

      if (response.data case final data?) {
        final responseBody = PokemonListResponse.fromJson(data);
        return responseBody.results;
      }
      return [];
    } on Exception catch (e, s) {
      logger.e('Error fetching Pokemon list with cache: \n $e \n $s');
      rethrow;
    }
  }

  /// 【キャッシュあり】ポケモンの詳細情報を取得する
  Future<PokemonSpecies?> fetchDetail({required String name}) async {
    final endPoint = '$_pokemonEndpoint/$name';
    try {
      final response = await _dioWithInterceptors.get<Map<String, dynamic>>(
        endPoint,
      );

      if (response.data case final data?) {
        final responseBody = PokemonSpecies.fromJson(data);
        return responseBody;
      }
      return null;
    } on Exception catch (e, s) {
      logger.e('Error fetching Pokemon detail: \n $e \n $s');
      rethrow;
    }
  }
}
