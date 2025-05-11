import 'package:dio_interceptors_sample/data/repositories/poke/repository.dart';
import 'package:dio_interceptors_sample/domain/models/pokemon_list_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
PokeRepository pokeRepository(Ref ref) => PokeRepository(ref);

@riverpod
Future<List<PokemonEntry>> pokemons(Ref ref) async =>
    ref.read(pokeRepositoryProvider).fetchList();

@riverpod
Future<List<PokemonEntry>> pokemonsWithInterceptors(Ref ref) async =>
    ref.read(pokeRepositoryProvider).fetchListWithCache();
