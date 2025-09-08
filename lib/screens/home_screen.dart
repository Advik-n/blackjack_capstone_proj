import 'package:flutter/material.dart';
import '../game/blackjack_logic.dart';
import '../widgets/card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BlackjackGame _game;

  @override
  void initState() {
    super.initState();
    _game = BlackjackGame();
    _game.startGame();
  }

  void _onHit() {
    setState(() {
      _game.playerHit();
    });
  }

  void _onStand() {
    setState(() {
      _game.playerStand();
    });
  }

  void _onRestart() {
    setState(() {
      _game.startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Dealer",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),

            // Dealer cards (manual logic for hiding second card)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_game.dealerHand.isNotEmpty)
                  CardWidget(cardName: _game.dealerHand[0].image),
                if (_game.dealerHand.length > 1)
                  CardWidget(
                    cardName: _game.isGameOver
                      ? _game.dealerHand[1].image
                      : null, // null = card-back
                  ),
              ],
            ),

            const SizedBox(height: 40),
            const Text(
              "Player",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),

            // Player cards
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _game.playerHand
                  .map((card) => CardWidget(cardName: card.image))
                  .toList(),
            ),

            const Spacer(),

            // Buttons
            if (!_game.isGameOver)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _onHit,
                    child: const Text("Hit"),
                  ),
                  ElevatedButton(
                    onPressed: _onStand,
                    child: const Text("Stand"),
                  ),
                ],
              )
            else
              Column(
                children: [
                  Text(
                    _game.resultMessage,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _onRestart,
                    child: const Text("Restart"),
                  ),
                ],
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
