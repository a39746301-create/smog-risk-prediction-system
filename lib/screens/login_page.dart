import 'package:flutter/material.dart';

import 'signup_page.dart';
import 'forgot_password_page.dart';
import 'user_dashboard.dart';
import 'nhmp_dashboard.dart';
import 'admin_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  String selectedRole = "User Login";

  bool hidePassword = true;
  bool isLoading = false;
  bool rememberMe = false;

  static const Color dark = Color(0xff071525);
  static const Color blue = Color(0xff1687E8);
  static const Color cyan = Color(0xff20C4E8);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    emailFocusNode.dispose();
    passwordFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 850) {
            return buildMobileLayout();
          }

          return buildDesktopLayout();
        },
      ),
    );
  }

  // =========================================================
  // DESKTOP / WEB LAYOUT
  // =========================================================

  Widget buildDesktopLayout() {
    return Row(
      children: [
        Expanded(
          flex: 11,
          child: buildLeftSide(),
        ),
        Expanded(
          flex: 9,
          child: Container(
            color: const Color(0xff091A2D),
            child: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 45,
                  vertical: 35,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 455,
                    ),
                    child: buildLoginPanel(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // LEFT SIDE
  // =========================================================

  Widget buildLeftSide() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/motorway_bg.png',
            fit: BoxFit.cover,
          ),
        ),

        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xff020B14).withValues(alpha: 0.90),
                  dark.withValues(alpha: 0.70),
                  const Color(0xff062A43).withValues(alpha: 0.84),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),

        Positioned(
          right: -120,
          top: 80,
          child: Container(
            width: 330,
            height: 330,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cyan.withValues(alpha: 0.06),
              boxShadow: [
                BoxShadow(
                  color: cyan.withValues(alpha: 0.08),
                  blurRadius: 100,
                  spreadRadius: 30,
                ),
              ],
            ),
          ),
        ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              48,
              35,
              42,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =====================================================
                // BRAND
                // =====================================================

                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cyan.withValues(alpha: 0.10),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.cloud_outlined,
                        color: cyan,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 13),

                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SMOG RISK",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.6,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          "PREDICTION SYSTEM",
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Spacer(),

                // =====================================================
                // AI BADGE
                // =====================================================

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: cyan.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: cyan.withValues(alpha: 0.28),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: cyan,
                        size: 15,
                      ),
                      SizedBox(width: 7),
                      Text(
                        "AI-POWERED ENVIRONMENTAL MONITORING",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // =====================================================
                // MAIN HEADING
                // =====================================================

                const Text(
                  "Smog Risk\nPrediction",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 44,
                    height: 1.06,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.3,
                  ),
                ),

                const SizedBox(height: 14),

                const SizedBox(
                  width: 520,
                  child: Text(
                    "An intelligent environmental monitoring system designed to analyze air quality and predict smog-related risks across Punjab motorways.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // =====================================================
                // FEATURE CARDS
                // =====================================================

                Row(
                  children: [
                    featureBox(
                      Icons.air_rounded,
                      "AQI",
                      "Monitoring",
                    ),
                    const SizedBox(width: 9),
                    featureBox(
                      Icons.psychology_outlined,
                      "AI",
                      "Prediction",
                    ),
                    const SizedBox(width: 9),
                    featureBox(
                      Icons.route_outlined,
                      "Motorway",
                      "Safety",
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // =====================================================
                // BOTTOM TEXT
                // =====================================================

                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: cyan,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Intelligent data-driven environmental monitoring",
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // MOBILE LAYOUT
  // =========================================================

  Widget buildMobileLayout() {
    return Container(
      width: double.infinity,
      color: dark,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;

            final horizontalPadding =
                screenWidth < 360 ? 16.0 : 20.0;

            return SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                22,
                horizontalPadding,
                MediaQuery.of(context).viewInsets.bottom + 30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =====================================================
                  // MOBILE BRAND
                  // =====================================================

                  Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(
                          Icons.cloud_outlined,
                          color: cyan,
                          size: 25,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "SMOG RISK",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.3,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "PREDICTION SYSTEM",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize:
                                    screenWidth < 360 ? 7 : 8,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // =====================================================
                  // MOBILE HEADING
                  // =====================================================

                  Text(
                    "Smog Risk\nPrediction",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth < 360 ? 30 : 34,
                      height: 1.08,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Intelligent air-quality monitoring and smog-risk prediction for safer motorway travel.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =====================================================
                  // MOBILE FEATURES
                  // =====================================================

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: [
                        featureBox(
                          Icons.air_rounded,
                          "AQI",
                          "Monitoring",
                        ),
                        const SizedBox(width: 9),
                        featureBox(
                          Icons.psychology_outlined,
                          "AI",
                          "Prediction",
                        ),
                        const SizedBox(width: 9),
                        featureBox(
                          Icons.route_outlined,
                          "Motorway",
                          "Safety",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =====================================================
                  // LOGIN
                  // =====================================================

                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 0,
                      maxWidth: 600,
                    ),
                    child: buildLoginPanel(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // LOGIN PANEL
  // =========================================================

  Widget buildLoginPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Sign In",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "Choose your role and sign in to continue",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 23),

        const Text(
          "SELECT YOUR ROLE",
          style: TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 10),

        // =====================================================
        // USER ROLE
        // =====================================================

        roleCard(
          "User Login",
          "Access user dashboard",
          Icons.person_outline,
          const Color(0xff2878F0),
        ),

        // =====================================================
        // NHMP ROLE
        // =====================================================

        roleCard(
          "NHMP Login",
          "National Highway Management",
          Icons.shield_outlined,
          const Color(0xff16B65B),
        ),

        // =====================================================
        // ADMIN ROLE
        // =====================================================

        roleCard(
          "Admin Login",
          "System administration",
          Icons.settings_outlined,
          const Color(0xff9A45F5),
        ),

        const SizedBox(height: 15),

        // =====================================================
        // INPUT BOX
        // =====================================================

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.035),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          child: Column(
            children: [
              // EMAIL
              inputField(
                controller: emailController,
                focusNode: emailFocusNode,
                hint: "Email address",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                onSubmitted: (_) {
                  passwordFocusNode.requestFocus();
                },
              ),

              const SizedBox(height: 12),

              // PASSWORD
              inputField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                hint: "Password",
                icon: Icons.lock_outline,
                obscureText: hidePassword,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: Icon(
                    hidePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey.shade600,
                    size: 19,
                  ),
                ),
                onSubmitted: (_) {
                  handleLogin();
                },
              ),

              const SizedBox(height: 3),

              // =====================================================
              // REMEMBER + FORGOT
              // =====================================================

              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 330) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberMe,
                              activeColor: blue,
                              checkColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white
                                    .withValues(alpha: 0.30),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(4),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                            ),
                            const Text(
                              "Remember me",
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                            ),
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: cyan,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        activeColor: blue,
                        checkColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white
                              .withValues(alpha: 0.30),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value ?? false;
                          });
                        },
                      ),

                      const Text(
                        "Remember me",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 11,
                        ),
                      ),

                      const Spacer(),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordPage(),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                        ),
                        child: const Text(
                          "Forgot password?",
                          style: TextStyle(
                            color: cyan,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 5),

              // =====================================================
              // SIGN IN BUTTON
              // =====================================================

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shadowColor: blue.withValues(alpha: 0.30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // =====================================================
        // CREATE ACCOUNT
        // =====================================================

        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 11,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(),
                    ),
                  );
                },
                child: const Text(
                  "Create Account",
                  style: TextStyle(
                    color: cyan,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 13),

        // =====================================================
        // SECURITY TEXT
        // =====================================================

        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: Colors.white.withValues(alpha: 0.25),
                size: 12,
              ),
              const SizedBox(width: 5),
              Text(
                "Secure system access",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.25),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =========================================================
  // ROLE CARD
  // =========================================================

  Widget roleCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    final bool selected = selectedRole == title;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = title;
        });

        Future.delayed(
          const Duration(milliseconds: 100),
          () {
            if (mounted) {
              emailFocusNode.requestFocus();
            }
          },
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 70,
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.10)
              : Colors.white.withValues(alpha: 0.035),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected
                ? color
                : Colors.white.withValues(alpha: 0.09),
            width: selected ? 1.7 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.08),
                    blurRadius: 18,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color:
                          selected ? color : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              color:
                  selected ? color : Colors.white30,
              size: 13,
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // INPUT FIELD
  // =========================================================

  Widget inputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    void Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onSubmitted: onSubmitted,
      style: const TextStyle(
        color: Color(0xff172033),
        fontSize: 13,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,

        hintText: hint,

        hintStyle: const TextStyle(
          color: Colors.black38,
          fontSize: 12,
        ),

        prefixIcon: Icon(
          icon,
          color: Colors.black45,
          size: 19,
        ),

        suffixIcon: suffixIcon,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(
            color: blue,
            width: 2,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // FEATURE BOX
  // =========================================================

  Widget featureBox(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      width: 112,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.065),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: cyan,
            size: 21,
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 1),

          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LOGIN FUNCTION
  // =========================================================

  void handleLogin() {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Empty fields
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );

      return;
    }

    // Email validation
    if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email)) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter a valid email address",
          ),
        ),
      );

      return;
    }

    // Password validation
    if (password.length < 8 ||
        !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[a-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password must contain capital, small letter and number",
          ),
        ),
      );

      return;
    }

    // =====================================================
    // NHMP LOGIN
    // =====================================================

    if (selectedRole == "NHMP Login" &&
        email == "nhmp@gmail.com" &&
        password == "Nhmp1234") {
      loginSuccess();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NHMPDashboard(),
        ),
      );
    }

    // =====================================================
    // USER LOGIN
    // =====================================================

    else if (selectedRole == "User Login" &&
        email == "user@gmail.com" &&
        password == "User1234") {
      loginSuccess();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserDashboard(),
        ),
      );
    }

    // =====================================================
    // ADMIN LOGIN
    // =====================================================

    else if (selectedRole == "Admin Login" &&
        email == "admin@gmail.com" &&
        password == "Admin1234") {
      loginSuccess();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminDashboard(),
        ),
      );
    }

    // =====================================================
    // INVALID LOGIN
    // =====================================================

    else {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Invalid email or password",
          ),
        ),
      );
    }
  }

  // =========================================================
  // LOGIN SUCCESS
  // =========================================================

  void loginSuccess() {
    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Login Successful"),
      ),
    );
  }
}