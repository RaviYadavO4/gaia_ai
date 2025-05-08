import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth/auth_provider.dart';
import '../../utils/utils.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;

  void _signup(BuildContext context) async {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final confirmPass = confirmPassCtrl.text.trim();

    if (name.isEmpty) {
      showSnack(context, "Enter your name.", type: SnackType.error);
      return;
    }

    if (email.isEmpty || !email.contains('@')) {
      showSnack(context, "Enter a valid email.", type: SnackType.error);
      return;
    }

    if (pass.isEmpty || pass.length < 6) {
      showSnack(context, "Password must be at least 6 characters.", type: SnackType.error);
      return;
    }

    if (pass != confirmPass) {
      showSnack(context, "Passwords do not match.", type: SnackType.error);
      return;
    }

    setState(() => isLoading = true);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final error = await auth.signUp(email, pass);

    if (error == null) {
      // Update user display name
      final user = auth.user;
      await user?.updateDisplayName(name);
      await user?.reload();
      showSnack(context, "Verify your email and login.", type: SnackType.success);
      Navigator.pop(context);
    } else {
      showSnack(context, error, type: SnackType.error);
    }

    setState(() => isLoading = false);
  }

  Widget buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool isVisible,
    required VoidCallback toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
          ),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                'https://www.gaialink.app/_next/image?url=%2Fimages%2Flogo.png&w=384&q=75',
                height: 100,
              ),
            ),
            SizedBox(height: 32),
            Text(
              "Create Account",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Sign up to get started",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 32),
            TextField(
              controller: nameCtrl,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            buildPasswordField(
              label: 'Password',
              controller: passCtrl,
              isVisible: showPassword,
              toggleVisibility: () => setState(() => showPassword = !showPassword),
            ),
            SizedBox(height: 16),
            buildPasswordField(
              label: 'Confirm Password',
              controller: confirmPassCtrl,
              isVisible: showConfirmPassword,
              toggleVisibility: () => setState(() => showConfirmPassword = !showConfirmPassword),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : () => _signup(context),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Sign Up",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
