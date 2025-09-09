class CardModel {
  final String suit; // "♠", "♥", "♦", "♣"
  final String rank; // "A", "2", ..., "K"

  CardModel(this.suit, this.rank);

  String get image => "$rank$suit";

  int get value {
    if (["J", "Q", "K"].contains(rank)) return 10;
    if (rank == "A") return 11;
    return int.parse(rank);
  }
}

class Deck {
  final List<CardModel> _cards = [];

  Deck() {
    const suits = ["♠", "♥", "♦", "♣"];
    const ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"];
    for (var suit in suits) {
      for (var rank in ranks) {
        _cards.add(CardModel(suit, rank));
      }
    }
  }

  void shuffle() {
    _cards.shuffle();
  }

  CardModel drawCard() {
    return _cards.removeLast();
  }
}
