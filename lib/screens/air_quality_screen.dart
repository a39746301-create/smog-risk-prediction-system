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
      appBar: _buildAppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final bool mobile = width < 600;
          final bool tablet = width >= 600 && width < 1000;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: mobile
                  ? 14
                  : tablet
                      ? 20
                      : 28,
              vertical: mobile
                  ? 14
                  : tablet
                      ? 20
                      : 26,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1450,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(
                      mobile: mobile,
                      tablet: tablet,
                    ),

                    const SizedBox(height: 20),

                    _buildSummary(
                      mobile: mobile,
                      tablet: tablet,
                    ),

                    const SizedBox(height: 20),

                    _buildControls(
                      mobile: mobile,
                      tablet: tablet,
                    ),

                    const SizedBox(height: 18),

                    _buildLocationList(
                      mobile: mobile,
                      tablet: tablet,
                    ),
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
  // APP BAR
  // ============================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: cardColor,
      elevation: 0,
      titleSpacing: 16,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      title: LayoutBuilder(
        builder: (context, constraints) {
          final bool small = constraints.maxWidth < 450;

          return Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: cyanColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.air_rounded,
                  color: cyanColor,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              if (!small)
                const Text(
                  "Air Quality",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          );
        },
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
        const SizedBox(width: 6),
      ],
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
            Expanded(
              child: Text(
                "Air quality data refreshed",
              ),
            ),
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

  Widget _buildHeader({
    required bool mobile,
    required bool tablet,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        mobile
            ? 16
            : tablet
                ? 19
                : 23,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff102A43),
            Color(0xff163B5C),
          ],
        ),
        borderRadius: BorderRadius.circular(
          mobile ? 17 : 20,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
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

                    const Expanded(
                      child: Text(
                        "Air Quality Monitoring",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                const Text(
                  "Monitor AQI, pollutants and environmental conditions",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                _liveDataBadge(),
              ],
            )
          : Row(
              children: [
                _headerIcon(),

                const SizedBox(width: 15),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Air Quality Monitoring",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Monitor AQI, pollutants and environmental conditions",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                _liveDataBadge(),
              ],
            ),
    );
  }

  Widget _headerIcon() {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: cyanColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.cloud_rounded,
        color: cyanColor,
        size: 29,
      ),
    );
  }

  Widget _liveDataBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
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
    );
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  Widget _buildSummary({
    required bool mobile,
    required bool tablet,
  }) {
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

    if (mobile) {
      return Column(
        children: summary.map(
          (item) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: _summaryCard(item),
            );
          },
        ).toList(),
      );
    }

    if (tablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: summary.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.6,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              data.icon,
              color: data.color,
              size: 22,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
  // CONTROLS
  // ============================================================

  Widget _buildControls({
    required bool mobile,
    required bool tablet,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (mobile)
          Row(
            children: [
              Expanded(
                child: _buildSearchBox(),
              ),

              const SizedBox(width: 8),

              _buildSortButton(),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: _buildSearchBox(),
              ),

              const SizedBox(width: 10),

              _buildSortButton(),
            ],
          ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
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

  Widget _buildSearchBox() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
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
        decoration: InputDecoration(
          hintText: "Search city or monitoring area...",
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontSize: 12,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: cyanColor,
            size: 21,
          ),
          suffixIcon:
              searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white54,
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
    );
  }

  Widget _buildSortButton() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: IconButton(
        tooltip: sortHighestFirst
            ? "Lowest AQI first"
            : "Highest AQI first",
        onPressed: () {
          setState(() {
            sortHighestFirst = !sortHighestFirst;
          });
        },
        icon: Icon(
          sortHighestFirst
              ? Icons.arrow_downward_rounded
              : Icons.arrow_upward_rounded,
          color: cyanColor,
        ),
      ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 9,
          ),
          textStyle: const TextStyle(
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

  Widget _buildLocationList({
    required bool mobile,
    required bool tablet,
  }) {
    final query =
        searchController.text.toLowerCase();

    final filtered =
        locations.where((location) {
      final String name =
          location["name"]
              .toString()
              .toLowerCase();

      final String status =
          location["status"].toString();

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
      return _buildEmptyState();
    }

    return Column(
      children: filtered.map(
        (location) {
          return _locationCard(
            location,
            mobile: mobile,
          );
        },
      ).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
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
            textAlign: TextAlign.center,
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
  // LOCATION CARD
  // ============================================================

  Widget _locationCard(
    Map<String, dynamic> location, {
    required bool mobile,
  }) {
    final int aqi = location["aqi"];
    final Color aqiColor = _getAQIColor(aqi);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.all(
        mobile ? 15 : 18,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (mobile)
            _buildMobileLocationHeader(
              location,
              aqi,
              aqiColor,
            )
          else
            _buildDesktopLocationHeader(
              location,
              aqi,
              aqiColor,
            ),

          const SizedBox(height: 16),

          Divider(
            color: Colors.white.withOpacity(0.07),
            height: 1,
          ),

          const SizedBox(height: 14),

          _buildEnvironmentGrid(
            location,
            mobile,
          ),

          const SizedBox(height: 15),

          Align(
            alignment: Alignment.centerRight,
            child: _buildAnalysisButton(location),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DESKTOP LOCATION HEADER
  // ============================================================

  Widget _buildDesktopLocationHeader(
    Map<String, dynamic> location,
    int aqi,
    Color aqiColor,
  ) {
    return Row(
      children: [
        _locationIcon(aqiColor),

        const SizedBox(width: 15),

        Expanded(
          child: _locationInfo(location),
        ),

        const SizedBox(width: 10),

        _aqiDisplay(
          aqi,
          location["status"],
          aqiColor,
        ),
      ],
    );
  }

  // ============================================================
  // MOBILE LOCATION HEADER
  // ============================================================

  Widget _buildMobileLocationHeader(
    Map<String, dynamic> location,
    int aqi,
    Color aqiColor,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _locationIcon(aqiColor),

            const SizedBox(width: 12),

            Expanded(
              child: _locationInfo(location),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: aqiColor.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: aqiColor.withOpacity(0.15),
            ),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Current AQI",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
              Row(
                children: [
                  Text(
                    "$aqi",
                    style: TextStyle(
                      color: aqiColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    location["status"],
                    style: TextStyle(
                      color: aqiColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _locationIcon(Color aqiColor) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: aqiColor.withOpacity(0.11),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.location_city_rounded,
        color: aqiColor,
        size: 28,
      ),
    );
  }

  Widget _locationInfo(
    Map<String, dynamic> location,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          location["name"],
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Wrap(
          spacing: 10,
          runSpacing: 4,
          children: [
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  color: Colors.greenAccent,
                  size: 7,
                ),
                SizedBox(width: 6),
                Text(
                  "Monitoring Active",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            Text(
              "Updated ${location["updated"]}",
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _aqiDisplay(
    int aqi,
    String status,
    Color aqiColor,
  ) {
    return Column(
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
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          status,
          style: TextStyle(
            color: aqiColor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ENVIRONMENT GRID
  // ============================================================

  Widget _buildEnvironmentGrid(
    Map<String, dynamic> location,
    bool mobile,
  ) {
    final items = [
      [
        Icons.grain_rounded,
        "PM2.5",
        location["pm25"],
      ],
      [
        Icons.blur_on_rounded,
        "PM10",
        location["pm10"],
      ],
      [
        Icons.cloud_rounded,
        "CO",
        location["co"],
      ],
      [
        Icons.thermostat_rounded,
        "Temperature",
        location["temperature"],
      ],
      [
        Icons.water_drop_rounded,
        "Humidity",
        location["humidity"],
      ],
    ];

    if (mobile) {
      return Wrap(
        spacing: 8,
        runSpacing: 10,
        children: items.map(
          (item) {
            return SizedBox(
              width: 142,
              child: _environmentItem(
                item[0] as IconData,
                item[1] as String,
                item[2] as String,
              ),
            );
          },
        ).toList(),
      );
    }

    return Wrap(
      spacing: 20,
      runSpacing: 15,
      children: items.map(
        (item) {
          return SizedBox(
            width: 145,
            child: _environmentItem(
              item[0] as IconData,
              item[1] as String,
              item[2] as String,
            ),
          );
        },
      ).toList(),
    );
  }

  // ============================================================
  // ENVIRONMENT ITEM
  // ============================================================

  Widget _environmentItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: cyanColor,
          size: 17,
        ),

        const SizedBox(width: 7),

        Expanded(
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ANALYSIS BUTTON
  // ============================================================

  Widget _buildAnalysisButton(
    Map<String, dynamic> location,
  ) {
    return OutlinedButton.icon(
      onPressed: () {
        _showAirQualityDetails(location);
      },
      icon: const Icon(
        Icons.analytics_outlined,
        size: 16,
      ),
      label: const Text(
        "View Analysis",
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: cyanColor,
        side: BorderSide(
          color: cyanColor.withOpacity(0.5),
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

    if (aqi <= 200) {
      return Colors.redAccent;
    }

    return Colors.purpleAccent;
  }

  // ============================================================
  // DETAILS DIALOG
  // ============================================================

  void _showAirQualityDetails(
    Map<String, dynamic> location,
  ) {
    final int aqi = location["aqi"];
    final Color aqiColor = _getAQIColor(aqi);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520,
              maxHeight: 650,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: aqiColor.withOpacity(0.12),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.pop(
                              dialogContext,
                            );
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.all(15),
                              decoration: BoxDecoration(
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
                    ),

                    const SizedBox(height: 8),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
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
                    ),
                  ],
                ),
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
      padding: const EdgeInsets.only(
        bottom: 11,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
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