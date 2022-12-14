import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:advanceproassesment/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:google_fonts/google_fonts.dart';
class UserDetails extends StatefulWidget {
  final String username;


  UserDetails({Key? key, required this.username})
      : super(key: key);
  @override
  _UserDetails createState() => _UserDetails();
}

class _UserDetails extends State<UserDetails> {


  signout() async {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) =>  MyHomePage()),
      ModalRoute.withName('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
                'assets/food-icons-fast-food-drinks-rolls-flat-style_1284-44066.jpg'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [

                      Text("Logged in User is " + widget.username),
                      SizedBox(
                        width: 120,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.teal,
                                shape: StadiumBorder(),
                                onSurface: Colors.indigo),
                            onPressed: () {
                              signout();
                            },
                            child: Text("Go Back", style: TextStyle(color: Colors.white),),
                          ),
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
    );
  }
}