import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PopularPackagesScreen extends ConsumerWidget {
  const PopularPackagesScreen({super.key});

  static const path = '/popular-packages';
  static const name = 'PopularPackagesScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(name),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('Popular Packages'),
          ],
        ),
      ),
    );
  }
}
