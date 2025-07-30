import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart'; // ✅ ADD THIS


class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  Future<void> _sendOTP() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String rawPhone = _phoneController.text.trim();
      String phone = rawPhone.startsWith('+') ? rawPhone : '+91$rawPhone';

      // ✅ FIXED: Use FirebaseAuthPlatform.instance instead of _auth
      final verifier = RecaptchaVerifier(
        auth: FirebaseAuthPlatform.instance,
        size: RecaptchaVerifierSize.normal,
        onSuccess: () => debugPrint('reCAPTCHA Completed'),
        onError: (FirebaseAuthException error) =>
            debugPrint('reCAPTCHA Error: $error'),
        onExpired: () => debugPrint('reCAPTCHA Expired'),
      );

      await _auth.signInWithPhoneNumber(phone, verifier);

      Fluttertoast.showToast(msg: "OTP sent to $phone");

    } catch (e) {
      debugPrint("Error sending OTP: $e");
      Fluttertoast.showToast(msg: "Error: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number (+91...)'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _sendOTP,
                child: const Text('Register & Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
