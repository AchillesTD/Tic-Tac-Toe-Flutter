import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ""));
  bool xTurn = true;
  String winner = "";

  void markCell(int row, int col) {
  if (board[row][col].isEmpty && winner.isEmpty) {
    setState(() {
      board[row][col] = "X";
      checkWinner();
    });
    Future.delayed(Duration(milliseconds: 500), () {
      if (winner.isEmpty) {
        setState(() {
          makeComputerMove();
          checkWinner();
        });
      }
    });
  }
}


  void makeComputerMove() {
    List<int> emptyCells = [];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j].isEmpty) {
          emptyCells.add(i * 3 + j);
        }
      }
    }
    if (emptyCells.isNotEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(emptyCells.length);
      int row = emptyCells[randomIndex] ~/ 3;
      int col = emptyCells[randomIndex] % 3;
      board[row][col] = "O";
    }
  }

  void checkWinner() {
  for (var i = 0; i < 3; i++) {
    // Check rows and columns
    if (_checkLine(board[i][0], board[i][1], board[i][2])) return;
    if (_checkLine(board[0][i], board[1][i], board[2][i])) return;
  }

  // Check diagonals
  if (_checkLine(board[0][0], board[1][1], board[2][2])) return;
  if (_checkLine(board[0][2], board[1][1], board[2][0])) return;

  // Check for a draw
  if (!board.any((row) => row.any((cell) => cell.isEmpty))) {
    winner = "Draw";
  }
}

bool _checkLine(String a, String b, String c) {
  if (a.isNotEmpty && a == b && a == c) {
    winner = a;
    return true;
  }
  return false;
}

  void resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ""));
      xTurn = true;
      winner = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Tic Tac Toe', style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (winner.isNotEmpty)
              Text(
                '${winner == "Draw" ? "It\'s a Draw!" : "$winner wins!"}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            Container(
              width: 200,
              height: 200,
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemBuilder: (BuildContext context, int index) {
                  int row = index ~/ 3;
                  int col = index % 3;
                  return GestureDetector(
                    onTap: () => markCell(row, col),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Center(
                        child: Text(
                          board[row][col],
                          style: TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: 9,
              ),
            ),
            SizedBox(height: 20),
            if (winner.isEmpty)
              Text(
                'Next Player: ${xTurn ? "X" : "O"}',
                style: TextStyle(fontSize: 24),
              ),
            SizedBox(height: 20),
            if (winner.isNotEmpty)
              ElevatedButton(
                onPressed: resetGame,
                child: Text('Play Again'),
              ),
          ],
        ),
      ),
    );
  }
}