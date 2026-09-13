import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color background = Color(0xff081426);
  static const Color cardColor = Color(0xff102A43);
  static const Color cyan = Colors.cyanAccent;

  // ============================================================
  // SETTINGS
  // ============================================================

  bool notifications = true;
  bool alerts = true;
  bool darkMode = true;
  bool autoRefresh = true;
  bool emailReports = false;
  bool predictionAlerts = true;
  bool soundAlerts = true;
  bool maintenanceNotifications = true;
  bool locationMonitoring = true;
  bool dataBackup = true;

  String refreshRate = "5 minutes";
  String alertThreshold = "Unhealthy";
  String dataRetention = "30 days";

  bool hasChanges = false;

  // ============================================================
  // RESPONSIVE HELPERS
  // ============================================================

  bool _isMobile(double width) => width < 600;

  bool _isTablet(double width) => width >= 600 && width < 1000;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      appBar: _buildAppBar(context),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final mobile = _isMobile(width);
          final tablet = _isTablet(width);

          final horizontalPadding = mobile
              ? 12.0
              : tablet
                  ? 18.0
                  : 25.0;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              mobile ? 14 : 20,
              horizontalPadding,
              25,
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

                    const SizedBox(height: 18),

                    _buildGeneralSection(),

                    const SizedBox(height: 18),

                    _buildAlertSection(),

                    const SizedBox(height: 18),

                    _buildDashboardSection(),

                    const SizedBox(height: 18),

                    _buildMonitoringSection(),

                    const SizedBox(height: 18),

                    _buildDataSection(),

                    const SizedBox(height: 18),

                    _buildSecuritySection(),

                    const SizedBox(height: 18),

                    _buildSystemSection(),

                    const SizedBox(height: 18),

                    _buildSaveSection(
                      mobile: mobile,
                      tablet: tablet,
                    ),

                    const SizedBox(height: 10),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: cardColor,
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
              Icons.settings_rounded,
              color: cyan,
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          Flexible(
            child: Row(
              children: [
                Flexible(
                  child: const Text(
                    "System Settings",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (hasChanges) ...[
                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Unsaved",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),

      actions: [
        IconButton(
          tooltip: "Reset Settings",
          onPressed: _showResetDialog,
          icon: const Icon(
            Icons.restart_alt_rounded,
            color: Colors.white70,
          ),
        ),

        const SizedBox(width: 4),
      ],
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
        mobile ? 16 : 22,
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
        borderRadius: BorderRadius.circular(
          mobile ? 16 : 20,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: mobile
          ? _mobileHeader()
          : _desktopHeader(tablet),
    );
  }

  Widget _mobileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: cyan.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                color: cyan,
                size: 27,
              ),
            ),

            const SizedBox(width: 13),

            const Expanded(
              child: Text(
                "System Preferences",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        const Text(
          "Configure dashboard, notifications, monitoring and system preferences.",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
            height: 1.4,
          ),
        ),

        const SizedBox(height: 12),

        _systemOnlineBadge(),
      ],
    );
  }

  Widget _desktopHeader(bool tablet) {
    return Row(
      children: [
        Container(
          width: tablet ? 52 : 56,
          height: tablet ? 52 : 56,
          decoration: BoxDecoration(
            color: cyan.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.admin_panel_settings_rounded,
            color: cyan,
            size: tablet ? 28 : 30,
          ),
        ),

        const SizedBox(width: 15),

        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "System Preferences",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 5),

              Text(
                "Configure dashboard, notifications, monitoring and system preferences",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 15),

        _systemOnlineBadge(),
      ],
    );
  }

  Widget _systemOnlineBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.greenAccent.withValues(alpha: 0.15),
        ),
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
            "System Online",
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GENERAL
  // ============================================================

  Widget _buildGeneralSection() {
    return _section(
      title: "General Preferences",
      subtitle: "Manage basic system preferences",
      icon: Icons.tune_rounded,
      children: [
        _settingTile(
          icon: Icons.notifications_none_rounded,
          iconColor: cyan,
          title: "Notifications",
          subtitle: "Receive system notifications",
          value: notifications,
          onChanged: (value) {
            _change(() => notifications = value);
          },
        ),

        _settingTile(
          icon: Icons.dark_mode_rounded,
          iconColor: Colors.purpleAccent,
          title: "Dark Mode",
          subtitle: "Use dark interface for the system",
          value: darkMode,
          onChanged: (value) {
            _change(() => darkMode = value);
          },
        ),

        _settingTile(
          icon: Icons.volume_up_rounded,
          iconColor: Colors.blueAccent,
          title: "Sound Alerts",
          subtitle: "Play sound when critical alerts arrive",
          value: soundAlerts,
          onChanged: (value) {
            _change(() => soundAlerts = value);
          },
        ),

        _settingTile(
          icon: Icons.build_circle_outlined,
          iconColor: Colors.orangeAccent,
          title: "Maintenance Notifications",
          subtitle: "Receive system maintenance updates",
          value: maintenanceNotifications,
          onChanged: (value) {
            _change(() => maintenanceNotifications = value);
          },
        ),
      ],
    );
  }

  // ============================================================
  // ALERT SETTINGS
  // ============================================================

  Widget _buildAlertSection() {
    return _section(
      title: "Alert Preferences",
      subtitle: "Control smog and AI prediction alerts",
      icon: Icons.warning_amber_rounded,
      children: [
        _settingTile(
          icon: Icons.warning_rounded,
          iconColor: Colors.redAccent,
          title: "Smog Alerts",
          subtitle: "Receive alerts for dangerous air quality",
          value: alerts,
          onChanged: (value) {
            _change(() => alerts = value);
          },
        ),

        _settingTile(
          icon: Icons.psychology_rounded,
          iconColor: Colors.orangeAccent,
          title: "AI Prediction Alerts",
          subtitle: "Receive warnings based on AI predictions",
          value: predictionAlerts,
          onChanged: (value) {
            _change(() => predictionAlerts = value);
          },
        ),

        _settingTile(
          icon: Icons.email_outlined,
          iconColor: Colors.lightBlueAccent,
          title: "Email Reports",
          subtitle: "Receive generated reports through email",
          value: emailReports,
          onChanged: (value) {
            _change(() => emailReports = value);
          },
        ),

        _dropdownTile(
          icon: Icons.speed_rounded,
          iconColor: Colors.redAccent,
          title: "Alert Threshold",
          subtitle: "Minimum AQI level for automatic alerts",
          value: alertThreshold,
          items: const [
            "Moderate",
            "Unhealthy",
            "Very Unhealthy",
            "Hazardous",
          ],
          onChanged: (value) {
            if (value != null) {
              _change(() => alertThreshold = value);
            }
          },
        ),
      ],
    );
  }

  // ============================================================
  // DASHBOARD
  // ============================================================

  Widget _buildDashboardSection() {
    return _section(
      title: "Dashboard Configuration",
      subtitle: "Configure monitoring and display options",
      icon: Icons.dashboard_customize_rounded,
      children: [
        _settingTile(
          icon: Icons.sync_rounded,
          iconColor: Colors.blueAccent,
          title: "Auto Refresh",
          subtitle: "Automatically refresh monitoring data",
          value: autoRefresh,
          onChanged: (value) {
            _change(() => autoRefresh = value);
          },
        ),

        _dropdownTile(
          icon: Icons.timer_outlined,
          iconColor: cyan,
          title: "Refresh Rate",
          subtitle: "How often dashboard data is updated",
          value: refreshRate,
          items: const [
            "1 minute",
            "5 minutes",
            "10 minutes",
            "30 minutes",
          ],
          onChanged: (value) {
            if (value != null) {
              _change(() => refreshRate = value);
            }
          },
        ),
      ],
    );
  }

  // ============================================================
  // MONITORING
  // ============================================================

  Widget _buildMonitoringSection() {
    return _section(
      title: "Monitoring Configuration",
      subtitle: "Manage live monitoring services",
      icon: Icons.monitor_heart_rounded,
      children: [
        _settingTile(
          icon: Icons.location_on_outlined,
          iconColor: Colors.greenAccent,
          title: "Location Monitoring",
          subtitle: "Track active monitoring station locations",
          value: locationMonitoring,
          onChanged: (value) {
            _change(() => locationMonitoring = value);
          },
        ),

        _actionTile(
          icon: Icons.sensors_rounded,
          iconColor: cyan,
          title: "Monitoring Stations",
          subtitle: "35 active monitoring stations",
          buttonText: "View",
          onPressed: _showStationsDialog,
        ),

        _actionTile(
          icon: Icons.cloud_done_rounded,
          iconColor: Colors.greenAccent,
          title: "Sensor Connection",
          subtitle: "All monitoring sensors are connected",
          buttonText: "Check",
          onPressed: _showSensorStatus,
        ),
      ],
    );
  }

  // ============================================================
  // DATA
  // ============================================================

  Widget _buildDataSection() {
    return _section(
      title: "Data Management",
      subtitle: "Manage reports, backups and stored monitoring data",
      icon: Icons.storage_rounded,
      children: [
        _settingTile(
          icon: Icons.backup_rounded,
          iconColor: Colors.greenAccent,
          title: "Automatic Backup",
          subtitle: "Automatically backup system monitoring data",
          value: dataBackup,
          onChanged: (value) {
            _change(() => dataBackup = value);
          },
        ),

        _dropdownTile(
          icon: Icons.history_rounded,
          iconColor: Colors.orangeAccent,
          title: "Data Retention",
          subtitle: "How long monitoring records are stored",
          value: dataRetention,
          items: const [
            "7 days",
            "30 days",
            "90 days",
            "1 year",
          ],
          onChanged: (value) {
            if (value != null) {
              _change(() => dataRetention = value);
            }
          },
        ),

        _actionTile(
          icon: Icons.download_rounded,
          iconColor: Colors.lightBlueAccent,
          title: "Export System Report",
          subtitle: "Generate a report of current system data",
          buttonText: "Export",
          onPressed: _exportReport,
        ),
      ],
    );
  }

  // ============================================================
  // SECURITY
  // ============================================================

  Widget _buildSecuritySection() {
    return _section(
      title: "Security & Access",
      subtitle: "Manage administrator security preferences",
      icon: Icons.security_rounded,
      children: [
        _actionTile(
          icon: Icons.lock_outline_rounded,
          iconColor: Colors.redAccent,
          title: "Change Password",
          subtitle: "Update administrator account password",
          buttonText: "Change",
          onPressed: _showPasswordDialog,
        ),

        _actionTile(
          icon: Icons.history_rounded,
          iconColor: Colors.orangeAccent,
          title: "Activity Logs",
          subtitle: "Review recent administrator activity",
          buttonText: "View",
          onPressed: _showActivityLogs,
        ),
      ],
    );
  }

  // ============================================================
  // SYSTEM INFORMATION
  // ============================================================

  Widget _buildSystemSection() {
    return _section(
      title: "System Information",
      subtitle: "Current Smog AI system information",
      icon: Icons.info_outline_rounded,
      children: [
        _infoRow(
          "System",
          "Smog Risk Prediction System",
          Icons.apps_rounded,
        ),
        _infoRow(
          "AI Model",
          "Smog Prediction Engine v2.1",
          Icons.psychology_rounded,
        ),
        _infoRow(
          "Monitoring",
          "24/7 Active",
          Icons.monitor_heart_rounded,
        ),
        _infoRow(
          "Stations",
          "35 Active Stations",
          Icons.route_rounded,
        ),
        _infoRow(
          "Database",
          "Connected",
          Icons.storage_rounded,
        ),
        _infoRow(
          "Last Update",
          "Just now",
          Icons.update_rounded,
        ),
        _infoRow(
          "Version",
          "1.0.0",
          Icons.new_releases_outlined,
        ),
      ],
    );
  }

  // ============================================================
  // SAVE SECTION
  // ============================================================

  Widget _buildSaveSection({
    required bool mobile,
    required bool tablet,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        mobile ? 15 : 18,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          mobile ? 16 : 18,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: mobile || tablet
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _saveContent(),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: _saveButton(),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _saveContent(),
                ),
                const SizedBox(width: 20),
                _saveButton(),
              ],
            ),
    );
  }

  Widget _saveContent() {
    return Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.greenAccent.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: Colors.greenAccent,
          ),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasChanges
                    ? "You have unsaved changes"
                    : "Settings are up to date",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                hasChanges
                    ? "Save your preferences to apply the changes."
                    : "Your current preferences are saved.",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _saveButton() {
    return ElevatedButton.icon(
      onPressed: _saveSettings,
      icon: const Icon(
        Icons.save_rounded,
        size: 16,
      ),
      label: const Text("Save Settings"),
      style: ElevatedButton.styleFrom(
        backgroundColor: cyan,
        foregroundColor: background,
        elevation: 0,
        minimumSize: const Size(0, 45),
        padding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 13,
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
  // SECTION CONTAINER
  // ============================================================

  Widget _section({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: cyan.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: cyan,
                  size: 20,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // SETTING TILE
  // ============================================================

  Widget _settingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Switch(
            value: value,
            activeColor: cyan,
            activeTrackColor: cyan.withValues(alpha: 0.25),
            inactiveThumbColor: Colors.white38,
            inactiveTrackColor: Colors.white10,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DROPDOWN TILE
  // ============================================================

  Widget _dropdownTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 500;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.035),
            borderRadius: BorderRadius.circular(14),
          ),
          child: mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tileTitle(
                      icon: icon,
                      iconColor: iconColor,
                      title: title,
                      subtitle: subtitle,
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.035),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: value,
                          isExpanded: true,
                          dropdownColor: cardColor,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.white54,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                          ),
                          items: items.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: onChanged,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    _tileIcon(
                      icon: icon,
                      iconColor: iconColor,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _tileText(
                        title: title,
                        subtitle: subtitle,
                      ),
                    ),

                    const SizedBox(width: 10),

                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: value,
                        dropdownColor: cardColor,
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white54,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                        items: items.map((item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          );
                        }).toList(),
                        onChanged: onChanged,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  // ============================================================
  // ACTION TILE
  // ============================================================

  Widget _actionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 500;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.035),
            borderRadius: BorderRadius.circular(14),
          ),
          child: mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tileTitle(
                      icon: icon,
                      iconColor: iconColor,
                      title: title,
                      subtitle: subtitle,
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: onPressed,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: iconColor,
                          side: BorderSide(
                            color: iconColor.withValues(alpha: 0.35),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    _tileIcon(
                      icon: icon,
                      iconColor: iconColor,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _tileText(
                        title: title,
                        subtitle: subtitle,
                      ),
                    ),

                    const SizedBox(width: 8),

                    OutlinedButton(
                      onPressed: onPressed,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: iconColor,
                        side: BorderSide(
                          color: iconColor.withValues(alpha: 0.35),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  // ============================================================
  // TILE HELPERS
  // ============================================================

  Widget _tileIcon({
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 21,
      ),
    );
  }

  Widget _tileText({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _tileTitle({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _tileIcon(
          icon: icon,
          iconColor: iconColor,
        ),

        const SizedBox(width: 12),

        Expanded(
          child: _tileText(
            title: title,
            subtitle: subtitle,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow(
    String title,
    String value,
    IconData icon,
  ) {
    final connected =
        value.toLowerCase().contains("connected") ||
        value.toLowerCase().contains("active") ||
        value.toLowerCase().contains("24/7");

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: cyan,
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

          if (connected)
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(right: 7),
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
            ),

          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: connected
                    ? Colors.greenAccent
                    : Colors.white,
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
  // CHANGE TRACKER
  // ============================================================

  void _change(VoidCallback action) {
    setState(() {
      action();
      hasChanges = true;
    });
  }

  // ============================================================
  // SAVE
  // ============================================================

  void _saveSettings() {
    setState(() {
      hasChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text("Settings saved successfully"),
          ],
        ),
        backgroundColor: cardColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // RESET DIALOG
  // ============================================================

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.restart_alt_rounded,
                color: Colors.orangeAccent,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Reset Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            "Are you sure you want to restore all settings to their default values?",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white60,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                _resetSettings();

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(
                          Icons.restart_alt_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Settings restored to default",
                        ),
                      ],
                    ),
                    backgroundColor: cardColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: background,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Reset"),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // RESET SETTINGS
  // ============================================================

  void _resetSettings() {
    setState(() {
      notifications = true;
      alerts = true;
      darkMode = true;
      autoRefresh = true;
      emailReports = false;
      predictionAlerts = true;
      soundAlerts = true;
      maintenanceNotifications = true;
      locationMonitoring = true;
      dataBackup = true;

      refreshRate = "5 minutes";
      alertThreshold = "Unhealthy";
      dataRetention = "30 days";

      hasChanges = false;
    });
  }

  // ============================================================
  // STATIONS DIALOG
  // ============================================================

  void _showStationsDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.sensors_rounded,
                color: cyan,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Monitoring Stations",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogStatusRow(
                  "Active Stations",
                  "35",
                  Colors.greenAccent,
                ),
                _dialogStatusRow(
                  "Offline Stations",
                  "2",
                  Colors.redAccent,
                ),
                _dialogStatusRow(
                  "Maintenance",
                  "1",
                  Colors.orangeAccent,
                ),
                _dialogStatusRow(
                  "Total Stations",
                  "38",
                  cyan,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "Close",
                style: TextStyle(color: cyan),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SENSOR STATUS
  // ============================================================

  void _showSensorStatus() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.cloud_done_rounded,
                color: Colors.greenAccent,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Sensor Connection",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: const SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Colors.greenAccent,
                  size: 55,
                ),
                SizedBox(height: 12),
                Text(
                  "All sensors are connected",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Sensor network is operating normally.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "Close",
                style: TextStyle(color: cyan),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // EXPORT REPORT
  // ============================================================

  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.download_done_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "System report generated successfully",
              ),
            ),
          ],
        ),
        backgroundColor: cardColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // PASSWORD DIALOG
  // ============================================================

  void _showPasswordDialog() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: Colors.redAccent,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Change Password",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _passwordField(
                  currentController,
                  "Current Password",
                ),
                const SizedBox(height: 12),
                _passwordField(
                  newController,
                  "New Password",
                ),
                const SizedBox(height: 12),
                _passwordField(
                  confirmController,
                  "Confirm New Password",
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white60,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                if (newController.text.isEmpty ||
                    confirmController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please enter the new password",
                      ),
                    ),
                  );
                  return;
                }

                if (newController.text !=
                    confirmController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Passwords do not match",
                      ),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Password updated successfully",
                    ),
                    backgroundColor: cardColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cyan,
                foregroundColor: background,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // PASSWORD FIELD
  // ============================================================

  Widget _passwordField(
    TextEditingController controller,
    String hint,
  ) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.white38,
          fontSize: 12,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.04),
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Colors.white54,
          size: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ============================================================
  // ACTIVITY LOGS
  // ============================================================

  void _showActivityLogs() {
    final logs = [
      "Admin logged into dashboard",
      "Alert settings updated",
      "Monitoring data refreshed",
      "System report generated",
      "User management accessed",
    ];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: Colors.orangeAccent,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Recent Activity",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 350,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: logs.length,
                separatorBuilder: (_, __) {
                  return Divider(
                    color: Colors.white.withValues(alpha: 0.06),
                  );
                },
                itemBuilder: (context, index) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: cyan.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: cyan,
                        size: 17,
                      ),
                    ),
                    title: Text(
                      logs[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                    subtitle: const Text(
                      "Recently",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 9,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "Close",
                style: TextStyle(
                  color: cyan,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DIALOG STATUS ROW
  // ============================================================

  Widget _dialogStatusRow(
    String title,
    String value,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
              ),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}