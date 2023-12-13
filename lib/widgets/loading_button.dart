import 'package:flutter/material.dart';

class LoadingButton extends StatelessWidget {
  final String text;
  final Function callBack;
  final Color enableColor;
  final Color disableColor;
  final bool isWaiting;
  final bool enable;
  final TextStyle? textStyle;

  LoadingButton({
    required this.text,
    required this.callBack,
    this.enableColor = Colors.white,
    this.disableColor = Colors.white70,
    this.enable = false,
    this.isWaiting = false,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    var size = Size(MediaQuery.sizeOf(context).width / 1.2, 50);
    return ElevatedButton(
        onPressed: enable ? () => callBack() : null,
        style: ButtonStyle(
            alignment: Alignment.center,
            shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
                (states) => RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            fixedSize:
                MaterialStateProperty.resolveWith<Size>((states) => size),
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) => states.contains(MaterialState.disabled)
                    ? disableColor
                    : enableColor)),
        child: isWaiting
            ? SizedBox(
                width: 20, height: 20, child: CircularProgressIndicator())
            : Text(text,
                style: TextStyle(color: Colors.black, fontSize: 20),
                textAlign: TextAlign.center));
  }
}
