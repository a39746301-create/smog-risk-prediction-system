
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  static const Color successGreen = Colors.greenAccent;

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

  bool hasMinLength = false;
  bool hasUppercase = false;
  bool hasLowercase = false;
  bool hasNumber = false;
  bool hasSpecialCharacter = false;

  @override
  void initState() {
    super.initState();

    passwordController.addListener(_updatePasswordStrength);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).requestFocus(nameFocusNode);
      }
    });
  }

  @override
  void dispose() {
    passwordController.removeListener(_updatePasswordStrength);

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

  void _updatePasswordStrength() {
    final password = passwordController.text;

    final minLength = password.length >= 8;
    final uppercase = RegExp(r'[A-Z]').hasMatch(password);
    final lowercase = RegExp(r'[a-z]').hasMatch(password);
    final number = RegExp(r'[0-9]').hasMatch(password);
    final special = RegExp(r'[^A-Za-z0-9]').hasMatch(password);

    if (mounted) {
      setState(() {
        hasMinLength = minLength;
        hasUppercase = uppercase;
        hasLowercase = lowercase;
        hasNumber = number;
        hasSpecialCharacter = special;
      });
    }
  }

  bool get isPasswordStrong {
    return hasMinLength &&
        hasUppercase &&
        hasLowercase &&
        hasNumber &&
        hasSpecialCharacter;
  }

  void _clearError() {
    if (activeError != null || errorField != null) {
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

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    return emailRegex.hasMatch(email);
  }

  bool _isValidName(String name) {
    if (name.length < 2) return false;

    final nameRegex = RegExp(
      r"^[A-Za-zÀ-ÿ][A-Za-zÀ-ÿ\s'\-]*$",
    );

    return nameRegex.hasMatch(name);
  }

  Future<void> createAccount() async {
    if (isLoading) return;

    FocusScope.of(context).unfocus();

    final name = nameController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    // --------------------------------------------------
    // EMPTY FIELD VALIDATION
    // --------------------------------------------------

    if (name.isEmpty) {
      _showValidationError(
        'name',
        'Please enter your full name',
        nameFocusNode,
      );
      return;
    }

    if (email.isEmpty) {
      _showValidationError(
        'email',
        'Please enter your email address',
        emailFocusNode,
      );
      return;
    }

    if (password.isEmpty) {
      _showValidationError(
        'password',
        'Please create a password',
        passwordFocusNode,
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      _showValidationError(
        'confirm',
        'Please confirm your password',
        confirmPasswordFocusNode,
      );
      return;
    }

    // --------------------------------------------------
    // NAME VALIDATION
    // --------------------------------------------------

    if (!_isValidName(name)) {
      _showValidationError(
        'name',
        'Please enter a valid name',
        nameFocusNode,
      );
      return;
    }

    // --------------------------------------------------
    // EMAIL VALIDATION
    // --------------------------------------------------

    if (email.contains(' ')) {
      _showValidationError(
        'email',
        'Email address cannot contain spaces',
        emailFocusNode,
      );
      return;
    }

    if (!_isValidEmail(email)) {
      _showValidationError(
        'email',
        'Please enter a valid email address',
        emailFocusNode,
      );
      return;
    }

    // --------------------------------------------------
    // STRONG PASSWORD VALIDATION
    // --------------------------------------------------

    if (!hasMinLength) {
      _showValidationError(
        'password',
        'Password must be at least 8 characters',
        passwordFocusNode,
      );
      return;
    }

    if (!hasUppercase) {
      _showValidationError(
        'password',
        'Password must contain at least one uppercase letter',
        passwordFocusNode,
      );
      return;
    }

    if (!hasLowercase) {
      _showValidationError(
        'password',
        'Password must contain at least one lowercase letter',
        passwordFocusNode,
      );
      return;
    }

    if (!hasNumber) {
      _showValidationError(
        'password',
        'Password must contain at least one number',
        passwordFocusNode,
      );
      return;
    }

    if (!hasSpecialCharacter) {
      _showValidationError(
        'password',
        'Password must contain at least one special character',
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
    // START ACCOUNT CREATION
    // --------------------------------------------------

    setState(() {
      activeError = null;
      errorField = null;
      isLoading = true;
    });

    try {
      // Create account in Firebase Authentication.
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'account-creation-failed',
          message: 'User account could not be created.',
        );
      }

      // Save display name in Firebase Authentication.
      await user.updateDisplayName(name);

      // Create the user's Firestore profile.
      //
      // IMPORTANT:
      // Every account created through normal Signup
      // automatically receives the "user" role.
      //
      // The person signing up cannot choose Admin or NHMP.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'name': name,
        'email': email,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Sign out after signup so the new user goes
      // through the normal Login page.
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      // Success dialog.
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
                  color: successGreen,
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
              'Your account has been created successfully. You can now sign in using your email and password.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
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
          'Firebase rejected this password as too weak',
          passwordFocusNode,
        );
      } else if (e.code == 'operation-not-allowed') {
        _showValidationError(
          'email',
          'Email/password authentication is disabled in Firebase',
          emailFocusNode,
        );
      } else if (e.code == 'network-request-failed') {
        _showValidationError(
          'email',
          'Network error. Please check your internet connection',
          emailFocusNode,
        );
      } else {
        _showValidationError(
          'email',
          'Unable to create account. Please try again',
          emailFocusNode,
        );
      }
    } on FirebaseException catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      if (e.code == 'permission-denied') {
        _showValidationError(
          'email',
          'Account created, but user profile could not be saved. Please check Firestore Rules.',
          emailFocusNode,
        );
      } else {
        _showValidationError(
          'email',
          'Database error. Please try again',
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

  Widget _passwordRequirement({
    required bool valid,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            valid
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 15,
            color: valid ? successGreen : Colors.white38,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: valid ? successGreen : Colors.white54,
                fontSize: 11.5,
                fontWeight:
                    valid ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordStrengthBox() {
    if (passwordController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    final requirements = [
      hasMinLength,
      hasUppercase,
      hasLowercase,
      hasNumber,
      hasSpecialCharacter,
    ];

    final score =
        requirements.where((requirement) => requirement).length;

    String strengthText;

    if (score <= 2) {
      strengthText = 'Weak password';
    } else if (score <= 4) {
      strengthText = 'Medium password';
    } else {
      strengthText = 'Strong password';
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withAlpha(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.security_rounded,
                color: cyan,
                size: 17,
              ),
              const SizedBox(width: 7),
              Text(
                strengthText,
                style: TextStyle(
                  color: score == 5
                      ? successGreen
                      : Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          _passwordRequirement(
            valid: hasMinLength,
            text: 'At least 8 characters',
          ),
          _passwordRequirement(
            valid: hasUppercase,
            text: 'One uppercase letter (A-Z)',
          ),
          _passwordRequirement(
            valid: hasLowercase,
            text: 'One lowercase letter (a-z)',
          ),
          _passwordRequirement(
            valid: hasNumber,
            text: 'One number (0-9)',
          ),
          _passwordRequirement(
            valid: hasSpecialCharacter,
            text: 'One special character (@, #, !, etc.)',
          ),
        ],
      ),
    );
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
          autocorrect: false,
          enableSuggestions: fieldName == 'name',
          textCapitalization: fieldName == 'name'
              ? TextCapitalization.words
              : TextCapitalization.none,
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
          Positioned.fill(
            child: Image.asset(
              'assets/images/cover-image-7.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: dark.withAlpha(180),
            ),
          ),

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
                        const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: cyan,
                          size: 42,
                        ),

                        const SizedBox(height: 12),

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
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(emailFocusNode);
                          },
                        ),

                        const SizedBox(height: 18),

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
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            FocusScope.of(context)
                                .requestFocus(passwordFocusNode);
                          },
                        ),

                        const SizedBox(height: 18),

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
                          hint: 'Create a strong password',
                          icon: Icons.lock_outline,
                          fieldName: 'password',
                          textInputAction: TextInputAction.next,
                          obscureText: obscurePassword,
                          onEditingComplete: () {
                            FocusScope.of(context).requestFocus(
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
                              color: const Color(0xff526170),
                              size: 20,
                            ),
                          ),
                        ),

                        _passwordStrengthBox(),

                        const SizedBox(height: 18),

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
                          controller: confirmPasswordController,
                          focusNode: confirmPasswordFocusNode,
                          hint: 'Confirm your password',
                          icon: Icons.lock_reset_outlined,
                          fieldName: 'confirm',
                          textInputAction: TextInputAction.done,
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
                              color: const Color(0xff526170),
                              size: 20,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 20),

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
                              onTap: isLoading
                                  ? null
                                  : () {
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

                        const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.verified_user_outlined,
                              color: successGreen,
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
