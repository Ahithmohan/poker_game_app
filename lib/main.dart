import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerpad/provider/affiliated_button_provider.dart';
import 'package:pokerpad/provider/avatar_provider.dart';
import 'package:pokerpad/provider/cashier_button_provider.dart';
import 'package:pokerpad/provider/country_provider.dart';
import 'package:pokerpad/provider/currency_button_provider.dart';
import 'package:pokerpad/provider/login_provider.dart';
import 'package:pokerpad/provider/profile_country_provider.dart';
import 'package:pokerpad/provider/qr_provider.dart';
import 'package:pokerpad/provider/register_provider.dart';
import 'package:pokerpad/provider/second_avatar_provider.dart';
import 'package:pokerpad/provider/transfer_button_provider.dart';
import 'package:pokerpad/view/front_camera_page.dart';
import 'package:pokerpad/view/image_scroll_page.dart';
import 'package:pokerpad/view/name_page.dart';
import 'package:pokerpad/view/p_y_i_camera_page.dart';
import 'package:pokerpad/view/phone_number_page.dart';
import 'package:pokerpad/view/pick_avatar_page.dart';
import 'package:pokerpad/view/pick_secondary_avatar.dart';
import 'package:pokerpad/view/register_page.dart';
import 'package:pokerpad/view/splash_page.dart';
import 'package:pokerpad/view/terms_page.dart';
import 'package:pokerpad/view/text_page.dart';
import 'package:pokerpad/view/verify_email_page.dart';
import 'package:provider/provider.dart';

import 'controller/chartline_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AffiliatedButtonProvider()),
    ChangeNotifierProvider(create: (_) => CashierButtonProvider()),
    ChangeNotifierProvider(create: (_) => TransferButtonProvider()),
    ChangeNotifierProvider(create: (_) => QrProvider()),
    ChangeNotifierProvider(create: (_) => CurrencyButtonProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => RegisterProvider()),
    ChangeNotifierProvider(create: (_) => CountryProvider()),
    ChangeNotifierProvider(create: (_) => ChartController()),
    ChangeNotifierProvider(create: (_) => AvatarProvider()),
    ChangeNotifierProvider(create: (_) => SecondAvatarProvider()),
    ChangeNotifierProvider(create: (_) => ProfileCountryProvider())
    // ChangeNotifierProvider(create: (_) => BalanceProvider()),
  ], child: const MyApp()));

  // runApp(DevicePreview(
  //     enabled: true,
  //     builder: (context) {
  //       return MultiProvider(providers: [
  //         ChangeNotifierProvider(create: (_) => AffiliatedButtonProvider()),
  //         ChangeNotifierProvider(create: (_) => CashierButtonProvider()),
  //         ChangeNotifierProvider(create: (_) => TransferButtonProvider()),
  //       ], child: const MyApp());
  //     }));
}

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.storage, // For Android 12 and below
    Permission.photos, // For iOS
    Permission.requestInstallPackages,
  ].request();

  if (statuses[Permission.camera]!.isDenied ||
      statuses[Permission.storage]!.isDenied ||
      statuses[Permission.requestInstallPackages]!.isDenied) {
    openAppSettings(); // Open settings if permission is permanently denied
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/email': (context) => const RegisterPage(),
        '/otp': (context) => const VerifyEmailPage(),
        '/gender': (context) => const ImageScrollPage(),
        '/photo': (context) => const FrontCameraPage(),
        '/name': (context) => const NamePage(),
        '/phone': (context) => const PhoneNumberPage(),
        '/primaryAvatar': (context) => const PickAvatarPage(),
        'secondaryAvatar': (context) => const PickSecondaryAvatar(),
        '/kycId': (context) => const PYICameraPage(),
        '/terms': (context) => const TermsPage(),
        '/finish': (context) => const TextPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          onPrimary: Colors.black12,
          seedColor: Colors.black12,
          primary: Colors.black12,
        ),
        useMaterial3: true,
      ),
      home: const SplashPage(),
    );
  }
}
