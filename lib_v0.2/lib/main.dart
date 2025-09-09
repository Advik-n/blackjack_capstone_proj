import 'package:flutter/material.dart';
import 'game/blackjack_logic.dart';
import 'models/hand_model.dart';
import 'widgets/card_widget.dart';

void main() {
  runApp(const MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late BlackjackGame _game;
  String betOption = 'full'; // 'full' or 'half'
  bool betPlaced = false;
  List<HandModel>? splitHands;
  int currentSplitHandIndex = 0;

  @override
  void initState() {
    super.initState();
    _game = BlackjackGame();
    _game.startNewRound();
  }

  void _onBet(String option) {
    setState(() {
      betOption = option;
      betPlaced = _game.placeBet(option);
    });
  }

  void _onHit() {
    setState(() {
      if (splitHands != null) {
        splitHands![currentSplitHandIndex].cards.add(_game.deck.drawCard());
        if (splitHands![currentSplitHandIndex].value > 21) {
          _nextSplitHandOrFinish();
        }
      } else {
        _game.playerHit();
      }
    });
  }

  void _onStand() {
    setState(() {
      if (splitHands != null) {
        _nextSplitHandOrFinish();
      } else {
        _game.playerStand();
      }
    });
  }

  void _nextSplitHandOrFinish() {
    if (splitHands != null) {
      if (currentSplitHandIndex < splitHands!.length - 1) {
        currentSplitHandIndex++;
      } else {
        splitHands = null;
        currentSplitHandIndex = 0;
        _game.playerStand();
      }
    }
  }

  void _onRestart() {
    setState(() {
      _game.startNewRound();
      betPlaced = false;
      splitHands = null;
      currentSplitHandIndex = 0;
    });
  }

  void _onDoubleDown() {
    setState(() {
      _game.playerDoubleDown();
    });
  }

  void _onSplit() {
    setState(() {
      splitHands = _game.playerSplit();
      currentSplitHandIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final handToShow =
        splitHands != null ? splitHands![currentSplitHandIndex] : _game.playerHand;
    return Scaffold(
      backgroundColor: Colors.green[700],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Scoreboard
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _scoreTile("Balance", "\$${_game.scoreboard.balance}"),
                _scoreTile("Wins", "${_game.scoreboard.wins}"),
                _scoreTile("Losses", "${_game.scoreboard.losses}"),
                _scoreTile("Streak", "${_game.scoreboard.streak} ${_game.scoreboard.streakType ?? ''}"),
              ],
            ),
            const SizedBox(height: 10),
            // Dealer
            const Text(
              "Dealer",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_game.isGameOver)
                  ...[
                    if (_game.dealerHand.cards.isNotEmpty)
                      CardWidget(cardName: _game.dealerHand.cards[0].image),
                    for (int i = 1; i < _game.dealerHand.cards.length; i++)
                      CardWidget(cardName: null),
                  ]
                else
                  ..._game.dealerHand.cards
                      .map((card) => CardWidget(cardName: card.image))
                      .toList(),
              ],
            ),
            const SizedBox(height: 40),
            // Player
            Text(
              splitHands != null
                  ? "Player (Hand ${currentSplitHandIndex + 1}/${splitHands!.length})"
                  : "Player",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: handToShow.cards
                  .map((card) => CardWidget(cardName: card.image))
                  .toList(),
            ),
            const SizedBox(height: 10),
            Text(
              "Hand value: ${handToShow.value}",
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            // Betting
            if (!betPlaced)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () => _onBet('full'),
                      child: Text("Bet Full (\$${_game.scoreboard.balance})")),
                  ElevatedButton(
                      onPressed: () => _onBet('half'),
                      child: Text("Bet Half (\$${(_game.scoreboard.balance / 2).floor()})")),
                ],
              ),
            if (betPlaced && !_game.isGameOver)
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
                  if (_game.canDoubleDown)
                    ElevatedButton(
                      onPressed: _onDoubleDown,
                      child: const Text("Double Down"),
                    ),
                  if (_game.canSplit)
                    ElevatedButton(
                      onPressed: _onSplit,
                      child: const Text("Split"),
                    ),
                ],
              ),
            if (_game.isGameOver)
              Column(
                children: [
                  Text(
                    _getResultText(),
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

  Widget _scoreTile(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  String _getResultText() {
    switch (_game.result) {
      case BlackjackResult.playerWin:
        return "You Win!";
      case BlackjackResult.dealerWin:
        return "Dealer Wins!";
      case BlackjackResult.tie:
        return "It's a Tie!";
      case BlackjackResult.playerBust:
        return "You Bust!";
      case BlackjackResult.dealerBust:
        return "Dealer Busts! You Win!";
      default:
        return "";
    }
  }
}
