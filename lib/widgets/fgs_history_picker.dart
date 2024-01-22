import 'package:flutter/material.dart';

class FgsHistoryPicker extends StatelessWidget {
  const FgsHistoryPicker({super.key, this.history, this.onChange});
  final List<Color>? history;
  final Function? onChange;

  @override
  Widget build(BuildContext context) {
    return history == null || history!.isEmpty
        ? Container()
        : ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(25))),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  for (Color c in history!)
                    ColorWidget(
                      backColor: c,
                      onChange: onChange,
                    )
                ]),
              ),
            ));
  }
}

class ColorWidget extends StatelessWidget {
  const ColorWidget({super.key, required this.backColor, this.onChange});
  final Color backColor;
  final Function? onChange;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: backColor),
      ),
      onTap: () {
        onChange?.call(backColor);
      },
    );
  }
}
