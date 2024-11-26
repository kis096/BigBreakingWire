import 'dart:ui';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;
  final double width; // The width of the button

  const CustomButton({
    Key? key,
    required this.text,
    required this.isLoading,
    required this.onPressed,
    required this.width,
    required int height, // Required width parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the primary color from the current theme
    final buttonColor = Theme.of(context).primaryColor;

    return SizedBox(
      width: width, // Set button width
      height: 60, //Set a default height for the button
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed, // Disable button if loading
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading
              ? Colors.grey
              : buttonColor, // Button color based on theme
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Text color stays white
                ),
              ),
      ),
    );
  }
}
