import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/controller/signup_controller.dart';
import 'package:pokerpad/view/loading_avatar_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/country_list.dart';
import 'login_provider.dart';

class CountryProvider extends ChangeNotifier {
  String _countryCode = "+1"; // Default country code
  String _countryFlag =
      "assets/images/Country Flags/United_States_of_America_1.png"; // Default flag
  String _phoneNumber = ""; // Store entered phone number
  String _countryName = "United States of America";
  String _deviceId = "Fetching..."; // Default value
  bool _isLoading = false;
  String? _apiResponse;
  String? errorMessage;

  List<Country> _filteredCountries = List.from(countries);
  // Getters
  String get countryCode => _countryCode;
  String get countryFlag => _countryFlag;
  String get phoneNumber => _phoneNumber;
  String get countryName => _countryName;
  String get deviceId => _deviceId;
  bool get isLoading => _isLoading;
  String? get apiResponse => _apiResponse;
  List<Country> get filteredCountries => _filteredCountries;

  CountryProvider() {
    _getStoredDeviceId(); // Fetch stored Device ID on provider initialization
    print("device id$_deviceId,number$phoneNumber");
  }

  bool validatePhoneNumber() {
    if (_countryCode == "+1") {
      if (_phoneNumber.length != 10) {
        errorMessage = "US numbers must be exactly 10 digits.";
        notifyListeners();
        return false;
      }
    } else {
      if (_phoneNumber.length < 5) {
        errorMessage = "Phone number must be at least 5 digits.";
        notifyListeners();
        return false;
      }
    }
    errorMessage = null;
    notifyListeners();
    return true;
  }

  Future<void> _getStoredDeviceId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? storedDeviceId = pref.getString("device_id");

    _deviceId = storedDeviceId ?? "No Device ID Found";
    notifyListeners(); // Update UI
    print("Updated Device ID: $_deviceId");
  }

  // Update phone number
  void updatePhoneNumber(String value) {
    _phoneNumber = value;
    print(_phoneNumber);
    notifyListeners();
  }

  // Search countries
  void searchCountry(String query) {
    _filteredCountries = countries
        .where((country) =>
            country.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  // Select country
  void selectCountry(Country country) {
    _countryFlag = country.flag;
    _countryCode = country.dialCode;
    _countryName = country.name;
    final id = SignupController.userId;
    print("userId$id");
    print("deviceId:$deviceId");
    print("countryName:$_countryName");
    print(_countryCode);
    notifyListeners();
  }

  // Reset filtered countries
  void resetFilteredCountries() {
    _filteredCountries = List.from(countries);
    notifyListeners();
  }
  //Api call

  Future<void> sentPhoneNumber(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final loginId = loginProvider.playerId;
    print("login id :$loginId");
    final id = SignupController.userId ?? loginId;
    final String url = "http://3.6.170.253:1080/server.php/api/v1/players/$id";

    print("url:$url");
    _isLoading = true;
    notifyListeners();
    try {
      if (_deviceId == "Fetching...") {
        _getStoredDeviceId();
      }
      //send api request
      final response = await Dio().put(url,
          data: {
            "phone": _phoneNumber,
            "ph_country_code": _countryCode,
            "country": _countryName,
            "deviceId": _deviceId
          },
          options: Options(headers: {
            "Content-Type": "application/json",
          }));
      if (response.statusCode == 200) {
        print("✅ API Success: ${response.data}");
        _apiResponse = "Success: ${response.data}";
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: const LoadingAvatarPage(), // Ensure HomePage is imported
            type: PageTransitionType.rightToLeftWithFade,
          ),
        );
      } else {
        print("⚠️ API Error: ${response.statusCode} - ${response.data}");
        _apiResponse = "Error: ${response.data}";
      }
    } catch (e) {
      print("❌ API Request Failed: $e");
      _apiResponse = "Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePhoneNumbe(
    BuildContext context,
    int userId,
    String newPhoneNumber,
  ) async {
    final String url =
        "http://3.6.170.253:1080/server.php/api/v1/players/$userId";

    print("🔄 Updating phone number at: $url");

    _isLoading = true;
    notifyListeners();

    try {
      if (_deviceId == "Fetching...") {
        await _getStoredDeviceId();
      }

      final response = await Dio().put(
        url,
        data: {
          "phone": newPhoneNumber,
          "ph_country_code": _countryCode,
          "country": _countryName,
          "deviceId": _deviceId,
        },
        options: Options(headers: {
          "Content-Type": "application/json",
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Phone number updated successfully: ${response.data}");
        _phoneNumber = newPhoneNumber;
        _apiResponse = "Phone updated: ${response.data}";
        notifyListeners();
      } else {
        print(
            "⚠️ Failed to update phone: ${response.statusCode} - ${response.data}");
        _apiResponse = "Error: ${response.data}";
      }
    } catch (e) {
      print("❌ Exception while updating phone: $e");
      _apiResponse = "Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
