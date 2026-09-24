import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'login_page.dart';

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
    try {
      final jsonString = await rootBundle.loadString(
        'assets/data/latest_risk.json',
      );

      if (!mounted) return;

      setState(() {
        riskData = json.decode(jsonString);
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to load motorway risk data.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const LoginPage(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to logout. Please try again.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
      default:
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

      default:
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

  bool showAlternate(String risk) {
    return risk == "HIGH" || risk == "CRITICAL";
  }

  String motorwayFor(String city) {
    const Map<String, String> motorwayMap = {
      "Islamabad":
          "M-2 (Lahore–Islamabad Motorway)",

      "Lahore":
          "M-2 (Lahore–Islamabad Motorway)",

      "Faisalabad":
          "M-3/M-4 (Faisalabad–Multan Corridor)",

      "Multan":
          "M-3/M-4 (Faisalabad–Multan Corridor)",
    };

    return motorwayMap[city] ?? "Motorway Network";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Motorway Travel Advisory",
        ),
        backgroundColor: const Color(0xff2563EB),
        foregroundColor: Colors.white,

        actions: [
          TextButton.icon(
            onPressed: logout,

            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),

            label: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : riskData.isEmpty
              ? const Center(
                  child: Text(
                    "No motorway risk data available.",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: riskData.length,

                  itemBuilder: (context, index) {
                    final item = riskData[index];

                    final String city =
                        item['city']?.toString() ?? "Unknown";

                    final String risk =
                        item['risk_level']?.toString() ?? "LOW";

                    return Card(
                      margin: const EdgeInsets.only(
                        bottom: 14,
                      ),

                      elevation: 3,

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),

                      child: Padding(
                        padding:
                            const EdgeInsets.all(16),

                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,

                                  backgroundColor:
                                      statusColor(risk),

                                  child: Icon(
                                    statusIcon(risk),
                                    color: Colors.white,
                                    size: 27,
                                  ),
                                ),

                                const SizedBox(
                                  width: 14,
                                ),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,

                                    children: [
                                      Text(
                                        city,

                                        style:
                                            const TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 3,
                                      ),

                                      Text(
                                        motorwayFor(city),

                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors
                                              .grey
                                              .shade600,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 5,
                                      ),

                                      Text(
                                        publicMessage(risk),

                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.w600,
                                          fontSize: 15,
                                          color:
                                              statusColor(
                                            risk,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),

                                  decoration:
                                      BoxDecoration(
                                    color:
                                        statusColor(risk)
                                            .withValues(
                                      alpha: 0.12,
                                    ),

                                    borderRadius:
                                        BorderRadius
                                            .circular(20),
                                  ),

                                  child: Text(
                                    risk,

                                    style: TextStyle(
                                      color:
                                          statusColor(risk),
                                      fontWeight:
                                          FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (showAlternate(risk)) ...[
                              const SizedBox(
                                height: 12,
                              ),

                              Container(
                                padding:
                                    const EdgeInsets.all(
                                  10,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.red.shade50,

                                  borderRadius:
                                      BorderRadius.circular(
                                    10,
                                  ),

                                  border: Border.all(
                                    color:
                                        Colors.red.shade100,
                                  ),
                                ),

                                child: const Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),

                                    SizedBox(
                                      width: 8,
                                    ),

                                    Expanded(
                                      child: Text(
                                        "Motorway travel is not "
                                        "recommended at this time. "
                                        "Please plan your own "
                                        "alternate route if travel "
                                        "is necessary.",

                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
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