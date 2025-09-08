import 'dart:math';
import '../models/card_model.dart';

class BlackjackGame {
  late Deck _deck;
  List<CardModel> playerHand = [];
  List<CardModel> dealerHand = [];
  bool isGameOver = false;
  String resultMessage = "";

  void startGame() {
    _deck = Deck();
    _deck.shuffle();

    playerHand = [_deck.drawCard(), _deck.drawCard()];
    dealerHand = [_deck.drawCard(), _deck.drawCard()];
    isGameOver = false;
    resultMessage = "";
  }

  void playerHit() {
    if (isGameOver) return;

    playerHand.add(_deck.drawCard());

    if (_handValue(playerHand) > 21) {
      isGameOver = true;
      resultMessage = "Player Busts! Dealer Wins 😢";
    }
  }

  void playerStand() {
    if (isGameOver) return;

    while (_handValue(dealerHand) < 17) {
      dealerHand.add(_deck.drawCard());
    }

    _determineWinner();
  }

  void _determineWinner() {
    final playerValue = _handValue(playerHand);
    final dealerValue = _handValue(dealerHand);

    isGameOver = true;

    if (dealerValue > 21) {
      resultMessage = "Dealer Busts! Player Wins 🎉";
    } else if (playerValue > dealerValue) {
      resultMessage = "Player Wins 🎉";
    } else if (playerValue < dealerValue) {
      resultMessage = "Dealer Wins 😢";
    } else {
      resultMessage = "It’s a Tie 🤝";
    }
  }

  int _handValue(List<CardModel> hand) {
    int value = 0;
    int aces = 0;

    for (var card in hand) {
      if (["J", "Q", "K"].contains(card.rank)) {
        value += 10;
      } else if (card.rank == "A") {
        value += 11;
        aces += 1;
      } else {
        value += int.parse(card.rank);
      }
    }

    while (value > 21 && aces > 0) {
      value -= 10;
      aces -= 1;
    }

    return value;
  }
}

