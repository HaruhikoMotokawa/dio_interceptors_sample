import 'package:dio_interceptors_sample/presentation/screens/all_packages/screen.dart';
import 'package:dio_interceptors_sample/presentation/screens/home/screen.dart';
import 'package:dio_interceptors_sample/presentation/screens/popular_packages/screen.dart';
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
    ),
    // Nested Screens 1
    GoRoute(
      path: PopularPackagesScreen.path,
      name: PopularPackagesScreen.name,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const PopularPackagesScreen(),
        );
      },
    ),
    // Nested Screens 2
    GoRoute(
      path: AllPackagesScreen.path,
      name: AllPackagesScreen.name,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const AllPackagesScreen(),
        );
      },
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
