import 'package:flutter/material.dart';

class AlertTable extends StatelessWidget {
  const AlertTable({super.key});

  static const Color cardColor = Color(0xff102A43);
  static const Color cyanColor = Colors.cyanAccent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _alertRow(
          icon: Icons.warning_amber_rounded,
          location: "M-2 Motorway",
          issue: "Heavy Smog",
          aqi: "AQI 245",
          time: "2 min ago",
          level: "HIGH",
          color: Colors.redAccent,
        ),

        _alertRow(
          icon: Icons.air_rounded,
          location: "Islamabad Zone",
          issue: "Poor Air Quality",
          aqi: "AQI 168",
          time: "8 min ago",
          level: "MEDIUM",
          color: Colors.orangeAccent,
        ),

        _alertRow(
          icon: Icons.warning_amber_rounded,
          location: "Rawalpindi Sector",
          issue: "PM2.5 Increased",
          aqi: "AQI 185",
          time: "15 min ago",
          level: "HIGH",
          color: Colors.redAccent,
        ),

        _alertRow(
          icon: Icons.visibility_rounded,
          location: "Lahore Route",
          issue: "Visibility Low",
          aqi: "AQI 210",
          time: "24 min ago",
          level: "CRITICAL",
          color: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget _alertRow({
    required IconData icon,
    required String location,
    required String issue,
    required String aqi,
    required String time,
    required String level,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          // ALERT ICON
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          // LOCATION + ISSUE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  issue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // AQI
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                aqi,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                time,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 9,
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          // SEVERITY
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: color.withValues(alpha: 0.18),
              ),
            ),
            child: Text(
              level,
              style: TextStyle(
                color: color,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
