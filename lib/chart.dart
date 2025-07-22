import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'database/database_helper.dart';
import 'models/test_result.dart';

class ProgressChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress Chart'),
      ),
      body: FutureBuilder<List<TestResult>>(
        future: DatabaseHelper().getResults(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final results = snapshot.data!;
          if (results.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          // Prepare data for the line chart (only marks for each test)
          final List<FlSpot> marksSpots = results
              .asMap()
              .entries
              .map((entry) {
                final index = entry.key;
                final result = entry.value;
                return FlSpot(
                  index.toDouble(), // X-axis: Test serial number (implicit)
                  result.correctAnswers.toDouble(), // Y-axis: Marks (correct answers)
                );
              })
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Chart Title
                Text(
                  'Marks in Each Test',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: marksSpots,
                          isCurved: true,
                          color: Colors.blue,
                          barWidth: 4,
                          belowBarData: BarAreaData(show: false),
                          dotData: FlDotData(show: true),
                        ),
                      ],
                      // Customize the axes
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(fontSize: 12),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false), // Hide X-axis titles
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}