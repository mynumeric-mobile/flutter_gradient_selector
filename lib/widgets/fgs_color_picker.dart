import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart' as hsv;
import '../helpers/localization.dart';
import '../helpers/popup_helper.dart';
import 'fgs_history_picker.dart';

// ignore: must_be_immutable
class WsColorPicker extends StatefulWidget {
  const WsColorPicker({super.key, required this.color, this.onChange, required this.title, this.child, this.colorHistory});
  final Color color;
  final String title;
  final Function? onChange;
  final Widget? child;
  final List<Color>? colorHistory;

  @override
  State<WsColorPicker> createState() => _WsColorPickerState();
}

class _WsColorPickerState extends State<WsColorPicker> {
  late Color _colorMemPopUp;

  @override
  void initState() {
    _colorMemPopUp = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        PopupHelper.showDialog(icon: Icons.color_lens, context,
            StatefulBuilder(builder: (BuildContext context, StateSetter popupState) {
          return SingleChildScrollView(
            child: SolidColorPicker(
              color: _colorMemPopUp,
              colorHistory: widget.colorHistory,
              onChange: (value) {
                _colorMemPopUp = value;
                setState(() {});
              },
            ),
          );
        }),
            title: localizationOptions.selectColor,
            button2: PopupHelper.okButton(
                context: context,
                onPress: () {
                  Navigator.pop(context);
                  widget.onChange?.call(_colorMemPopUp);
                }),
            button1: PopupHelper.cancelButton(
                context: context,
                onPress: () {
                  Navigator.pop(
                    context,
                  );
                }));
      },
      clipBehavior: Clip.none,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(1.0),
        minimumSize: const Size(0, 0),
      ),
      child: widget.child ??
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(20),
              color: widget.color,
            ),
          ),
    );
  }
}

class SolidColorPicker extends StatefulWidget {
  const SolidColorPicker({super.key, required this.color, required this.colorHistory, this.onChange});

  final Color color;
  final List<Color>? colorHistory;
  final Function? onChange;

  @override
  State<SolidColorPicker> createState() => _SolidColorPickerState();
}

class _SolidColorPickerState extends State<SolidColorPicker> {
  var hsvcp = GlobalKey();
  late Color _color;

  @override
  void initState() {
    _color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var portrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      //height: portrait ? 570 : 400, //max(portrait ? 550 : 400, MediaQuery.of(context).size.height * 0.9),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          hsv.ColorPicker(
            key: hsvcp,
            color: _color,
            onChanged: (value) {
              _color = value;
              widget.onChange?.call(value);
            },
            initialPicker: hsv.Picker.wheel,
          ),
          const SizedBox(
            height: 10,
          ),
          FgsHistoryPicker(
              history: widget.colorHistory,
              onChange: (value) {
                _color = value;
                hsvcp = GlobalKey();
                setState(() {});
                widget.onChange?.call(value);
              })
        ],
      ),
    );
  }
}
