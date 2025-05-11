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
            child: Column(
              children: [
                Text(pokemon.name),
                Image.network(
                  pokemon.sprites.frontDefault!,
                  width: 100,
                  height: 100,
                ),
                Text(pokemon.types.map((e) => e.type.name).join(', ')),
              ],
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
