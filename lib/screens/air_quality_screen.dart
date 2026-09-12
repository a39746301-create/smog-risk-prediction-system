import 'package:flutter/material.dart';

class AirQualityScreen extends StatefulWidget {
  const AirQualityScreen({super.key});

  @override
  State<AirQualityScreen> createState() => _AirQualityScreenState();
}

class _AirQualityScreenState extends State<AirQualityScreen> {
  static const Color backgroundColor = Color(0xff081426);
  static const Color cardColor = Color(0xff102A43);
  static const Color cyanColor = Colors.cyanAccent;

  final TextEditingController searchController = TextEditingController();

  String selectedFilter = "All";
  bool sortHighestFirst = true;
  bool isRefreshing = false;

  final List<Map<String, dynamic>> locations = [
    {
      "name": "Islamabad",
      "aqi": 92,
      "status": "Moderate",
      "pm25": "38 µg/m³",
      "pm10": "61 µg/m³",
      "co": "0.7 ppm",
      "temperature": "27°C",
      "humidity": "58%",
      "updated": "2 min ago",
    },
    {
      "name": "Rawalpindi",
      "aqi": 145,
      "status": "Unhealthy",
      "pm25": "67 µg/m³",
      "pm10": "105 µg/m³",
      "co": "1.1 ppm",
      "temperature": "29°C",
      "humidity": "61%",
      "updated": "3 min ago",
    },
    {
      "name": "Lahore",
      "aqi": 220,
      "status": "Very Unhealthy",
      "pm25": "118 µg/m³",
      "pm10": "180 µg/m³",
      "co": "1.8 ppm",
      "temperature": "31°C",
      "humidity": "66%",
      "updated": "1 min ago",
    },
    {
      "name": "Faisalabad",
      "aqi": 78,
      "status": "Good",
      "pm25": "28 µg/m³",
      "pm10": "44 µg/m³",
      "co": "0.5 ppm",
      "temperature": "26°C",
      "humidity": "54%",
      "updated": "5 min ago",
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
                color: cyanColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.air_rounded,
                color: cyanColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              "Air Quality",
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
            tooltip: "Refresh data",
            onPressed: isRefreshing ? null : _refreshData,
            icon: isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cyanColor,
                    ),
                  )
                : const Icon(
                    Icons.refresh_rounded,
                  ),
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
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                _buildHeader(compact),

                const SizedBox(height: 22),

                _buildSummary(compact),

                const SizedBox(height: 22),

                _buildControls(compact),

                const SizedBox(height: 20),

                _buildLocationList(),
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

