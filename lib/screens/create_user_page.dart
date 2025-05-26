import 'package:firebase_crud_app/screens/database_methods.dart';
import 'package:firebase_crud_app/screens/textformfields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:random_string/random_string.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController location = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  bool _validateInputs() {
    String nameText = name.text.trim();
    String ageText = age.text.trim();
    String emailText = email.text.trim();
    String phoneText = phone.text.trim();
    String locationText = location.text.trim();

    if (nameText.isEmpty ||
        ageText.isEmpty ||
        emailText.isEmpty ||
        phoneText.isEmpty ||
        locationText.isEmpty) {
      _showToast("Please fill all required fields");
      return false;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(nameText)) {
      _showToast("Name must contain only letters");
      return false;
    }

    if (!RegExp(r'^\d+$').hasMatch(ageText)) {
      _showToast("Age must contain only numbers");
      return false;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(phoneText)) {
      _showToast("Phone must be a 10-digit number");
      return false;
    }

    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(locationText)) {
      _showToast("Location must contain only letters");
      return false;
    }

    if (!emailText.contains('@') || !emailText.endsWith('.com')) {
      _showToast("Enter a valid email (must include '@' and end with '.com')");
      return false;
    }

    return true;
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
       appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Create ',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'User',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        child: Card(
          elevation: 8,
          // color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   child: Text(
                //     'Employee Details',
                //     style: TextStyle(
                //       fontSize: isSmallScreen ? 22 : 26,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.blueAccent,
                //     ),
                //   ),
                // ),
                // const Divider(height: 30, thickness: 1.2),
                CustomTextField(
                    controller: name,
                    label: 'Name',
                    icon: Icons.person,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                    ]),
                CustomTextField(
                    controller: age,
                    label: 'Age',
                    icon: Icons.cake,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
                CustomTextField(
                    controller: email,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress),
                CustomTextField(
                    controller: phone,
                    label: 'Phone',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly
                    ]),
                CustomTextField(
                    controller: location,
                    label: 'Location',
                    icon: Icons.location_on,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                    ],
                    ),
                SizedBox(height: screenHeight * 0.04),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (!_validateInputs()) return;

                      String id = randomAlphaNumeric(10);
                      Map<String, dynamic> employeeInfoMap = {
                        "Name": name.text.trim(),
                        "Age": age.text.trim(),
                        "Email": email.text.trim(),
                        "Phone": phone.text.trim(),
                        "Id": id,
                        "Location": location.text.trim(),
                      };

                      await DatabaseMethods()
                          .addEmployeeDetails(employeeInfoMap, id);

                      Fluttertoast.showToast(
                        msg: "Employee Details created successfully",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        fontSize: 18.0,
                      );

                      name.clear();
                      age.clear();
                      email.clear();
                      phone.clear();
                      location.clear();
                    },
                    icon:const Icon(Icons.save, color: Colors.white, size: 25.0),
                    label: Text('Create',
                        style: TextStyle(
                            fontSize: isSmallScreen ? 18 : 20,
                            color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.orange,
                      shadowColor: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
