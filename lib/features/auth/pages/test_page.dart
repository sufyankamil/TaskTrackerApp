import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:management/features/auth/controller/code_providers.dart';

class TestPage extends ConsumerWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String test = ref.watch(codeStateProvider);
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              Text(test,
                  style: const TextStyle(fontSize: 30, color: Colors.white)),
              ElevatedButton(
                onPressed: () {
                  ref.read(codeStateProvider.notifier).setStart('Hello man');
                },
                child: const Text('Change'),
              )
            ],
          ),
        ));
  }
}
