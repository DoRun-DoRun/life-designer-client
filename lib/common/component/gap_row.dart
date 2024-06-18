import 'package:flutter/material.dart';

class GapRow extends StatelessWidget {
  final List<Widget> children;
  final double gap;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const GapRow({
    super.key,
    required this.children,
    this.gap = 0,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: _addGaps(children, gap),
    );
  }

  List<Widget> _addGaps(List<Widget> children, double gap) {
    if (children.isEmpty) return [];

    final List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(width: gap));
      }
    }
    return spacedChildren;
  }
}
