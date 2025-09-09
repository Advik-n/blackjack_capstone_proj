import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final String? cardName; // allow null for hidden card

  const CardWidget({super.key, required this.cardName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Image.asset(
        cardName != null
          ? "assets/cards/$cardName.png"
          : "assets/cards/back.png", // Display back.png if card is hidden
        width: 60,
        height: 90,
        fit: BoxFit.cover,
      ),
    );
  }
}
