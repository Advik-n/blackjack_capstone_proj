import 'dart:math';
import '../models/card_model.dart';
import '../models/deck_model.dart';
import '../models/hand_model.dart';
import '../models/scoreboard_model.dart';
import '../models/bet_model.dart';

enum BlackjackResult { playerWin, dealerWin, tie, playerBust, dealerBust }

class BlackjackGame {
  final Random _rand = Random();
  late DeckModel _deck;
  DeckModel get deck => _deck; // For UI to access deck if needed

  late HandModel playerHand;
  late HandModel dealerHand;
  late ScoreboardModel scoreboard;
  late BetModel currentBet;

  bool isGameOver = false;
  BlackjackResult? result;
  bool canSplit = false;
  bool canDoubleDown = true;

  BlackjackGame() {
    scoreboard = ScoreboardModel();
    startNewRound();
  }

  void startNewRound({int? forcedBalance}) {
    _deck = DeckModel();
    playerHand = HandModel([_deck.drawCard(), _deck.drawCard()]);
    dealerHand = HandModel([_deck.drawCard(), _deck.drawCard()]);
    isGameOver = false;
    result = null;
    canSplit = playerHand.canSplit;
    canDoubleDown = true;

    currentBet = BetModel(
      pot: scoreboard.balance,
      amount: 0,
      status: BetStatus.notStarted,
    );

    if (forcedBalance != null) {
      scoreboard.balance = forcedBalance;
    }
  }

  /// Place bet: "full" or "half"
  bool placeBet(String option) {
    if (option != 'full' && option != 'half') return false;
    int betAmt = option == 'full'
        ? scoreboard.balance
        : (scoreboard.balance / 2).floor();
    currentBet = BetModel(
      pot: scoreboard.balance,
      amount: betAmt,
      status: BetStatus.placed,
    );
    return true;
  }

  /// Player hits (draws card to hand)
  void playerHit() {
    if (isGameOver) return;
    playerHand.cards.add(_deck.drawCard());
    canDoubleDown = false;
    if (playerHand.value > 21) {
      isGameOver = true;
      result = BlackjackResult.playerBust;
      _handleResult();
    }
  }

  /// Player stands -> Dealer plays
  void playerStand() {
    if (isGameOver) return;
    _dealerPlay();
    _determineWinner();
    _handleResult();
  }

  /// Double down (double bet, draw one card, stand)
  bool playerDoubleDown() {
    if (!canDoubleDown || currentBet.status != BetStatus.placed) return false;
    currentBet.amount *= 2;
    playerHand.cards.add(_deck.drawCard());
    canDoubleDown = false;
    if (playerHand.value > 21) {
      isGameOver = true;
      result = BlackjackResult.playerBust;
      _handleResult();
      return true;
    }
    playerStand();
    return true;
  }

  /// Split (if possible) - returns two hands
  List<HandModel>? playerSplit() {
    if (!canSplit || playerHand.cards.length != 2) return null;
    var splitHands = [
      HandModel([playerHand.cards[0], _deck.drawCard()]),
      HandModel([playerHand.cards[1], _deck.drawCard()])
    ];
    canSplit = false;
    return splitHands;
  }

  /// "Full" or "Half" pot for betting
  int getBetAmount(String option) {
    return option == 'full' ? scoreboard.balance : (scoreboard.balance / 2).floor();
  }

  /// After game over, resets balance if zero
  void resetIfZero() {
    if (scoreboard.balance <= 0) {
      scoreboard.balance = 200;
      scoreboard.streak = 0;
      scoreboard.streakType = null;
    }
  }

  /// Handles result and updates scoreboard
  void _handleResult() {
    if (result == null) return;
    switch (result!) {
      case BlackjackResult.playerWin:
      case BlackjackResult.dealerBust:
        scoreboard.wins++;
        scoreboard.streakType =
            scoreboard.streakType == 'win' ? 'win' : 'win';
        scoreboard.streak =
            scoreboard.streakType == 'win' ? scoreboard.streak + 1 : 1;
        scoreboard.balance += currentBet.amount;
        scoreboard.betWon += currentBet.amount;
        break;
      case BlackjackResult.dealerWin:
      case BlackjackResult.playerBust:
        scoreboard.losses++;
        scoreboard.streakType =
            scoreboard.streakType == 'loss' ? 'loss' : 'loss';
        scoreboard.streak =
            scoreboard.streakType == 'loss' ? scoreboard.streak + 1 : 1;
        scoreboard.balance -= currentBet.amount;
        scoreboard.betLost += currentBet.amount;
        break;
      case BlackjackResult.tie:
        // no change
        break;
    }
    resetIfZero();
  }

  void _dealerPlay() {
    while (dealerHand.value < 17) {
      dealerHand.cards.add(_deck.drawCard());
    }
  }

  void _determineWinner() {
    isGameOver = true;
    final playerVal = playerHand.value;
    final dealerVal = dealerHand.value;

    if (dealerVal > 21) {
      result = BlackjackResult.dealerBust;
    } else if (playerVal > 21) {
      result = BlackjackResult.playerBust;
    } else if (playerVal > dealerVal) {
      result = BlackjackResult.playerWin;
    } else if (playerVal < dealerVal) {
      result = BlackjackResult.dealerWin;
    } else {
      result = BlackjackResult.tie;
    }
  }
}
