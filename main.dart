import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(BalloonPopGame());
}

class BalloonPopGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon Pop Game',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int balloonsPopped = 0;
  int balloonsMissed = 0;
  int timeLeft = 120; // 2 minutes in seconds
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          // Show end screen
        }
      });
    });
  }

  void popBalloon(int number) {
    setState(() {
      if (number == getMaxNumber()) {
        balloonsPopped += 2;
      } else {
        balloonsMissed++;
      }
    });
  }

  int getMaxNumber() {
    int maxNumber = 0;
    for (int i = 0; i < 20; i++) {
      final random = Random();
      final number = random.nextInt(10) + 1;
      if (number > maxNumber) {
        maxNumber = number;
      }
    }
    return maxNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balloon Pop Game'),
      ),
      body: Stack(
        children: [
          BackgroundBalloons(onTap: (number) {
            popBalloon(number);
          }),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Time Left: ${timeLeft ~/ 60}:${(timeLeft % 60).toString().padLeft(2, '0')}',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Balloons Popped: $balloonsPopped',
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
              ),
            ),
          ),
          Positioned(
            top: 80,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'Balloons Missed: $balloonsMissed',
                  style: TextStyle(fontSize: 20, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundBalloons extends StatelessWidget {
  final Function(int) onTap;

  const BackgroundBalloons({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: List.generate(20, (index) {
          final random = Random();
          final left = random.nextDouble() * MediaQuery.of(context).size.width;
          final top = random.nextDouble() * MediaQuery.of(context).size.height;
          final size = random.nextInt(50).toDouble(); // Adjust as needed
          final speed = random.nextDouble() * 0.5 + 0.5; // Adjust as needed
          final number = random.nextInt(10) + 1;

          return AnimatedPositioned(
            duration: Duration(seconds: 10),
            left: left,
            top: top,
            child: GestureDetector(
              onTap: () => onTap(number),
              child: Container(
                width: size * 1.5,
                height: size * 2,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size),
                    topRight: Radius.circular(size),
                    bottomLeft: Radius.circular(size * 2),
                    bottomRight: Radius.circular(size * 2),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      fontSize: size / 1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
