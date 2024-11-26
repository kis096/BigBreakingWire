import 'package:flutter/material.dart';
import 'package:marquee_plus/marquee.dart';
import '../models/article_model.dart';
import '../utils/design_tokens.dart';

class LiveTickerWidget extends StatelessWidget {
  final List<Article> articles;

  const LiveTickerWidget({Key? key, required this.articles}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Concatenate all article titles into a single string separated by bullet points
    final tickerText = articles.map((article) => article.title).join(' • ');

    return Container(
      color: primaryRedColor,
      height: 30,
      child: Marquee(
        text: tickerText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        scrollAxis: Axis.horizontal,
        blankSpace: 20.0,
        velocity: 50.0,
        pauseAfterRound: const Duration(seconds: 1),
        startPadding: 10.0,
        accelerationDuration: const Duration(seconds: 1),
        accelerationCurve: Curves.linear,
        decelerationDuration: const Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
      ),
    );
  }
}
