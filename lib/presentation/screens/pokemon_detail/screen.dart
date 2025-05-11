import 'package:dio_interceptors_sample/data/repositories/poke/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PokemonDetailScreen extends ConsumerWidget {
  const PokemonDetailScreen({required this.pokemonName, super.key});
  static const path = 'pokemon_detail';
  static const name = 'PokemonDetailScreen';

  final String pokemonName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPokemon = ref.watch(pokemonDetailProvider(pokemonName));

    return Scaffold(
      appBar: AppBar(
        title: const Text(name),
      ),
      body: switch (asyncPokemon) {
        AsyncData(value: final pokemon?) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ポケモン名: ${pokemon.name}'),
                    Image.network(
                      scale: 0.1,
                      pokemon.sprites.frontDefault!,
                      width: 200,
                      height: 200,
                    ),
                    Text(
                      'ポケモンタイプ: '
                      '${pokemon.types.map((e) => e.type.name).join(', ')}',
                    ),
                  ],
                ),
              ),
            ),
          ),
        AsyncData() => SafeArea(
            child: Column(
              children: [
                Text('No.$pokemonName'),
              ],
            ),
          ),
        AsyncError(:final error, :final stackTrace) =>
          Text('Error: $error, StackTrace: $stackTrace'),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
