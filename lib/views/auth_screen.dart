import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'onboarding_screen.dart';
import 'dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool isLoading = false;
  bool isPasswordVisible = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Color primaryNavy = const Color(0xFF1B1464);
  final Color accentPurple = const Color(0xFF4F46E5);
  final Color bgLight = const Color(0xFFFAFAFC);
  final Color textDark = const Color(0xFF0F172A);
  final Color textMuted = const Color(0xFF64748B);

  Future<void> _handleAuth() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Please fill in all fields.");
      return;
    }

    setState(() => isLoading = true);

    try {
      final supabase = Supabase.instance.client;

      if (isLogin) {
        // --- LOGIN FLOW ---
        final response = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );

        final userId = response.user?.id;
        if (userId != null) {
          // Check Supabase if user has already completed onboarding profile
          final profileData = await supabase
              .from('profiles')
              .select()
              .eq('id', userId)
              .maybeSingle();

          if (mounted) {
            bool isOnboarded = profileData != null &&
                (profileData['degree'] != null || profileData['is_onboarded'] == true);

            if (isOnboarded) {
              // Direct Dashboard Redirection
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen(userId: userId)),
              );
            } else {
              // First time / Incomplete profile -> Onboarding
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingScreen()),
              );
            }
          }
        }
      } else {
        // --- SIGN UP FLOW ---
        final response = await supabase.auth.signUp(
          email: email,
          password: password,
        );

        if (response.user != null && mounted) {
          _showSnackBar("Account created successfully!");
          // Always send new sign-ups to Onboarding
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      }
    } on AuthException catch (e) {
      _showSnackBar(e.message);
    } catch (e) {
      _showSnackBar("An unexpected error occurred: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: accentPurple),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo & Brand Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.school_outlined, size: 36, color: primaryNavy),
                      const SizedBox(width: 8),
                      Text(
                        "Skill Pathway",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryNavy,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Welcome to your future.",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your path. Your skills. Your future.",
                    style: TextStyle(color: textMuted, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // Auth Card Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Login / Sign Up Tab Toggle Bar
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isLogin = true),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: isLogin ? accentPurple : Colors.transparent,
                                          width: 2.5,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          fontWeight: isLogin ? FontWeight.bold : FontWeight.w500,
                                          color: isLogin ? accentPurple : textMuted,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => isLogin = false),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: !isLogin ? accentPurple : Colors.transparent,
                                          width: 2.5,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Sign Up",
                                        style: TextStyle(
                                          fontWeight: !isLogin ? FontWeight.bold : FontWeight.w500,
                                          color: !isLogin ? accentPurple : textMuted,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Email Field
                        Text("Email Address", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textDark)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _buildInputDecoration(
                            prefixIcon: Icon(Icons.email_outlined, color: textMuted, size: 20),
                            hintText: "yourname@gmail.com",
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Password", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: textDark)),
                            if (isLogin)
                              GestureDetector(
                                onTap: () {},
                                child: Text("Forgot Password?", style: TextStyle(fontSize: 12, color: accentPurple, fontWeight: FontWeight.w600)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: !isPasswordVisible,
                          decoration: _buildInputDecoration(
                            prefixIcon: Icon(Icons.lock_outline_rounded, color: textMuted, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: textMuted,
                                size: 20,
                              ),
                              onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _handleAuth,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    isLogin ? "Login" : "Create Account",
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({Widget? prefixIcon, Widget? suffixIcon, String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: accentPurple, width: 1.5),
      ),
    );
  }
}