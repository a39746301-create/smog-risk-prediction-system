import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class NHMPDashboard extends StatefulWidget {
  const NHMPDashboard({super.key});

  @override
  State<NHMPDashboard> createState() => _NHMPDashboardState();
}

class _NHMPDashboardState extends State<NHMPDashboard> {
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

  Color riskColor(String risk) {
    switch (risk) {
      case "CRITICAL": return Colors.red;
      case "HIGH": return Colors.orange;
      case "MODERATE": return Colors.yellow.shade700;
      case "LOW": return Colors.lightGreen;
      default: return Colors.green;
    }
  }

  Widget buildLegend() {
    final legendItems = [
      {"label": "SAFE", "range": "Visibility > 10.0 km", "color": Colors.green},
      {"label": "LOW", "range": "Visibility < 10.0 km", "color": Colors.lightGreen},
      {"label": "MODERATE", "range": "Visibility < 5.0 km", "color": Colors.yellow.shade700},
      {"label": "HIGH", "range": "Visibility < 2.0 km", "color": Colors.orange},
      {"label": "CRITICAL", "range": "Visibility < 0.5 km", "color": Colors.red},
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Risk Classification Thresholds",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 10),
          ...legendItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: item["color"] as Color,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${item["label"]}: ",
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      "${item["range"]}",
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NHMP Monitoring Dashboard"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                buildLegend(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: riskData.length,
                    itemBuilder: (context, index) {
                      final item = riskData[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: riskColor(item['risk_level']),
                            child: const Icon(Icons.warning, color: Colors.white),
                          ),
                          title: Text(
                            item['city'],
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Text(
                            "Risk: ${item['risk_level']}\n"
                            "Visibility: ${item['visibility_km']} km\n"
                            "${item['recommendation']}",
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}