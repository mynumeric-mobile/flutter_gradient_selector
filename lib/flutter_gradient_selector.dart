library flutter_gradient_selector;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gradient_selector/alignment_picker.dart';

import 'helpers/localization.dart';
import 'widgets/fgs_color_picker.dart';

enum CornerMode { begin, end, none }

List<Color> colorHistory = [];

///
/// GradientSelector widget
///
class GradientSelector extends StatefulWidget {
  const GradientSelector(
      {super.key,
      required this.color,
      this.onChange,
      this.lang,
      this.history,
      this.gradientMode = true,
      this.allowChangeMode = true});

  final dynamic color;
  final Function? onChange;
  final LocalisationCode? lang;
  final List<Color>? history;
  final bool gradientMode;
  final bool allowChangeMode;

  @override
  State<GradientSelector> createState() => _GradientSelectorState();
}

class _GradientSelectorState extends State<GradientSelector> with TickerProviderStateMixin {
  late Gradient gradient;
  late Color color;
  CornerMode _cornerMode = CornerMode.none;
  late GradientProperties properties;
  String _explanation = '';
  bool solidColorMode = true;

  GlobalKey _sampleKey = GlobalKey();
  GlobalKey _linearKey = GlobalKey();
  GlobalKey _radialKey = GlobalKey();
  GlobalKey _sweepKey = GlobalKey();

