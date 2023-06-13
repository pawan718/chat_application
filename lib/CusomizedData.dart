import 'package:flutter/material.dart';

class CustomizedTextField extends StatelessWidget {
  const CustomizedTextField(
      {super.key, this.onChanged, required this.hinttext, this.validator});
  final String hinttext;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextFormField(
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hinttext,
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3, color: Color(0xffffc3c3)),
              borderRadius: BorderRadius.circular(30)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3, color: Color(0xffffc3c3)),
              borderRadius: BorderRadius.circular(30)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3, color: Color(0xffffc3c3)),
              borderRadius: BorderRadius.circular(30)),
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 3, color: Colors.red),
              borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}

class LoginSIngupButton extends StatelessWidget {
  const LoginSIngupButton({super.key, required this.text, this.onPressed});
  final String text;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(colors: [
                Color(0xffffe1e1),
                Color(0xffffc3c3),
                Color(0xffff9d9d),
              ])),
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}
