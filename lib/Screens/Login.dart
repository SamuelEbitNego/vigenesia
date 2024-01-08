import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import 'MainScreens.dart';
import '../Constant/const.dart';
import '../Models/Login_Model.dart';
import 'Register.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with WidgetsBindingObserver {
  //Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  String? nama;
  String? iduser;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Future<LoginModels?> postLogin(String email, String password) async {
    var dio = Dio();
    LoginModels? model;

    Map<String, dynamic> data = {"email": email, "password": password};
    print("https://72d6-223-255-230-10.ngrok-free.app/vigenesia/api/login");
    try {
      final response = await dio.post(
          "https://72d6-223-255-230-10.ngrok-free.app/vigenesia/api/login",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));

      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        model = LoginModels.fromJson(response.data);
      }
    } catch (e) {
      print("Failed to load $e");
    }

    return model;
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(left: 0, right: 0),
        decoration: new BoxDecoration(color: Colors.blueGrey),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "VIGENESIA",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w500,
                color: Colors.lightGreenAccent),
          ),
          Text(
            "Visi Generasi Indonesia",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.lightGreenAccent,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 50),
          Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.only(left: 0, right: 0),
              child: Form(
                key: _fbKey,
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  margin: const EdgeInsets.only(
                      top: 20, left: 50.0, right: 50.0, bottom: 20),
                  child: Column(
                    children: [
                      Image.asset(
                        '../assets/logo.png',
                        width: 100,
                        height: 100,
                      ),
                      Text(
                        "LOGIN",
                        style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87),
                      ),
                      SizedBox(height: 20),
                      FormBuilderTextField(
                          name: "email",
                          cursorColor: Colors.black12,
                          controller: emailController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 0.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              borderSide:
                                  BorderSide(color: Colors.red, width: 1.0),
                            ),
                            labelStyle: TextStyle(color: Colors.black87),
                            labelText: "Email",
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      FormBuilderTextField(
                        obscureText: true,
                        name: "password",
                        controller: passwordController,
                        cursorColor: Colors.black12,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 1.0),
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(color: Colors.black87),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.blueAccent),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            onPressed: () async {
                              await postLogin(emailController.text,
                                      passwordController.text)
                                  .then((value) => {
                                        if (value != null)
                                          {
                                            setState(() {
                                              nama = value.data!.nama;
                                              iduser = value.data!.iduser;
                                              Navigator.pushReplacement(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          new MainScreens(
                                                              nama: nama!,
                                                              iduser:
                                                                  iduser!)));
                                            })
                                          }
                                      });
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: 'Dont Have an Account ? ',
                              style: TextStyle(color: Colors.black54)),
                          TextSpan(
                              text: 'Sign Up',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              new Register()));
                                },
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54))
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 50),
        ]),
      ),
    ));
  }
}
