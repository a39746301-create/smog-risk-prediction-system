import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color background = Color(0xff081426);
  static const Color sidebarBlue = Color(0xff102A43);
  static const Color card = Color(0xff132B43);
  static const Color cyan = Colors.cyanAccent;

  // ============================================================
  // STATE
  // ============================================================

  String selectedPeriod = "This Month";
  String selectedReport = "Air Quality Report";
  bool isRefreshing = false;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: sidebarBlue,
        elevation: 0,
        titleSpacing: 14,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: cyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.analytics_rounded,
                color: cyan,
                size: 21,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "Reports & Analytics",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Refresh Reports",
            onPressed: _refreshReports,
            icon: isRefreshing
                ? const SizedBox(
                    width: 19,
                    height: 19,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cyan,
                    ),
                  )
                : const Icon(
                    Icons.refresh_rounded,
                    color: Colors.white,
                  ),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final mobile = width < 600;
          final tablet = width >= 600 && width < 1000;
         

          final horizontalPadding = mobile
              ? 12.0
              : tablet
                  ? 18.0
                  : 25.0;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: mobile ? 14 : 22,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1450,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _header(
                      mobile: mobile,
                      tablet: tablet,
                    ),

                    SizedBox(height: mobile ? 14 : 20),

                    _periodSelector(
                      mobile: mobile,
                    ),

                    SizedBox(height: mobile ? 14 : 20),

                    _summaryCards(
                      mobile: mobile,
                      tablet: tablet,
                    ),

                    SizedBox(height: mobile ? 14 : 22),

                    _airQualityChart(
                      mobile: mobile,
                    ),

                    SizedBox(height: mobile ? 14 : 22),

                    _reportCategories(
                      mobile: mobile,
                      tablet: tablet,
                    ),

                    SizedBox(height: mobile ? 14 : 22),

                    _monthlyOverview(),

                    SizedBox(height: mobile ? 14 : 22),

                    _recentReports(
                      mobile: mobile,
                    ),

                    SizedBox(height: mobile ? 14 : 22),

                    _downloadSection(
                      mobile: mobile,
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
  // REFRESH
  // ============================================================

  Future<void> _refreshReports() async {
    setState(() {
      isRefreshing = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    setState(() {
      isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_rounded,
              color: Colors.greenAccent,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Reports refreshed successfully",
              ),
            ),
          ],
        ),
        backgroundColor: sidebarBlue,
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _header({
    required bool mobile,
    required bool tablet,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        mobile ? 16 : 22,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerIcon(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _headerText(
                        mobile: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _liveBadge(),
              ],
            )
          : Row(
              children: [
                _headerIcon(),
                const SizedBox(width: 15),
                Expanded(
                  child: _headerText(
                    mobile: false,
                  ),
                ),
                _liveBadge(),
              ],
            ),
    );
  }

  Widget _headerIcon() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: cyan.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.insert_chart_rounded,
        color: cyan,
        size: 30,
      ),
    );
  }

  Widget _headerText({
    required bool mobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "System Reports",
          style: TextStyle(
            color: Colors.white,
            fontSize: mobile ? 20 : 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          "Analyze air quality, predictions and alert activity",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _liveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.12),
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
            "Live Analytics",
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
  // PERIOD SELECTOR
  // ============================================================

  Widget _periodSelector({
    required bool mobile,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
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
                    _calendarIcon(),
                    const SizedBox(width: 11),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Analytics Period",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "Select the reporting period",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _periodDropdown(
                  fullWidth: true,
                ),
              ],
            )
          : Row(
              children: [
                _calendarIcon(),
                const SizedBox(width: 11),
                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Analytics Period",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "Select the reporting period",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                _periodDropdown(
                  fullWidth: false,
                ),
              ],
            ),
    );
  }

  Widget _calendarIcon() {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: cyan.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.calendar_month_rounded,
        color: cyan,
        size: 20,
      ),
    );
  }

  Widget _periodDropdown({
    required bool fullWidth,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      height: 40,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: sidebarBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedPeriod,
          isExpanded: fullWidth,
          dropdownColor: sidebarBlue,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white70,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          items: const [
            DropdownMenuItem(
              value: "Today",
              child: Text("Today"),
            ),
            DropdownMenuItem(
              value: "This Week",
              child: Text("This Week"),
            ),
            DropdownMenuItem(
              value: "This Month",
              child: Text("This Month"),
            ),
            DropdownMenuItem(
              value: "This Year",
              child: Text("This Year"),
            ),
          ],
          onChanged: (value) {
            if (value == null) return;

            setState(() {
              selectedPeriod = value;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Analytics updated for $value",
                ),
                backgroundColor: sidebarBlue,
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY CARDS
  // ============================================================

  Widget _summaryCards({
    required bool mobile,
    required bool tablet,
  }) {
    final cards = [
      _Summary(
        "Average AQI",
        "134",
        "+8.4%",
        Icons.air_rounded,
        Colors.orangeAccent,
      ),
      _Summary(
        "Predictions",
        "560",
        "+12.2%",
        Icons.auto_graph_rounded,
        cyan,
      ),
      _Summary(
        "Alerts Generated",
        "18",
        "-5.1%",
        Icons.warning_amber_rounded,
        Colors.redAccent,
      ),
      _Summary(
        "AI Accuracy",
        "94.6%",
        "+2.8%",
        Icons.verified_rounded,
        Colors.greenAccent,
      ),
    ];

    if (mobile) {
      return Column(
        children: cards
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: _summaryCard(item),
              ),
            )
            .toList(),
      );
    }

    if (tablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
        ),
        itemBuilder: (context, index) {
          return _summaryCard(cards[index]);
        },
      );
    }

    return Row(
      children: List.generate(
        cards.length,
        (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == cards.length - 1
                    ? 0
                    : 13,
              ),
              child: _summaryCard(
                cards[index],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _summaryCard(_Summary item) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: card,
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
              color: item.color.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              item.icon,
              color: item.color,
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
                  item.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.change,
                  style: TextStyle(
                    color: item.change.startsWith("-")
                        ? Colors.redAccent
                        : Colors.greenAccent,
                    fontSize: 9,
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
  // AQI CHART
  // ============================================================

  Widget _airQualityChart({
    required bool mobile,
  }) {
    final values = [
      70.0,
      90.0,
      82.0,
      120.0,
      105.0,
      145.0,
      132.0,
      170.0,
      150.0,
      185.0,
      160.0,
      134.0,
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        mobile ? 16 : 22,
      ),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AQI Trend",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Average air quality index over selected period",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cyan.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "AQI",
                  style: TextStyle(
                    color: cyan,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: mobile ? 18 : 25),
          SizedBox(
            height: mobile ? 195 : 250,
            width: double.infinity,
            child: CustomPaint(
              painter: _ReportChartPainter(values),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              _ChartLabel("Jan"),
              _ChartLabel("Feb"),
              _ChartLabel("Mar"),
              _ChartLabel("Apr"),
              _ChartLabel("May"),
              _ChartLabel("Jun"),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REPORT CATEGORIES
  // ============================================================

  Widget _reportCategories({
    required bool mobile,
    required bool tablet,
  }) {
    final cards = [
      _ReportType(
        "Air Quality Report",
        "AQI and pollutant monitoring",
        Icons.air_rounded,
        cyan,
      ),
      _ReportType(
        "AI Prediction Report",
        "Prediction performance",
        Icons.psychology_rounded,
        Colors.purpleAccent,
      ),
      _ReportType(
        "Alert Report",
        "Smog alert history",
        Icons.warning_rounded,
        Colors.orangeAccent,
      ),
      _ReportType(
        "Motorway Report",
        "Highway monitoring status",
        Icons.route_rounded,
        Colors.blueAccent,
      ),
    ];

    if (mobile) {
      return Column(
        children: cards
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(
                  bottom: 12,
                ),
                child: _reportTypeCard(item),
              ),
            )
            .toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 2.15,
      ),
      itemBuilder: (context, index) {
        return _reportTypeCard(cards[index]);
      },
    );
  }

  Widget _reportTypeCard(
    _ReportType item,
  ) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.11),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: 24,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.greenAccent
                      .withValues(alpha: 0.08),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: const Text(
                  "AVAILABLE",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 13),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  selectedReport = item.title;
                });

                _showReportDialog(item);
              },
              icon: const Icon(
                Icons.visibility_rounded,
                size: 15,
              ),
              label: const Text(
                "View Report",
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: cyan,
                side: BorderSide(
                  color: cyan.withValues(alpha: 0.35),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REPORT DIALOG
  // ============================================================

  void _showReportDialog(
    _ReportType item,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: card,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 520,
              maxHeight: 650,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  _dialogHeader(
                    icon: item.icon,
                    color: item.color,
                    title: item.title,
                    subtitle: selectedPeriod,
                    onClose: () {
                      Navigator.pop(dialogContext);
                    },
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _dialogStat(
                            "Report Status",
                            "Generated",
                            Icons.check_circle_rounded,
                            Colors.greenAccent,
                          ),
                          _dialogStat(
                            "Reporting Period",
                            selectedPeriod,
                            Icons.calendar_month_rounded,
                            cyan,
                          ),
                          _dialogStat(
                            "Records Analyzed",
                            "1,248",
                            Icons.dataset_rounded,
                            Colors.orangeAccent,
                          ),
                          _dialogStat(
                            "Last Generated",
                            "Just now",
                            Icons.update_rounded,
                            Colors.purpleAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _dialogActionButtons(
                    dialogContext,
                    item,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _dialogHeader({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onClose,
  }) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onClose,
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white54,
          ),
        ),
      ],
    );
  }

  Widget _dialogActionButtons(
    BuildContext dialogContext,
    _ReportType item,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final narrow = constraints.maxWidth < 360;

        if (narrow) {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: _exportOutlinedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    _showExportDialog(
                      reportName: item.title,
                    );
                  },
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: double.infinity,
                child: _generateButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          "${item.title} generated successfully",
                        ),
                        backgroundColor: sidebarBlue,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _exportOutlinedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);

                  _showExportDialog(
                    reportName: item.title,
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _generateButton(
                onPressed: () {
                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        "${item.title} generated successfully",
                      ),
                      backgroundColor: sidebarBlue,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _exportOutlinedButton({
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: cyan,
        side: const BorderSide(
          color: cyan,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        "Export",
      ),
    );
  }

  Widget _generateButton({
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.autorenew_rounded,
        size: 17,
      ),
      label: const Text(
        "Generate",
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: cyan,
        foregroundColor: background,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _dialogStat(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 9,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.035,
        ),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 11,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
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

  // ============================================================
  // MONTHLY OVERVIEW
  // ============================================================

  Widget _monthlyOverview() {
    final rows = [
      _Overview(
        "Good Air Quality",
        "12 Days",
        Colors.greenAccent,
        0.40,
      ),
      _Overview(
        "Moderate",
        "9 Days",
        Colors.yellowAccent,
        0.30,
      ),
      _Overview(
        "Poor",
        "6 Days",
        Colors.orangeAccent,
        0.20,
      ),
      _Overview(
        "Critical Smog",
        "3 Days",
        Colors.redAccent,
        0.10,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cyan.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.donut_small_rounded,
                  color: cyan,
                  size: 20,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Air Quality Overview",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Distribution of air quality conditions",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ...rows.map(
            (row) => _overviewRow(row),
          ),
        ],
      ),
    );
  }

  Widget _overviewRow(
    _Overview item,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                item.value,
                style: TextStyle(
                  color: item.color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: item.progress,
              minHeight: 6,
              backgroundColor:
                  Colors.white.withValues(
                alpha: 0.06,
              ),
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                item.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECENT REPORTS
  // ============================================================

  Widget _recentReports({
    required bool mobile,
  }) {
    final reports = [
      _RecentReport(
        "Air Quality Analysis",
        "This Month",
        "Generated",
        "Today, 10:30 AM",
        Icons.air_rounded,
        cyan,
      ),
      _RecentReport(
        "AI Prediction Summary",
        "This Month",
        "Generated",
        "Yesterday, 04:20 PM",
        Icons.psychology_rounded,
        Colors.purpleAccent,
      ),
      _RecentReport(
        "Smog Alert History",
        "This Week",
        "Generated",
        "Aug 14, 2026",
        Icons.warning_rounded,
        Colors.orangeAccent,
      ),
      _RecentReport(
        "Motorway Monitoring",
        "This Week",
        "Generated",
        "Aug 12, 2026",
        Icons.route_rounded,
        Colors.blueAccent,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        mobile ? 16 : 22,
      ),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent Reports",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Recently generated system reports",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  _showAllReportsDialog(
                    reports,
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                ),
                label: const Text(
                  "View All",
                ),
                style: TextButton.styleFrom(
                  foregroundColor: cyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...reports.map(
            (item) => _recentReportRow(
              item,
              mobile: mobile,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentReportRow(
    _RecentReport item, {
    required bool mobile,
  }) {
    if (mobile) {
      return Container(
        margin: const EdgeInsets.only(
          bottom: 9,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.035,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                _recentReportIcon(item),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${item.period} • ${item.date}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _readyBadge(),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showExportDialog(
                    reportName: item.title,
                  );
                },
                icon: const Icon(
                  Icons.download_rounded,
                  size: 16,
                ),
                label: const Text(
                  "Export Report",
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white70,
                  side: BorderSide(
                    color: Colors.white.withValues(
                      alpha: 0.10,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(9),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(
        bottom: 9,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.035,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _recentReportIcon(item),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "${item.period} • ${item.date}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          _readyBadge(),
          const SizedBox(width: 8),
          IconButton(
            tooltip: "Export",
            onPressed: () {
              _showExportDialog(
                reportName: item.title,
              );
            },
            icon: const Icon(
              Icons.download_rounded,
              color: Colors.white54,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentReportIcon(
    _RecentReport item,
  ) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: item.color.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(
        item.icon,
        color: item.color,
        size: 19,
      ),
    );
  }

  Widget _readyBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withValues(
          alpha: 0.08,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: const Text(
        "READY",
        style: TextStyle(
          color: Colors.greenAccent,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // ALL REPORTS DIALOG
  // ============================================================

  void _showAllReportsDialog(
    List<_RecentReport> reports,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: card,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
              maxHeight: 600,
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          "All Recent Reports",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 8),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: reports
                            .map(
                              (item) =>
                                  _recentReportRow(
                                item,
                                mobile: true,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
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
                          color: cyan,
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

  // ============================================================
  // EXPORT SECTION
  // ============================================================

  Widget _downloadSection({
    required bool mobile,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff102A43),
            Color(0xff153B5C),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: 0.08,
          ),
        ),
      ),
      child: mobile
          ? Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _downloadIcon(),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: _DownloadText(),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: _exportMainButton(),
                ),
              ],
            )
          : Row(
              children: [
                _downloadIcon(),
                const SizedBox(width: 13),
                const Expanded(
                  child: _DownloadText(),
                ),
                _exportMainButton(),
              ],
            ),
    );
  }

  Widget _downloadIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: cyan.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(13),
      ),
      child: const Icon(
        Icons.description_rounded,
        color: cyan,
        size: 23,
      ),
    );
  }

  Widget _exportMainButton() {
    return ElevatedButton.icon(
      onPressed: () {
        _showExportDialog(
          reportName: selectedReport,
        );
      },
      icon: const Icon(
        Icons.download_rounded,
        size: 16,
      ),
      label: const Text(
        "Export",
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: cyan,
        foregroundColor: background,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // EXPORT DIALOG
  // ============================================================

  void _showExportDialog({
    required String reportName,
  }) {
    String format = "PDF";

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
            dialogBuildContext,
            setDialogState,
          ) {
            return Dialog(
              backgroundColor: card,
              insetPadding:
                  const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(22),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                  maxHeight: 650,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: cyan.withValues(
                                alpha: 0.10,
                              ),
                              borderRadius:
                                  BorderRadius.circular(
                                12,
                              ),
                            ),
                            child: const Icon(
                              Icons.file_download_rounded,
                              color: cyan,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Export Report",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "Choose export format",
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
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
                      const SizedBox(height: 16),
                      Flexible(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _exportInfo(
                                "Report",
                                reportName,
                                Icons.description_rounded,
                              ),
                              _exportInfo(
                                "Period",
                                selectedPeriod,
                                Icons.calendar_month_rounded,
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                "Export Format",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _formatButton(
                                      title: "PDF",
                                      icon: Icons
                                          .picture_as_pdf_rounded,
                                      selected:
                                          format == "PDF",
                                      color:
                                          Colors.redAccent,
                                      onTap: () {
                                        setDialogState(
                                          () {
                                            format = "PDF";
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _formatButton(
                                      title: "CSV",
                                      icon: Icons
                                          .table_chart_rounded,
                                      selected:
                                          format == "CSV",
                                      color:
                                          Colors.greenAccent,
                                      onTap: () {
                                        setDialogState(
                                          () {
                                            format = "CSV";
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child:
                                    ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(
                                      dialogContext,
                                    );

                                    ScaffoldMessenger
                                            .of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: [
                                            const Icon(
                                              Icons
                                                  .check_circle_rounded,
                                              color:
                                                  Colors.greenAccent,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Text(
                                                "$reportName exported as $format",
                                              ),
                                            ),
                                          ],
                                        ),
                                        backgroundColor:
                                            sidebarBlue,
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.download_rounded,
                                    size: 17,
                                  ),
                                  label: Text(
                                    "Generate $format Report",
                                  ),
                                  style:
                                      ElevatedButton.styleFrom(
                                    backgroundColor: cyan,
                                    foregroundColor:
                                        background,
                                    elevation: 0,
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      vertical: 14,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(
                                        11,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
      },
    );
  }

  Widget _exportInfo(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.035,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: cyan,
            size: 17,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formatButton({
    required String title,
    required IconData icon,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.10)
              : Colors.white.withValues(
                  alpha: 0.035,
                ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? color
                : Colors.white.withValues(
                    alpha: 0.08,
                  ),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? color
                    : Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// DOWNLOAD TEXT
// ================================================================

class _DownloadText extends StatelessWidget {
  const _DownloadText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          "Export System Report",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Generate a professional report for the selected period",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

// ================================================================
// DATA CLASSES
// ================================================================

class _Summary {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;

  const _Summary(
    this.title,
    this.value,
    this.change,
    this.icon,
    this.color,
  );
}

class _ReportType {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _ReportType(
    this.title,
    this.subtitle,
    this.icon,
    this.color,
  );
}

class _Overview {
  final String title;
  final String value;
  final Color color;
  final double progress;

  const _Overview(
    this.title,
    this.value,
    this.color,
    this.progress,
  );
}

class _RecentReport {
  final String title;
  final String period;
  final String status;
  final String date;
  final IconData icon;
  final Color color;

  const _RecentReport(
    this.title,
    this.period,
    this.status,
    this.date,
    this.icon,
    this.color,
  );
}

// ================================================================
// CHART LABEL
// ================================================================

class _ChartLabel extends StatelessWidget {
  final String text;

  const _ChartLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 9,
      ),
    );
  }
}

// ================================================================
// CUSTOM AQI CHART
// ================================================================

class _ReportChartPainter extends CustomPainter {
  final List<double> values;

  _ReportChartPainter(this.values);

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    if (values.isEmpty ||
        size.width <= 0 ||
        size.height <= 0) {
      return;
    }

    final paint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = Colors.cyanAccent.withValues(
        alpha: 0.08,
      )
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = Colors.white.withValues(
        alpha: 0.06,
      )
      ..strokeWidth = 1;

    const left = 5.0;
    const right = 5.0;
    const top = 10.0;
    const bottom = 10.0;

    final chartWidth =
        size.width - left - right;

    final chartHeight =
        size.height - top - bottom;

    if (chartWidth <= 0 ||
        chartHeight <= 0) {
      return;
    }

    // Horizontal grid
    for (int i = 0; i <= 4; i++) {
      final y =
          top +
          chartHeight * i / 4;

      canvas.drawLine(
        Offset(left, y),
        Offset(
          size.width - right,
          y,
        ),
        gridPaint,
      );
    }

    const maxValue = 200.0;

    final points = <Offset>[];

    for (
      int i = 0;
      i < values.length;
      i++
    ) {
      final x = values.length == 1
          ? left + chartWidth / 2
          : left +
              chartWidth *
                  i /
                  (values.length - 1);

      final normalized =
          (values[i] / maxValue)
              .clamp(0.0, 1.0);

      final y =
          top +
          chartHeight *
              (1 - normalized);

      points.add(
        Offset(x, y),
      );
    }

    final path = Path();

    path.moveTo(
      points.first.dx,
      points.first.dy,
    );

    for (
      int i = 1;
      i < points.length;
      i++
    ) {
      path.lineTo(
        points[i].dx,
        points[i].dy,
      );
    }

    final fillPath = Path.from(path);

    fillPath.lineTo(
      points.last.dx,
      size.height - bottom,
    );

    fillPath.lineTo(
      points.first.dx,
      size.height - bottom,
    );

    fillPath.close();

    canvas.drawPath(
      fillPath,
      fillPaint,
    );

    canvas.drawPath(
      path,
      paint,
    );

    final dotPaint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(
        point,
        3.5,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(
    covariant _ReportChartPainter oldDelegate,
  ) {
    return oldDelegate.values != values;
  }
}
