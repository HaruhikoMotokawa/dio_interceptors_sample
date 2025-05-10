import 'package:dio_interceptors_sample/presentation/screens/all_packages/screen.dart';
import 'package:dio_interceptors_sample/presentation/screens/popular_packages/screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  static const path = '/';
  static const name = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(name),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Go to Popular Packages'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.push(PopularPackagesScreen.path),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Go to All Packages'),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => context.push(AllPackagesScreen.path),
            ),
          ],
        ),
      ),
    );
  }
}
