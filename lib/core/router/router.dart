import 'package:dio_interceptors_sample/presentation/screens/home/screen.dart';
import 'package:dio_interceptors_sample/presentation/screens/pokemon_detail/screen.dart';
import 'package:dio_interceptors_sample/presentation/screens/pokemons/screen.dart';
import 'package:dio_interceptors_sample/presentation/screens/pokemons_use_cache/screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) => _goRouter;

final _goRouter = GoRouter(
  // アプリが起動した時
  initialLocation: HomeScreen.path,
  // パスと画面の組み合わせ
  routes: [
    GoRoute(
      path: HomeScreen.path,
      name: HomeScreen.name,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const HomeScreen(),
        );
      },
      routes: [
        // Nested Screens 1
        GoRoute(
          path: PokemonsScreen.path,
          name: PokemonsScreen.name,
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const PokemonsScreen(),
            );
          },
        ),
        // Nested Screens 2
        GoRoute(
          path: PokemonsUseCacheScreen.path,
          name: PokemonsUseCacheScreen.name,
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const PokemonsUseCacheScreen(),
            );
          },
          routes: [
            // 詳細画面
            GoRoute(
              path: PokemonDetailScreen.path,
              name: PokemonDetailScreen.name,
              pageBuilder: (context, state) {
                return MaterialPage(
                  key: state.pageKey,
                  child: PokemonDetailScreen(
                    pokemonName: state.extra! as String,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
  // 遷移ページがないなどのエラーが発生した時に、このページに行く
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text(state.error.toString()),
      ),
    ),
  ),
);
