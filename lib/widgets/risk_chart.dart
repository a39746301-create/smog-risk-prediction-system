import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RiskChart extends StatelessWidget {
  const RiskChart({super.key});

  static const Color cardColor = Color(0xff102A43);
  static const Color cyanColor = Colors.cyanAccent;
  static const Color purpleColor = Colors.purpleAccent;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Icons.psychology_rounded,
                  color: purpleColor,
                  size: 17,
                ),

                const SizedBox(width: 7),

                const Text(
                  "AI Risk Forecast",
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
                    color: purpleColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "FORECAST",
                    style: TextStyle(
                      color: purpleColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // RISK GRAPH
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 20,
                maxY: 100,

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withValues(alpha: 0.05),
                      strokeWidth: 1,
                    );
                  },
                ),

                titlesData: const FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),

                borderData: FlBorderData(
                  show: false,
                ),

                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData:
                      LineTouchTooltipData(
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        return LineTooltipItem(
                          "Risk ${spot.y.toInt()}%",
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
                      FlSpot(0, 40),
                      FlSpot(1, 55),
                      FlSpot(2, 70),
                      FlSpot(3, 60),
                      FlSpot(4, 85),
                    ],

                    isCurved: true,
                    curveSmoothness: 0.25,

                    // PROFESSIONAL AI GRAPH
                    color: purpleColor,

                    barWidth: 3,

                    isStrokeCapRound: true,

                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          purpleColor.withValues(alpha: 0.18),
                          cyanColor.withValues(alpha: 0.02),
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
                          color: cyanColor,
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
