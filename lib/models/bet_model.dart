enum BetStatus { notStarted, placed, resolved }

class BetModel {
  int pot;
  int amount;
  BetStatus status;

  BetModel({
    required this.pot,
    required this.amount,
    required this.status,
  });
}
