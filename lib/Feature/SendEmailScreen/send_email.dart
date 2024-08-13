import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:my_contact/Feature/HomeScreen/model/view_model_api_profile.dart';
import 'package:my_contact/Screen/Widget/Style/model_style.dart';
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

// MUHAMMAD SYAHMI BIN SAMURI
// https://github.com/syahmisenpai97/
// www.linkedin.com/in/muhdsyahmisamuri

class SendEmailUI extends StatefulWidget {
  ViewModelApiProfile profile;
  final bool favorite;

  SendEmailUI({Key? key, required this.profile, required this.favorite})
      : super(key: key);

  @override
  _SendEmailUIState createState() => _SendEmailUIState();
}

class _SendEmailUIState extends State<SendEmailUI> {
  void navigateToEditProfile(
      BuildContext context, ViewModelApiProfile profileData) async {
    final updatedData = await context.push<ViewModelApiProfile>(
      '/edit_profile',
      extra: profileData,
    );

    if (updatedData != null) {
      widget.profile = updatedData;
    }
  }

  void sendEmail() async {
    final email = widget.profile.email;
    const subject = 'Subject of your email';
    const body = 'Body of your email';
    final mailtoLink =
        'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    final uri = Uri.parse(mailtoLink);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      log('Could not launch email');
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileData = widget.profile;
    final isFavorite = widget.favorite;

    final firstName = profileData.firstName;
    final lastName = profileData.lastName;
    final email = profileData.email;
    final avatar = profileData.avatar;
    final fullName = "$firstName $lastName";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ModelStyle.bgGreen,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, widget.profile);
          },
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontSize: 17,
          ),
        ),
        toolbarHeight: 80,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigateToEditProfile(context, profileData);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 40, top: 15),
                        child: Text(
                          'Edit',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: ModelStyle.bgGreen, width: 4),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(avatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (isFavorite) const ShowFavouriteIcon(),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: const Color.fromARGB(255, 133, 129, 129),
                        height: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.email,
                              color: Colors.white,
                              size: 30,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              email,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                saveChangesButton()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget saveChangesButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10, top: 24),
      child: ElevatedButton(
        onPressed: () {
          sendEmail();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ModelStyle.bgGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          minimumSize: const Size(349, 50),
        ),
        child: const Text(
          'Send Email',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            fontFamily: 'Raleway',
          ),
        ),
      ),
    );
  }
}

class ShowFavouriteIcon extends StatelessWidget {
  const ShowFavouriteIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      bottom: 0,
      right: 0,
      child: SizedBox(
        height: 35,
        width: 35,
        child: Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      ),
    );
  }
}
