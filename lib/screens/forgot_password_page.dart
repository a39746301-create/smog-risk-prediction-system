
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final emailFocusNode = FocusNode();

  bool isLoading = false;

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
    emailFocusNode.dispose();
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
          // FORGOT PASSWORD CARD
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
                  child: _buildForgotCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORGOT PASSWORD CARD
  // ============================================================

  Widget _buildForgotCard() {
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
                Icons.lock_reset_rounded,
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
            'Forgot Password?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.1,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Reset your password securely',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 28),

          // =========================
          // INFORMATION
          // =========================
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: blue.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: cyan.withValues(alpha: 0.16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: cyan,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Enter your registered email address. '
                    'We will send you a secure password reset link.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
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
          TextField(
            controller: emailController,
            focusNode: emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) {
              if (!isLoading) {
                sendResetLink();
              }
            },
            style: const TextStyle(
              color: Color(0xff071525),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: blue,
            decoration: InputDecoration(
              hintText: 'Enter your registered email',
              hintStyle: const TextStyle(
                color: Color(0xff7A8794),
                fontSize: 13,
              ),
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Color(0xff526170),
                size: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(13),
                borderSide: const BorderSide(
                  color: Color(0xffD7E0E8),
                  width: 1,
                ),
              ),
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
          ),

          const SizedBox(height: 20),

          // =========================
          // SEND RESET BUTTON
          // =========================
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed:
                  isLoading ? null : sendResetLink,
              style: ElevatedButton.styleFrom(
                backgroundColor: blue,
                disabledBackgroundColor:
                    blue.withValues(alpha: 0.45),
                foregroundColor: Colors.white,
                elevation: 8,
                shadowColor:
                    blue.withValues(alpha: 0.30),
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
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.send_rounded,
                          size: 19,
                        ),
                        SizedBox(width: 9),
                        Text(
                          'Send Reset Link',
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
          // BACK TO LOGIN
          // =========================
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_back_rounded,
                color: cyan,
                size: 16,
              ),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back to Sign In',
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
  // FIREBASE RESET PASSWORD
  // ============================================================

  Future<void> sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showMessage(
        'Please enter your email address.',
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      showMessage(
        'Please enter a valid email address.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xff20C4E8),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Reset Link Sent',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            content: const Text(
              'A password reset link has been sent to your email address. '
              'Please check your inbox and follow the instructions.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Back to Sign In',
                  style: TextStyle(
                    color: cyan,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      String message =
          'Unable to send reset link.';

      if (e.code == 'user-not-found') {
        message =
            'No account found with this email.';
      } else if (e.code == 'invalid-email') {
        message =
            'Please enter a valid email address.';
      } else if (e.code == 'too-many-requests') {
        message =
            'Too many requests. Please try again later.';
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

