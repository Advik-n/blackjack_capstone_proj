import 'card_model.dart';

class HandModel {
  List<CardModel> cards;

  HandModel(this.cards);

  int get value {
    int total = 0;
    int aces = 0;
    for (var card in cards) {
      if (card.rank == "A") {
        aces += 1;
        total += 11;
      } else if (["J", "Q", "K"].contains(card.rank)) {
        total += 10;
      } else {
        total += int.parse(card.rank);
      }
    }
    while (total > 21 && aces > 0) {
      total -= 10;
      aces -= 1;
    }
    return total;
  }

  bool get canSplit {
    return cards.length == 2 && cards[0].rank == cards[1].rank;
  }
}
