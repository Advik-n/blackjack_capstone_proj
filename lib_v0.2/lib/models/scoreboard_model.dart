class ScoreboardModel {
  int wins = 0;
  int losses = 0;
  int betWon = 0;
  int betLost = 0;
  int balance = 200;
  int streak = 0;
  String? streakType; // "win" or "loss"

  Map<String, dynamic> toJson() => {
    'wins': wins,
    'losses': losses,
    'betWon': betWon,
    'betLost': betLost,
    'balance': balance,
    'streak': streak,
    'streakType': streakType,
  };
}
