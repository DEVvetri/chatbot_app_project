import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPLoginScreen extends StatefulWidget {
  const OTPLoginScreen({super.key});

  @override
  _OTPLoginScreenState createState() => _OTPLoginScreenState();
}

class _OTPLoginScreenState extends State<OTPLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNumber = '';
  String verificationId = '';
  String otpCode = '';
  bool isCodeSent = false;

  // Send OTP
  void sendOTP() async {
    print(phoneNumber);
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        print("User logged in automatically!");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification Failed: ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
          isCodeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  // Verify OTP
  void verifyOTP() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otpCode,
    );

    await _auth.signInWithCredential(credential);
    print("User logged in successfully!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("OTP Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
              onChanged: (value) => phoneNumber = value,
            ),
            if (isCodeSent)
              TextField(
                decoration: InputDecoration(labelText: "Enter OTP"),
                keyboardType: TextInputType.number,
                onChanged: (value) => otpCode = value,
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isCodeSent ? verifyOTP : sendOTP,
              child: Text(isCodeSent ? "Verify OTP" : "Send OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
