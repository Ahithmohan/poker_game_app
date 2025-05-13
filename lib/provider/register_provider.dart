import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/signup_controller.dart';
import '../model/signup_request_model.dart';
import '../view/verify_email_page.dart';

class RegisterProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  bool isPasswordVisible = false;
  bool isPasswordMatch = false; // Default to false
  bool isLoading = false;
  String? errorMessage;
  String _deviceId = "No Device ID Found";
  final SignupController _signupController = SignupController();

  RegisterProvider() {
    passwordController.addListener(_checkPasswordMatch);
    confirmPasswordController.addListener(_checkPasswordMatch);
    _getStoredDeviceId();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void _checkPasswordMatch() {
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Ensure password match check is not applied when confirm password is empty
    if (confirmPassword.isEmpty) {
      isPasswordMatch = false;
    } else {
      isPasswordMatch = password == confirmPassword;
    }

    notifyListeners();
  }

  Future<void> _getStoredDeviceId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? storedDeviceId = pref.getString("device_id");
    _deviceId = storedDeviceId ?? "No Device ID Found";
    notifyListeners();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    if (!RegExp(emailPattern).hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    const pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.#])[A-Za-z\d@$!%*?&.#]{8,}$';
    if (!RegExp(pattern).hasMatch(value)) {
      return 'Password must be at least 8 characters long and include '
          '1 uppercase letter, 1 lowercase letter, 1 number, and 1 symbol (@,  !, %, *, ?, &, #).';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> signup(BuildContext context, {int? affiliateId}) async {
    if (!formKey.currentState!.validate()) {
      return; // Stop if form validation fails
    }
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final requestModel = SignupRequestModel(
      email: emailController.text,
      password: passwordController.text,
      deviceId: _deviceId,
      accountNo: "A020241027101417",
      affiliateId: affiliateId, // ✅ Pass only if available
    );

    try {
      final response = await _signupController.signup(requestModel);
      isLoading = false;
      print("Response: ${response.id}");

      notifyListeners();

      if (response.status == "OK") {
        print("Step:${response.step}");
        debugPrint("Response: ${response.id}");
        debugPrint("Step: ${response.step}");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     elevation: 10,
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        //     behavior: SnackBarBehavior.floating,
        //     backgroundColor: CupertinoColors.activeGreen,
        //     content: const Text("Signup Successfully",
        //         style: TextStyle(color: Colors.white)),
        //   ),
        // );
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: VerifyEmailPage(
              email: requestModel.email,
              deviceId: requestModel.deviceId,
              id: response.id!.toInt(),
            ),
            type: PageTransitionType.rightToLeftWithFade,
          ),
        );
      } else if (response.status == "FAIL") {
        print(response.commonMessage);
        errorMessage = response.commonMessage;
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     elevation: 10,
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        //     behavior: SnackBarBehavior.floating,
        //     content: Text(response.commonMessage ?? "Signup Failed"),
        //   ),
        // );
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     elevation: 10,
      //     shape:
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      //     behavior: SnackBarBehavior.floating,
      //     content: const Text("Error: Signup failed."),
      //   ),
      // );
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
