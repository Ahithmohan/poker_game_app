import 'package:flutter/material.dart';
import 'package:pokerpad/provider/profile_country_provider.dart';
import 'package:provider/provider.dart';

import '../model/login_response_model.dart';
import '../widget/build_text_widget.dart';

class ProfilePhoneNumber extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  const ProfilePhoneNumber({super.key, this.playerResponse});

  @override
  State<ProfilePhoneNumber> createState() => _ProfilePhoneNumberState();
}

class _ProfilePhoneNumberState extends State<ProfilePhoneNumber> {
  late TextEditingController phoneController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController = TextEditingController(
        // text: widget.playerResponse?.data?.phone ?? '',
        );
    print(widget.playerResponse?.data?.phone);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final countryProvider = Provider.of<ProfileCountryProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                width: width / 1.4,
                height: height / 1.6,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/images/phonenumbpopupassets/phone_number_bg.png"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const BuildTextWidget(
                      text: "Phone Number",
                      fontSize: 23,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 30),
                    Image.asset(
                        "assets/images/phonenumbpopupassets/phone_icon.png"),
                    const SizedBox(height: 60),
                    SizedBox(
                      width: width / 1.7,
                      height: 50,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              countryProvider.resetFilteredCountries();
                              Future.delayed(const Duration(milliseconds: 300),
                                  () {
                                _showCountryPicker(context);
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              height: 55,
                              width: 110,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/phonenumbpopupassets/country_selection.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    countryProvider.countryFlag,
                                    width: 33,
                                    height: 33,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    countryProvider.countryCode,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/phonenumbpopupassets/number_field.png"),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                controller: phoneController,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: "Phone Number",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: width / 1.9,
                      height: 40,
                      child: countryProvider.errorMessage != null
                          ? Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/verifyemail/alert frame.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  countryProvider.errorMessage!,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (countryProvider.validatePhoneNumber()) {
                          await countryProvider.sentPhoneNumber(context);
                        }
                        final trimmedPhone = phoneController.text.trim();
                        countryProvider.updatePhoneNumber(trimmedPhone);
                      },
                      child: Image.asset(
                        width: width / 1.8,
                        fit: BoxFit.cover,
                        "assets/images/phonenumbpopupassets/confirm_button_black.png",
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final countryProvider =
        Provider.of<ProfileCountryProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.topCenter, // Moves the dialog to the top

          child: Material(
            color: Colors.transparent,
            child: Container(
              width: width,
              // / 1.3,
              height: height / 1.02,
              decoration: const BoxDecoration(
                // color: Colors.red,
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/phonenumbpopupassets/1st_level.png"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  const BuildTextWidget(
                    text: "Country Code",
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),

                  // Search Field
                  SizedBox(
                    width: width / 1.4,
                    height: 55,
                    child: Container(
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                              "assets/images/phonenumbpopupassets/countru_search_field.png"),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.text,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: "Enter country name",
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(14),
                        ),
                        onChanged: countryProvider.searchCountry,
                      ),
                    ),
                  ),

                  // List of Countries
                  Container(
                    width: width / 1.4,
                    height: height / 1.33,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/phonenumbpopupassets/2nd_lavel.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Consumer<ProfileCountryProvider>(
                      builder: (context, provider, child) {
                        return provider.filteredCountries.isEmpty
                            ? const Center(
                                child: Text("No Results Found",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey)))
                            : Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: provider.filteredCountries.length,
                                  itemBuilder: (context, index) {
                                    final country =
                                        provider.filteredCountries[index];
                                    return ListTile(
                                      contentPadding: const EdgeInsets.all(5),
                                      leading: Container(
                                        width: 68,
                                        height: 68,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/phonenumbpopupassets/flag_field.png"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            country.flag,
                                            width: 45,
                                            height: 45,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        country.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      trailing: Text(
                                        country.dialCode,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                      onTap: () {
                                        provider.selectCountry(country);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
