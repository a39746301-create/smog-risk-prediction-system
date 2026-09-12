import 'package:flutter/material.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({super.key});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  // ============================================================
  // THEME
  // ============================================================

  static const Color backgroundColor = Color(0xff081426);
  static const Color cardColor = Color(0xff102A43);
  static const Color cardLightColor = Color(0xff132B43);
  static const Color cyanColor = Colors.cyanAccent;

  final TextEditingController searchController =
      TextEditingController();

  String selectedFilter = "All";

  // ============================================================
  // ALERT DATA
  // ============================================================

  final List<Map<String, dynamic>> alerts = [
    {
      "id": 1,
      "title": "High Smog Level Detected",
      "location": "Rawalpindi Motorway",
      "aqi": 245,
      "severity": "High",
      "time": "2 min ago",
      "status": "Active",
      "description":
          "Air quality has reached a dangerous level. Immediate monitoring is recommended.",
      "icon": Icons.warning_rounded,
    },
    {
      "id": 2,
      "title": "Poor Air Quality",
      "location": "Islamabad Sector F-8",
      "aqi": 168,
      "severity": "Medium",
      "time": "8 min ago",
      "status": "Active",
      "description":
          "PM2.5 concentration is above the recommended safety level.",
      "icon": Icons.air_rounded,
    },
    {
      "id": 3,
      "title": "Visibility Low",
      "location": "M-2 Motorway",
      "aqi": 132,
      "severity": "Medium",
      "time": "15 min ago",
      "status": "Acknowledged",
      "description":
          "Low visibility has been detected due to heavy smog conditions.",
      "icon": Icons.visibility_rounded,
    },
    {
      "id": 4,
      "title": "Air Quality Improved",
      "location": "M-3 Faisalabad",
      "aqi": 78,
      "severity": "Low",
      "time": "32 min ago",
      "status": "Resolved",
      "description":
          "Air quality has returned to an acceptable level.",
      "icon": Icons.check_circle_rounded,
    },
    {
      "id": 5,
      "title": "Critical AQI Detected",
      "location": "Lahore Ring Road",
      "aqi": 310,
      "severity": "High",
      "time": "45 min ago",
      "status": "Active",
      "description":
          "Critical AQI level detected. Immediate action is recommended.",
      "icon": Icons.dangerous_rounded,
    },
    {
      "id": 6,
      "title": "Moderate AQI Detected",
      "location": "Islamabad Blue Area",
      "aqi": 118,
      "severity": "Low",
      "time": "1 hour ago",
      "status": "Resolved",
      "description":
          "Air quality was moderate but has now returned to a stable condition.",
      "icon": Icons.air_rounded,
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        titleSpacing: 20,

        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications_active_rounded,
                color: Colors.redAccent,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              "Smog Alerts",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),

        actions: [
          IconButton(
            tooltip: "Refresh Alerts",
            onPressed: _refreshAlerts,
            icon: const Icon(
              Icons.refresh_rounded,
            ),
          ),

          const SizedBox(width: 5),

          PopupMenuButton<String>(
            tooltip: "More options",
            color: cardColor,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
            onSelected: (value) {
              if (value == "acknowledge") {
                _acknowledgeAll();
              } else if (value == "clear") {
                _clearFilters();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: "acknowledge",
                child: Row(
                  children: [
                    Icon(
                      Icons.done_all_rounded,
                      color: Colors.greenAccent,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Acknowledge All",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: "clear",
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_alt_off_rounded,
                      color: cyanColor,
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Clear Filters",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(width: 10),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool compact = constraints.maxWidth < 850;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            padding: EdgeInsets.all(
              compact ? 18 : 25,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildHeader(compact),

                const SizedBox(height: 22),

                _buildStatistics(compact),

                const SizedBox(height: 22),

                _buildSearchAndFilter(compact),

                const SizedBox(height: 20),

                _buildAlertsList(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // REFRESH
  // ============================================================

  void _refreshAlerts() {
    setState(() {});

    _showSnackBar(
      "Alert data refreshed successfully",
      Icons.refresh_rounded,
      cyanColor,
    );
  }

  // ============================================================
  // ACKNOWLEDGE ALL
  // ============================================================

  void _acknowledgeAll() {
    int count = 0;

    setState(() {
      for (final alert in alerts) {
        if (alert["status"] == "Active") {
          alert["status"] = "Acknowledged";
          count++;
        }
      }
    });

    if (count == 0) {
      _showSnackBar(
        "No active alerts available",
        Icons.info_outline_rounded,
        Colors.orangeAccent,
      );
    } else {
      _showSnackBar(
        "$count alert${count == 1 ? "" : "s"} acknowledged",
        Icons.done_all_rounded,
        Colors.greenAccent,
      );
    }
  }

  // ============================================================
  // CLEAR FILTERS
  // ============================================================

  void _clearFilters() {
    setState(() {
      selectedFilter = "All";
      searchController.clear();
    });

    _showSnackBar(
      "Search and filters cleared",
      Icons.filter_alt_off_rounded,
      cyanColor,
    );
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showSnackBar(
    String message,
    IconData icon,
    Color color,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cardColor,
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(bool compact) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(
        compact ? 18 : 22,
      ),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff102A43),
            Color(0xff163B5C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,

            decoration: BoxDecoration(
              color:
                  Colors.redAccent.withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(16),
            ),

            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 30,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  "Smog Alert Management",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        compact ? 21 : 26,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Monitor, acknowledge and manage air quality alerts",
                  maxLines: 2,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          if (!compact) ...[
            const SizedBox(width: 15),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                color:
                    Colors.redAccent.withOpacity(
                  0.12,
                ),
                borderRadius:
                    BorderRadius.circular(20),
                border: Border.all(
                  color:
                      Colors.redAccent.withOpacity(
                    0.18,
                  ),
                ),
              ),

              child: const Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.redAccent,
                    size: 8,
                  ),
                  SizedBox(width: 7),
                  Text(
                    "Live Alerts",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics(bool compact) {
    final total = alerts.length;

    final high = alerts
        .where((a) => a["severity"] == "High")
        .length;

    final acknowledged = alerts
        .where(
          (a) => a["status"] == "Acknowledged",
        )
        .length;

    final resolved = alerts
        .where((a) => a["status"] == "Resolved")
        .length;

    final active = alerts
        .where((a) => a["status"] == "Active")
        .length;

    final stats = [
      _AlertStat(
        "Total Alerts",
        "$total",
        Icons.notifications_active_rounded,
        cyanColor,
      ),
      _AlertStat(
        "Active",
        "$active",
        Icons.error_outline_rounded,
        Colors.redAccent,
      ),
      _AlertStat(
        "High Priority",
        "$high",
        Icons.warning_rounded,
        Colors.orangeAccent,
      ),
      _AlertStat(
        "Acknowledged",
        "$acknowledged",
        Icons.done_all_rounded,
        Colors.amberAccent,
      ),
      _AlertStat(
        "Resolved",
        "$resolved",
        Icons.check_circle_rounded,
        Colors.greenAccent,
      ),
    ];

    if (compact) {
      return GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(),
        itemCount: stats.length,

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.05,
        ),

        itemBuilder: (context, index) {
          return _statCard(stats[index]);
        },
      );
    }

    return Row(
      children: List.generate(
        stats.length,
        (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right:
                    index == stats.length - 1
                        ? 0
                        : 12,
              ),
              child:
                  _statCard(stats[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(_AlertStat stat) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color:
              Colors.white.withOpacity(0.08),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,

            decoration: BoxDecoration(
              color:
                  stat.color.withOpacity(
                0.11,
              ),
              borderRadius:
                  BorderRadius.circular(13),
            ),

            child: Icon(
              stat.icon,
              color: stat.color,
              size: 22,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  stat.title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  stat.value,
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH + FILTER
  // ============================================================

  Widget _buildSearchAndFilter(
    bool compact,
  ) {
    if (compact) {
      return Column(
        children: [
          _searchBox(),

          const SizedBox(height: 12),

          Row(
            children: [
              _filterButton(),

              const SizedBox(width: 8),

              if (searchController.text.isNotEmpty)
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      searchController.clear();
                    });
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 15,
                  ),
                  label: const Text(
                    "Clear",
                  ),
                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        Colors.white70,
                    side: BorderSide(
                      color: Colors.white
                          .withOpacity(0.12),
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _searchBox(),
        ),

        const SizedBox(width: 12),

        _filterButton(),

        if (searchController.text.isNotEmpty) ...[
          const SizedBox(width: 8),
          IconButton(
            tooltip: "Clear search",
            onPressed: () {
              setState(() {
                searchController.clear();
              });
            },
            icon: const Icon(
              Icons.close_rounded,
              color: Colors.white54,
            ),
          ),
        ],
      ],
    );
  }

  Widget _searchBox() {
    return Container(
      height: 48,

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(13),

        border: Border.all(
          color:
              Colors.white.withOpacity(0.08),
        ),
      ),

      child: TextField(
        controller: searchController,

        onChanged: (_) {
          setState(() {});
        },

        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),

        decoration:
            const InputDecoration(
          hintText:
              "Search alerts or locations...",

          hintStyle: TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),

          prefixIcon: Icon(
            Icons.search_rounded,
            color: cyanColor,
            size: 21,
          ),

          border: InputBorder.none,

          contentPadding:
              EdgeInsets.symmetric(
            vertical: 13,
          ),
        ),
      ),
    );
  }

  Widget _filterButton() {
    return PopupMenuButton<String>(
      color: cardColor,

      onSelected: (value) {
        setState(() {
          selectedFilter = value;
        });
      },

      itemBuilder: (context) {
        const filters = [
          "All",
          "High",
          "Medium",
          "Low",
          "Active",
          "Acknowledged",
          "Resolved",
        ];

        return filters.map((item) {
          final selected =
              item == selectedFilter;

          return PopupMenuItem<String>(
            value: item,

            child: Row(
              children: [
                Icon(
                  _filterIcon(item),
                  color: selected
                      ? cyanColor
                      : Colors.white54,
                  size: 18,
                ),

                const SizedBox(width: 10),

                Text(
                  item,
                  style: TextStyle(
                    color: selected
                        ? cyanColor
                        : Colors.white,
                    fontWeight: selected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },

      child: Container(
        height: 48,

        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
        ),

        decoration: BoxDecoration(
          color: cardColor,

          borderRadius:
              BorderRadius.circular(13),

          border: Border.all(
            color:
                Colors.white.withOpacity(0.08),
          ),
        ),

        child: Row(
          children: [
            const Icon(
              Icons.filter_list_rounded,
              color: cyanColor,
              size: 19,
            ),

            const SizedBox(width: 7),

            Text(
              selectedFilter,
              style:
                  const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),

            const SizedBox(width: 5),

            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white54,
              size: 17,
            ),
          ],
        ),
      ),
    );
  }

  IconData _filterIcon(String item) {
    switch (item) {
      case "High":
        return Icons.priority_high_rounded;
      case "Medium":
        return Icons.warning_amber_rounded;
      case "Low":
        return Icons.info_outline_rounded;
      case "Active":
        return Icons.circle;
      case "Acknowledged":
        return Icons.done_all_rounded;
      case "Resolved":
        return Icons.check_circle_outline;
      default:
        return Icons.list_rounded;
    }
  }

  // ============================================================
  // ALERT LIST
  // ============================================================

  Widget _buildAlertsList() {
    final query =
        searchController.text.trim().toLowerCase();

    final filtered = alerts.where((alert) {
      final title =
          alert["title"].toString().toLowerCase();

      final location =
          alert["location"].toString().toLowerCase();

      final description =
          alert["description"]
              .toString()
              .toLowerCase();

      final matchesSearch =
          title.contains(query) ||
          location.contains(query) ||
          description.contains(query);

      final matchesFilter =
          selectedFilter == "All" ||
          alert["severity"] ==
              selectedFilter ||
          alert["status"] ==
              selectedFilter;

      return matchesSearch &&
          matchesFilter;
    }).toList();

    if (filtered.isEmpty) {
      return _emptyState();
    }

    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Alert Activity",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width: 8),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),

              decoration: BoxDecoration(
                color:
                    cyanColor.withOpacity(0.08),
                borderRadius:
                    BorderRadius.circular(8),
              ),

              child: Text(
                "${filtered.length}",
                style: const TextStyle(
                  color: cyanColor,
                  fontSize: 10,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),

            Text(
              selectedFilter == "All"
                  ? "All alerts"
                  : selectedFilter,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        ...filtered.map(
          (alert) => _alertCard(alert),
        ),
      ],
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.symmetric(
        vertical: 55,
        horizontal: 20,
      ),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color:
              Colors.white.withOpacity(0.07),
        ),
      ),

      child: const Column(
        children: [
          Icon(
            Icons.notifications_off_rounded,
            color: Colors.white38,
            size: 48,
          ),

          SizedBox(height: 12),

          Text(
            "No alerts found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "Try changing your search or filter.",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ALERT CARD
  // ============================================================

  Widget _alertCard(
    Map<String, dynamic> alert,
  ) {
    final String severity =
        alert["severity"].toString();

    final Color severityColor =
        _severityColor(severity);

    final String status =
        alert["status"].toString();

    final bool resolved =
        status == "Resolved";

    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(19),

        border: Border.all(
          color: severity == "High"
              ? Colors.redAccent
                  .withOpacity(0.20)
              : Colors.white
                  .withOpacity(0.08),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Container(
                width: 54,
                height: 54,

                decoration: BoxDecoration(
                  color:
                      severityColor
                          .withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),

                child: Icon(
                  alert["icon"] as IconData,
                  color: severityColor,
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert["title"]
                          .toString(),

                      maxLines: 2,

                      overflow:
                          TextOverflow.ellipsis,

                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(
                          Icons
                              .location_on_outlined,
                          color:
                              Colors.white54,
                          size: 14,
                        ),

                        const SizedBox(
                          width: 4,
                        ),

                        Flexible(
                          child: Text(
                            alert["location"]
                                .toString(),

                            overflow:
                                TextOverflow
                                    .ellipsis,

                            style:
                                const TextStyle(
                              color:
                                  Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end,

                children: [
                  _severityBadge(
                    severity,
                    severityColor,
                  ),

                  const SizedBox(height: 7),

                  Text(
                    alert["time"]
                        .toString(),

                    style:
                        const TextStyle(
                      color: Colors.white38,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Divider(
            color:
                Colors.white.withOpacity(0.07),
            height: 1,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              _alertInfo(
                Icons.speed_rounded,
                "AQI",
                "${alert["aqi"]}",
                severityColor,
              ),

              _alertInfo(
                Icons.access_time_rounded,
                "Detected",
                alert["time"].toString(),
                Colors.white,
              ),

              _alertInfo(
                Icons.info_outline_rounded,
                "Status",
                status,
                _statusColor(status),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.end,

            children: [
              OutlinedButton.icon(
                onPressed: () {
                  _showDetails(alert);
                },

                icon: const Icon(
                  Icons.visibility_outlined,
                  size: 15,
                ),

                label:
                    const Text("Details"),

                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      cyanColor,

                  side: BorderSide(
                    color:
                        cyanColor.withOpacity(
                      0.45,
                    ),
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),

                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 13,
                    vertical: 10,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              if (!resolved)
                ElevatedButton.icon(
                  onPressed: () {
                    _updateAlertStatus(
                      alert,
                    );
                  },

                  icon: Icon(
                    status == "Active"
                        ? Icons.done_rounded
                        : Icons
                            .check_circle_outline,
                    size: 15,
                  ),

                  label: Text(
                    status == "Active"
                        ? "Acknowledge"
                        : "Resolve",
                  ),

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.green
                            .withOpacity(
                      0.85,
                    ),

                    foregroundColor:
                        Colors.white,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),

                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                  ),
                ),

              const SizedBox(width: 8),

              IconButton(
                tooltip: "Delete alert",
                onPressed: () {
                  _confirmDelete(alert);
                },
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEVERITY BADGE
  // ============================================================

  Widget _severityBadge(
    String severity,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: color.withOpacity(0.12),

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: color.withOpacity(0.18),
        ),
      ),

      child: Text(
        severity,

        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // ALERT INFO
  // ============================================================

  Widget _alertInfo(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 16,
          ),

          const SizedBox(width: 6),

          Flexible(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    color:
                        Colors.white38,
                    fontSize: 9,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS UPDATE
  // ============================================================

  void _updateAlertStatus(
    Map<String, dynamic> alert,
  ) {
    setState(() {
      if (alert["status"] == "Active") {
        alert["status"] = "Acknowledged";
      } else if (alert["status"] ==
          "Acknowledged") {
        alert["status"] = "Resolved";
      }
    });

    _showSnackBar(
      "Alert marked as ${alert["status"]}",
      Icons.check_circle_outline,
      Colors.greenAccent,
    );
  }

  // ============================================================
  // DELETE CONFIRMATION
  // ============================================================

  void _confirmDelete(
    Map<String, dynamic> alert,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: const Row(
            children: [
              Icon(
                Icons.delete_forever_rounded,
                color: Colors.redAccent,
              ),

              SizedBox(width: 10),

              Text(
                "Delete Alert",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          content: Text(
            "Are you sure you want to delete \"${alert["title"]}\"?\n\nThis action cannot be undone.",
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.5,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                _deleteAlert(alert);
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.redAccent,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
              ),

              child:
                  const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DELETE ALERT
  // ============================================================

  void _deleteAlert(
    Map<String, dynamic> alert,
  ) {
    setState(() {
      alerts.remove(alert);
    });

    _showSnackBar(
      "Alert deleted successfully",
      Icons.delete_outline_rounded,
      Colors.redAccent,
    );
  }

  // ============================================================
  // DETAILS DIALOG
  // ============================================================

  void _showDetails(
    Map<String, dynamic> alert,
  ) {
    final Color severityColor =
        _severityColor(
      alert["severity"].toString(),
    );

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,

                decoration: BoxDecoration(
                  color:
                      severityColor
                          .withOpacity(0.12),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: Icon(
                  alert["icon"] as IconData,
                  color: severityColor,
                  size: 22,
                ),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Text(
                  "Alert Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          content:
              SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                _dialogRow(
                  "Alert",
                  alert["title"].toString(),
                ),

                _dialogRow(
                  "Location",
                  alert["location"]
                      .toString(),
                ),

                _dialogRow(
                  "AQI",
                  "${alert["aqi"]}",
                ),

                _dialogRow(
                  "Severity",
                  alert["severity"]
                      .toString(),
                ),

                _dialogRow(
                  "Status",
                  alert["status"]
                      .toString(),
                ),

                _dialogRow(
                  "Detected",
                  alert["time"].toString(),
                ),

                const SizedBox(height: 8),

                const Text(
                  "Description",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 6),

                Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets.all(
                    12,
                  ),

                  decoration:
                      BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.04),

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),

                  child: Text(
                    alert["description"]
                        .toString(),

                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            if (alert["status"] !=
                "Resolved")
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );
                  _updateAlertStatus(
                    alert,
                  );
                },
                icon: const Icon(
                  Icons.check_circle_outline,
                  size: 16,
                ),
                label: Text(
                  alert["status"] ==
                          "Active"
                      ? "Acknowledge"
                      : "Resolve",
                ),
                style:
                    TextButton.styleFrom(
                  foregroundColor:
                      Colors.greenAccent,
                ),
              ),

            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child: const Text(
                "Close",
                style: TextStyle(
                  color: cyanColor,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DIALOG ROW
  // ============================================================

  Widget _dialogRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 10,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 75,

            child: Text(
              title,

              style:
                  const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,

              style:
                  const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  Color _severityColor(
    String severity,
  ) {
    switch (severity) {
      case "High":
        return Colors.redAccent;

      case "Medium":
        return Colors.orangeAccent;

      case "Low":
        return Colors.yellowAccent;

      default:
        return cyanColor;
    }
  }

  Color _statusColor(
    String status,
  ) {
    switch (status) {
      case "Active":
        return Colors.redAccent;

      case "Acknowledged":
        return Colors.orangeAccent;

      case "Resolved":
        return Colors.greenAccent;

      default:
        return Colors.white70;
    }
  }
}

// ================================================================
// MODEL
// ================================================================

class _AlertStat {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _AlertStat(
    this.title,
    this.value,
    this.icon,
    this.color,
  );
}