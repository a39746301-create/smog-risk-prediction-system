import 'package:flutter/material.dart';

class NHMPScreen extends StatefulWidget {
  const NHMPScreen({super.key});

  @override
  State<NHMPScreen> createState() => _NHMPScreenState();
}

class _NHMPScreenState extends State<NHMPScreen> {
  static const Color backgroundColor = Color(0xff081426);
  static const Color cardColor = Color(0xff102A43);
  static const Color cyanColor = Colors.cyanAccent;

  final TextEditingController searchController = TextEditingController();

  String selectedFilter = "All";
  bool isRefreshing = false;

  final List<Map<String, dynamic>> stations = [
    {
      "name": "M-1 Islamabad",
      "aqi": 145,
      "risk": "Moderate Risk",
      "visibility": "6.2 km",
      "road": "Clear",
      "status": "Active",
      "updated": "2 min ago",
      "temperature": "28°C",
      "humidity": "57%",
      "pm25": "61 µg/m³",
      "pm10": "104 µg/m³",
      "speed": "92 km/h",
      "traffic": "Normal",
    },
    {
      "name": "M-2 Lahore",
      "aqi": 220,
      "risk": "High Risk",
      "visibility": "3.4 km",
      "road": "Foggy",
      "status": "Active",
      "updated": "1 min ago",
      "temperature": "31°C",
      "humidity": "68%",
      "pm25": "118 µg/m³",
      "pm10": "180 µg/m³",
      "speed": "61 km/h",
      "traffic": "Heavy",
    },
    {
      "name": "M-3 Faisalabad",
      "aqi": 90,
      "risk": "Good",
      "visibility": "8.5 km",
      "road": "Clear",
      "status": "Active",
      "updated": "4 min ago",
      "temperature": "27°C",
      "humidity": "52%",
      "pm25": "32 µg/m³",
      "pm10": "49 µg/m³",
      "speed": "96 km/h",
      "traffic": "Normal",
    },
    {
      "name": "M-4 Multan",
      "aqi": 178,
      "risk": "Unhealthy",
      "visibility": "4.7 km",
      "road": "Normal",
      "status": "Active",
      "updated": "3 min ago",
      "temperature": "33°C",
      "humidity": "64%",
      "pm25": "82 µg/m³",
      "pm10": "139 µg/m³",
      "speed": "74 km/h",
      "traffic": "Moderate",
    },
    {
      "name": "M-5 Sukkur",
      "aqi": 72,
      "risk": "Good",
      "visibility": "9.1 km",
      "road": "Clear",
      "status": "Offline",
      "updated": "18 min ago",
      "temperature": "30°C",
      "humidity": "48%",
      "pm25": "27 µg/m³",
      "pm10": "43 µg/m³",
      "speed": "88 km/h",
      "traffic": "Normal",
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
        titleSpacing: 16,
        title: LayoutBuilder(
          builder: (context, constraints) {
            final bool mobile = constraints.maxWidth < 500;

            return Row(
              children: [
                Container(
                  width: mobile ? 36 : 40,
                  height: mobile ? 36 : 40,
                  decoration: BoxDecoration(
                    color: cyanColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.route_rounded,
                    color: cyanColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    mobile ? "NHMP" : "NHMP Stations",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mobile ? 17 : 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            tooltip: "Refresh Stations",
            onPressed: _refreshStations,
            icon: isRefreshing
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cyanColor,
                    ),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          final bool mobile = width < 600;
          final bool tablet = width >= 600 && width < 1000;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(
              mobile
                  ? 14
                  : tablet
                      ? 18
                      : 25,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1450,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _pageHeader(mobile, tablet),
                    const SizedBox(height: 20),
                    _statistics(mobile, tablet),
                    const SizedBox(height: 20),
                    _searchAndFilter(mobile, tablet),
                    const SizedBox(height: 20),
                    _stationList(mobile, tablet),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshStations() async {
    if (isRefreshing) return;

    setState(() {
      isRefreshing = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Station data refreshed successfully"),
        backgroundColor: cardColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // PAGE HEADER
  // ============================================================

  Widget _pageHeader(bool mobile, bool tablet) {
    final activeCount =
        stations.where((s) => s["status"] == "Active").length;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        mobile
            ? 16
            : tablet
                ? 18
                : 22,
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
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: mobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _headerIcon(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _headerText(mobile),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _liveBadge(activeCount),
              ],
            )
          : Row(
              children: [
                _headerIcon(),
                const SizedBox(width: 15),
                Expanded(
                  child: _headerText(tablet),
                ),
                const SizedBox(width: 12),
                _liveBadge(activeCount),
              ],
            ),
    );
  }

  Widget _headerIcon() {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: cyanColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.location_on_rounded,
        color: cyanColor,
        size: 29,
      ),
    );
  }

  Widget _headerText(bool compact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Highway Monitoring Stations",
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 20 : 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Real-time motorway air quality and road monitoring",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _liveBadge(int activeCount) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.circle,
            color: Colors.greenAccent,
            size: 8,
          ),
          const SizedBox(width: 7),
          Text(
            "$activeCount Live Stations",
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _statistics(bool mobile, bool tablet) {
    final total = stations.length;

    final active =
        stations.where((s) => s["status"] == "Active").length;

    final highRisk =
        stations.where((s) => s["risk"] == "High Risk").length;

    final averageAqi =
        stations.map<int>((s) => s["aqi"] as int).reduce(
              (a, b) => a + b,
            ) ~/
            total;

    final stats = [
      _StatData(
        "Total Stations",
        "$total",
        Icons.route_rounded,
        cyanColor,
      ),
      _StatData(
        "Active Stations",
        "$active",
        Icons.wifi_tethering_rounded,
        Colors.greenAccent,
      ),
      _StatData(
        "High Risk",
        "$highRisk",
        Icons.warning_amber_rounded,
        Colors.redAccent,
      ),
      _StatData(
        "Average AQI",
        "$averageAqi",
        Icons.air_rounded,
        Colors.orangeAccent,
      ),
    ];

    if (mobile) {
      return Column(
        children: stats
            .map(
              (stat) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _statCard(stat),
              ),
            )
            .toList(),
      );
    }

    if (tablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stats.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.4,
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
                right: index == stats.length - 1 ? 0 : 13,
              ),
              child: _statCard(stats[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(_StatData data) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(13),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  overflow: TextOverflow.ellipsis,
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
  // SEARCH + FILTER
  // ============================================================

  Widget _searchAndFilter(bool mobile, bool tablet) {
    if (mobile) {
      return Column(
        children: [
          _searchField(),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _filterButton(),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _searchField(),
        ),
        const SizedBox(width: 12),
        _filterButton(),
      ],
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
        return [
          "All",
          "Good",
          "Moderate Risk",
          "High Risk",
          "Unhealthy",
          "Active",
          "Offline",
        ].map((item) {
          return PopupMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }).toList();
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.filter_list_rounded,
              color: cyanColor,
              size: 19,
            ),
            const SizedBox(width: 7),
            Text(
              selectedFilter,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w600,
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

  Widget _searchField() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
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
        decoration: const InputDecoration(
          hintText: "Search stations or motorway...",
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
          contentPadding: EdgeInsets.symmetric(
            vertical: 13,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STATION LIST
  // ============================================================

  Widget _stationList(bool mobile, bool tablet) {
    final query =
        searchController.text.trim().toLowerCase();

    final filtered = stations.where((station) {
      final matchesSearch =
          station["name"]
                  .toString()
                  .toLowerCase()
                  .contains(query) ||
              station["road"]
                  .toString()
                  .toLowerCase()
                  .contains(query);

      final matchesFilter =
          selectedFilter == "All" ||
              station["risk"] == selectedFilter ||
              station["status"] == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();

    if (filtered.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(45),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.location_off_rounded,
              color: Colors.white38,
              size: 45,
            ),
            SizedBox(height: 10),
            Text(
              "No stations found",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: filtered
          .map(
            (station) => _stationCard(
              station,
              mobile,
              tablet,
            ),
          )
          .toList(),
    );
  }

  // ============================================================
  // STATION CARD
  // ============================================================

  Widget _stationCard(
    Map<String, dynamic> station,
    bool mobile,
    bool tablet,
  ) {
    final int aqi = station["aqi"];

    final bool highRisk =
        station["risk"] == "High Risk";

    final bool unhealthy =
        station["risk"] == "Unhealthy";

    final bool good =
        station["risk"] == "Good";

    final bool active =
        station["status"] == "Active";

    final Color riskColor = highRisk
        ? Colors.redAccent
        : unhealthy
            ? Colors.orangeAccent
            : good
                ? Colors.greenAccent
                : Colors.amberAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(mobile ? 14 : 18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: highRisk
              ? Colors.redAccent.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (mobile)
            _mobileStationHeader(
              station,
              aqi,
              riskColor,
              active,
            )
          else
            _desktopStationHeader(
              station,
              aqi,
              riskColor,
              active,
            ),

          const SizedBox(height: 16),

          _aqiProgress(aqi, riskColor),

          const SizedBox(height: 17),

          Divider(
            color: Colors.white.withValues(alpha: 0.07),
            height: 1,
          ),

          const SizedBox(height: 14),

          if (mobile)
            _mobileStationDetails(
              station,
              riskColor,
            )
          else
            Row(
              children: [
                _stationDetail(
                  Icons.air_rounded,
                  "Air Quality",
                  station["risk"],
                  riskColor,
                ),
                _stationDetail(
                  Icons.visibility_rounded,
                  "Visibility",
                  station["visibility"],
                  Colors.white,
                ),
                _stationDetail(
                  Icons.directions_car_rounded,
                  "Road",
                  station["road"],
                  station["road"] == "Foggy"
                      ? Colors.orangeAccent
                      : Colors.white,
                ),
                _stationDetail(
                  Icons.traffic_rounded,
                  "Traffic",
                  station["traffic"],
                  Colors.white,
                ),
              ],
            ),

          const SizedBox(height: 15),

          if (mobile)
            _mobileBottomMetrics(
              station,
            )
          else
            _desktopBottomMetrics(
              station,
            ),
        ],
      ),
    );
  }

  Widget _mobileStationHeader(
    Map<String, dynamic> station,
    int aqi,
    Color riskColor,
    bool active,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.route_rounded,
                color: riskColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    station["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: active
                            ? Colors.greenAccent
                            : Colors.redAccent,
                        size: 7,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        station["status"],
                        style: TextStyle(
                          color: active
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Updated ${station["updated"]}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.end,
              children: [
                const Text(
                  "AQI",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
                Text(
                  "$aqi",
                  style: TextStyle(
                    color: riskColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  station["risk"],
                  style: TextStyle(
                    color: riskColor,
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _desktopStationHeader(
    Map<String, dynamic> station,
    int aqi,
    Color riskColor,
    bool active,
  ) {
    return Row(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: riskColor.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.route_rounded,
            color: riskColor,
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
                station["name"],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: active
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    size: 7,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    station["status"],
                    style: TextStyle(
                      color: active
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      "Updated ${station["updated"]}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
            const SizedBox(height: 2),
            Text(
              "$aqi",
              style: TextStyle(
                color: riskColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              station["risk"],
              style: TextStyle(
                color: riskColor,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // AQI PROGRESS
  // ============================================================

  Widget _aqiProgress(
    int aqi,
    Color riskColor,
  ) {
    final double progress =
        (aqi / 300).clamp(0.0, 1.0).toDouble();

    return Column(
      children: [
        Row(
          children: [
            const Text(
              "AQI Level",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
            const Spacer(),
            Text(
              "${(progress * 100).round()}%",
              style: TextStyle(
                color: riskColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor:
                Colors.white.withValues(alpha: 0.07),
            valueColor:
                AlwaysStoppedAnimation<Color>(
              riskColor,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE DETAILS
  // ============================================================

  Widget _mobileStationDetails(
    Map<String, dynamic> station,
    Color riskColor,
  ) {
    return Column(
      children: [
        Row(
          children: [
            _stationDetail(
              Icons.air_rounded,
              "Air Quality",
              station["risk"],
              riskColor,
            ),
            _stationDetail(
              Icons.visibility_rounded,
              "Visibility",
              station["visibility"],
              Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            _stationDetail(
              Icons.directions_car_rounded,
              "Road",
              station["road"],
              station["road"] == "Foggy"
                  ? Colors.orangeAccent
                  : Colors.white,
            ),
            _stationDetail(
              Icons.traffic_rounded,
              "Traffic",
              station["traffic"],
              Colors.white,
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // BOTTOM METRICS
  // ============================================================

  Widget _mobileBottomMetrics(
    Map<String, dynamic> station,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _metricBox(
                Icons.thermostat_rounded,
                "Temperature",
                station["temperature"],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _metricBox(
                Icons.water_drop_rounded,
                "Humidity",
                station["humidity"],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _metricBox(
                Icons.speed_rounded,
                "Vehicle Speed",
                station["speed"],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _showStationDetails(station);
                },
                icon: const Icon(
                  Icons.analytics_outlined,
                  size: 16,
                ),
                label: const Text("View Details"),
                style: OutlinedButton.styleFrom(
                  minimumSize:
                      const Size.fromHeight(44),
                  foregroundColor: cyanColor,
                  side: BorderSide(
                    color: cyanColor.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _desktopBottomMetrics(
    Map<String, dynamic> station,
  ) {
    return Row(
      children: [
        _smallMetric(
          Icons.thermostat_rounded,
          station["temperature"],
        ),
        _smallMetric(
          Icons.water_drop_rounded,
          station["humidity"],
        ),
        _smallMetric(
          Icons.speed_rounded,
          station["speed"],
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: () {
            _showStationDetails(station);
          },
          icon: const Icon(
            Icons.analytics_outlined,
            size: 16,
          ),
          label: const Text("View Details"),
          style: OutlinedButton.styleFrom(
            foregroundColor: cyanColor,
            side: BorderSide(
              color: cyanColor.withValues(alpha: 0.5),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 10,
            ),
            textStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _metricBox(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: cyanColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 8,
                  ),
                ),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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
  // SMALL METRIC
  // ============================================================

  Widget _smallMetric(
    IconData icon,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(right: 14),
      child: Row(
        children: [
          Icon(
            icon,
            color: cyanColor,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATION DETAIL
  // ============================================================

  Widget _stationDetail(
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
            size: 17,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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

  void _showStationDetails(
    Map<String, dynamic> station,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520,
              maxHeight: 650,
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color:
                              cyanColor.withValues(alpha: 0.10),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.route_rounded,
                          color: cyanColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          station["name"],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        icon: const Icon(
                          Icons.close_rounded,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  const Divider(
                    color: Colors.white12,
                    height: 25,
                  ),

                  Flexible(
                    child: SingleChildScrollView(
                      physics:
                          const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _dialogRow(
                            "AQI",
                            "${station["aqi"]}",
                          ),
                          _dialogRow(
                            "Risk Level",
                            station["risk"],
                          ),
                          _dialogRow(
                            "Visibility",
                            station["visibility"],
                          ),
                          _dialogRow(
                            "Road Condition",
                            station["road"],
                          ),
                          _dialogRow(
                            "Traffic",
                            station["traffic"],
                          ),
                          _dialogRow(
                            "Temperature",
                            station["temperature"],
                          ),
                          _dialogRow(
                            "Humidity",
                            station["humidity"],
                          ),
                          _dialogRow(
                            "PM2.5",
                            station["pm25"],
                          ),
                          _dialogRow(
                            "PM10",
                            station["pm10"],
                          ),
                          _dialogRow(
                            "Vehicle Speed",
                            station["speed"],
                          ),
                          _dialogRow(
                            "Station Status",
                            station["status"],
                          ),
                          _dialogRow(
                            "Last Updated",
                            station["updated"],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: cyanColor,
                        backgroundColor:
                            cyanColor.withValues(alpha: 0.07),
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dialogRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// MODEL
// ================================================================

class _StatData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatData(
    this.title,
    this.value,
    this.icon,
    this.color,
  );
}
