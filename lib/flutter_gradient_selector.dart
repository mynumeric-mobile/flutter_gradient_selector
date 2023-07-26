library flutter_gradient_selector;

import 'package:flutter/material.dart';
import 'package:flutter_gradient_selector/alignment_picker.dart';

class GradientSelector extends StatefulWidget {
  const GradientSelector({super.key, required this.gradient, this.onChange});

  final Gradient gradient;
  final Function? onChange;

  @override
  State<GradientSelector> createState() => _GradientSelectorState();
}

class _GradientSelectorState extends State<GradientSelector> {
  late Gradient gradient;
  bool selectBegin = true;
  late GradientProperties properties;

  @override
  void initState() {
    gradient = widget.gradient;
    properties = GradientProperties.fromGradient(gradient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return SingleChildScrollView(
        child: SizedBox(
          height: constraints.maxHeight,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: constraints.maxWidth * 0.9,
                height: 90,
                child: AlignmentPicker(
                  alignment: selectBegin ? properties.begin : properties.end,
                  onChange: (value) {
                    if (selectBegin) {
                      properties.begin = value;
                    } else {
                      properties.end = value;
                    }

                    gradient = properties.applyProperties(gradient);
                    setState(() {});
                  },
                  decoratedChild: Container(
                      decoration: BoxDecoration(
                    gradient: gradient,
                    //       )
                  )),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Type :"),
                  ElevatedButton(
                    clipBehavior: Clip.none,
                    style: ElevatedButton.styleFrom(
                      side: gradient is LinearGradient ? const BorderSide(width: 3) : null,
                      padding: const EdgeInsets.all(1.0),
                      minimumSize: const Size(0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () {
                      gradient = GradientType.linear.get(properties);
                      widget.onChange?.call(gradient);
                      setState(() {});
                    },
                    child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(20),
                          gradient: GradientType.linear.get(properties),
                          //       )
                        )),
                  ),
                  ElevatedButton(
                    clipBehavior: Clip.none,
                    style: ElevatedButton.styleFrom(
                      side: gradient is RadialGradient ? const BorderSide(width: 3) : null,
                      padding: const EdgeInsets.all(1.0),
                      minimumSize: const Size(0, 0),
                    ),
                    onPressed: () {
                      gradient = GradientType.radial.get(properties);
                      widget.onChange?.call(gradient);
                      setState(() {});
                    },
                    child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: GradientType.radial.get(properties),
                          //       )
                        )),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Axe :"),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    clipBehavior: Clip.none,
                    style: ElevatedButton.styleFrom(
                        side: selectBegin ? const BorderSide(width: 3) : null,
                        padding: const EdgeInsets.all(1.0),
                        backgroundColor: selectBegin ? Theme.of(context).colorScheme.primary : null),
                    onPressed: () {
                      selectBegin = true;
                      setState(() {});
                    },
                    child: Text("Début",
                        style: const TextStyle().copyWith(color: selectBegin ? Theme.of(context).colorScheme.onPrimary : null)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    clipBehavior: Clip.none,
                    style: ElevatedButton.styleFrom(
                        side: !selectBegin ? const BorderSide(width: 3) : null,
                        padding: const EdgeInsets.all(1.0),
                        backgroundColor: !selectBegin ? Theme.of(context).colorScheme.primary : null),
                    onPressed: () {
                      selectBegin = false;
                      setState(() {});
                    },
                    child: Text("Fin",
                        style: const TextStyle().copyWith(color: !selectBegin ? Theme.of(context).colorScheme.onPrimary : null)),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SizedBox(
                  width: constraints.maxWidth * 0.9,
                  child: ReorderableListView.builder(
                    shrinkWrap: true,
                    itemCount: properties.colors.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                          key: Key('$index'),
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(width: 1)),
                            child: Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: properties.colors[index],
                                  ),
                                ),
                              ],
                            ),
                          ));
                    },
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final Color c = properties.colors.removeAt(oldIndex);
                        properties.colors.insert(newIndex, c);
                        gradient = properties.applyProperties(gradient);
                      });

                      widget.onChange?.call(gradient);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
    });
  }
}

enum GradientType { linear, radial, sweep }

extension GradientExtension on GradientType {
  Gradient get(GradientProperties prop) {
    switch (this) {
      case GradientType.linear:
        return LinearGradient(colors: prop.colors, stops: prop.stops, begin: prop.begin, end: prop.end);
      case GradientType.radial:
        return RadialGradient(colors: prop.colors, stops: prop.stops, center: prop.begin, radius: prop.radius);
      case GradientType.sweep:
        return SweepGradient(colors: prop.colors, stops: prop.stops, center: prop.begin);
    }
  }
}

class GradientProperties {
  List<Color> colors;
  List<double>? stops;
  AlignmentGeometry begin;
  AlignmentGeometry end;
  double radius;

  GradientProperties({
    colors,
    this.stops,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    this.radius = 0.5,
  }) : colors = colors ??= [Colors.pink, Colors.blue];

  static fromGradient(Gradient g) {
    var p = GradientProperties(colors: List<Color>.from(g.colors), stops: g.stops);

    if (g is LinearGradient) {
      p.begin = g.begin;
      p.end = g.end;
    } else if (g is RadialGradient) {
      p.begin = g.center;
      p.radius = g.radius;
    }

    return p;
  }

  applyProperties(Gradient g) {
    GradientType type = g is LinearGradient
        ? GradientType.linear
        : g is RadialGradient
            ? GradientType.radial
            : GradientType.sweep;

    return type.get(this);
  }
}
