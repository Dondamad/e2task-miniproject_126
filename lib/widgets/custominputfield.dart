import 'package:flutter/material.dart';

import '../theme.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;
  final int? maxline;
  final String label;

  const CustomInputField({
    Key? key,
    required this.inputController,
    required this.hintText,
    this.maxline,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: bodyText1.copyWith(color: darkColor),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: inputController,
          maxLines: maxline,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(18.0),
            // fillColor: textWhiteGrey,
            // filled: true,
            hintText: hintText,
            hintStyle: bodyText1.copyWith(color: textGrey),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff6146C6), width: 2),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
          ),
        ),
      ],
    );
  }
}
