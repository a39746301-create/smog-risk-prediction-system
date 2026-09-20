
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  static const Color dark = Color(0xff071525);
  static const Color card = Color(0xff0D2035);
  static const Color blue = Color(0xff1687E8);
  static const Color cyan = Color(0xff20C4E8);
  static const Color errorRed = Color(0xffE5485D);

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final nameFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  String? activeError;
  String? errorField;

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(nameFocusNode);
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();

    super.dispose();
  }

  void _clearError() {
    if (activeError != null) {
      setState(() {
        activeError = null;
        errorField = null;
      });
    }
  }

  void _showValidationError(
    String field,
    String message,
    FocusNode focusNode,
  ) {
    setState(() {
      errorField = field;
      activeError = message;
    });

    FocusScope.of(context).requestFocus(focusNode);
  }

  Future<void> createAccount() async {
    FocusScope.of(context).unfocus();

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // --------------------------------------------------
    // EMPTY FIELD VALIDATION
    // --------------------------------------------------

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        errorField = 'name';
        activeError = 'Please fill all fields';
      });

      FocusScope.of(context).requestFocus(nameFocusNode);
      return;
    }

    // --------------------------------------------------
    // EMAIL VALIDATION
    // --------------------------------------------------

    if (!email.contains('@') || !email.contains('.')) {
      _showValidationError(
        'email',
        'Please enter a valid email address',
        emailFocusNode,
      );
      return;
    }

    // --------------------------------------------------
    // PASSWORD VALIDATION
    // --------------------------------------------------

    if (password.length < 6) {
      _showValidationError(
        'password',
        'Password must be at least 6 characters',
        passwordFocusNode,
      );
      return;
    }

    // --------------------------------------------------
    // CONFIRM PASSWORD VALIDATION
    // --------------------------------------------------

    if (password != confirmPassword) {
      _showValidationError(
        'confirm',
        'Passwords do not match',
        confirmPasswordFocusNode,
      );
      return;
    }

    // --------------------------------------------------
    // START FIREBASE ACCOUNT CREATION
    // --------------------------------------------------

    setState(() {
      activeError = null;
      errorField = null;
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: card,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: const Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.greenAccent,
                  size: 28,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Account Created',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: const Text(
              'Your account has been created successfully.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Go to Login',
                  style: TextStyle(
                    color: cyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (e.code == 'email-already-in-use') {
        _showValidationError(
          'email',
          'This email is already registered',
          emailFocusNode,
        );
      } else if (e.code == 'invalid-email') {
        _showValidationError(
          'email',
          'Please enter a valid email address',
          emailFocusNode,
        );
      } else if (e.code == 'weak-password') {
        _showValidationError(
          'password',
          'Password is too weak',
          passwordFocusNode,
        );
      } else {
        _showValidationError(
          'email',
          'Unable to create account. Please try again',
          emailFocusNode,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      _showValidationError(
        'email',
        'Something went wrong. Please try again',
        emailFocusNode,
      );
    }
  }

  Widget _inputField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    required String fieldName,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    VoidCallback? onEditingComplete,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    final bool hasError = errorField == fieldName;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          onEditingComplete: onEditingComplete,
          onChanged: (_) {
            if (hasError) {
              _clearError();
            }
          },
          style: const TextStyle(
            color: dark,
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
            prefixIcon: Icon(
              icon,
              color: const Color(0xff526170),
              size: 20,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: hasError
                    ? errorRed
                    : const Color(0xffD7E0E8),
                width: hasError ? 1.5 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(
                color: hasError ? errorRed : blue,
                width: 1.8,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
        ),

        // Only the current error is displayed.
        if (hasError && activeError != null) ...[
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              activeError!,
              style: const TextStyle(
                color: errorRed,
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: dark,
      body: Stack(
        children: [
          // --------------------------------------------------
          // BACKGROUND IMAGE
          // --------------------------------------------------

          Positioned.fill(
            child: Image.asset(
              'assets/images/cover-image-7.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // --------------------------------------------------
          // DARK OVERLAY
          // --------------------------------------------------

          Positioned.fill(
            child: Container(
              color: dark.withAlpha(180),
            ),
          ),

          // --------------------------------------------------
          // MAIN CONTENT
          // --------------------------------------------------

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 470,
                  ),
                  child: Container(
                    padding: EdgeInsets.all(
                      size.width < 500 ? 24 : 34,
                    ),
                    decoration: BoxDecoration(
                      color: card.withAlpha(248),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withAlpha(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(110),
                          blurRadius: 35,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.stretch,
                      children: [
                        // --------------------------------------------------
                        // ICON
                        // --------------------------------------------------

                        const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: cyan,
                          size: 42,
                        ),

                        const SizedBox(height: 12),

                        // --------------------------------------------------
                        // TITLE
                        // --------------------------------------------------

                        const Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          'Create your account to access the Smog Risk Prediction System',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.5,
                            height: 1.4,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // --------------------------------------------------
                        // FULL NAME
                        // --------------------------------------------------

                        const Text(
                          'Full Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _inputField(
                          controller: nameController,
                          focusNode: nameFocusNode,
                          hint: 'Enter your full name',
                          icon: Icons.person_outline,
                          fieldName: 'name',
                          textInputAction:
                              TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(emailFocusNode);
                          },
                        ),

                        const SizedBox(height: 18),

                        // --------------------------------------------------
                        // EMAIL
                        // --------------------------------------------------

                        const Text(
                          'Email Address',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _inputField(
                          controller: emailController,
                          focusNode: emailFocusNode,
                          hint: 'Enter your email',
                          icon: Icons.email_outlined,
                          fieldName: 'email',
                          keyboardType:
                              TextInputType.emailAddress,
                          textInputAction:
                              TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                        ),

                        const SizedBox(height: 18),

                        // --------------------------------------------------
                        // PASSWORD
                        // --------------------------------------------------

                        const Text(
                          'Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _inputField(
                          controller: passwordController,
                          focusNode: passwordFocusNode,
                          hint: 'Create a password',
                          icon: Icons.lock_outline,
                          fieldName: 'password',
                          textInputAction:
                              TextInputAction.next,
                          obscureText: obscurePassword,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(
                                  confirmPasswordFocusNode,
                                );
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurePassword =
                                    !obscurePassword;
                              });
                            },
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color:
                                  const Color(0xff526170),
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // --------------------------------------------------
                        // CONFIRM PASSWORD
                        // --------------------------------------------------

                        const Text(
                          'Confirm Password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        _inputField(
                          controller:
                              confirmPasswordController,
                          focusNode:
                              confirmPasswordFocusNode,
                          hint: 'Confirm your password',
                          icon: Icons.lock_reset_outlined,
                          fieldName: 'confirm',
                          textInputAction:
                              TextInputAction.done,
                          obscureText:
                              obscureConfirmPassword,
                          onEditingComplete: createAccount,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureConfirmPassword =
                                    !obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              obscureConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color:
                                  const Color(0xff526170),
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // --------------------------------------------------
                        // CREATE ACCOUNT BUTTON
                        // --------------------------------------------------

                        SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed:
                                isLoading ? null : createAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                              disabledBackgroundColor:
                                  blue.withAlpha(100),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(13),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Create Account',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // --------------------------------------------------
                        // SIGN IN
                        // --------------------------------------------------

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.5,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: cyan,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // --------------------------------------------------
                        // FIREBASE SECURITY
                        // --------------------------------------------------

                        const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: Colors.greenAccent,
                              size: 15,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Secure Firebase Authentication',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
