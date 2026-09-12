import 'package:flutter/material.dart';

class MotorwayMonitor extends StatelessWidget {
  const MotorwayMonitor({super.key});

  static const Color cardColor = Color(0xff102A43);
  static const Color cyanColor = Colors.cyanAccent;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 650;

        final items = [
          _MonitorData(
            Icons.location_on_rounded,
            "Stations",
            "35 Active",
            "Monitoring stations",
            cyanColor,
          ),
          _MonitorData(
            Icons.visibility_rounded,
            "Visibility",
            "2.5 KM",
            "Current visibility",
            Colors.blueAccent,
          ),
          _MonitorData(
            Icons.air_rounded,
            "Smog Level",
            "High",
            "Current condition",
            Colors.orangeAccent,
          ),
          _MonitorData(
            Icons.warning_amber_rounded,
            "Alerts",
            "18",
            "Active alerts",
            Colors.redAccent,
          ),
        ];

        if (compact) {
          return GridView.builder(
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
              return _monitorCard(items[index]);
            },
          );
        }

        return Row(
          children: List.generate(
            items.length,
            (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index == items.length - 1 ? 0 : 10,
                  ),
                  child: _monitorCard(items[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _monitorCard(_MonitorData data) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.72),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              data.icon,
              color: data.color,
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  data.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: data.color,
                    fontSize: 16,
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
                    fontSize: 8,
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

class _MonitorData {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _MonitorData(
    this.icon,
    this.title,
    this.value,
    this.subtitle,
    this.color,
  );
}