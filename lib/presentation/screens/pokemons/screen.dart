import 'package:dio_interceptors_sample/data/repositories/poke/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PokemonsScreen extends ConsumerWidget {
  const PokemonsScreen({super.key});

  static const path = '/pokemons';
  static const name = 'PokemonsScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPokemons = ref.watch(pokemonsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(name),
      ),
      body: switch (asyncPokemons) {
        AsyncData(value: final pokemons) => SafeArea(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                return Text(
                  'No.${index + 1}: ${pokemons[index].name}',
                  style: Theme.of(context).textTheme.titleLarge,
                );
              },
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        AsyncError(:final error, :final stackTrace) =>
          Text('Error: $error, StackTrace: $stackTrace'),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
