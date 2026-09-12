import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ============================================================
  // THEME
  // ============================================================

  static const Color backgroundColor = Color(0xff081426);
  static const Color cardColor = Color(0xff102A43);
  static const Color cyanColor = Colors.cyanAccent;

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController nameController =
      TextEditingController(text: "Admin User");

  final TextEditingController emailController =
      TextEditingController(text: "admin@smogsystem.com");

  final TextEditingController phoneController =
      TextEditingController(text: "+92 300 1234567");

  final TextEditingController roleController =
      TextEditingController(text: "System Administrator");

  final TextEditingController passwordController =
      TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool editing = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    roleController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                color: cyanColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: cyanColor,
                size: 22,
              ),
            ),

            const SizedBox(width: 12),

            const Text(
              "Admin Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            tooltip: editing ? "Cancel Editing" : "Edit Profile",
            onPressed: () {
              setState(() {
                editing = !editing;
              });
            },
            icon: Icon(
              editing
                  ? Icons.close_rounded
                  : Icons.edit_rounded,
              color: Colors.white70,
            ),
          ),

          const SizedBox(width: 10),
        ],
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 850;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),

            padding: EdgeInsets.all(
              compact ? 18 : 25,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                _buildProfileHeader(compact),

                const SizedBox(height: 20),

                _buildPersonalInformation(compact),

                const SizedBox(height: 20),

                _buildAccountInformation(),

                const SizedBox(height: 20),

                _buildSecuritySection(),

                const SizedBox(height: 20),

                _buildPermissionsSection(),

                const SizedBox(height: 20),

                _buildActivitySection(),

                const SizedBox(height: 20),

                if (editing) _buildSaveSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader(bool compact) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(
        compact ? 20 : 25,
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
      ),

      child: compact
          ? Column(
              children: [
                _profileAvatar(),

                const SizedBox(height: 14),

                _profileMainInfo(
                  center: true,
                ),
              ],
            )
          : Row(
              children: [
                _profileAvatar(),

                const SizedBox(width: 18),

                Expanded(
                  child: _profileMainInfo(
                    center: false,
                  ),
                ),

                _onlineBadge(),
              ],
            ),
    );
  }

  // ============================================================
  // AVATAR
  // ============================================================

  Widget _profileAvatar() {
    return Container(
      width: 82,
      height: 82,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        gradient: const LinearGradient(
          colors: [
            cyanColor,
            Colors.blueAccent,
          ],
        ),

        boxShadow: [
          BoxShadow(
            color: cyanColor.withOpacity(0.15),
            blurRadius: 18,
          ),
        ],
      ),

      child: const Center(
        child: Text(
          "AU",
          style: TextStyle(
            color: backgroundColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MAIN PROFILE INFO
  // ============================================================

  Widget _profileMainInfo({
    required bool center,
  }) {
    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,

      children: [
        const Text(
          "Admin User",
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        const Text(
          "System Administrator",
          style: TextStyle(
            color: cyanColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          "admin@smogsystem.com",
          style: TextStyle(
            color: Colors.white60,
            fontSize: 11,
          ),
        ),

        if (center) ...[
          const SizedBox(height: 12),
          _onlineBadge(),
        ],
      ],
    );
  }

  // ============================================================
  // ONLINE BADGE
  // ============================================================

  Widget _onlineBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),

      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.greenAccent.withOpacity(0.18),
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
            "Online",
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
  // PERSONAL INFORMATION
  // ============================================================

  Widget _buildPersonalInformation(bool compact) {
    return _section(
      title: "Personal Information",
      subtitle: "Manage administrator contact details",
      icon: Icons.person_outline_rounded,

      children: [
        if (compact)
          Column(
            children: [
              _inputField(
                controller: nameController,
                label: "Full Name",
                icon: Icons.person_outline_rounded,
              ),

              const SizedBox(height: 12),

              _inputField(
                controller: emailController,
                label: "Email Address",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 12),

              _inputField(
                controller: phoneController,
                label: "Phone Number",
                icon: Icons.phone_outlined,
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: _inputField(
                  controller: nameController,
                  label: "Full Name",
                  icon: Icons.person_outline_rounded,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _inputField(
                  controller: emailController,
                  label: "Email Address",
                  icon: Icons.email_outlined,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _inputField(
                  controller: phoneController,
                  label: "Phone Number",
                  icon: Icons.phone_outlined,
                ),
              ),
            ],
          ),
      ],
    );
  }

  // ============================================================
  // ACCOUNT INFORMATION
  // ============================================================

  Widget _buildAccountInformation() {
    return _section(
      title: "Account Information",
      subtitle: "Administrator account details",
      icon: Icons.badge_outlined,

      children: [
        _infoRow(
          "Account ID",
          "ADM-001",
          Icons.fingerprint_rounded,
        ),

        _infoRow(
          "Role",
          roleController.text,
          Icons.admin_panel_settings_outlined,
        ),

        _infoRow(
          "Account Status",
          "Active",
          Icons.verified_user_outlined,
          valueColor: Colors.greenAccent,
        ),

        _infoRow(
          "Created",
          "January 2026",
          Icons.calendar_today_outlined,
        ),
      ],
    );
  }

  // ============================================================
  // SECURITY
  // ============================================================

  Widget _buildSecuritySection() {
    return _section(
      title: "Security",
      subtitle: "Protect your administrator account",
      icon: Icons.security_rounded,

      children: [
        _passwordField(
          controller: passwordController,
          label: "New Password",
          obscure: !showPassword,
          onToggle: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),

        const SizedBox(height: 12),

        _passwordField(
          controller: confirmPasswordController,
          label: "Confirm New Password",
          obscure: !showConfirmPassword,
          onToggle: () {
            setState(() {
              showConfirmPassword =
                  !showConfirmPassword;
            });
          },
        ),

        const SizedBox(height: 15),

        Container(
          padding: const EdgeInsets.all(13),

          decoration: BoxDecoration(
            color: Colors.orangeAccent.withOpacity(0.07),
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: Colors.orangeAccent.withOpacity(0.12),
            ),
          ),

          child: const Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: Colors.orangeAccent,
                size: 18,
              ),

              SizedBox(width: 10),

              Expanded(
                child: Text(
                  "Use a strong password containing uppercase letters, numbers and special characters.",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PERMISSIONS
  // ============================================================

  Widget _buildPermissionsSection() {
    return _section(
      title: "Access & Permissions",
      subtitle: "Administrator access level",
      icon: Icons.lock_open_rounded,

      children: [
        _permissionTile(
          icon: Icons.dashboard_rounded,
          title: "Dashboard",
          subtitle: "View monitoring dashboard",
        ),

        _permissionTile(
          icon: Icons.people_alt_outlined,
          title: "User Management",
          subtitle: "Add, edit and manage users",
        ),

        _permissionTile(
          icon: Icons.warning_amber_rounded,
          title: "Alert Management",
          subtitle: "Manage and resolve smog alerts",
        ),

        _permissionTile(
          icon: Icons.analytics_outlined,
          title: "Reports & Analytics",
          subtitle: "Access system reports and analytics",
        ),

        _permissionTile(
          icon: Icons.settings_outlined,
          title: "System Settings",
          subtitle: "Configure system preferences",
        ),
      ],
    );
  }

  // ============================================================
  // ACTIVITY
  // ============================================================

  Widget _buildActivitySection() {
    return _section(
      title: "Account Activity",
      subtitle: "Recent administrator activity",
      icon: Icons.history_rounded,

      children: [
        _activityTile(
          Icons.login_rounded,
          "Last Login",
          "Today at 03:42 PM",
          Colors.greenAccent,
        ),

        _activityTile(
          Icons.warning_rounded,
          "Last Alert Action",
          "High Smog Alert acknowledged",
          Colors.orangeAccent,
        ),

        _activityTile(
          Icons.settings_rounded,
          "Last Settings Change",
          "Auto Refresh updated",
          cyanColor,
        ),
      ],
    );
  }

  // ============================================================
  // SAVE SECTION
  // ============================================================

  Widget _buildSaveSection() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),

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
              color: Colors.greenAccent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),

            child: const Icon(
              Icons.save_rounded,
              color: Colors.greenAccent,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  "Save Profile Changes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  "Update your administrator profile information.",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          ElevatedButton.icon(
            onPressed: _saveProfile,

            icon: const Icon(
              Icons.check_rounded,
              size: 16,
            ),

            label: const Text("Save"),

            style: ElevatedButton.styleFrom(
              backgroundColor: cyanColor,
              foregroundColor: backgroundColor,
              elevation: 0,

              padding: const EdgeInsets.symmetric(
                horizontal: 18,
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
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION
  // ============================================================

  Widget _section({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color: cyanColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(11),
                ),

                child: Icon(
                  icon,
                  color: cyanColor,
                  size: 20,
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
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
            ],
          ),

          const SizedBox(height: 17),

          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // INPUT FIELD
  // ============================================================

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      enabled: editing,

      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Colors.white54,
          fontSize: 11,
        ),

        prefixIcon: Icon(
          icon,
          color: cyanColor,
          size: 19,
        ),

        filled: true,
        fillColor: Colors.white.withOpacity(0.035),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.06),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: cyanColor,
          ),
        ),

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }

  // ============================================================
  // PASSWORD FIELD
  // ============================================================

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      enabled: editing,

      style: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),

      decoration: InputDecoration(
        labelText: label,

        labelStyle: const TextStyle(
          color: Colors.white54,
          fontSize: 11,
        ),

        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: cyanColor,
          size: 19,
        ),

        suffixIcon: IconButton(
          onPressed: editing ? onToggle : null,
          icon: Icon(
            obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white54,
            size: 19,
          ),
        ),

        filled: true,
        fillColor: Colors.white.withOpacity(0.035),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.06),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: cyanColor,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow(
    String title,
    String value,
    IconData icon, {
    Color valueColor = Colors.white,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),

      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 12,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color: cyanColor,
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
              style: TextStyle(
                color: valueColor,
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
  // PERMISSION TILE
  // ============================================================

  Widget _permissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),

      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 11,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: cyanColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              color: cyanColor,
              size: 19,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),

            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Text(
              "Allowed",
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTIVITY TILE
  // ============================================================

  Widget _activityTile(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),

      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.035),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,

            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),

            child: Icon(
              icon,
              color: color,
              size: 19,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 9,
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
  // SAVE PROFILE
  // ============================================================

  void _saveProfile() {
    if (passwordController.text.isNotEmpty &&
        passwordController.text !=
            confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Passwords do not match",
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    setState(() {
      editing = false;
      passwordController.clear();
      confirmPasswordController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Text(
              "Profile updated successfully",
            ),
          ],
        ),
        backgroundColor: cardColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}