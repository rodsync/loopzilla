import 'package:flutter/material.dart';

class OptionTile extends StatelessWidget {

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionTile({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin:
        const EdgeInsets.only(bottom: 16),

        padding:
        const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5E8748)
              : Colors.grey.shade100,

          borderRadius:
          BorderRadius.circular(20),

          border: Border.all(
            color: isSelected
                ? const Color(0xFF5E8748)
                : Colors.grey.shade300,
          ),
        ),

        child: Row(
          children: [

            Expanded(
              child: Text(
                text,

                style: TextStyle(
                  fontSize: 16,

                  color: isSelected
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),

            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,

              color: isSelected
                  ? Colors.white
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}