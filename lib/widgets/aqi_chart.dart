import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AQIChart extends StatelessWidget {
  const AQIChart({super.key});

  static const Color cardColor = Color(0xff102A43);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 8),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          // TOP INFO
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.air_rounded,
                  color: Colors.cyanAccent,
                  size: 17,
                ),

                const SizedBox(width: 7),

                const Text(
                  "Current AQI",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "AQI 220 • HIGH",
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // CHART
          Expanded(
            child: LineChart(
              LineChartData(
                minY: 80,
                maxY: 250,

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 40,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withValues(alpha: 0.05),
                      strokeWidth: 1,
                    );
                  },
                ),

                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                    ),
                  ),
                ),

                borderData: FlBorderData(show: false),

                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          "AQI ${spot.y.toInt()}",
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 120),
                      FlSpot(1, 150),
                      FlSpot(2, 180),
                      FlSpot(3, 140),
                      FlSpot(4, 220),
                    ],

                    isCurved: true,
                    curveSmoothness: 0.25,

                    color: Colors.cyanAccent,

                    barWidth: 3,

                    isStrokeCapRound: true,

                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.cyanAccent.withValues(alpha: 0.18),
                          Colors.cyanAccent.withValues(alpha: 0.01),
                        ],
                      ),
                    ),

                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (
                        spot,
                        percent,
                        bar,
                        index,
                      ) {
                        return FlDotCirclePainter(
                          radius: 3.5,
                          color: Colors.cyanAccent,
                          strokeWidth: 2,
                          strokeColor: cardColor,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
