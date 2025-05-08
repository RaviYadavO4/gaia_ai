import 'package:flutter/material.dart';
import 'package:gaia_ai/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();
  bool isLoading = false;

  void _reset(BuildContext context) async {
    final email = emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      showSnack(context, "Enter a valid email.", type: SnackType.error);
      return;
    }

    setState(() => isLoading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.resetPassword(email);
    setState(() => isLoading = false);
    showSnack(context, "Reset email sent.", type: SnackType.success);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo
              Center(
                child: Image.network(
                  'https://www.gaialink.app/_next/image?url=%2Fimages%2Flogo.png&w=384&q=75',
                  height: 100,
                ),
              ),
              SizedBox(height: 32),

              // Heading Text
              Text(
                "Forgot Your Password?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Enter your email to receive a reset link.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 32),

              // Email TextField
              TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              SizedBox(height: 16),

              // Reset Link Button with Figma Style
              isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4), // Shadow position
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () => _reset(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Remove default color
                          shadowColor: Colors.transparent, // Remove default shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Send Reset Link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
