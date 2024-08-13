import 'package:flutter/material.dart';
import 'package:whadoeat/components/gradient_button.dart';

class CustomPage extends StatelessWidget {
  final String imagePath;
  final String subtitle;
  final String title;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final double? imageHeight;
  final double? imageWidth;
  final String? subtitleFontFamily;
  final String? titleFontFamily;

  const CustomPage({
    required this.imagePath,
    required this.subtitle,
    required this.title,
    required this.buttonText,
    required this.onButtonPressed,
    this.imageHeight,
    this.imageWidth,
    this.subtitleFontFamily,
    this.titleFontFamily,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(
                imagePath,
                height: imageHeight ?? 350,  // Varsayılan değer 350
                width: imageWidth ?? 400,    // Varsayılan değer 400
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontFamily: subtitleFontFamily,
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              fontFamily: titleFontFamily,
            ),
          ),
          SizedBox(height: 30),
          GradientButton(
            text: buttonText,
            onPressed: onButtonPressed,
            height: MediaQuery.of(context).size.height * 1 / 13,
            width: MediaQuery.of(context).size.width * 3 / 5,
          ),
        ],
      ),
    );
  }
}


class InfoBox extends StatelessWidget {
  final String title;
  final String content;

  InfoBox({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 90,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.purple),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.0),
          Text(
            content,
            style: TextStyle(fontSize: 14.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class SectionBox extends StatelessWidget {
  final String title;
  final String content;

  SectionBox({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5.0,
            blurRadius: 10.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            content,
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
