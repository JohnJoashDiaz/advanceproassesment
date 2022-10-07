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
            image: NetworkImage(
                'https://img.freepik.com/free-vector/food-icons-fast-food-drinks-rolls-flat-style_1284-44066.jpg?w=2000'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text("Logged in User is " + widget.username),
                        Container(
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