  @override
  void initState() {
    setLocalizationOptions(widget.lang);

    solidColorMode = !widget.gradientMode;

    if (widget.color is Gradient) {
      gradient = widget.color as Gradient;
      color = Colors.amber;
    } else {
      color = widget.color as Color;
      gradient = const LinearGradient(colors: [Colors.green, Colors.amber]);
    }

    properties = GradientProperties.fromGradient(gradient);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      GradientSpecification specif = GradientProperties.getType(gradient).specifications()!;
      return SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _explanation,
                  textScaler: const TextScaler.linear(0.8),
                ),
              ),
              if (widget.allowChangeMode && !solidColorMode)
                ElevatedButton(
                    onPressed: () {
                      solidColorMode = true;
                      setState(() {});
                    },
                    child: Text(
                      localizationOptions.solid,
                    )),
              if (widget.allowChangeMode && solidColorMode)
                ElevatedButton(
                    onPressed: () {
                      solidColorMode = false;
                      setState(() {});
                    },
                    child: Text(
                      localizationOptions.gradient,
                    ))
            ],
          ),
          solidColorMode
              ? SolidColorPicker(
                  color: color,
                  colorHistory: widget.history,
                  onChange: (value) {
                    color = value;
                    widget.onChange?.call(value);
                    setState(() {});
                  },
                )
              : SizedBox(height: constraints.maxHeight, child: gradientWidget(specif, constraints))
        ]),
      );
    });
  }

  Column gradientWidget(GradientSpecification specif, BoxConstraints constraints) {
    return Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
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
                    activeColor: Colors.grey,
                    thumbColor: Colors.blueGrey,
                    inactiveColor: Colors.black45,
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
              gradient = GradientType.LinearGradient.get(properties);
              _explanation = localizationOptions.linearGradient;
              _cornerMode = CornerMode.none;
              widget.onChange?.call(gradient);
              setState(() {});
            },
            child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  gradient: GradientType.LinearGradient.get(properties),
                  //       )
                )),
          ),
          const SizedBox(
            width: 5,
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
              gradient = GradientType.RadialGradient.get(properties);
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
                  gradient: GradientType.RadialGradient.get(properties),
                  //       )
                )),
          ),
          const SizedBox(
            width: 5,
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
              gradient = GradientType.SweepGradient.get(properties);
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
                  gradient: GradientType.SweepGradient.get(properties),
                  //       )
                )),
          ),
          const SizedBox(
            width: 5,
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
            colorHistory: widget.history,
            child: Container(
              alignment: AlignmentDirectional.center,
              width: 30,
              height: 30,
              child: const Text(
                "+",
                style: TextStyle(fontSize: 20, color: Colors.grey),
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
    ]);
  }

  ///
  /// color tile
  ///
  colorWidget(index, selected, specif, constraints) {
    var alignAjustable = index == 0 || ((index == properties.colors.length - 1) && specif.adjustEnd);
    return Padding(
        key: Key('$index'),
        padding: const EdgeInsets.only(top: 3),
        child: Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(width: 1),
            color: selected ? Theme.of(context).primaryColor.withAlpha(100) : Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: WsColorPicker(
                  color: properties.colors[index],
                  onChange: (value) {
                    properties.colors[index] = value;
                    upDateGradient();
                  },
                  title: localizationOptions.selectColor,
                  colorHistory: widget.history,
                ),
              ),
              Expanded(
                  child: index < properties.colors.length - 1
                      ? SliderTheme(
                          data: SliderThemeData(
                              overlayShape: SliderComponentShape.noThumb,
                              activeTrackColor: properties.colors[index],
                              thumbColor: Colors.blueGrey,
                              inactiveTrackColor: Colors.black45),
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
                        color: Colors.grey,
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

// ignore: constant_identifier_names
enum GradientType { LinearGradient, RadialGradient, SweepGradient }

extension GradientExtension on GradientType {
  Gradient get(GradientProperties prop) {
    switch (this) {
      case GradientType.LinearGradient:
        return LinearGradient(colors: prop.colors, stops: prop.stops, begin: prop.begin, end: prop.end);
      case GradientType.RadialGradient:
        return RadialGradient(colors: prop.colors, stops: prop.stops, center: prop.begin, radius: prop.radius);
      case GradientType.SweepGradient:
        return SweepGradient(colors: prop.colors, stops: prop.stops, center: prop.begin);
    }
  }

  GradientSpecification? specifications() {
    return gradientSpecificationDictionary[this];
  }

  static Map<GradientType, GradientSpecification> gradientSpecificationDictionary = {
    GradientType.LinearGradient: GradientSpecification(),
    GradientType.RadialGradient: GradientSpecification(adjustEnd: false, displayRadius: true),
    GradientType.SweepGradient: GradientSpecification(adjustEnd: false)
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
  int? typeIndex;

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

    p.typeIndex = p.typeIndex = GradientType.SweepGradient.index;

    if (g is LinearGradient) {
      p.typeIndex = GradientType.LinearGradient.index;
      p.begin = g.begin;
      p.end = g.end;
    } else if (g is RadialGradient) {
      p.typeIndex = GradientType.RadialGradient.index;
      p.begin = g.center;
      p.radius = g.radius;
    }

    // var s = p.serialize();

    // var ds = GradientProperties.deserialize(s);

    return p;
  }

  static GradientType getType(Gradient g) {
    GradientType type = g is LinearGradient
        ? GradientType.LinearGradient
        : g is RadialGradient
            ? GradientType.RadialGradient
            : GradientType.SweepGradient;

    return type;
  }

  applyProperties(Gradient g) {
    return getType(g).get(this);
  }

  Map<String, dynamic> serialize() {
    return {
      "type": typeIndex,
      "begin": contract(begin),
      "end": contract(end),
      "radius": radius,
      "colors": colors.map((c) => c.toString().split('(0x')[1].split(')')[0]).toList(),
      "stops": stops,
    };
  }

  String contract(dynamic v) {
    //return v.toString().substring(v.runtimeType.toString().length + 1);
    return v.toString().split('.')[1];
  }

  static deserialize(Map<String, dynamic> s) {
    var type = GradientType.values[s["type"]];
    List<Color> colors = s["colors"].map<Color>((c) => Color(int.parse(c, radix: 16))).toList();
    List<double> stops = s["stops"].map<double>((e) => e as double).toList();

    var prop = GradientProperties(
      begin: getAlignment(s["begin"]),
      end: getAlignment(s["end"]),
      radius: s["radius"],
      colors: colors,
      stops: stops,
    );

    return type.get(prop);
  }

  static getAlignment(value) {
    switch (value) {
      case "bottomCenter":
        return Alignment.bottomCenter;
      case "bottomLeft":
        return Alignment.bottomLeft;
      case "bottomRight":
        return Alignment.bottomRight;
      case "center":
        return Alignment.center;
      case "centerLeft":
        return Alignment.centerLeft;
      case "centerRight":
        return Alignment.centerRight;
      case "topCenter":
        return Alignment.topCenter;
      case "topLeft":
        return Alignment.topLeft;
      case "topRight":
        return Alignment.topRight;
    }
  }
}
