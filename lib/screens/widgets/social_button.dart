// ===========================
// social_button.dart
// ===========================

import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
          ),

          borderRadius:
          BorderRadius.circular(20),
        ),

        child: Row(
          children: [
            Icon(icon),

            const SizedBox(width: 14),

            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}