import 'package:flutter/material.dart';

// 定義玩家類別
class Player {
  String name; // 玩家姓名
  String? choice; // 玩家選擇,可以為null
  bool hasChanged; // 是否已經變拳

  Player({required this.name, this.choice, this.hasChanged = false});
}

// 定義遊戲頁面
class GuessGamePage extends StatefulWidget {
  @override
  _GuessGamePageState createState() => _GuessGamePageState();
}

class _GuessGamePageState extends State<GuessGamePage> {
  static const List<String> options = ['石頭', '剪刀', '布']; // 選項列表
  Player player1 = Player(name: '玩家1'); // 玩家1
  Player player2 = Player(name: '玩家2'); // 玩家2
  String result = ''; // 遊戲結果
  bool isGameOver = false; // 遊戲是否結束
  int currentStep = 0; // 當前步驟

  // 處理玩家選擇
  void handleChoice(Player player, String choice) {
    setState(() {
      player.choice = choice;
      currentStep++;
    });
  }

  // 處理玩家變拳
  void handleChange(Player player) {
    setState(() {
      player.hasChanged = true;
    });
  }

  // 判斷勝負
  void judge() {
    setState(() {
      if (player1.choice == player2.choice) {
        result = '平手！';
      } else if ((player1.choice == '石頭' && player2.choice == '剪刀') ||
          (player1.choice == '剪刀' && player2.choice == '布') ||
          (player1.choice == '布' && player2.choice == '石頭')) {
        result = '${player1.name}獲勝！';
      } else {
        result = '${player2.name}獲勝！';
      }
      isGameOver = true;
      currentStep++;
    });
  }

  // 重置遊戲
  void reset() {
    setState(() {
      player1 = Player(name: '玩家1');
      player2 = Player(name: '玩家2');
      result = '';
      isGameOver = false;
      currentStep = 0;
    });
  }

  // 獲取拳的圖標
  IconData getChoiceIcon(String? choice) {
    switch (choice) {
      case '石頭':
        return Icons.sports_kabaddi;
      case '剪刀':
        return Icons.content_cut;
      case '布':
        return Icons.waves;
      default:
        return Icons.question_mark;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('猜拳遊戲')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentStep == 0)
              Column(
                children: [
                  Text('玩家1,請選擇你的手勢:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: options.map((option) {
                      return ElevatedButton(
                        onPressed: () => handleChoice(player1, option),
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ],
              ),
            if (currentStep == 1)
              Column(
                children: [
                  Text('玩家2,請選擇你的手勢:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: options.map((option) {
                      return ElevatedButton(
                        onPressed: () => handleChoice(player2, option),
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ],
              ),
            if (currentStep == 2 && !player1.hasChanged)
              Column(
                children: [
                  Text('玩家1,是否要變拳?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => handleChange(player1),
                        child: Text('變拳'),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {
                          currentStep++;
                        }),
                        child: Text('不變拳'),
                      ),
                    ],
                  ),
                ],
              ),
            if (currentStep == 2 && player1.hasChanged)
              Column(
                children: [
                  Text('玩家1,請選擇新的手勢:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: options.map((option) {
                      return ElevatedButton(
                        onPressed: () => setState(() {
                          player1.choice = option;
                          currentStep++;
                        }),
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ],
              ),
            if (currentStep == 3 && !player2.hasChanged)
              Column(
                children: [
                  Text('玩家2,是否要變拳?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => handleChange(player2),
                        child: Text('變拳'),
                      ),
                      ElevatedButton(
                        onPressed: () => judge(),
                        child: Text('不變拳'),
                      ),
                    ],
                  ),
                ],
              ),
            if (currentStep == 3 && player2.hasChanged)
              Column(
                children: [
                  Text('玩家2,請選擇新的手勢:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: options.map((option) {
                      return ElevatedButton(
                        onPressed: () => setState(() {
                          player2.choice = option;
                          judge();
                        }),
                        child: Text(option),
                      );
                    }).toList(),
                  ),
                ],
              ),
            if (currentStep == 4 && isGameOver)
              Column(
                children: [
                  Text(
                    '結果：$result',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Icon(getChoiceIcon(player1.choice), size: 48),
                          Text('${player1.name}出${player1.choice}'),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(getChoiceIcon(player2.choice), size: 48),
                          Text('${player2.name}出${player2.choice}'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: reset,
                      child: const Text('再玩一局'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// 主程式
void main() {
  runApp(MaterialApp(
    home: GuessGamePage(),
  ));
}
