import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/controller/name_controller.dart';
import 'package:pokerpad/model/name_request_model.dart';
import 'package:pokerpad/model/name_response_model.dart';
import 'package:pokerpad/view/phone_number_page.dart';

import '../constants/screen_size.dart';
import '../widget/build_text_widget.dart';

class NamePage extends StatefulWidget {
  const NamePage({super.key});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  String? _errorText;
  final TextEditingController nameController = TextEditingController();
  bool isLoading = false;
  final NameController _nameController = NameController();
  Future<void> playerName() async {
    setState(() {
      isLoading = true;
      _errorText = null;
    });

    try {
      if (nameController.text.isEmpty) {
        setState(() {
          _errorText = "Please enter a nickname";
        });
        return; // Stop execution here
      }

      NameRequestModel request =
          NameRequestModel(nickname: nameController.text, deviceId: 1);
      NameResponseModel? response =
          await _nameController.getName(request, context);

      if (response?.status == "OK") {
        print("Step:${response?.data?.step}");

        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     duration: const Duration(milliseconds: 350),
        //     content: Text(response!.status)));
        Navigator.push(
            context,
            PageTransition(
                child: const PhoneNumberPage(),
                type: PageTransitionType.rightToLeftWithFade));
      } else {
        setState(() {
          _errorText = response?.messages?["common"] ??
              "This nickname already exist. choose another one";
        });
        print(response?.status);
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('An error occurred: $e'),
      //     duration: const Duration(milliseconds: 400),
      //   ),
      // );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: ScreenSize.screenHeight,
            width: ScreenSize.screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: width,
            height: height / 1.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/images/phone&country/log-reg frame.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const BuildTextWidget(
                    text: "Choose Your Nickname",
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black54,
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Image.asset("assets/images/nickname/nickname icon.png"),
                  const SizedBox(
                    height: 80,
                  ),
                  SizedBox(
                    width: width / 1.39,
                    height: 60,
                    child: Container(
                      width: width / 1.5,
                      height: 50,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                              "assets/images/phone&country/country text field.png"),
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "nick name",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 16),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        // validator: (value) {
                        //   if (value == null || value.trim().length < 4) {
                        //     return "Name must be at least 4 characters long";
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: width / 1.4,
                    height: 50, // Ensuring consistent height
                    child: _errorText != null
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
                                _errorText!,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        : const SizedBox(), // Empty SizedBox maintains the height
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? const CircularProgressIndicator()
                      : GestureDetector(
                          onTap: () {
                            print("clicked");
                            playerName();
                          },
                          child: SizedBox(
                            width: width / 1.39,
                            child: Image.asset(
                                "assets/images/phone&country/confirm button (1).png"),
                          ),
                        ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
