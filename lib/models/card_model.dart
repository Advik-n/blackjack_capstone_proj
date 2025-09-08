class CardModel {
  final String rank; // e.g. "A", "2", "10", "K"
  final String suit; // e.g. "C", "D", "H", "S"

  CardModel(this.rank, this.suit);

  /// Returns filename like "10C.png"
  String get image => "$rank$suit";
}

class Deck {
  final List<CardModel> _cards = [];

  Deck() {
    final suits = ["C", "D", "H", "S"];
    final ranks = [
      "A",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "10",
      "J",
      "Q",
      "K"
    ];

    for (var suit in suits) {
      for (var rank in ranks) {
        _cards.add(CardModel(rank, suit));
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
