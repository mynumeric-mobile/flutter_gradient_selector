import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../helpers/localization.dart';
import '../helpers/popup_helper.dart';

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
          return ColorPicker(
            paletteType: PaletteType.hueWheel,
            pickerColor: _colorMemPopUp,
            onColorChanged: (value) {
              setState(() {
                _colorMemPopUp = value;
              });
            },
            colorHistory: widget.colorHistory,
            onHistoryChanged: (value) {
              setState(() {});
            },
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
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(20),
              color: widget.color,
            ),
          ),
    );
  }
}
