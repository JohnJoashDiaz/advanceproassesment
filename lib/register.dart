import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:advanceproassesment/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final usernametextcontroller = TextEditingController();
  final passwordtextcontroller = TextEditingController();
  final firstnamecontroller = TextEditingController();
  final lastnamecontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loadingstatus = false;
  bool _showPassword = false;

  void register() async {
    String username = usernametextcontroller.text;
    String userpassword = passwordtextcontroller.text;
    String firstname = firstnamecontroller.text;
    String lastname = lastnamecontroller.text;
    try {
      var postresponse = await post(
          Uri.http('uslsthesisapi.herokuapp.com', '/register'),
          body: {
            'username': username,
            'password': userpassword,
            'first_name': firstname,
            'last_name': lastname
          }).timeout(const Duration(seconds: 10));
      var response = json.decode(postresponse.body);
      if (postresponse.statusCode == 200) {
        if (response == "SameUsername") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Container(
              height: 15,
              child: Row(
                children: const [
                  Text('Existing User'),
                ],
              ),
            ),
          ));
          setState(() {
            loadingstatus = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.lightGreen,
            content: Container(
              height: 15,
              child: Row(
                children: const [
                  Text('User has been created'),
                ],
              ),
            ),
          ));
          setState(() {
            loadingstatus = false;
          });
        }
      }
    } on TimeoutException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.deepOrange,
        content: Container(
          height: 15,
          child: Row(
            children: const [
              Text('API Error, Please Check Internet Connection'),
            ],
          ),
        ),
      ));
      setState(() {
        loadingstatus = false;
      });
    }
  }

  void gobacktoLogin() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyApp()))
        .then((value) => setState(() {}));
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(body: RegisterScreen(context)),
    );
  }

  @override
  Widget RegisterScreen(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                'https://img.freepik.com/free-vector/food-icons-fast-food-drinks-rolls-flat-style_1284-44066.jpg?w=2000'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Username",
                              style: GoogleFonts.openSans(fontSize: 15)),
                        ),
                        TextFormField(
                            controller: usernametextcontroller,
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueGrey)),
                              labelText: 'Enter your Username here',
                              prefixIcon: Icon(Icons.person_outline_rounded),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                            }),
                        SizedBox(height: 5),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Password",
                              style: GoogleFonts.openSans(fontSize: 15)),
                        ),
                        TextFormField(
                            controller: passwordtextcontroller,
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 3, color: Colors.blueGrey)),
                                labelText: 'Enter your Password here',
                                prefixIcon: Icon(Icons.lock_outline_rounded),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                  child: Icon(
                                    _showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                )),
                            obscureText: !_showPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                            }),
                        const SizedBox(
                          height: 16.0,
                        ),
                        TextFormField(
                            controller: firstnamecontroller,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueGrey)),
                              labelText: 'Enter your First Name ',
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                            ),
                            obscureText: !_showPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                            }),
                        SizedBox(height: 5),
                        TextFormField(
                            controller: lastnamecontroller,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 3, color: Colors.blueGrey)),
                              labelText: 'Enter your Last Name ',
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                            ),
                            obscureText: !_showPassword,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                            }),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: OutlinedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.teal,
                                  shape: StadiumBorder(),
                                  onSurface: Colors.indigo),
                              child: loadingstatus
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                                color: Colors.white)),
                                        const SizedBox(width: 24),
                                        Text("Creating User...",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    )
                                  : Text(
                                      'Register User',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              onPressed: !loadingstatus
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        register();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        if (loadingstatus == false)
                                          return setState(
                                              () => loadingstatus = true);
                                      }
                                    }
                                  : null),
                        ),
                        Divider(
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                          color: Colors.deepPurple,
                          height: 15,
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                                shape: StadiumBorder(),
                                onSurface: Colors.indigo),
                            onPressed: () {
                              gobacktoLogin();
                            },
                            child: Text("Go Back"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
