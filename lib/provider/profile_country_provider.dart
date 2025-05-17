import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/signup_controller.dart';
import '../model/country_list.dart';
import 'login_provider.dart';

class ProfileCountryProvider extends ChangeNotifier {
  String? errorMessage;
  String _countryCode = "+1"; // Default country code
  String _countryFlag =
      "assets/images/Country Flags/United_States_of_America_1.png"; // Default flag
  String _phoneNumber = ""; // Store entered phone number
  String _countryName = "United States of America";
  String _deviceId = "Fetching..."; // Default value
  bool _isLoading = false;
  String? _apiResponse;
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

  Future<void> _getStoredDeviceId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? storedDeviceId = pref.getString("device_id");

    _deviceId = storedDeviceId ?? "No Device ID Found";
    notifyListeners(); // Update UI
    print("Updated Device ID: $_deviceId");
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
    final id = loginProvider.playerId;

    if (id == null) {
      print("❌ Invalid Player ID");
      _apiResponse = "Invalid Player ID";
      notifyListeners();
      return;
    }

    final String url = "http://3.6.170.253:1080/server.php/api/v1/players/$id";
    print("🔗 API URL: $url");

    _isLoading = true;
    notifyListeners();

    try {
      // Make sure deviceId is loaded
      if (_deviceId == "Fetching...") {
        await _getStoredDeviceId();
      }

      // Make sure phone number is set (e.g. from text field)
      if (_phoneNumber.isEmpty) {
        print("⚠️ Phone number is empty. Aborting.");
        _apiResponse = "Phone number is empty";
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Send the API request
      final response = await Dio().put(
        url,
        data: {
          "phone": _phoneNumber,
          "ph_country_code": _countryCode,
          "country": _countryName,
          "profile": 1,
          "deviceId": _deviceId
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
        ),
      );
      print(response);
      if (response.statusCode == 200) {
        print("✅ API Success: ${response.data}");
        _apiResponse = "Success: ${response.data}";
        Navigator.pop(context); // Close the dialog
      } else {
        print("⚠️ API Error: ${response.statusCode} - ${response.data}");
        _apiResponse = "Error: ${response.statusCode} - ${response.data}";
      }
    } catch (e) {
      print("❌ API Request Failed: $e");
      _apiResponse = "Exception: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
