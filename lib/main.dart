
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login & Registration',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5B55D9),
        ),
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();

  // Text controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form settings
  bool _isLogin = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;

  // REGEX PATTERNS

  // Email validation
  final RegExp emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  // Password validation
  // Minimum 8 characters, uppercase, lowercase,
  // number, and special character
  final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,}$',
  );

  // Name validation
  final RegExp nameRegex = RegExp(
    r"^[A-Za-z][A-Za-z .'-]{1,48}$",
  );

  // NAME VALIDATION
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }

    if (!nameRegex.hasMatch(value.trim())) {
      return 'Enter a valid name (at least 2 characters)';
    }

    return null;
  }

  // EMAIL VALIDATION
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // PASSWORD VALIDATION
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (!passwordRegex.hasMatch(value)) {
      return 'Password must meet all the requirements below';
    }

    return null;
  }

  // CONFIRM PASSWORD VALIDATION
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  // FORM SUBMISSION
  void submitForm() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLogin
                ? 'Login form validated successfully!'
                : 'Registration form validated successfully!',
          ),
          backgroundColor: const Color(0xFF39358F),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // SWITCH BETWEEN LOGIN AND REGISTRATION
  void switchMode() {
    setState(() {
      _isLogin = !_isLogin;

      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      _obscurePassword = true;
      _obscureConfirmPassword = true;
    });

    _formKey.currentState?.reset();
  }

  // REUSABLE TEXT FIELD
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    bool obscureText = false,
    Widget? suffixIcon,
    Iterable<String>? autofillHints,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      validator: validator,
      autofillHints: autofillHints,
      textInputAction: TextInputAction.next,
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF272747),
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF7772C9),
          size: 21,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF7F7FB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        labelStyle: const TextStyle(
          color: Color(0xFF77778D),
          fontSize: 14,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFFAAAABD),
          fontSize: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFFE8E8F0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Color(0xFF7772C9),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // LOGIN AND REGISTRATION TAB
  Widget buildModeButton(String text, bool loginMode) {
    final selected = _isLogin == loginMode;

    return Expanded(
      child: GestureDetector(
        onTap: switchMode,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected
                    ? const Color(0xFF514BB5)
                    : const Color(0xFF85859A),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F1FA),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF7F5FF),
              Color(0xFFECEEFF),
              Color(0xFFF4F1FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 30,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 450,
                ),
                child: Column(
                  children: [
                    // APP LOGO
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7772D9),
                            Color(0xFF514BB5),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF514BB5)
                                .withValues(alpha: 0.25),
                            blurRadius: 18,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.lock_person_rounded,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // HEADING
                    Text(
                      _isLogin ? 'Welcome Back' : 'Create Account',
                      style: const TextStyle(
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF252548),
                        letterSpacing: -0.7,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _isLogin
                          ? 'Sign in to continue to your account'
                          : 'Join us and create your new account',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF82829B),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // MAIN FORM CARD
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF37316C)
                                .withValues(alpha: 0.09),
                            blurRadius: 35,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // LOGIN / REGISTER SWITCH
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F0F7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                buildModeButton('LOGIN', true),
                                buildModeButton('REGISTER', false),
                              ],
                            ),
                          ),

                          const SizedBox(height: 27),

                          // FORM STARTS HERE
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // FULL NAME
                                if (!_isLogin) ...[
                                  buildTextField(
                                    controller: _nameController,
                                    label: 'Full Name',
                                    hint: 'Enter your full name',
                                    icon: Icons.person_outline_rounded,
                                    validator: validateName,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    autofillHints: const [
                                      AutofillHints.name,
                                    ],
                                  ),

                                  const SizedBox(height: 19),
                                ],

                                // EMAIL
                                buildTextField(
                                  controller: _emailController,
                                  label: 'Email Address',
                                  hint: 'example@email.com',
                                  icon: Icons.mail_outline_rounded,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: validateEmail,
                                  autofillHints: const [
                                    AutofillHints.email,
                                  ],
                                ),

                                const SizedBox(height: 19),

                                // PASSWORD
                                buildTextField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  icon: Icons.lock_outline_rounded,
                                  obscureText: _obscurePassword,
                                  validator: validatePassword,
                                  autofillHints: const [
                                    AutofillHints.password,
                                  ],
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: const Color(0xFF9292A8),
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword =
                                            !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),

                                // PASSWORD REQUIREMENTS
                                const SizedBox(height: 9),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3,
                                  ),
                                  child: Text(
                                    'Use 8+ characters with uppercase, '
                                    'lowercase, number and special character.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF9292A8),
                                      height: 1.5,
                                    ),
                                  ),
                                ),

                                // CONFIRM PASSWORD
                                if (!_isLogin) ...[
                                  const SizedBox(height: 19),

                                  buildTextField(
                                    controller: _confirmPasswordController,
                                    label: 'Confirm Password',
                                    hint: 'Re-enter your password',
                                    icon: Icons.verified_user_outlined,
                                    obscureText: _obscureConfirmPassword,
                                    validator: validateConfirmPassword,
                                    autofillHints: const [
                                      AutofillHints.newPassword,
                                    ],
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureConfirmPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF9292A8),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 17),

                                // REMEMBER ME / FORGOT PASSWORD
                                if (_isLogin)
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 35,
                                        child: Checkbox(
                                          value: _rememberMe,
                                          activeColor:
                                              const Color(0xFF5B55C9),
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value ?? false;
                                            });
                                          },
                                          visualDensity:
                                              VisualDensity.compact,
                                        ),
                                      ),
                                      const Text(
                                        'Remember me',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF707089),
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Password recovery is not '
                                                'connected in this demo.',
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Forgot password?',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF5B55C9),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                if (!_isLogin)
                                  const SizedBox(height: 3),

                                const SizedBox(height: 15),

                                // SUBMIT BUTTON
                                SizedBox(
                                  height: 55,
                                  child: ElevatedButton(
                                    onPressed: submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFF5B55C9),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _isLogin
                                              ? 'SIGN IN'
                                              : 'CREATE ACCOUNT',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 9),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 19,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 21),

                                // SWITCH ACCOUNT MODE
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        _isLogin
                                            ? "Don't have an account?"
                                            : 'Already have an account?',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF85859A),
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: switchMode,
                                      style: TextButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        _isLogin ? 'Sign Up' : 'Sign In',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF5B55C9),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    // FOOTER
                    const Text(
                      'SECURE  •  SIMPLE  •  YOURS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: Color(0xFF9999AD),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
