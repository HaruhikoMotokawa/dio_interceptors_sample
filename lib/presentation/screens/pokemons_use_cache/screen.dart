import 'package:dio_interceptors_sample/data/repositories/poke/provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PokemonsUseCacheScreen extends ConsumerWidget {
  const PokemonsUseCacheScreen({super.key});

  static const path = '/pokemons_use_cache';
  static const name = 'PokemonsUseCacheScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPokemons = ref.watch(pokemonsWithInterceptorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(name),
      ),
      body: switch (asyncPokemons) {
        AsyncData(value: final pokemons) => ListView.separated(
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
        AsyncError(:final error, :final stackTrace) =>
          Text('Error: $error, StackTrace: $stackTrace'),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
