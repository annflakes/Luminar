import 'package:flutter/material.dart';
import 'dart:math';

class ColorNamingPracticePage extends StatefulWidget {
  @override
  _ColorNamingPracticePageState createState() =>
      _ColorNamingPracticePageState();
}

class _ColorNamingPracticePageState extends State<ColorNamingPracticePage> {
  final List<Map<String, Color>> colorOptions = [
    {'Red': Colors.red},
    {'Blue': Colors.blue},
    {'Green': Colors.green},
    {'Yellow': Colors.yellow},
    {'Purple': Colors.purple},
    {'Orange': Colors.orange},
    {'Pink': Colors.pink},
    {'Brown': Colors.brown},
  ];

  late Map<String, Color> currentColor;
  late List<String> currentOptions;
  String? feedbackMessage;

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
  }

  void generateNewQuestion() {
    final random = Random();
    currentColor = colorOptions[random.nextInt(colorOptions.length)];

    List<String> allOptions =
        colorOptions.map((option) => option.keys.first).toList();
    allOptions.remove(currentColor.keys.first); // Remove correct answer
    allOptions.shuffle();

    currentOptions = [currentColor.keys.first, ...allOptions.take(3)];
    currentOptions.shuffle(); // Shuffle to randomize positions

    feedbackMessage = null;
  }

  void checkAnswer(String selectedColorName) {
    setState(() {
      feedbackMessage = currentColor.keys.first == selectedColorName
          ? "Correct! It's ${currentColor.keys.first}. 🎉"
          : "Wrong! It's actually ${currentColor.keys.first}. Try again.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Color Naming Practice')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Identify the Color!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                height: 150,
                width: double.infinity,
                color: currentColor.values.first,
              ),
              SizedBox(height: 20),
              ...currentOptions.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SizedBox(
                    width: double.infinity, // Buttons take full width
                    child: ElevatedButton(
                      onPressed: () => checkAnswer(option),
                      child: Text(option),
                    ),
                  ),
                );
              }).toList(),
              if (feedbackMessage != null) ...[
                SizedBox(height: 20),
                Text(
                  feedbackMessage!,
                  style: TextStyle(
                    fontSize: 18,
                    color: feedbackMessage!.contains('Correct')
                        ? Colors.green
                        : Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      generateNewQuestion();
                    });
                  },
                  child: Text('Next Color'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
