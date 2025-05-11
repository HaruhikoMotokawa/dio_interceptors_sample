import 'package:dio_interceptors_sample/data/repositories/poke/repository.dart';
import 'package:dio_interceptors_sample/domain/api_models/pokemon_named_api_resource.dart';
import 'package:dio_interceptors_sample/domain/api_models/pokemon_species.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
PokeRepository pokeRepository(Ref ref) => PokeRepository(ref);

@riverpod
Future<List<PokemonNamedApiResource>> pokemons(Ref ref) async =>
    ref.read(pokeRepositoryProvider).fetchList();

@riverpod
Future<List<PokemonNamedApiResource>> pokemonsWithInterceptors(Ref ref) async =>
    ref.read(pokeRepositoryProvider).fetchListWithCache();

@riverpod
Future<PokemonSpecies?> pokemonDetail(
  Ref ref,
  String pokemonName,
) async =>
    ref.read(pokeRepositoryProvider).fetchDetail(name: pokemonName);
