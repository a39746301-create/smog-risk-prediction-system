import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  static const Color background = Color(0xff081426);
  static const Color cardColor = Color(0xff102A43);
  static const Color cyan = Colors.cyanAccent;

  final List<Map<String, dynamic>> notifications = [
    {
      "title": "High Smog Risk Detected",
      "message":
          "Very unhealthy air quality has been detected at Lahore Motorway Station.",
      "time": "5 min ago",
      "icon": Icons.warning_rounded,
      "color": Colors.redAccent,
      "read": false,
    },
    {
      "title": "AI Prediction Updated",
      "message":
          "The AI prediction model has generated new smog risk predictions.",
      "time": "18 min ago",
      "icon": Icons.psychology_rounded,
      "color": Colors.orangeAccent,
      "read": false,
    },
    {
      "title": "Station Status Updated",
      "message":
          "NHMP monitoring stations have successfully synchronized their data.",
      "time": "1 hour ago",
      "icon": Icons.route_rounded,
      "color": Colors.blueAccent,
      "read": false,
    },
    {
      "title": "System Update",
      "message":
          "Air quality monitoring data has been refreshed successfully.",
      "time": "2 hours ago",
      "icon": Icons.sync_rounded,
      "color": cyan,
      "read": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount =
        notifications.where((item) => item["read"] == false).length;

    return Scaffold(
      backgroundColor: background,
      appBar: _buildAppBar(unreadCount),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final bool mobile = width < 600;
          final bool tablet = width >= 600 && width < 1000;

          return SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1450,
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                    mobile
                        ? 14
                        : tablet
                            ? 20
                            : 28,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(
                        unreadCount,
                        mobile,
                      ),
                      SizedBox(
                        height: mobile ? 15 : 22,
                      ),
                      _buildNotificationList(
                        mobile,
                        tablet,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(int unreadCount) {
    return AppBar(
      backgroundColor: cardColor,
      elevation: 0,
      automaticallyImplyLeading: true,
      titleSpacing: 16,
      title: const Row(
        children: [
          Icon(
            Icons.notifications_rounded,
            color: cyan,
            size: 23,
          ),
          SizedBox(width: 9),
          Text(
            "Notifications",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
        ],
      ),
      actions: [
        if (unreadCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                "Mark all read",
                style: TextStyle(
                  color: cyan,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        const SizedBox(width: 5),
      ],
    );
  }

  Widget _buildHeader(
    int unreadCount,
    bool mobile,
  ) {
    if (mobile) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xff102A43),
              Color(0xff163B5C),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _notificationHeaderIcon(),
                const SizedBox(width: 13),
                Expanded(
                  child: _headerText(unreadCount),
                ),
              ],
            ),
            if (unreadCount > 0) ...[
              const SizedBox(height: 15),
              _newBadge(unreadCount),
            ],
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
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
      child: Row(
        children: [
          _notificationHeaderIcon(),
          const SizedBox(width: 15),
          Expanded(
            child: _headerText(unreadCount),
          ),
          if (unreadCount > 0) _newBadge(unreadCount),
        ],
      ),
    );
  }

  Widget _notificationHeaderIcon() {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: cyan.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.notifications_rounded,
        color: cyan,
        size: 29,
      ),
    );
  }

  Widget _headerText(int unreadCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "System Notifications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          unreadCount == 0
              ? "You're all caught up"
              : "$unreadCount unread notification${unreadCount == 1 ? '' : 's'}",
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _newBadge(int unreadCount) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        "$unreadCount New",
        style: const TextStyle(
          color: Colors.redAccent,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    bool mobile,
    bool tablet,
  ) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: List.generate(
        notifications.length,
        (index) {
          return _notificationCard(
            notifications[index],
            index,
            mobile,
          );
        },
      ),
    );
  }

  Widget _notificationCard(
    Map<String, dynamic> notification,
    int index,
    bool mobile,
  ) {
    final bool unread = notification["read"] == false;
    final Color notificationColor =
        notification["color"] as Color;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(
        mobile ? 13 : 16,
      ),
      decoration: BoxDecoration(
        color: unread
            ? Colors.white.withValues(alpha: 0.055)
            : cardColor,
        borderRadius: BorderRadius.circular(
          mobile ? 15 : 17,
        ),
        border: Border.all(
          color: unread
              ? cyan.withValues(alpha: 0.14)
              : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: mobile
          ? _mobileNotificationContent(
              notification,
              index,
              unread,
              notificationColor,
            )
          : _desktopNotificationContent(
              notification,
              index,
              unread,
              notificationColor,
            ),
    );
  }

  Widget _desktopNotificationContent(
    Map<String, dynamic> notification,
    int index,
    bool unread,
    Color notificationColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _notificationIcon(
          notification,
          notificationColor,
        ),
        const SizedBox(width: 13),
        Expanded(
          child: _notificationText(
            notification,
            unread,
          ),
        ),
        _menuButton(
          notification,
          index,
        ),
      ],
    );
  }

  Widget _mobileNotificationContent(
    Map<String, dynamic> notification,
    int index,
    bool unread,
    Color notificationColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _notificationIcon(
              notification,
              notificationColor,
            ),
            const SizedBox(width: 11),
            Expanded(
              child: _notificationText(
                notification,
                unread,
              ),
            ),
            _menuButton(
              notification,
              index,
            ),
          ],
        ),
      ],
    );
  }

  Widget _notificationIcon(
    Map<String, dynamic> notification,
    Color notificationColor,
  ) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: notificationColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(
        notification["icon"] as IconData,
        color: notificationColor,
        size: 23,
      ),
    );
  }

  Widget _notificationText(
    Map<String, dynamic> notification,
    bool unread,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                notification["title"] as String,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  height: 1.25,
                  fontWeight: unread
                      ? FontWeight.bold
                      : FontWeight.w600,
                ),
              ),
            ),
            if (unread) ...[
              const SizedBox(width: 7),
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: cyan,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          notification["message"] as String,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: 11,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: Colors.white38,
              size: 12,
            ),
            const SizedBox(width: 4),
            Text(
              notification["time"] as String,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _menuButton(
    Map<String, dynamic> notification,
    int index,
  ) {
    return PopupMenuButton<String>(
      color: cardColor,
      padding: EdgeInsets.zero,
      iconSize: 21,
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white38,
      ),
      onSelected: (value) {
        if (value == "read") {
          setState(() {
            notification["read"] = true;
          });
        }

        if (value == "delete") {
          setState(() {
            notifications.removeAt(index);
          });
        }
      },
      itemBuilder: (context) => [
        if (notification["read"] == false)
          const PopupMenuItem(
            value: "read",
            child: Row(
              children: [
                Icon(
                  Icons.done_rounded,
                  color: cyan,
                  size: 18,
                ),
                SizedBox(width: 9),
                Text(
                  "Mark as read",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        const PopupMenuItem(
          value: "delete",
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: Colors.redAccent,
                size: 18,
              ),
              SizedBox(width: 9),
              Text(
                "Delete",
                style: TextStyle(
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 55,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.notifications_none_rounded,
            color: Colors.white38,
            size: 55,
          ),
          SizedBox(height: 15),
          Text(
            "No Notifications",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            "You're all caught up!",
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (final item in notifications) {
        item["read"] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "All notifications marked as read",
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}