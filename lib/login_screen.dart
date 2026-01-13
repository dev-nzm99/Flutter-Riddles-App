import 'package:flashcards_quiz/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoginMode = true;
  bool _isPasswordVisible = false;
  bool _loading = false;
  String _errorMessage = '';

  final supabase = Supabase.instance.client;

  @override
  void dispose() {
    _usernameController.dispose();
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

  // Placeholder for forgot password logic
  void _forgotPassword() {
    // Implement password recovery logic here
  }

  Future<void> _signUp() async {
    setState(() {
      _errorMessage = '';
      _loading = true;
    });

    final email = _emailController.text.trim().toLowerCase();
    final pass = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    final username = _usernameController.text.trim();

    try {
      if (username.isEmpty) throw 'Username is required.';
      if (!_isValidEmail(email)) throw 'Please enter a valid email.';
      if (pass.length < 6) throw 'Password must be at least 6 characters.';
      if (pass != confirm) throw 'Passwords do not match.';

      await supabase.auth.signUp(
        email: email,
        password: pass,
        data: {'display_name': username},
      );

      // Note: Ensure your 'users' table has 'username', 'email', and 'password' columns
      // If your 'password' column is 'NOT NULL', you must include it here.
      await supabase.from('users').insert({
        'username': username,
        'email': email,
        'password': pass,
      });

      if (!mounted) return;
      setState(() => _isLoginMode = true);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Account created. Please confirm your email.')),
      );
    } on AuthException catch (error) {
      setState(() => _errorMessage = error.message);
    } catch (error) {
      setState(() => _errorMessage = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
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
      if (!_isValidEmail(email)) throw 'Please enter a valid email.';
      if (pass.isEmpty) throw 'Password is required.';

      await supabase.auth.signInWithPassword(email: email, password: pass);

      final userData = await supabase
          .from('users')
          .select('username')
          .eq('email', email)
          .maybeSingle();

      final username = userData?['username'] ?? 'User';
      await _storage.write(key: 'isLoggedIn', value: 'true');
      await _storage.write(key: 'currentEmail', value: email);
      await _storage.write(key: 'currentUsername', value: username);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomePage(username: username)),
      );
    } on AuthException catch (error) {
      setState(() => _errorMessage = error.message);
    } catch (e) {
      setState(() => _errorMessage = 'An unexpected error occurred.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                image: AssetImage('assets/login_screen_dp.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                // Added to allow scrolling for the extra field
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.13),
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
                    // Increased maxHeight to accommodate the new Username field
                    maxHeight: 600,
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
                            color: Colors.white.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 20),

                      // Username Text Field (Only in Sign Up Mode)
                      if (!_isLoginMode) ...[
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            hintText: 'Username',
                            prefixIcon:
                                Icon(Icons.person, color: Colors.blue[800]),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Email Text Field
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'example@gmail.com',
                          prefixIcon:
                              Icon(Icons.email, color: Colors.blue[800]),
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
                      if (!_isLoginMode) ...[
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            prefixIcon:
                                Icon(Icons.lock, color: Colors.blue[800]),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],

                      // Forgot Password link (only in login mode)
                      if (_isLoginMode)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _forgotPassword,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
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
                            horizontal:
                                80, // Slightly reduced to fit text better
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
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
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
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.6)),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isLoginMode = !_isLoginMode;
                                _errorMessage = '';
                                _confirmPasswordController.clear();
                              });
                            },
                            child: Text(
                              _isLoginMode ? 'Sign Up' : 'Sign In',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.8)),
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
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
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
