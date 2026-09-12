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
      appBar: AppBar(
        backgroundColor: cardColor,
        elevation: 0,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: () {
                setState(() {
                  for (final item in notifications) {
                    item["read"] = true;
                  }
                });
              },
              child: const Text(
                "Mark all read",
                style: TextStyle(
                  color: cyan,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 700;

          return SingleChildScrollView(
            padding: EdgeInsets.all(
              compact ? 18 : 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(unreadCount),

                const SizedBox(height: 20),

                ...List.generate(
                  notifications.length,
                  (index) => _notificationCard(
                    notifications[index],
                    index,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(int unreadCount) {
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
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: cyan.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.notifications_rounded,
              color: cyan,
              size: 29,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "System Notifications",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
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
            ),
          ),

          if (unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "$unreadCount New",
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _notificationCard(
    Map<String, dynamic> notification,
    int index,
  ) {
    final bool unread = notification["read"];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: unread
            ? Colors.white.withOpacity(0.055)
            : cardColor,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: unread
              ? cyan.withOpacity(0.14)
              : Colors.white.withOpacity(0.06),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color:
                  notification["color"].withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              notification["icon"],
              color: notification["color"],
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification["title"],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: unread
                              ? FontWeight.bold
                              : FontWeight.w600,
                        ),
                      ),
                    ),

                    if (unread)
                      Container(
                        width: 7,
                        height: 7,
                        decoration:
                            const BoxDecoration(
                          color: cyan,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  notification["message"],
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  notification["time"],
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            color: cardColor,
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
              const PopupMenuItem(
                value: "read",
                child: Text(
                  "Mark as read",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const PopupMenuItem(
                value: "delete",
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}