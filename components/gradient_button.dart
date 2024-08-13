import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;

  GradientButton({
    required this.text,
    required this.onPressed,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.red,
                  Colors.purple,
                ]),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(""),
              Text(
                text,
                style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: const Icon(
                    Icons.arrow_right_alt_outlined,
                    size: 25.0,
                    color: Colors.green,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
