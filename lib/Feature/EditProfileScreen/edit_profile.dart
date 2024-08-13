import 'package:flutter/material.dart';
import 'package:my_contact/Feature/HomeScreen/model/view_model_api_profile.dart';
import 'package:my_contact/Screen/Widget/Style/model_style.dart';

// MUHAMMAD SYAHMI BIN SAMURI
// https://github.com/syahmisenpai97/
// www.linkedin.com/in/muhdsyahmisamuri

class EditProfileUI extends StatefulWidget {
  final ViewModelApiProfile profile;

  const EditProfileUI({Key? key, required this.profile}) : super(key: key);

  @override
  _EditProfileUIState createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ViewModelApiProfile profileData = widget.profile;

    firstNameController.text = profileData.firstName;
    lastNameController.text = profileData.lastName;
    emailController.text = profileData.email;
    String avatar = profileData.avatar;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ModelStyle.bgGreen,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Edit Profile",
          style: ModelStyle.defaultAppBarTextStyle,
        ),
        toolbarHeight: 80,
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 20,
          left: 20,
          right: 15,
        ),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(color: ModelStyle.bgGreen, width: 4),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                          )
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(avatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: ModelStyle.bgGreen),
                            color: ModelStyle.bgGreen,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              buildTextField(firstNameController, "First Name"),
              buildTextField(lastNameController, "Last Name"),
              buildTextField(emailController, "Email"),
              saveChangesButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String textHint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: const BorderSide(
              color: Color(0xFF32BAA5),
              width: 2,
            ),
          ),
          labelText: textHint,
          labelStyle: const TextStyle(
            color: Color(0xFF32BAA5),
            fontWeight: FontWeight.w400,
            fontSize: 14,
            fontFamily: 'Montserrat',
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 24, 0, 24),
        ),
        controller: controller, // Use the provided controller
      ),
    );
  }

  Widget saveChangesButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 10, right: 10, top: 24),
      child: ElevatedButton(
        onPressed: () {
          final updatedProfile = ViewModelApiProfile(
            id: widget.profile.id,
            firstName: firstNameController.text,
            lastName: lastNameController.text,
            email: emailController.text,
            avatar: widget.profile.avatar,
          );

          Navigator.of(context).pop(updatedProfile);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ModelStyle.bgGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          minimumSize: const Size(349, 50),
        ),
        child: const Text(
          'Save Changes',
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
