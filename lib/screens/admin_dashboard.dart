import 'package:flutter/material.dart';

import '../widgets/aqi_chart.dart';
import '../widgets/alert_table.dart';
import '../widgets/motorway_monitor.dart';
import '../widgets/ai_prediction.dart';
import '../widgets/risk_chart.dart';

import 'users_screen.dart';
import 'air_quality_screen.dart';
import 'alert_screen.dart';
import 'nhmp_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'notifications_screen.dart';
import 'login_page.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  // ============================================================
  // COLORS
  // ============================================================

  static const Color backgroundColor = Color(0xff081426);
  static const Color sidebarColor = Color(0xff102A43);
  static const Color cardColor = Color(0xff102A43);

  static const Color cyanColor = Colors.cyanAccent;
  static const Color blueColor = Color(0xff3B82F6);
  static const Color redColor = Colors.redAccent;

  static const Color whiteColor = Colors.white;
  static const Color secondaryColor = Colors.white70;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        // ========================================================
        // RESPONSIVE BREAKPOINTS
        // ========================================================

        final bool isMobile = width < 700;
        final bool isTablet = width >= 700 && width < 1100;
        final bool isDesktop = width >= 1100;

        return Scaffold(
          backgroundColor: backgroundColor,

          // ======================================================
          // MOBILE DRAWER
          // ======================================================

          drawer: isMobile
              ? Drawer(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: SafeArea(
                    child: SizedBox(
                      width: 285,
                      child: _buildSidebar(
                        context,
                        false,
                      ),
                    ),
                  ),
                )
              : null,

          body: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // DESKTOP SIDEBAR
                // ==================================================

                if (!isMobile)
                  _buildSidebar(
                    context,
                    isTablet,
                  ),

                // ==================================================
                // MAIN CONTENT
                // ==================================================

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      isMobile ? 14 : isTablet ? 20 : 28,
                      isMobile ? 14 : isTablet ? 20 : 24,
                      isMobile ? 14 : isTablet ? 20 : 28,
                      35,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==================================================
                        // HEADER
                        // ==================================================

                        _buildHeader(
                          context,
                          isMobile,
                          isTablet,
                        ),

                        SizedBox(
                          height: isMobile ? 18 : 24,
                        ),

                        // ==================================================
                        // OVERVIEW
                        // ==================================================

                        _buildSectionHeading(
                          "Dashboard Overview",
                          "Real-time system performance at a glance",
                          isMobile: isMobile,
                        ),

                        SizedBox(
                          height: isMobile ? 12 : 15,
                        ),

                        // ==================================================
                        // DASHBOARD CARDS
                        // ==================================================

                        _buildDashboardCards(
                          context,
                          isMobile,
                          isTablet,
                        ),

                        SizedBox(
                          height: isMobile ? 20 : 27,
                        ),

                        // ==================================================
                        // LIVE STATUS
                        // ==================================================

                        _buildLiveStatusPanel(
                          isMobile || isTablet,
                        ),

                        SizedBox(
                          height: isMobile ? 20 : 28,
                        ),

                        // ==================================================
                        // ANALYTICS
                        // ==================================================

                        _buildSectionHeading(
                          "Air Quality Analytics",
                          "AQI trends and smog risk distribution",
                          isMobile: isMobile,
                        ),

                        SizedBox(
                          height: isMobile ? 12 : 15,
                        ),

                        _buildCharts(
                          context,
                          isMobile,
                          isTablet,
                        ),

                        SizedBox(
                          height: isMobile ? 20 : 28,
                        ),

                        // ==================================================
                        // RECENT SMOG ALERTS
                        // ==================================================

                        _buildDashboardSection(
                          title: "Recent Smog Alerts",
                          subtitle:
                              "Latest alerts generated by the monitoring system",
                          icon: Icons.warning_amber_rounded,
                          color: redColor,
                          buttonText: "View All",
                          isMobile: isMobile,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const AlertScreen(),
                              ),
                            );
                          },
                          child: const AlertTable(),
                        ),

                        SizedBox(
                          height: isMobile ? 20 : 28,
                        ),

                        // ==================================================
                        // MOTORWAY MONITORING
                        // ==================================================

                        _buildDashboardSection(
                          title: "Motorway Monitoring",
                          subtitle:
                              "Current NHMP motorway monitoring status",
                          icon: Icons.route_rounded,
                          color: blueColor,
                          buttonText: "View Stations",
                          isMobile: isMobile,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const NHMPScreen(),
                              ),
                            );
                          },
                          child: const MotorwayMonitor(),
                        ),

                        SizedBox(
                          height: isMobile ? 20 : 28,
                        ),

                        // ==================================================
                        // AI RISK PREDICTION
                        // ==================================================

                        _buildDashboardSection(
                          title: "AI Risk Prediction",
                          subtitle:
                              "AI-powered smog risk analysis and forecasting",
                          icon: Icons.psychology_rounded,
                          color: cyanColor,
                          buttonText: "View Reports",
                          isMobile: isMobile,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ReportsScreen(),
                              ),
                            );
                          },
                          child: const AIPrediction(),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget _buildSidebar(
    BuildContext context,
    bool isTablet,
  ) {
    return Container(
      width: isTablet ? 225 : 260,
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: sidebarColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 25,
            offset: const Offset(5, 0),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 28),

            // ========================================================
            // LOGO
            // ========================================================

            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: cyanColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: cyanColor.withOpacity(0.25),
                ),
              ),
              child: const Icon(
                Icons.cloud_rounded,
                color: cyanColor,
                size: 31,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Smog AI",
              style: TextStyle(
                color: whiteColor,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Risk Prediction System",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 11.5,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white.withOpacity(0.08),
            ),

            const SizedBox(height: 18),

            _sidebarItem(
              context,
              Icons.dashboard_rounded,
              "Dashboard",
              active: true,
            ),

            _sidebarItem(
              context,
              Icons.people_rounded,
              "Users",
            ),

            _sidebarItem(
              context,
              Icons.route_rounded,
              "NHMP Stations",
            ),

            _sidebarItem(
              context,
              Icons.air_rounded,
              "Air Quality",
            ),

            _sidebarItem(
              context,
              Icons.warning_rounded,
              "Alerts",
            ),

            _sidebarItem(
              context,
              Icons.bar_chart_rounded,
              "Reports",
            ),

            _sidebarItem(
              context,
              Icons.settings_rounded,
              "Settings",
            ),

            _sidebarItem(
              context,
              Icons.person_rounded,
              "Profile",
            ),

            const SizedBox(height: 20),

            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white.withOpacity(0.08),
            ),

            const SizedBox(height: 15),

            _sidebarItem(
              context,
              Icons.logout_rounded,
              "Logout",
              logout: true,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SIDEBAR ITEM
  // ============================================================

  Widget _sidebarItem(
    BuildContext context,
    IconData icon,
    String title, {
    bool active = false,
    bool logout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 3,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          hoverColor: Colors.white.withOpacity(0.05),
          splashColor: cyanColor.withOpacity(0.08),
          onTap: () {
            // Mobile drawer close
            if (MediaQuery.of(context).size.width < 700) {
              Navigator.pop(context);
            }

            _navigate(
              context,
              title,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(
              milliseconds: 180,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: active
                  ? cyanColor.withOpacity(0.13)
                  : logout
                      ? redColor.withOpacity(0.04)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: active
                  ? Border.all(
                      color: cyanColor.withOpacity(0.18),
                    )
                  : Border.all(
                      color: Colors.transparent,
                    ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: active
                        ? cyanColor.withOpacity(0.13)
                        : logout
                            ? redColor.withOpacity(0.08)
                            : Colors.white.withOpacity(0.045),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 21,
                    color: active
                        ? cyanColor
                        : logout
                            ? redColor
                            : Colors.white70,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active
                          ? cyanColor
                          : logout
                              ? redColor
                              : whiteColor,
                      fontSize: 14,
                      fontWeight:
                          active
                              ? FontWeight.bold
                              : FontWeight.w500,
                    ),
                  ),
                ),

                if (active)
                  Container(
                    width: 5,
                    height: 5,
                    decoration:
                        const BoxDecoration(
                      color: cyanColor,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _navigate(
    BuildContext context,
    String title,
  ) {
    switch (title) {
      case "Dashboard":
        return;

      case "Users":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const UsersScreen(),
          ),
        );
        break;

      case "NHMP Stations":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const NHMPScreen(),
          ),
        );
        break;

      case "Air Quality":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AirQualityScreen(),
          ),
        );
        break;

      case "Alerts":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const AlertScreen(),
          ),
        );
        break;

      case "Reports":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const ReportsScreen(),
          ),
        );
        break;

      case "Settings":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const SettingsScreen(),
          ),
        );
        break;

      case "Profile":
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const ProfileScreen(),
          ),
        );
        break;

      case "Logout":
        _showLogoutDialog(context);
        break;
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _showLogoutDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      barrierColor:
          Colors.black.withOpacity(0.65),
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: sidebarColor,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color:
                      redColor.withOpacity(0.10),
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: redColor,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to logout?",
            style: TextStyle(
              color: secondaryColor,
              fontSize: 14,
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
                  color: secondaryColor,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const LoginPage(),
                  ),
                  (route) => false,
                );
              },
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: redColor,
                foregroundColor: whiteColor,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(
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
  // HEADER
  // ============================================================

  Widget _buildHeader(
    BuildContext context,
    bool isMobile,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        isMobile ? 14 : 22,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff102A43),
            Color(0xff163B5C),
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          isMobile ? 18 : 24,
        ),
        border: Border.all(
          color:
              Colors.white.withOpacity(0.09),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.18),
            blurRadius: 25,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // ======================================================
          // MOBILE MENU BUTTON
          // ======================================================

          if (isMobile) ...[
            Builder(
              builder: (drawerContext) {
                return GestureDetector(
                  onTap: () {
                    Scaffold.of(
                      drawerContext,
                    ).openDrawer();
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration:
                        BoxDecoration(
                      color:
                          Colors.white.withOpacity(
                        0.07,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        13,
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_rounded,
                      color: whiteColor,
                      size: 24,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(width: 10),
          ],

          // ======================================================
          // ADMIN ICON
          // ======================================================

          Container(
            width: isMobile ? 46 : 56,
            height: isMobile ? 46 : 56,
            decoration: BoxDecoration(
              color:
                  cyanColor.withOpacity(0.13),
              borderRadius:
                  BorderRadius.circular(17),
              border: Border.all(
                color:
                    cyanColor.withOpacity(0.20),
              ),
            ),
            child: Icon(
              Icons.admin_panel_settings_rounded,
              color: cyanColor,
              size: isMobile ? 24 : 30,
            ),
          ),

          SizedBox(
            width: isMobile ? 10 : 15,
          ),

          // ======================================================
          // WELCOME TEXT
          // ======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  isMobile
                      ? "Welcome, Admin 👋"
                      : "Welcome back, Admin 👋",
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    color: whiteColor,
                    fontSize:
                        isMobile ? 16 : 25,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                if (!isMobile) ...[
                  const SizedBox(height: 5),

                  const Text(
                    "Monitor air quality, predictions and alerts",
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          secondaryColor,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ======================================================
          // NOTIFICATION
          // ======================================================

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const NotificationsScreen(),
                ),
              );
            },
            child: _headerButton(
              icon:
                  Icons.notifications_none_rounded,
              badge: "3",
              small: isMobile,
            ),
          ),

          // ======================================================
          // PROFILE
          // ======================================================

          if (!isMobile) ...[
            const SizedBox(width: 10),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color:
                    Colors.white.withOpacity(
                  0.06,
                ),
                borderRadius:
                    BorderRadius.circular(14),
                border: Border.all(
                  color:
                      Colors.white.withOpacity(
                    0.06,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 19,
                    backgroundColor:
                        cyanColor,
                    child: Icon(
                      Icons.person,
                      color:
                          backgroundColor,
                      size: 21,
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    "Admin",
                    style: TextStyle(
                      color: whiteColor,
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(width: 4),

                  const Icon(
                    Icons
                        .keyboard_arrow_down_rounded,
                    color: Colors.white60,
                    size: 18,
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
  // HEADER BUTTON
  // ============================================================

  Widget _headerButton({
    required IconData icon,
    String? badge,
    bool small = false,
  }) {
    return Container(
      width: small ? 42 : 45,
      height: small ? 42 : 45,
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.07),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              Colors.white.withOpacity(0.07),
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              icon,
              color: whiteColor,
              size: small ? 21 : 23,
            ),
          ),

          if (badge != null)
            Positioned(
              right: 6,
              top: 5,
              child: Container(
                width: 14,
                height: 14,
                decoration:
                    const BoxDecoration(
                  color: redColor,
                  shape: BoxShape.circle,
                ),
                alignment:
                    Alignment.center,
                child: Text(
                  badge,
                  style:
                      const TextStyle(
                    color: whiteColor,
                    fontSize: 8,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION HEADING
  // ============================================================

  Widget _buildSectionHeading(
    String title,
    String subtitle, {
    String? buttonText,
    VoidCallback? onPressed,
    bool isMobile = false,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 34,
          decoration: BoxDecoration(
            color: cyanColor,
            borderRadius:
                BorderRadius.circular(10),
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: whiteColor,
                  fontSize:
                      isMobile ? 16 : 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                maxLines: isMobile ? 2 : 1,
                overflow:
                    TextOverflow.ellipsis,
                style: const TextStyle(
                  color: secondaryColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        if (!isMobile &&
            buttonText != null &&
            onPressed != null)
          _actionButton(
            text: buttonText,
            onPressed: onPressed,
          ),
      ],
    );
  }

  // ============================================================
  // ACTION BUTTON
  // ============================================================

  Widget _actionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(
        Icons.arrow_forward_rounded,
        size: 15,
      ),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        foregroundColor: cyanColor,
        side: BorderSide(
          color:
              cyanColor.withOpacity(0.30),
        ),
        backgroundColor:
            cyanColor.withOpacity(0.05),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 10,
        ),
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // DASHBOARD CARDS
  // ============================================================

  Widget _buildDashboardCards(
    BuildContext context,
    bool isMobile,
    bool isTablet,
  ) {
    final cards = [
      _DashboardCardData(
        title: "Total Users",
        value: "12,450",
        status: "+12.5%",
        icon: Icons.people_rounded,
        color: cyanColor,
        page: const UsersScreen(),
      ),
      _DashboardCardData(
        title: "NHMP Stations",
        value: "35",
        status: "Active",
        icon: Icons.route_rounded,
        color: blueColor,
        page: const NHMPScreen(),
      ),
      _DashboardCardData(
        title: "Predictions",
        value: "560",
        status: "Today",
        icon: Icons.analytics_rounded,
        color: cyanColor,
        page: const ReportsScreen(),
      ),
      _DashboardCardData(
        title: "Alerts",
        value: "18",
        status: "Active",
        icon: Icons.warning_rounded,
        color: redColor,
        page: const AlertScreen(),
      ),
    ];

    // ==========================================================
    // MOBILE
    // ==========================================================

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0;
              i < cards.length;
              i++) ...[
            _dashboardCard(
              context,
              cards[i],
            ),
            if (i != cards.length - 1)
              const SizedBox(height: 12),
          ],
        ],
      );
    }

    // ==========================================================
    // TABLET
    // ==========================================================

    if (isTablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(),
        itemCount: cards.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 2.0,
        ),
        itemBuilder:
            (context, index) {
          return _dashboardCard(
            context,
            cards[index],
          );
        },
      );
    }

    // ==========================================================
    // DESKTOP
    // ==========================================================

    return Row(
      children: List.generate(
        cards.length,
        (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right:
                    index ==
                            cards.length - 1
                        ? 0
                        : 14,
              ),
              child: _dashboardCard(
                context,
                cards[index],
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // DASHBOARD CARD
  // ============================================================

  Widget _dashboardCard(
    BuildContext context,
    _DashboardCardData data,
  ) {
    return Material(
      color: Colors.transparent,
      borderRadius:
          BorderRadius.circular(20),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(20),
        hoverColor:
            Colors.white.withOpacity(0.025),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => data.page,
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient:
                LinearGradient(
              colors: [
                Colors.white
                    .withOpacity(0.09),
                Colors.white
                    .withOpacity(0.035),
              ],
              begin:
                  Alignment.topLeft,
              end:
                  Alignment.bottomRight,
            ),
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color:
                  Colors.white.withOpacity(
                0.09,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(
                  0.12,
                ),
                blurRadius: 18,
                offset:
                    const Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Container(
                    width: 47,
                    height: 47,
                    decoration:
                        BoxDecoration(
                      color:
                          data.color.withOpacity(
                        0.12,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        14,
                      ),
                    ),
                    child: Icon(
                      data.icon,
                      color: data.color,
                      size: 25,
                    ),
                  ),

                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration:
                        BoxDecoration(
                      color:
                          data.color.withOpacity(
                        0.08,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        8,
                      ),
                    ),
                    child: Text(
                      data.status,
                      style: TextStyle(
                        color: data.color,
                        fontSize: 9,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Text(
                data.title,
                style:
                    const TextStyle(
                  color: secondaryColor,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  Text(
                    data.value,
                    style:
                        const TextStyle(
                      color: whiteColor,
                      fontSize: 23,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  Icon(
                    Icons
                        .arrow_forward_rounded,
                    color:
                        data.color.withOpacity(
                      0.65,
                    ),
                    size: 18,
                  ),
                ],
              ),

              const SizedBox(height: 7),

              const Text(
                "View details",
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LIVE STATUS
  // ============================================================

  Widget _buildLiveStatusPanel(
    bool isSmall,
  ) {
    final content = [
      _liveItem(
        Icons.cloud_rounded,
        "Air Quality System",
        "Operational",
        Colors.greenAccent,
      ),
      _liveItem(
        Icons.route_rounded,
        "NHMP Monitoring",
        "35 Stations Online",
        cyanColor,
      ),
      _liveItem(
        Icons.psychology_rounded,
        "AI Prediction Engine",
        "Running",
        blueColor,
      ),
      _liveItem(
        Icons.notifications_active_rounded,
        "Alert Service",
        "18 Active Alerts",
        Colors.orangeAccent,
      ),
    ];

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient:
            const LinearGradient(
          colors: [
            Color(0xff0D2139),
            Color(0xff102A43),
          ],
        ),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              Colors.white.withOpacity(0.08),
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
                width: 36,
                height: 36,
                decoration:
                    BoxDecoration(
                  color:
                      cyanColor.withOpacity(
                    0.10,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),
                child: const Icon(
                  Icons
                      .monitor_heart_rounded,
                  color: cyanColor,
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
                      "Live System Status",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Current platform health",
                      style: TextStyle(
                        color:
                            secondaryColor,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),

              if (!isSmall)
                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration:
                      BoxDecoration(
                    color: Colors
                        .greenAccent
                        .withOpacity(0.08),
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color:
                            Colors.greenAccent,
                        size: 7,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "All Systems Normal",
                        style: TextStyle(
                          color:
                              Colors.greenAccent,
                          fontSize: 9,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          if (isSmall)
            const Padding(
              padding:
                  EdgeInsets.only(top: 12),
              child: Align(
                alignment:
                    Alignment.centerLeft,
                child: Text(
                  "●  All Systems Normal",
                  style: TextStyle(
                    color:
                        Colors.greenAccent,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 18),

          if (isSmall)
            Column(
              children: [
                for (int i = 0;
                    i < content.length;
                    i++) ...[
                  content[i],
                  if (i !=
                      content.length - 1)
                    const SizedBox(
                      height: 10,
                    ),
                ],
              ],
            )
          else
            Row(
              children: [
                for (int i = 0;
                    i < content.length;
                    i++)
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.only(
                        right:
                            i ==
                                    content.length -
                                        1
                                ? 0
                                : 10,
                      ),
                      child:
                          content[i],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _liveItem(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.035),
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration:
                BoxDecoration(
              color:
                  color.withOpacity(0.10),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 18,
            ),
          ),

          const SizedBox(width: 9),

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
                    color: Colors.white70,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: color,
                      size: 6,
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        value,
                        overflow:
                            TextOverflow.ellipsis,
                        style: TextStyle(
                          color: color,
                          fontSize: 9,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHARTS
  // ============================================================

  Widget _buildCharts(
    BuildContext context,
    bool isMobile,
    bool isTablet,
  ) {
    if (isMobile) {
      return Column(
        children: [
          _chartContainer(
            const AQIChart(),
            290,
          ),

          const SizedBox(height: 16),

          _chartContainer(
            const RiskChart(),
            290,
          ),
        ],
      );
    }

    if (isTablet) {
      return Column(
        children: [
          _chartContainer(
            const AQIChart(),
            320,
          ),

          const SizedBox(height: 18),

          _chartContainer(
            const RiskChart(),
            320,
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _chartContainer(
            const AQIChart(),
            350,
          ),
        ),

        const SizedBox(width: 20),

        Expanded(
          flex: 2,
          child: _chartContainer(
            const RiskChart(),
            350,
          ),
        ),
      ],
    );
  }

  Widget _chartContainer(
    Widget child,
    double height,
  ) {
    return Container(
      height: height,
      width: double.infinity,
      padding:
          const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            Colors.white.withOpacity(0.035),
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color:
              Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset:
                const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(14),
        child: child,
      ),
    );
  }

  // ============================================================
  // PROFESSIONAL DASHBOARD SECTION
  // ============================================================

  Widget _buildDashboardSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget child,
    required bool isMobile,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color:
              Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset:
                const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // ======================================================
          // HEADER
          // ======================================================

          Padding(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              14,
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration:
                                BoxDecoration(
                              color: color
                                  .withOpacity(
                                0.12,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                13,
                              ),
                            ),
                            child: Icon(
                              icon,
                              color: color,
                              size: 21,
                            ),
                          ),

                          const SizedBox(
                            width: 11,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  title,
                                  style:
                                      const TextStyle(
                                    color:
                                        whiteColor,
                                    fontSize:
                                        15,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 4,
                                ),

                                Text(
                                  subtitle,
                                  maxLines: 3,
                                  overflow:
                                      TextOverflow
                                          .ellipsis,
                                  style:
                                      const TextStyle(
                                    color:
                                        secondaryColor,
                                    fontSize:
                                        10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (buttonText !=
                              null &&
                          onPressed != null)
                        Padding(
                          padding:
                              const EdgeInsets
                                  .only(
                            top: 12,
                          ),
                          child:
                              SizedBox(
                            width:
                                double.infinity,
                            child:
                                OutlinedButton.icon(
                              onPressed:
                                  onPressed,
                              icon:
                                  const Icon(
                                Icons
                                    .arrow_forward_rounded,
                                size: 14,
                              ),
                              label:
                                  Text(
                                buttonText,
                              ),
                              style:
                                  OutlinedButton
                                      .styleFrom(
                                foregroundColor:
                                    color,
                                side:
                                    BorderSide(
                                  color: color
                                      .withOpacity(
                                    0.30,
                                  ),
                                ),
                                backgroundColor:
                                    color
                                        .withOpacity(
                                  0.06,
                                ),
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical:
                                      10,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    10,
                                  ),
                                ),
                                textStyle:
                                    const TextStyle(
                                  fontSize:
                                      10,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration:
                            BoxDecoration(
                          color: color
                              .withOpacity(
                            0.12,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(
                            13,
                          ),
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 22,
                        ),
                      ),

                      const SizedBox(
                        width: 13,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              title,
                              style:
                                  const TextStyle(
                                color:
                                    whiteColor,
                                fontSize:
                                    16,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),

                            const SizedBox(
                              height: 4,
                            ),

                            Text(
                              subtitle,
                              maxLines: 2,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style:
                                  const TextStyle(
                                color:
                                    secondaryColor,
                                fontSize:
                                    11,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (buttonText !=
                              null &&
                          onPressed != null)
                        OutlinedButton.icon(
                          onPressed:
                              onPressed,
                          icon:
                              const Icon(
                            Icons
                                .arrow_forward_rounded,
                            size: 14,
                          ),
                          label:
                              Text(
                            buttonText,
                          ),
                          style:
                              OutlinedButton
                                  .styleFrom(
                            foregroundColor:
                                color,
                            side:
                                BorderSide(
                              color: color
                                  .withOpacity(
                                0.30,
                              ),
                            ),
                            backgroundColor:
                                color
                                    .withOpacity(
                              0.06,
                            ),
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  12,
                              vertical:
                                  9,
                            ),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                10,
                              ),
                            ),
                            textStyle:
                                const TextStyle(
                              fontSize:
                                  10,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),

          // ======================================================
          // DIVIDER
          // ======================================================

          Container(
            height: 1,
            color:
                Colors.white.withOpacity(
              0.06,
            ),
          ),

          // ======================================================
          // CHILD WIDGET
          // ======================================================

          Padding(
            padding:
                const EdgeInsets.all(10),
            child: child,
          ),
        ],
      ),
    );
  }
}

// ================================================================
// DASHBOARD CARD DATA
// ================================================================

class _DashboardCardData {
  final String title;
  final String value;
  final String status;
  final IconData icon;
  final Color color;
  final Widget page;

  const _DashboardCardData({
    required this.title,
    required this.value,
    required this.status,
    required this.icon,
    required this.color,
    required this.page,
  });
}