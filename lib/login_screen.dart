import 'package:flashcards_quiz/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Single-file auth demo:
/// - Sign up: saves email+password
/// - Login: checks email+password
/// - Persists logged-in state across app restarts
/// - Uses your provided UI layout/design
///
/// IMPORTANT: For real apps, do NOT store raw passwords.
/// This is for offline demo/learning only.

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoginMode = true;
  bool _isPasswordVisible = false;
  bool _loading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  bool _isValidEmail(String email) {
    final e = email.trim();
    return e.isNotEmpty && e.contains('@') && e.contains('.');
  }

  Future<void> _signUp() async {
    setState(() {
      _errorMessage = '';
      _loading = true;
    });

    final email = _emailController.text.trim().toLowerCase();
    final pass = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    try {
      if (!_isValidEmail(email)) {
        throw 'Please enter a valid email.';
      }
      if (pass.length < 6) {
        throw 'Password must be at least 6 characters.';
      }
      if (pass != confirm) {
        throw 'Passwords do not match.';
      }

      // Save signup credentials (demo/learning use)
      await _storage.write(key: 'signupEmail', value: email);
      await _storage.write(key: 'signupPassword', value: pass);

      // After signup, switch to login mode
      setState(() {
        _isLoginMode = true;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created. Please log in.')),
      );
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _login() async {
    setState(() {
      _errorMessage = '';
      _loading = true;
    });

    final email = _emailController.text.trim().toLowerCase();
    final pass = _passwordController.text;

    try {
      if (!_isValidEmail(email)) {
        throw 'Please enter a valid email.';
      }
      if (pass.isEmpty) {
        throw 'Password is required.';
      }

      final savedEmail = await _storage.read(key: 'signupEmail');
      final savedPass = await _storage.read(key: 'signupPassword');

      if (savedEmail == null || savedPass == null) {
        throw 'No account found. Please Sign Up first.';
      }

      if (email != savedEmail || pass != savedPass) {
        throw 'Invalid email or password.';
      }

      // Persist login session
      await _storage.write(key: 'isLoggedIn', value: 'true');
      await _storage.write(key: 'currentEmail', value: email);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    // Offline demo:
    // show saved password only for demonstration (NOT recommended in real apps).
    final savedEmail = await _storage.read(key: 'signupEmail');
    final savedPass = await _storage.read(key: 'signupPassword');

    if (!mounted) return;

    if (savedEmail == null || savedPass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No saved account found. Please Sign Up.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Demo: Saved Credentials'),
        content: Text('Email: $savedEmail\nPassword: $savedPass'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image container
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/LogIn_dp.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20.0),
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 500,
                  // allow enough height for signup + error text
                  maxHeight: 560,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      _isLoginMode
                          ? 'Login with your Account'
                          : 'Create an Account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Email Text Field
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'example@gmail.com',
                        prefixIcon: Icon(Icons.email, color: Colors.blue[800]),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Text Field
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue[800],
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Confirm Password Text Field for Sign Up Mode
                    if (!_isLoginMode)
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          prefixIcon: Icon(Icons.lock, color: Colors.blue[800]),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blue[800],
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),

                    // Forgot Password link (only in login mode)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _isLoginMode ? _forgotPassword : null,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Sign In / Sign Up Button
                    ElevatedButton(
                      onPressed:
                          _loading ? null : (_isLoginMode ? _login : _signUp),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: _loading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              _isLoginMode ? 'Sign In' : 'Sign Up',
                              style: const TextStyle(fontSize: 18),
                            ),
                    ),
                    const SizedBox(height: 20),

                    // Toggle Login/Signup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLoginMode
                              ? 'Don\'t have an account? '
                              : 'Already have an account? ',
                          style: TextStyle(color: Colors.blue[800]),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLoginMode = !_isLoginMode;
                              _errorMessage = '';
                              // optional: clear confirm field when switching
                              _confirmPasswordController.clear();
                            });
                          },
                          child: Text(
                            _isLoginMode ? 'Sign Up' : 'Sign In',
                            style: TextStyle(color: Colors.blue[800]),
                          ),
                        ),
                      ],
                    ),

                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
