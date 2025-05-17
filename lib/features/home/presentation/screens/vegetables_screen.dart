import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VegetablesScreen extends StatelessWidget {
  const VegetablesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [SliverList(delegate: SliverChildBuilderDelegate((context, index) => ListTile(title: Text('Vegetable $index'))))],
    );
  }
}
