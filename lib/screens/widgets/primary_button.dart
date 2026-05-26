import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {

  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: double.infinity,

      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor:
          const Color(0xFF5E8748),

          disabledBackgroundColor:
          Colors.grey.shade300,

          padding:
          const EdgeInsets.symmetric(
            vertical: 18,
          ),

          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20),
          ),
        ),

        child: Text(
          text,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}