  Future<void> _refreshData() async {
    setState(() {
      isRefreshing = true;
    });

    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    setState(() {
      isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Colors.greenAccent,
            ),
            SizedBox(width: 10),
            Text("Air quality data refreshed"),
          ],
        ),
        backgroundColor: cardColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
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
        ),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,

            decoration: BoxDecoration(
              color: cyanColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),

            child: const Icon(
              Icons.cloud_rounded,
              color: cyanColor,
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
                  "Air Quality Monitoring",

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 21 : 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  "Monitor AQI, pollutants and environmental conditions",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          if (!compact)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),

              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),

              child: const Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: Colors.greenAccent,
                    size: 8,
                  ),

                  SizedBox(width: 7),

                  Text(
                    "Live Data",
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
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
  // SUMMARY
  // ============================================================

  Widget _buildSummary(bool compact) {
    const summary = [
      _SummaryData(
        "Average AQI",
        "134",
        Icons.air_rounded,
        Colors.orangeAccent,
      ),
      _SummaryData(
        "Good Areas",
        "1",
        Icons.check_circle_rounded,
        Colors.greenAccent,
      ),
      _SummaryData(
        "Unhealthy",
        "2",
        Icons.warning_amber_rounded,
        Colors.redAccent,
      ),
      _SummaryData(
        "Monitoring",
        "24/7",
        Icons.monitor_heart_rounded,
        cyanColor,
      ),
    ];

    if (compact) {
      return GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(),

        itemCount: summary.length,

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.1,
        ),

        itemBuilder: (context, index) {
          return _summaryCard(summary[index]);
        },
      );
    }

    return Row(
      children: List.generate(
        summary.length,
        (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == summary.length - 1
                    ? 0
                    : 13,
              ),
              child: _summaryCard(
                summary[index],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(
    _SummaryData data,
  ) {
    return Container(
      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,

            decoration: BoxDecoration(
              color: data.color.withOpacity(0.11),
              borderRadius:
                  BorderRadius.circular(13),
            ),

            child: Icon(
              data.icon,
              color: data.color,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  data.title,
                  overflow:
                      TextOverflow.ellipsis,

                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  data.value,

                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
  // SEARCH + FILTER + SORT
  // ============================================================

  Widget _buildControls(bool compact) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
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
                  ),

                  decoration:
                      InputDecoration(
                    hintText:
                        "Search city or monitoring area...",

                    hintStyle:
                        const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),

                    prefixIcon:
                        const Icon(
                      Icons.search_rounded,
                      color: cyanColor,
                      size: 21,
                    ),

                    suffixIcon:
                        searchController
                                .text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  searchController
                                      .clear();

                                  setState(() {});
                                },

                                icon:
                                    const Icon(
                                  Icons.close_rounded,
                                  color:
                                      Colors.white54,
                                  size: 19,
                                ),
                              )
                            : null,

                    border: InputBorder.none,

                    contentPadding:
                        const EdgeInsets.symmetric(
                      vertical: 13,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            Container(
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

              child: IconButton(
                tooltip: sortHighestFirst
                    ? "Lowest AQI first"
                    : "Highest AQI first",

                onPressed: () {
                  setState(() {
                    sortHighestFirst =
                        !sortHighestFirst;
                  });
                },

                icon: Icon(
                  sortHighestFirst
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: cyanColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,

          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: Row(
              children: [
                _filterButton("All"),
                _filterButton("Good"),
                _filterButton("Moderate"),
                _filterButton("Unhealthy"),
                _filterButton("Very Unhealthy"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterButton(String title) {
    final bool selected =
        selectedFilter == title;

    return Padding(
      padding: const EdgeInsets.only(right: 8),

      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            selectedFilter = title;
          });
        },

        icon: Icon(
          selected
              ? Icons.check_circle_rounded
              : Icons.circle_outlined,
          size: 15,
        ),

        label: Text(title),

        style: OutlinedButton.styleFrom(
          foregroundColor: selected
              ? backgroundColor
              : Colors.white70,

          backgroundColor: selected
              ? cyanColor
              : Colors.transparent,

          side: BorderSide(
            color: selected
                ? cyanColor
                : Colors.white24,
          ),

          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 9,
          ),

          textStyle:
              const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOCATION LIST
  // ============================================================

  Widget _buildLocationList() {
    final query =
        searchController.text.toLowerCase();

    final filtered =
        locations.where((location) {
      final String name =
          location["name"]
              .toString()
              .toLowerCase();

      final String status =
          location["status"]
              .toString();

      final matchesSearch =
          name.contains(query);

      final matchesFilter =
          selectedFilter == "All" ||
          status == selectedFilter;

      return matchesSearch &&
          matchesFilter;
    }).toList();

    filtered.sort(
      (a, b) {
        final int aqiA = a["aqi"] as int;
        final int aqiB = b["aqi"] as int;

        return sortHighestFirst
            ? aqiB.compareTo(aqiA)
            : aqiA.compareTo(aqiB);
      },
    );

    if (filtered.isEmpty) {
      return Container(
        width: double.infinity,

        padding:
            const EdgeInsets.all(45),

        decoration: BoxDecoration(
          color: cardColor,

          borderRadius:
              BorderRadius.circular(18),

          border: Border.all(
            color:
                Colors.white.withOpacity(0.08),
          ),
        ),

        child: const Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              color: Colors.white38,
              size: 45,
            ),

            SizedBox(height: 10),

            Text(
              "No location found",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 5),

            Text(
              "Try another city or filter.",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: filtered.map(
        (location) {
          return _locationCard(location);
        },
      ).toList(),
    );
  }

  // ============================================================
  // LOCATION CARD
  // ============================================================

  Widget _locationCard(
    Map<String, dynamic> location,
  ) {
    final int aqi = location["aqi"];

    final Color aqiColor =
        _getAQIColor(aqi);

    return Container(
      margin:
          const EdgeInsets.only(bottom: 14),

      padding:
          const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(19),

        border: Border.all(
          color:
              Colors.white.withOpacity(0.08),
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
            children: [
              Container(
                width: 55,
                height: 55,

                decoration:
                    BoxDecoration(
                  color:
                      aqiColor.withOpacity(0.11),

                  borderRadius:
                      BorderRadius.circular(16),
                ),

                child: Icon(
                  Icons.location_city_rounded,
                  color: aqiColor,
                  size: 28,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      location["name"],

                      style:
                          const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Wrap(
                      spacing: 10,
                      runSpacing: 4,

                      children: [
                        const Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              color:
                                  Colors.greenAccent,
                              size: 7,
                            ),

                            SizedBox(width: 6),

                            Text(
                              "Monitoring Active",
                              style:
                                  TextStyle(
                                color:
                                    Colors.greenAccent,
                                fontSize: 10,
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "Updated ${location["updated"]}",

                          style:
                              const TextStyle(
                            color:
                                Colors.white54,
                            fontSize: 10,
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
                  const Text(
                    "AQI",
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                  ),

                  Text(
                    "$aqi",

                    style: TextStyle(
                      color: aqiColor,
                      fontSize: 26,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  Text(
                    location["status"],

                    style: TextStyle(
                      color: aqiColor,
                      fontSize: 10,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 17),

          Divider(
            color:
                Colors.white.withOpacity(0.07),
            height: 1,
          ),

          const SizedBox(height: 14),

          Wrap(
            spacing: 15,
            runSpacing: 15,

            children: [
              _environmentItem(
                Icons.grain_rounded,
                "PM2.5",
                location["pm25"],
              ),

              _environmentItem(
                Icons.blur_on_rounded,
                "PM10",
                location["pm10"],
              ),

              _environmentItem(
                Icons.cloud_rounded,
                "CO",
                location["co"],
              ),

              _environmentItem(
                Icons.thermostat_rounded,
                "Temperature",
                location["temperature"],
              ),

              _environmentItem(
                Icons.water_drop_rounded,
                "Humidity",
                location["humidity"],
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
                  _showAirQualityDetails(
                    location,
                  );
                },

                icon: const Icon(
                  Icons.analytics_outlined,
                  size: 16,
                ),

                label: const Text(
                  "View Analysis",
                ),

                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      cyanColor,

                  side: BorderSide(
                    color:
                        cyanColor.withOpacity(0.5),
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 10,
                  ),

                  textStyle:
                      const TextStyle(
                    fontSize: 11,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AQI COLOR
  // ============================================================

  Color _getAQIColor(int aqi) {
    if (aqi <= 50) {
      return Colors.greenAccent;
    }

    if (aqi <= 100) {
      return Colors.yellowAccent;
    }

    if (aqi <= 150) {
      return Colors.orangeAccent;
    }

    return Colors.redAccent;
  }

  // ============================================================
  // ENVIRONMENT ITEM
  // ============================================================

  Widget _environmentItem(
    IconData icon,
    String title,
    String value,
  ) {
    return SizedBox(
      width: 135,

      child: Row(
        children: [
          Icon(
            icon,
            color: cyanColor,
            size: 17,
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value,
                  overflow:
                      TextOverflow.ellipsis,

                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
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
  // DETAILS DIALOG
  // ============================================================

  void _showAirQualityDetails(
    Map<String, dynamic> location,
  ) {
    final int aqi = location["aqi"];

    final Color aqiColor =
        _getAQIColor(aqi);

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
                width: 40,
                height: 40,

                decoration:
                    BoxDecoration(
                  color:
                      aqiColor.withOpacity(0.12),

                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Icon(
                  Icons.air_rounded,
                  color: aqiColor,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  "${location["name"]} Air Quality",

                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              children: [
                Container(
                  width: double.infinity,

                  padding:
                      const EdgeInsets.all(15),

                  decoration:
                      BoxDecoration(
                    color:
                        aqiColor.withOpacity(0.08),

                    borderRadius:
                        BorderRadius.circular(14),

                    border: Border.all(
                      color:
                          aqiColor.withOpacity(0.2),
                    ),
                  ),

                  child: Row(
                    children: [
                      Text(
                        "$aqi",
                        style: TextStyle(
                          color: aqiColor,
                          fontSize: 34,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Current AQI",
                            style: TextStyle(
                              color:
                                  Colors.white54,
                              fontSize: 11,
                            ),
                          ),

                          Text(
                            location["status"],
                            style: TextStyle(
                              color: aqiColor,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                _dialogRow(
                  "PM2.5",
                  location["pm25"],
                ),

                _dialogRow(
                  "PM10",
                  location["pm10"],
                ),

                _dialogRow(
                  "CO",
                  location["co"],
                ),

                _dialogRow(
                  "Temperature",
                  location["temperature"],
                ),

                _dialogRow(
                  "Humidity",
                  location["humidity"],
                ),

                _dialogRow(
                  "Last Updated",
                  location["updated"],
                ),
              ],
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
                "Close",
                style: TextStyle(
                  color: cyanColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _dialogRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 11),

      child: Row(
        children: [
          SizedBox(
            width: 105,

            child: Text(
              title,

              style:
                  const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,

              style:
                  const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// SUMMARY MODEL
// ================================================================

class _SummaryData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryData(
    this.title,
    this.value,
    this.icon,
    this.color,
  );
}