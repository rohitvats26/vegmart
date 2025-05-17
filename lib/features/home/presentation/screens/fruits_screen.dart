import 'package:flutter/material.dart';

class FruitsScreen extends StatelessWidget {
  const FruitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [SliverList(delegate: SliverChildBuilderDelegate((context, index) => ListTile(title: Text('Fruit $index'))))]);
  }
}
