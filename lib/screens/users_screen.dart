import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color backgroundColor = Color(0xff081426);
  static const Color sidebarColor = Color(0xff102A43);
  static const Color cardColor = Color(0xff102A43);
  static const Color cardLightColor = Color(0xff163B5C);

  static const Color cyanColor = Colors.cyanAccent;
  static const Color whiteColor = Colors.white;
  static const Color secondaryColor = Colors.white70;

  final TextEditingController searchController =
      TextEditingController();

  // ============================================================
  // USERS DATA
  // ============================================================

  final List<Map<String, dynamic>> users = [
    {
      "name": "Ali Khan",
      "location": "Rawalpindi",
      "status": "Active",
      "email": "ali.khan@example.com",
      "icon": Icons.person_rounded,
    },
    {
      "name": "Ayesha Malik",
      "location": "Islamabad",
      "status": "Active",
      "email": "ayesha.malik@example.com",
      "icon": Icons.person_rounded,
    },
    {
      "name": "Ahmed Raza",
      "location": "Lahore",
      "status": "Inactive",
      "email": "ahmed.raza@example.com",
      "icon": Icons.person_rounded,
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

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: sidebarColor,
        elevation: 0,
        automaticallyImplyLeading: true,
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
                Icons.people_alt_rounded,
                color: cyanColor,
                size: 21,
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              "Users Management",
              style: TextStyle(
                color: whiteColor,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        iconTheme: const IconThemeData(
          color: whiteColor,
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 18,
              top: 8,
              bottom: 8,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
              ),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: cyanColor,
                  child: Icon(
                    Icons.person,
                    color: backgroundColor,
                    size: 17,
                  ),
                ),

                SizedBox(width: 7),

                Text(
                  "Admin",
                  style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool compact = constraints.maxWidth < 800;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            padding: EdgeInsets.all(
              compact ? 16 : 25,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // PAGE HEADER
                _buildPageHeader(compact),

                const SizedBox(height: 24),

                // STATISTICS
                _buildStatistics(compact),

                const SizedBox(height: 25),

                // SEARCH + ADD BUTTON
                _buildSearchSection(compact),

                const SizedBox(height: 22),

                // USERS TITLE
                _buildUsersTitle(),

                const SizedBox(height: 12),

                // USER LIST
                _buildUserList(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // PAGE HEADER
  // ============================================================

  Widget _buildPageHeader(bool compact) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        compact ? 18 : 22,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff102A43),
            Color(0xff163B5C),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),

      child: Row(
        children: [
          // ICON
          Container(
            width: compact ? 50 : 58,
            height: compact ? 50 : 58,
            decoration: BoxDecoration(
              color: cyanColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.manage_accounts_rounded,
              color: cyanColor,
              size: compact ? 26 : 30,
            ),
          ),

          const SizedBox(width: 15),

          // TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Registered Users",
                  style: TextStyle(
                    color: whiteColor,
                    fontSize: compact ? 20 : 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Manage system users and their information",
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: compact ? 12 : 13,
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
  // STATISTICS
  // ============================================================

  Widget _buildStatistics(bool compact) {
    final int totalUsers = users.length;

    final int activeUsers = users.where(
      (user) => user["status"] == "Active",
    ).length;

    final int inactiveUsers = users.where(
      (user) => user["status"] == "Inactive",
    ).length;

    final stats = [
      _Stat(
        "Total Users",
        "$totalUsers",
        Icons.people_rounded,
        cyanColor,
      ),
      _Stat(
        "Active Users",
        "$activeUsers",
        Icons.verified_user_rounded,
        Colors.greenAccent,
      ),
      _Stat(
        "Inactive Users",
        "$inactiveUsers",
        Icons.person_off_rounded,
        Colors.redAccent,
      ),
    ];

    if (compact) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stats.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.85,
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
                right: index == stats.length - 1 ? 0 : 14,
              ),
              child: _statCard(stats[index]),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // STAT CARD
  // ============================================================

  Widget _statCard(_Stat stat) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: stat.color.withOpacity(0.11),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              stat.icon,
              color: stat.color,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.title,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 11.5,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  stat.value,
                  style: const TextStyle(
                    color: whiteColor,
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
  // SEARCH SECTION
  // ============================================================

  Widget _buildSearchSection(bool compact) {
    if (compact) {
      return Column(
        children: [
          _buildSearchField(),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: _buildAddButton(),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildSearchField(),
        ),

        const SizedBox(width: 12),

        _buildAddButton(),
      ],
    );
  }

  // ============================================================
  // SEARCH FIELD
  // ============================================================

  Widget _buildSearchField() {
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

        style: const TextStyle(
          color: whiteColor,
          fontSize: 13,
        ),

        onChanged: (_) {
          setState(() {});
        },

        decoration: InputDecoration(
          hintText: "Search users by name or location...",

          hintStyle: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),

          prefixIcon: const Icon(
            Icons.search_rounded,
            color: cyanColor,
            size: 21,
          ),

          suffixIcon:
              searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: Colors.white54,
                        size: 19,
                      ),
                      onPressed: () {
                        searchController.clear();

                        setState(() {});
                      },
                    )
                  : null,

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 4,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ADD BUTTON
  // ============================================================

  Widget _buildAddButton() {
    return ElevatedButton.icon(
      onPressed: _showAddUserDialog,

      icon: const Icon(
        Icons.person_add_alt_1_rounded,
        size: 18,
      ),

      label: const Text(
        "Add User",
      ),

      style: ElevatedButton.styleFrom(
        backgroundColor: cyanColor,
        foregroundColor: backgroundColor,
        elevation: 0,

        minimumSize: const Size(120, 48),

        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),

        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  // ============================================================
  // USERS TITLE
  // ============================================================

  Widget _buildUsersTitle() {
    return Row(
      children: [
        const Icon(
          Icons.people_outline_rounded,
          color: cyanColor,
          size: 20,
        ),

        const SizedBox(width: 8),

        const Text(
          "System Users",
          style: TextStyle(
            color: whiteColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 3,
          ),
          decoration: BoxDecoration(
            color: cyanColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            "${users.length}",
            style: const TextStyle(
              color: cyanColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // USER LIST
  // ============================================================

  Widget _buildUserList() {
    final String query =
        searchController.text.trim().toLowerCase();

    final List<Map<String, dynamic>> filteredUsers =
        users.where((user) {
      final String name =
          user["name"].toString().toLowerCase();

      final String location =
          user["location"].toString().toLowerCase();

      final String email =
          user["email"].toString().toLowerCase();

      return name.contains(query) ||
          location.contains(query) ||
          email.contains(query);
    }).toList();

    if (filteredUsers.isEmpty) {
      return _emptyState();
    }

    return Column(
      children: filteredUsers.map((user) {
        return _userCard(user);
      }).toList(),
    );
  }

  // ============================================================
  // USER CARD
  // ============================================================

  Widget _userCard(
    Map<String, dynamic> user,
  ) {
    final bool active =
        user["status"] == "Active";

    return Container(
      margin: const EdgeInsets.only(bottom: 13),

      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool small =
              constraints.maxWidth < 600;

          if (small) {
            return _smallUserCard(user, active);
          }

          return _largeUserCard(user, active);
        },
      ),
    );
  }

  // ============================================================
  // LARGE USER CARD
  // ============================================================

  Widget _largeUserCard(
    Map<String, dynamic> user,
    bool active,
  ) {
    return Row(
      children: [
        _buildAvatar(user),

        const SizedBox(width: 15),

        Expanded(
          child: _buildUserInformation(user),
        ),

        const SizedBox(width: 15),

        _buildStatus(user, active),

        const SizedBox(width: 8),

        _buildMenu(user),
      ],
    );
  }

  // ============================================================
  // SMALL USER CARD
  // ============================================================

  Widget _smallUserCard(
    Map<String, dynamic> user,
    bool active,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildAvatar(user),

            const SizedBox(width: 12),

            Expanded(
              child: _buildUserInformation(user),
            ),

            _buildMenu(user),
          ],
        ),

        const SizedBox(height: 13),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 1),

            _buildStatus(user, active),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _buildAvatar(
    Map<String, dynamic> user,
  ) {
    return Container(
      width: 54,
      height: 54,

      decoration: BoxDecoration(
        color: cyanColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: cyanColor.withOpacity(0.10),
        ),
      ),

      child: Icon(
        user["icon"],
        color: cyanColor,
        size: 29,
      ),
    );
  }

  // ============================================================
  // USER INFORMATION
  // ============================================================

  Widget _buildUserInformation(
    Map<String, dynamic> user,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user["name"].toString(),
          overflow: TextOverflow.ellipsis,

          style: const TextStyle(
            color: whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Wrap(
          spacing: 12,
          runSpacing: 5,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white54,
                  size: 14,
                ),

                const SizedBox(width: 4),

                Text(
                  user["location"].toString(),
                  style: const TextStyle(
                    color: secondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.email_outlined,
                  color: Colors.white54,
                  size: 14,
                ),

                const SizedBox(width: 4),

                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 260,
                  ),

                  child: Text(
                    user["email"].toString(),
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _buildStatus(
    Map<String, dynamic> user,
    bool active,
  ) {
    final Color statusColor =
        active ? Colors.greenAccent : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: active
            ? Colors.green.withOpacity(0.13)
            : Colors.red.withOpacity(0.13),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: statusColor.withOpacity(0.10),
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,

            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            user["status"].toString(),
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENU
  // ============================================================

  Widget _buildMenu(
    Map<String, dynamic> user,
  ) {
    return PopupMenuButton<String>(
      color: sidebarColor,

      elevation: 8,

      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white70,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      onSelected: (value) {
        switch (value) {
          case "view":
            _showUserDetails(user);
            break;

          case "edit":
            _showEditUserDialog(user);
            break;

          case "delete":
            _showDeleteDialog(user);
            break;
        }
      },

      itemBuilder: (context) {
        return const [
          PopupMenuItem(
            value: "view",
            child: Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  color: cyanColor,
                  size: 18,
                ),

                SizedBox(width: 9),

                Text(
                  "View Details",
                  style: TextStyle(
                    color: whiteColor,
                  ),
                ),
              ],
            ),
          ),

          PopupMenuItem(
            value: "edit",
            child: Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: Colors.white70,
                  size: 18,
                ),

                SizedBox(width: 9),

                Text(
                  "Edit User",
                  style: TextStyle(
                    color: whiteColor,
                  ),
                ),
              ],
            ),
          ),

          PopupMenuItem(
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
                  "Delete User",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
          ),
        ];
      },
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
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
          color: Colors.white.withOpacity(0.08),
        ),
      ),

      child: const Column(
        children: [
          Icon(
            Icons.person_search_rounded,
            color: Colors.white38,
            size: 50,
          ),

          SizedBox(height: 12),

          Text(
            "No users found",
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          SizedBox(height: 5),

          Text(
            "Try searching with another name, email or location.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VIEW DETAILS
  // ============================================================

  void _showUserDetails(
    Map<String, dynamic> user,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: sidebarColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

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
                  Icons.person_rounded,
                  color: cyanColor,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                "User Details",
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Divider(
                color: Colors.white12,
              ),

              const SizedBox(height: 8),

              _detailRow(
                "Name",
                user["name"].toString(),
              ),

              _detailRow(
                "Location",
                user["location"].toString(),
              ),

              _detailRow(
                "Email",
                user["email"].toString(),
              ),

              _detailRow(
                "Status",
                user["status"].toString(),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },

              child: const Text(
                "Close",
                style: TextStyle(
                  color: cyanColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12,
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          SizedBox(
            width: 75,

            child: Text(
              title,

              style: const TextStyle(
                color: secondaryColor,
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,

              style: const TextStyle(
                color: whiteColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADD USER DIALOG
  // ============================================================

  void _showAddUserDialog() {
    final nameController =
        TextEditingController();

    final locationController =
        TextEditingController();

    final emailController =
        TextEditingController();

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: sidebarColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            "Add New User",
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField(
                  nameController,
                  "Full Name",
                  Icons.person_outline,
                ),

                const SizedBox(height: 11),

                _dialogField(
                  locationController,
                  "Location",
                  Icons.location_on_outlined,
                ),

                const SizedBox(height: 11),

                _dialogField(
                  emailController,
                  "Email Address",
                  Icons.email_outlined,
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
                  color: secondaryColor,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final name =
                    nameController.text.trim();

                final location =
                    locationController.text.trim();

                final email =
                    emailController.text.trim();

                if (name.isEmpty ||
                    location.isEmpty ||
                    email.isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Please fill all fields.",
                      ),
                    ),
                  );

                  return;
                }

                setState(() {
                  users.add({
                    "name": name,
                    "location": location,
                    "status": "Active",
                    "email": email,
                    "icon": Icons.person_rounded,
                  });
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "User added successfully.",
                    ),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: cyanColor,
                foregroundColor: backgroundColor,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),

              child: const Text(
                "Add User",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // EDIT USER DIALOG
  // ============================================================

  void _showEditUserDialog(
    Map<String, dynamic> user,
  ) {
    final nameController =
        TextEditingController(
      text: user["name"].toString(),
    );

    final locationController =
        TextEditingController(
      text: user["location"].toString(),
    );

    final emailController =
        TextEditingController(
      text: user["email"].toString(),
    );

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: sidebarColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          title: const Text(
            "Edit User",
            style: TextStyle(
              color: whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dialogField(
                  nameController,
                  "Full Name",
                  Icons.person_outline,
                ),

                const SizedBox(height: 11),

                _dialogField(
                  locationController,
                  "Location",
                  Icons.location_on_outlined,
                ),

                const SizedBox(height: 11),

                _dialogField(
                  emailController,
                  "Email Address",
                  Icons.email_outlined,
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
                  color: secondaryColor,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final name =
                    nameController.text.trim();

                final location =
                    locationController.text.trim();

                final email =
                    emailController.text.trim();

                if (name.isEmpty ||
                    location.isEmpty ||
                    email.isEmpty) {
                  return;
                }

                setState(() {
                  user["name"] = name;
                  user["location"] = location;
                  user["email"] = email;
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "User updated successfully.",
                    ),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: cyanColor,
                foregroundColor: backgroundColor,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),

              child: const Text(
                "Save Changes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DELETE USER DIALOG
  // ============================================================

  void _showDeleteDialog(
    Map<String, dynamic> user,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: sidebarColor,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

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
                  Icons.delete_outline_rounded,
                  color: Colors.redAccent,
                  size: 22,
                ),
              ),

              const SizedBox(width: 10),

              const Text(
                "Delete User?",
                style: TextStyle(
                  color: whiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          content: Text(
            "Are you sure you want to delete ${user["name"]}?\n\nThis action cannot be undone.",
            style: const TextStyle(
              color: secondaryColor,
              fontSize: 13,
              height: 1.5,
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
                  color: secondaryColor,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  users.remove(user);
                });

                Navigator.pop(dialogContext);

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                      "User deleted successfully.",
                    ),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: whiteColor,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),

              child: const Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DIALOG FIELD
  // ============================================================

  Widget _dialogField(
    TextEditingController controller,
    String hint,
    IconData icon,
  ) {
    return TextField(
      controller: controller,

      style: const TextStyle(
        color: whiteColor,
        fontSize: 13,
      ),

      cursorColor: cyanColor,

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(
          color: Colors.white54,
          fontSize: 13,
        ),

        prefixIcon: Icon(
          icon,
          color: cyanColor,
          size: 19,
        ),

        filled: true,

        fillColor: Colors.white.withOpacity(0.06),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.06),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(
            color: cyanColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}

// ================================================================
// STAT MODEL
// ================================================================

class _Stat {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _Stat(
    this.title,
    this.value,
    this.icon,
    this.color,
  );
}