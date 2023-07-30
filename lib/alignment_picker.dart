import 'package:flutter/material.dart';

double _cornerDiameter = 25.0;

class AlignmentPicker extends StatelessWidget {
  AlignmentPicker({super.key, required this.decoratedChild, this.alignment, required this.onChange});

  final Widget decoratedChild;
  final AlignmentGeometry? alignment;
  final Function onChange;

  // late AlignmentGeometry alignment;

  final List<Alignment> allowedAlignment = [
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var normalizedHeight = constraints.maxHeight - _cornerDiameter;
      var normalizedWidth = constraints.maxWidth - _cornerDiameter;
      return Stack(children: <Widget>[
        Positioned(
          top: _cornerDiameter / 2,
          left: _cornerDiameter / 2,
          child: SizedBox(height: normalizedHeight, width: normalizedWidth, child: decoratedChild),
        ),
        if (alignment != null)
          for (Alignment a in allowedAlignment)
            Positioned(
                top: (1 + a.y) * normalizedHeight / 2,
                left: (1 + a.x) * normalizedWidth / 2,
                child: _SelectablePoint(
                  type: a,
                  selected: alignment == a,
                  onChange: (value) {
                    onChange(value);
                  },
                )),
      ]);
    });
  }
}

class _SelectablePoint extends StatelessWidget {
  const _SelectablePoint({required this.type, required this.selected, required this.onChange});

  final Alignment type;
  final bool selected;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChange.call(type);
      },
      child: Container(
        width: _cornerDiameter,
        height: _cornerDiameter,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
          shape: BoxShape.circle,
        ),
        child: Container(
          decoration: selected
              ? BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                )
              : null,
        ),
      ),
    );
  }
}
