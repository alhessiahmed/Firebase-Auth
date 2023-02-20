import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.label,
    this.suffixIcon,
    this.textInputAction = TextInputAction.next,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.isPhoneNumber = false,
  }) : super(key: key);

  final TextEditingController controller;
  final Widget? suffixIcon;
  final String label;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isPassword;
  final bool isPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          controller: controller,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required *';
            } else if (isPassword && value.length < 6) {
              return 'Password must be 6 characters at least!';
            } else if (isPhoneNumber && value.length != 9) {
              return 'Phone number must be 9 characters';
            }
            return null;
          },
          maxLength: isPhoneNumber ? 9 : null,
          textInputAction: textInputAction,
          keyboardType: isPhoneNumber ? TextInputType.number : keyboardType,
          obscureText: obscureText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: Colors.purple,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            // isDense: true,
            suffixIcon: suffixIcon,
            prefix: isPhoneNumber
                ? Container(
                    height: 26,
                    width: 70,
                    alignment: Alignment.center,
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    margin: const EdgeInsetsDirectional.only(end: 12),
                    decoration: const BoxDecoration(
                      border: BorderDirectional(
                        end: BorderSide(width: 1),
                      ),
                    ),
                    child: const Text(
                      '+970',
                      style: TextStyle(
                        letterSpacing: 1.2,
                        fontSize: 16,
                      ),
                    ),
                  )
                : null,
            counterText: '',
            fillColor: Colors.grey[300],
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
