import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokerpad/constants/screen_size.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'device_info_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkDeviceAndNavigate();

    // Timer(
    //     const Duration(seconds: 8),
    //     () => Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder: (context) => const DeviceInfoPage())));
  }

  Future<void> _checkDeviceAndNavigate() async {
    await Future.delayed(
        const Duration(milliseconds: 2)); // optional splash delay
    // if (!mounted) return;

    SharedPreferences pref = await SharedPreferences.getInstance();
    String? storedDeviceId = pref.getString("device_id");

    if (storedDeviceId != null && storedDeviceId.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DeviceInfoPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SizedBox(
            width: ScreenSize.screenWidth,
            height: ScreenSize.screenHeight,
            child: Image.asset(
              "assets/images/background.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SizedBox(
              width: width / 2,
              child: Image.asset("assets/Gifs/White PP Logo Animation.gif"),
            ),
          ),
        ],
      ),
    );
  }
}
