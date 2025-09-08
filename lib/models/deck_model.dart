import 'dart:math';
import 'card_model.dart';

class DeckModel {
  final List<CardModel> _cards = [];

  DeckModel() {
    _generateDeck();
    shuffle();
  }

  void _generateDeck() {
    final suits = ['C', 'D', 'H', 'S']; // Clubs, Diamonds, Hearts, Spades
    final ranks = [
      'A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'
    ];

    for (var suit in suits) {
      for (var rank in ranks) {
        _cards.add(CardModel(rank: rank, suit: suit));
      }
    }
  }

  void shuffle() {
    _cards.shuffle(Random());
  }

  CardModel drawCard() {
    if (_cards.isEmpty) {
      throw Exception("Deck is empty!");
    }
    return _cards.removeLast();
  }

  int remainingCards() => _cards.length;
}
