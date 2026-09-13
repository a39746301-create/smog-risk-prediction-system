import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  List<dynamic> riskData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRiskData();
  }

  Future<void> loadRiskData() async {
    final jsonString = await rootBundle.loadString('assets/data/latest_risk.json');
    setState(() {
      riskData = json.decode(jsonString);
      isLoading = false;
    });
  }

  // Plain-language message for the public — no jargon, no numbers.
  String publicMessage(String risk) {
    switch (risk) {
      case "CRITICAL":
        return "Avoid This Route";
      case "HIGH":
        return "Avoid This Route";
      case "MODERATE":
        return "Drive with Caution";
      case "LOW":
        return "Safe to Travel";
      default: // SAFE
        return "Safe to Travel";
    }
  }

  Color statusColor(String risk) {
    switch (risk) {
      case "CRITICAL":
      case "HIGH":
        return Colors.red;
      case "MODERATE":
        return Colors.orange;
      default: // SAFE, LOW
        return Colors.green;
    }
  }

  IconData statusIcon(String risk) {
    switch (risk) {
      case "CRITICAL":
      case "HIGH":
        return Icons.dangerous;
      case "MODERATE":
        return Icons.warning_amber_rounded;
      default:
        return Icons.check_circle;
    }
  }

  // Only shown when the route should actually be avoided.
  bool showAlternate(String risk) {
    return risk == "HIGH" || risk == "CRITICAL";
  }

  // Approximate city -> motorway mapping based on geography.
  // NOTE: underlying data is per-city, not per-motorway-segment —
  // confirm this mapping with NHMP before final submission.
  String motorwayFor(String city) {
    const Map<String, String> motorwayMap = {
      "Islamabad": "M-2 (Lahore–Islamabad Motorway)",
      "Lahore": "M-2 (Lahore–Islamabad Motorway)",
      "Faisalabad": "M-3/M-4 (Faisalabad–Multan Corridor)",
      "Multan": "M-3/M-4 (Faisalabad–Multan Corridor)",
    };
    return motorwayMap[city] ?? "Motorway Network";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Motorway Travel Advisory"),
        backgroundColor: const Color(0xff2563EB),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: riskData.length,
              itemBuilder: (context, index) {
                final item = riskData[index];
                final String risk = item['risk_level'];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: statusColor(risk),
                              child: Icon(statusIcon(risk), color: Colors.white),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['city'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    motorwayFor(item['city']),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    publicMessage(risk),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: statusColor(risk),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (showAlternate(risk)) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.info_outline, color: Colors.red, size: 20),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Motorway travel is not recommended at this time. "
                                    "Please plan your own alternate route if travel is necessary.",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}