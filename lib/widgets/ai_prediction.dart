import 'package:flutter/material.dart';

class AIPrediction extends StatelessWidget {
  const AIPrediction({super.key});

  static const Color cardColor = Color(0xff102A43);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;

        final items = [
          _PredictionData(
            Icons.analytics_rounded,
            "Accuracy",
            "94.5%",
            "Model accuracy",
            Colors.cyanAccent,
          ),
          _PredictionData(
            Icons.cloud_rounded,
            "PM2.5 Level",
            "186 µg/m³",
            "Current level",
            Colors.orangeAccent,
          ),
          _PredictionData(
            Icons.health_and_safety_rounded,
            "Risk Status",
            "HIGH",
            "Current risk",
            Colors.redAccent,
          ),
          _PredictionData(
            Icons.schedule_rounded,
            "Next Update",
            "10 Min",
            "Prediction refresh",
            Colors.purpleAccent,
          ),
        ];

        return Column(
          children: [
            if (compact)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.7,
                ),
                itemBuilder: (context, index) {
                  return _predictionCard(items[index]);
                },
              )
            else
              Row(
                children: List.generate(
                  items.length,
                  (index) {
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index == items.length - 1 ? 0 : 10,
                        ),
                        child: _predictionCard(items[index]),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),

            // AI WARNING
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 11),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AI Risk Alert",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "High smog probability detected. Immediate monitoring is recommended.",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "HIGH RISK",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _predictionCard(_PredictionData data) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              data.icon,
              color: data.color,
              size: 20,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  data.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: data.color,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  data.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PredictionData {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _PredictionData(
    this.icon,
    this.title,
    this.value,
    this.subtitle,
    this.color,
  );
}
