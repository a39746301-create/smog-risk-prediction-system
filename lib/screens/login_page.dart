
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  String selectedRole = 'User Login';

  bool hidePassword = true;
  bool isLoading = false;
  bool rememberMe = false;

  static const Color dark = Color(0xff071525);
  static const Color card = Color(0xff0D2035);
  static const Color blue = Color(0xff1687E8);
  static const Color cyan = Color(0xff20C4E8);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        emailFocusNode.requestFocus();
      }
    });
  }

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
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // =========================
          // BACKGROUND IMAGE
          // =========================
          Positioned.fill(
            child: Image.asset(
              'assets/images/cover-image-7.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: dark,
                );
              },
            ),
          ),

          // =========================
          // DARK OVERLAY
          // =========================
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    dark.withValues(alpha: 0.88),
                    const Color(0xff061321).withValues(alpha: 0.72),
                    const Color(0xff082A40).withValues(alpha: 0.84),
                  ],
                ),
              ),
            ),
          ),

          // =========================
          // LOGIN CARD
          // =========================
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 480,
                  ),
                  child: _buildLoginCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGIN CARD
  // ============================================================

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        30,
        30,
        30,
        25,
      ),
      decoration: BoxDecoration(
        color: card.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 35,
            spreadRadius: 4,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // =========================
          // ICON
          // =========================
          Center(
            child: Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    blue.withValues(alpha: 0.28),
                    cyan.withValues(alpha: 0.12),
                  ],
                ),
                border: Border.all(
                  color: cyan.withValues(alpha: 0.35),
                ),
              ),
              child: const Icon(
                Icons.cloud_outlined,
                color: cyan,
                size: 34,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // =========================
          // TITLE
          // =========================
          const Text(
            'Sign In',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            'Smog Risk Prediction System',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 28),

          // =========================
          // ROLE TITLE
          // =========================
          Text(
            'SELECT YOUR ROLE',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 10),

          // =========================
          // ROLE CARDS
          // =========================
          Row(
            children: [
              Expanded(
                child: _roleCard(
                  title: 'User',
                  icon: Icons.person_outline_rounded,
                  value: 'User Login',
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _roleCard(
                  title: 'NHMP',
                  icon: Icons.local_police_outlined,
                  value: 'NHMP Login',
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: _roleCard(
                  title: 'Admin',
                  icon: Icons.admin_panel_settings_outlined,
                  value: 'Admin Login',
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =========================
          // EMAIL LABEL
          // =========================
          Text(
            'EMAIL ADDRESS',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),

          const SizedBox(height: 8),

          // =========================
          // EMAIL FIELD
          // =========================
          _inputField(
            controller: emailController,
            focusNode: emailFocusNode,
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) {
              passwordFocusNode.requestFocus();
            },
          ),

          const SizedBox(height: 18),

          // =========================
          // PASSWORD LABEL
          // =========================
          Text(
            'PASSWORD',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),

          const SizedBox(height: 8),

          // =========================
          // PASSWORD FIELD
          // =========================
          _inputField(
            controller: passwordController,
            focusNode: passwordFocusNode,
            hint: 'Enter your password',
            icon: Icons.lock_outline_rounded,
            obscureText: hidePassword,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (!isLoading) {
                handleLogin();
              }
            },
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
                color: const Color(0xff526170),
                size: 20,
              ),
            ),
          ),

          const SizedBox(height: 13),

          // =========================
          // REMEMBER + FORGOT
          // =========================
          Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Checkbox(
                  value: rememberMe,
                  activeColor: blue,
                  checkColor: Colors.white,
                  side: BorderSide(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Remember me',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.65),
                  fontSize: 12,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordPage(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                ),
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: cyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // =========================
          // LOGIN BUTTON
          // =========================
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                disabledBackgroundColor: blue.withValues(
                  alpha: 0.45,
                ),
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor: blue.withValues(alpha: 0.30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.login_rounded,
                          size: 20,
                        ),
                        SizedBox(width: 9),
                        Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 22),

          // =========================
          // CREATE ACCOUNT
          // =========================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.58),
                  fontSize: 12,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignupPage(),
                    ),
                  );
                },
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    color: cyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =========================
          // SECURITY FOOTER
          // =========================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_outlined,
                color: Colors.white.withValues(alpha: 0.42),
                size: 15,
              ),
              const SizedBox(width: 6),
              Text(
                'Secure Firebase authentication',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.42),
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ROLE CARD
  // ============================================================

  Widget _roleCard({
    required String title,
    required IconData icon,
    required String value,
  }) {
    final selected = selectedRole == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = value;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(emailFocusNode);
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: selected
              ? blue.withValues(alpha: 0.18)
              : Colors.white.withValues(alpha: 0.045),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected
                ? cyan.withValues(alpha: 0.80)
                : Colors.white.withValues(alpha: 0.10),
            width: selected ? 1.4 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: cyan.withValues(alpha: 0.10),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: selected ? cyan : Colors.white60,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INPUT FIELD
  // ============================================================

  Widget _inputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmitted,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onSubmitted: onSubmitted,
      obscureText: obscureText,

      // DARK TEXT INSIDE WHITE BOX
      style: const TextStyle(
        color: Color(0xff071525),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),

      cursorColor: blue,

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: const TextStyle(
          color: Color(0xff7A8794),
          fontSize: 13,
        ),

        // ICON
        prefixIcon: Icon(
          icon,
          color: const Color(0xff526170),
          size: 20,
        ),

        suffixIcon: suffixIcon,

        // =========================
        // WHITE INPUT BOX
        // =========================
        filled: true,
        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        // NORMAL BORDER
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xffD7E0E8),
            width: 1,
          ),
        ),

        // BLUE BORDER WHEN FOCUSED
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
          borderSide: BorderSide(
            color: blue,
            width: 1.8,
          ),
        ),

        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(13),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FIREBASE LOGIN
  // ============================================================

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage(
        'Please enter your email and password.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (selectedRole == 'User Login') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const UserDashboard(),
          ),
        );
      } else if (selectedRole == 'NHMP Login') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const NHMPDashboard(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const AdminDashboard(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message =
          'Login failed. Please try again.';

      if (e.code == 'user-not-found') {
        message =
            'No account found with this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      } else if (e.code == 'invalid-credential') {
        message =
            'Email or password is incorrect.';
      } else if (e.code == 'invalid-email') {
        message =
            'Please enter a valid email address.';
      } else if (e.code == 'too-many-requests') {
        message =
            'Too many attempts. Please try again later.';
      }

      showMessage(message);
    } catch (e) {
      showMessage(
        'Something went wrong. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xff102A43),
      ),
    );
  }
}
