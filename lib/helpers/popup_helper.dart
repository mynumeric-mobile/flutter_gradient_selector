import 'dart:ui';

import 'package:flutter/material.dart';

import 'localization.dart';

class PopupHelper {
  static Widget cancelButton({Function? onPress, required BuildContext context}) => button(
      title: localizationOptions.cancel,
      icon: Icons.cancel,
      onPress: onPress ??
          () {
            Navigator.pop(context);
          });
  static Widget okButton({Function? onPress, required BuildContext context}) =>
      button(title: localizationOptions.ok, icon: Icons.check_circle, onPress: onPress);

  static Widget button({required String title, icon, onPress}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(5.0)),
        onPressed: onPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Icon(icon, size: 20),
            if (icon != null)
              const SizedBox(
                width: 5,
              ),
            Text(title),
          ],
        ));
  }

  static Future<Object?> showDialog(BuildContext context, Widget body,
      {Widget? button1, Widget? button2, Widget? button3, String? title, Widget? titleWidget, IconData? icon}) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4 * anim1.value, sigmaY: 4 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: popupWidget(
              context: ctx,
              icon: icon,
              title: title,
              titleWidget: titleWidget,
              body: body,
              button1: button1,
              button2: button2,
              button3: button3),
        ),
      ),
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static Widget popupWidget(
      {required BuildContext context, String? title, Widget? titleWidget, IconData? icon, body, button1, button2, button3}) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(4.0),
      actionsPadding: const EdgeInsets.all(8.0),
      insetPadding: const EdgeInsets.all(8.0),
      backgroundColor: Theme.of(context).colorScheme.background,
      title: titleWidget ??
          (title != null
              ? Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) Icon(icon, size: 30),
                      if (icon != null)
                        const SizedBox(
                          width: 5,
                        ),
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.headlineSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ))
              : null),
      content: body,
      actions: <Widget>[if (button1 != null) button1, if (button2 != null) button2, if (button3 != null) button3],
    );
  }
}
