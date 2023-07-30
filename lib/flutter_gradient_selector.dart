library flutter_gradient_selector;

import 'package:flutter/material.dart';
import 'package:flutter_gradient_selector/alignment_picker.dart';

import 'helpers/localization.dart';
import 'widgets/color_picker.dart';

enum CornerMode { begin, end, none }

List<Color> colorHistory = [];

class GradientSelector extends StatefulWidget {
  const GradientSelector({super.key, required this.gradient, this.onChange, this.lang});

  final Gradient gradient;
  final Function? onChange;
  final LocalisationCode? lang;

  @override
  State<GradientSelector> createState() => _GradientSelectorState();
}

class _GradientSelectorState extends State<GradientSelector> with TickerProviderStateMixin {
  late Gradient gradient;
  CornerMode _cornerMode = CornerMode.none;
  late GradientProperties properties;
  String _explanation = '';

  GlobalKey _sampleKey = GlobalKey();
  GlobalKey _linearKey = GlobalKey();
  GlobalKey _radialKey = GlobalKey();
  GlobalKey _sweepKey = GlobalKey();

  @override
  void initState() {
    setLocalizationOptions(widget.lang);
    gradient = widget.gradient;
    properties = GradientProperties.fromGradient(gradient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      GradientSpecification specif = GradientProperties.getType(gradient).specifications()!;
      return SingleChildScrollView(
          child: SizedBox(
        height: constraints.maxHeight,
        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            children: [
              Text(
                _explanation,
                textScaleFactor: 0.8,
              ),
            ],
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: specif.displayRadius ? 80 : constraints.maxWidth,
                height: 80,
                child: AlignmentPicker(
                  key: _sampleKey,
                  alignment: _cornerMode == CornerMode.begin
                      ? properties.begin
                      : _cornerMode == CornerMode.none
                          ? null
                          : properties.end,
                  onChange: (value) {
                    if (_cornerMode == CornerMode.begin) {
                      properties.begin = value;
                    } else {
                      properties.end = value;
                    }
                    upDateGradient();
                  },
                  decoratedChild: Container(
                      decoration: BoxDecoration(
                    gradient: gradient,
                    //       )
                  )),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: specif.displayRadius
                    ? Slider(
                        value: properties.radius,
                        onChanged: (value) {
                          properties.radius = value;
                          upDateGradient();
                        })
                    : Container(),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                key: _linearKey,
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
                  _explanation = localizationOptions.linearGradient;
                  _cornerMode = CornerMode.none;
                  widget.onChange?.call(gradient);
                  setState(() {});
                },
                child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: GradientType.linear.get(properties),
                      //       )
                    )),
              ),
              ElevatedButton(
                key: _radialKey,
                clipBehavior: Clip.none,
                style: ElevatedButton.styleFrom(
                  side: gradient is RadialGradient ? const BorderSide(width: 3) : null,
                  padding: const EdgeInsets.all(1.0),
                  minimumSize: const Size(0, 0),
                ),
                onPressed: () {
                  gradient = GradientType.radial.get(properties);
                  _explanation = localizationOptions.radialGradient;
                  _cornerMode = CornerMode.none;
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
              ),
              ElevatedButton(
                key: _sweepKey,
                clipBehavior: Clip.none,
                style: ElevatedButton.styleFrom(
                  side: gradient is SweepGradient ? const BorderSide(width: 3) : null,
                  padding: const EdgeInsets.all(1.0),
                  minimumSize: const Size(0, 0),
                ),
                onPressed: () {
                  gradient = GradientType.sweep.get(properties);
                  _explanation = localizationOptions.sweepGradient;
                  _cornerMode = CornerMode.none;
                  widget.onChange?.call(gradient);
                  setState(() {});
                },
                child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: GradientType.sweep.get(properties),
                      //       )
                    )),
              ),
              WsColorPicker(
                color: Colors.white,
                title: localizationOptions.selectColor,
                onChange: (value) {
                  var delta = (properties.stops[1] - properties.stops[0]) / 2;

                  properties.colors.insert(1, value);
                  properties.stops.insert(1, properties.stops[0] + delta);
                  _explanation = localizationOptions.changeColor;
                  upDateGradient();
                },
                child: Container(
                  alignment: AlignmentDirectional.center,
                  width: 30,
                  height: 30,
                  child: const Text(
                    "+",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: SizedBox(
              width: constraints.maxWidth * 0.9,
              child: ReorderableListView.builder(
                shrinkWrap: true,
                itemCount: properties.colors.length,
                itemBuilder: (BuildContext context, int index) {
                  return (index == 0 || (index == properties.colors.length - 1 && specif.adjustEnd))
                      ? GestureDetector(
                          key: Key('GD$index'),
                          child: colorWidget(
                              index,
                              (index == 0 && _cornerMode == CornerMode.begin) ||
                                  (index == properties.colors.length - 1 && _cornerMode == CornerMode.end),
                              specif,
                              constraints),
                          onTap: () {
                            var val = index == 0 ? CornerMode.begin : CornerMode.end;
                            _cornerMode = val == _cornerMode ? CornerMode.none : val;
                            _explanation = val == CornerMode.none
                                ? ""
                                : val == CornerMode.begin
                                    ? localizationOptions.startingPoint
                                    : localizationOptions.endPoint;
                            setState(() {});
                          },
                        )
                      : colorWidget(index, false, specif, constraints);
                },
                onReorder: (int oldIndex, int newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Color c = properties.colors.removeAt(oldIndex);
                  properties.colors.insert(newIndex, c);
                  upDateGradient();
                },
              ),
            ),
          ),
        ]),
      ));
    });
  }

  ///
  /// color tile
  ///
  colorWidget(index, selected, specif, constraints) {
    var alignAjustable = index == 0 || ((index == properties.colors.length - 1) && specif.adjustEnd);
    return Padding(
        key: Key('$index'),
        padding: const EdgeInsets.all(3),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1),
            color: selected ? Theme.of(context).primaryColor.withAlpha(100) : Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              WsColorPicker(
                color: properties.colors[index],
                onChange: (value) {
                  properties.colors[index] = value;
                  upDateGradient();
                },
                title: localizationOptions.selectColor,
              ),
              Expanded(
                  child: index < properties.colors.length - 1
                      ? SliderTheme(
                          data: SliderThemeData(
                            overlayShape: SliderComponentShape.noThumb,
                          ),
                          child: Slider(
                              value: properties.stops[index],
                              onChanged: (value) {
                                properties.stops[index] = value;
                                upDateGradient();
                              }))
                      : Container()),
              (index > 0 || properties.colors.length > 2) && index < properties.colors.length - 1
                  ? ElevatedButton(
                      clipBehavior: Clip.none,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(1.0),
                          minimumSize: const Size(0, 0),
                          shadowColor: const Color.fromARGB(0, 7, 2, 2)),
                      onPressed: () {
                        properties.colors.removeAt(index);
                        properties.stops.removeAt(index);
                        _explanation = "";
                        upDateGradient();
                      },
                      child: const Icon(
                        Icons.delete_outline,
                        size: 30,
                      ),
                    )
                  : const SizedBox(
                      width: 50,
                    ),
              alignAjustable
                  ? const Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(Icons.fit_screen),
                      ),
                    )
                  : const SizedBox(
                      width: 45,
                    ),
            ],
          ),
        ));
  }

  void upDateGradient() {
    gradient = properties.applyProperties(gradient); //
    widget.onChange?.call(gradient);
    _sampleKey = GlobalKey();
    _radialKey = GlobalKey();
    _linearKey = GlobalKey();
    _sweepKey = GlobalKey();
    setState(() {});
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

  GradientSpecification? specifications() {
    return gradientSpecificationDictionary[this];
  }

  static Map<GradientType, GradientSpecification> gradientSpecificationDictionary = {
    GradientType.linear: GradientSpecification(),
    GradientType.radial: GradientSpecification(adjustEnd: false, displayRadius: true),
    GradientType.sweep: GradientSpecification(adjustEnd: false)
  };
}

class GradientSpecification {
  bool adjustBegin;
  bool adjustEnd;
  bool displayRadius;

  GradientSpecification({this.adjustBegin = true, this.adjustEnd = true, this.displayRadius = false});
}

class GradientProperties {
  List<Color> colors;
  List<double> stops;
  AlignmentGeometry begin;
  //AlignmentGeometry center;
  AlignmentGeometry end;
  double radius;

  GradientProperties({
    colors,
    stops,
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    //this.center = Alignment.center,
    this.radius = 0.5,
  })  : colors = colors ??= [Colors.pink, Colors.blue],
        stops = stops ?? [0, 1];

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

  static GradientType getType(Gradient g) {
    GradientType type = g is LinearGradient
        ? GradientType.linear
        : g is RadialGradient
            ? GradientType.radial
            : GradientType.sweep;

    return type;
  }

  applyProperties(Gradient g) {
    return getType(g).get(this);
  }
}
