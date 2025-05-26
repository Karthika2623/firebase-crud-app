import 'package:firebase_crud_app/screens/create_user_page.dart';
import 'package:firebase_crud_app/screens/database_methods.dart';
import 'package:firebase_crud_app/screens/textformfields.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController age = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController location = TextEditingController();

  Stream? employeeStream;

  @override
  void initState() {
    super.initState();
    getEmployeeData();
  }

  Future<void> getEmployeeData() async {
    employeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
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

  Widget allEmployeeDetails(double width) {
    return StreamBuilder(
      stream: employeeStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.orange,
                          child: Text(
                            ds["Name"][0],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 22),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            ds["Name"],
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            name.text = ds["Name"];
                            age.text = ds["Age"];
                            email.text = ds["Email"];
                            phone.text = ds["Phone"];
                            location.text = ds["Location"];
                            editEmployeeDetails(ds["Id"]);
                          },
                          icon: const Icon(Icons.edit, color: Colors.blue),
                        ),
                        IconButton(
                          onPressed: () async {
                            await DatabaseMethods()
                                .deleteEmployeeDetails(ds["Id"]);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                    const Divider(),
                    buildTextRow("Age: ${ds["Age"]}", Colors.black87),
                    buildTextRow("Email: ${ds["Email"]}", Colors.black87),
                    buildTextRow("Phone: ${ds["Phone"]}", Colors.black87),
                    buildTextRow("Location: ${ds["Location"]}", Colors.black87),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildTextRow(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          const Icon(Icons.arrow_right,
              size: 25, color: Color.fromARGB(255, 71, 70, 70)),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.0, color: color),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Employee ',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Details',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, size: 30, color: Colors.black),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateUserPage()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: width * 0.08),
        child: Column(
          children: [Expanded(child: allEmployeeDetails(width))],
        ),
      ),
    );
  }

  Future editEmployeeDetails(String id) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.edit, size: 24, color: Colors.blue),
                    SizedBox(width: 10),
                    Text('Edit Details',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 20.0),
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
                    ]),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (!_validateInputs()) return;
                      Map<String, dynamic> updateInfo = {
                        "Name": name.text.trim(),
                        "Age": age.text.trim(),
                        "Email": email.text.trim(),
                        "Phone": phone.text.trim(),
                        "Id": id,
                        "Location": location.text.trim()
                      };
                      await DatabaseMethods()
                          .updateEmployeeDetails(id, updateInfo);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.update),
                    label: const Text('Update'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
