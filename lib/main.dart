import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:advanceproassesment/home.dart';
import 'package:advanceproassesment/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff272D66),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final usernametextcontroller = TextEditingController();
  final passwordtextcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loadingstatus = false;
  bool _showPassword = false;

  void login() async {
    String username = usernametextcontroller.text;
    String userpassword = passwordtextcontroller.text;
    try {
      var postresponse = await post(
              Uri.http('uslsthesisapi.herokuapp.com', '/login'),
              body: {'username': username, 'password': userpassword})
          .timeout(const Duration(seconds: 10));
      var response = json.decode(postresponse.body);
      if (postresponse.statusCode == 200) {
        if (response == "Failed") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Container(
              height: 15,
              child: Row(
                children: const [
                  Text('Wrong Username or Password'),
                ],
              ),
            ),
          ));
          setState(() {
            loadingstatus = false;
          });
        } else if (response == 'No such User') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.deepOrange,
            content: Container(
              height: 15,
              child: Row(
                children: const [
                  Text('No such username exists'),
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
                  Text('Login Successful'),
                ],
              ),
            ),
          ));
          setState(() {
            loadingstatus = false;
          });
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) =>  UserDetails(username: username)),
            ModalRoute.withName('/'),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.deepOrange,
          content: Container(
            height: 15,
            child: Row(
              children: const [
                Text('Error'),
              ],
            ),
          ),
        ));
        setState(() {
          loadingstatus = false;
        });
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
    } on SocketException catch (_) {
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

  void gotoRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 960) {
            return webview(context);
          }
          return LoginScreen(context);
        },
      )),
    );
  }

  @override
  Widget LoginScreen(BuildContext context) {
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
          alignment: Alignment.bottomCenter,
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 20),
                              Image.asset("assets/clipart4729970.png",height: 170,width: 300),
                              Text("PudPanda",style: GoogleFonts.openSans(),),
                              Text("You Eat, We Deliver"),
                            SizedBox(height: 10,)
                            ],
                          ),
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
                                return 'Please Enter your Username';
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
                                return 'Please Enter Password';
                              }
                            }),
                        const SizedBox(
                          height: 16.0,
                        ),
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
                                        Text("Logging in..",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600))
                                      ],
                                    )
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              onPressed: !loadingstatus
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        login();
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
                        Text("Don't Have an Account?"),
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
                              gotoRegister();
                            },
                            child: Text("Register Now",style: TextStyle(color:Colors.white),),
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

  Widget webview(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
                'assets/food-icons-fast-food-drinks-rolls-flat-style_1284-44066.jpg'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.all(Radius.circular(40))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 400,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                      height: 5),
                                  Image.asset("assets/clipart4729970.png",height: 120,width: 300),
                                  Text("PudPanda",style: GoogleFonts.openSans(),),
                                  Text("You Eat, We Deliver"),
                                  SizedBox(height: 10,)
                                ],
                              ),
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
                                    prefixIcon:
                                        Icon(Icons.person_outline_rounded),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter your Username';
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
                                              width: 3,
                                              color: Colors.blueGrey)),
                                      labelText: 'Enter your Password here',
                                      prefixIcon:
                                          Icon(Icons.lock_outline_rounded),
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
                                      return 'Please Enter Password';
                                    }
                                  }),
                              const SizedBox(
                                height: 16.0,
                              ),
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
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors.white)),
                                              const SizedBox(width: 24),
                                              Text("Logging in..",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600))
                                            ],
                                          )
                                        : Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                    onPressed: !loadingstatus
                                        ? () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              login();
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
                              Text("Don't Have an Account?"),
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
                                    gotoRegister();
                                  },
                                  child: Text("Register Now", style: TextStyle(color: Colors.white),),
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
            ],
          ),
        ),
      ),
    );
  }
}
