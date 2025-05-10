import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllPackagesScreen extends ConsumerWidget {
  const AllPackagesScreen({super.key});

  static const path = '/all-packages';
  static const name = 'AllPackagesScreen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(name),
      ),
      body: const Center(
        child: Text('List of All Packages'),
      ),
    );
  }
}
