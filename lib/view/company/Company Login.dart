import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/request_controller.dart';
import '../../models/company.dart';
import '../../models/user.dart';
import '../user/forget_password.dart';
import '../widget/login_role.dart';
import '../widget/register_role.dart';
import 'CompanyHome_Navi.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto/crypto.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:art_sweetalert/art_sweetalert.dart';

class CompanyLogin extends StatefulWidget {
  const CompanyLogin({super.key});

  @override
  State<CompanyLogin> createState() => _CompanyLoginState();
}

class _CompanyLoginState extends State<CompanyLogin> {

  /**
   * Variables
   * 1. _password -> for Show/Hide password
   */
  bool _password = false;

  /**
   * This is the function to show and hide password
   */
  void togglePassword()
  {
    setState(() {
      _password = !_password;
    });
  }

  /**
   * Variables for controlling text fields
   */
  User user = User(0, "", "", "", "", "Company", "",
      Company(0, "", "", "", "", "", "", ""), "");
  TextEditingController usernameTextCtrl = TextEditingController();
  TextEditingController passwordTextCtrl = TextEditingController();

  /**
   * The localhost for emulator is 10.0.2.2
   * which is totally different with MySQL
   *
   * default url api to request web service for login
   */

  /**
   * User login web service function
   */
  Future login() async{

    /**
     * validation
     */
    if(usernameTextCtrl.text == "" || passwordTextCtrl.text == ""){

      ArtSweetAlert.show(
          context: context,
          artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "EMPTY INPUT!",
            text: "Both text fields cannot be blank!",
          )
      );

    }
    else {
      /**
       * Here we request web service using URL API
       * for login module
       */
      final prefs = await SharedPreferences.getInstance();
      String? server = prefs.getString("localhost");
      WebRequestController req = WebRequestController(path: "/inployed/user/companyLogin",
          server: "http://$server:8080");

      req.setBody(
          {
            'username': usernameTextCtrl.text,
            'userPassword':  md5.convert(utf8.encode(passwordTextCtrl.text)).toString(),
          }
      );

      await req.post();
      print(req.result());


      /**
       * if HTTP response status code = 200, means OK
       * it will let user login successfully
       * and navigate to HomeNavi()
       */
      if (req.status() == 200) {
        // Successful login
        final userData = req.result();
        var id = userData["userId"];
        var company = userData["company"]["companyID"];
        String usertype = userData["userType"];

        await prefs.setString("loggedUsername", usernameTextCtrl.text);
        await prefs.setInt("company", company);
        await prefs.setInt("loggedUserId", id);
        await prefs.setString("usertype", usertype);

        print(id);
        OneSignal.login(id.toString());

        // Handle the user data as needed
        // For example, you can navigate to the home screen or save user details to the app state.
        Fluttertoast.showToast(
          msg: 'Login Successfully！ Welcome! ${usernameTextCtrl.text}',
          backgroundColor: Colors.white,
          textColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          fontSize: 16.0,
        );

        String loggedUsername = usernameTextCtrl.text;
        print("External id: ${id.toString()}");

        // clear the text field
        usernameTextCtrl.clear();
        passwordTextCtrl.clear();

        // navigate to HomeNavi() screen
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => CompanyHomeNavi(
                username: loggedUsername, id: id, tabIndexes: 0, company: company,
              ),
            ), (route) => false);

      }
      else if(req.status() == 401){
        //final errorMessage = json.decode(response.body);
        ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
              type: ArtSweetAlertType.danger,
              title: "INVALID EMAIL OR PASSWORD",
              text: "Wrong combination of user email and password",
            )
        );
        // Display the error message to the user
      }
      else{
        Fluttertoast.showToast(
          msg: 'Error',
          backgroundColor: Colors.white,
          textColor: Colors.red,
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        height: double.infinity,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          // set the background color of the container to be gradient
          gradient: LinearGradient(
            // determine the direction and angle of each color stop in gradient
            begin: Alignment.topRight,
            end: Alignment.bottomRight,

            /**
             * 0xFF is needed to convert RGB Hex code to int value
                Hex code here is 29539B and 1E3B70
                Gradient Name: Unloved Teen
             */
            colors: [
              Color.fromRGBO(249, 151, 119, 1),
              Color.fromRGBO(98, 58, 162, 1),// #a6c1ee
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    /**
                     * Illustration
                     */
                    Image.asset("images/login01.png",
                      height: 250, width: 160,),

                    //Spacing
                    SizedBox(width: 20),

                    /**
                     * Title
                     */
                    Column(
                      children: [
                        Text("COMPANY",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 35, color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF545454),
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            )),
                        Text("LOGIN",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 35, color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF545454),
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 4.0,
                                ),
                              ],
                            )),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Center(
                      /**
                       * Create a region box for login form
                       */
                      child: Expanded(
                        child: Container(
                            padding: EdgeInsets.all(20),
                            height: 450,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.center,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFFF3F3F3), Color(0xFFC8C8C8)],
                                ),
                                borderRadius: BorderRadius.circular(15)
                            ),

                            child: Column(
                              children: [
                                /**
                                 * The Username Field
                                 */
                                TextField(
                                  controller: usernameTextCtrl,
                                  decoration: InputDecoration(
                                    //errorText: 'Please enter a valid value',
                                      prefixIcon: Icon(Icons.person),
                                      filled: true,
                                      fillColor: Colors.white70,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: "Enter your username",
                                      hintStyle: GoogleFonts.poppins(
                                          fontSize: 15, fontWeight: FontWeight.bold
                                      ),
                                      labelText: "Enter your username",
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: 15,
                                      )
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontSize: 15
                                  ),

                                ),

                                SizedBox(height: 20),

                                /**
                                 * The Password Field
                                 */
                                TextField(
                                  // Hide text when _password is false
                                  obscureText: !_password,
                                  controller: passwordTextCtrl,
                                  decoration: InputDecoration(
                                    //errorText: 'Please enter a valid value',
                                      filled: true,
                                      fillColor: Colors.white70,
                                      prefixIcon: Icon(Icons.lock),
                                      suffixIcon: Tooltip(
                                        message: _password ? 'Hide Password' : 'Show Password',
                                        child: IconButton(
                                          onPressed: togglePassword,
                                          icon: Icon(_password
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide.none,
                                      ),
                                      hintText: "Enter your password",
                                      hintStyle: GoogleFonts.poppins(
                                          fontSize: 15, fontWeight: FontWeight.bold
                                      ),
                                      labelText: "Enter your password",
                                      labelStyle: GoogleFonts.poppins(
                                        fontSize: 15,
                                      )
                                  ),
                                  style: GoogleFonts.poppins(
                                      fontSize: 15
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Forget Password?",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black, fontSize: 15
                                        )
                                    ),
                                    TextButton(onPressed: (){
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context)
                                          => ForgetPassword(usertypePassed: "Company",)));
                                    }, child: Text("Reset here",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black, fontSize: 15
                                      ),),
                                    ),
                                  ],
                                ),



                                SizedBox(height: 20),

                                /**
                                 * Login button
                                 */
                                InkWell(
                                  onTap: ()
                                  {
                                    /**
                                     * Navigate to login() function
                                     * for web service request
                                     */
                                    login();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [ Color.fromRGBO(249, 151, 119, 1),
                                            Color.fromRGBO(98, 58, 162, 1),]
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF1f1f1f), // Shadow color
                                          offset: Offset(0, 2), // Offset of the shadow
                                          blurRadius: 4, // Spread of the shadow
                                          spreadRadius: 0, // Spread radius of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                          "Login",
                                          style: GoogleFonts.poppins(
                                              fontSize: 20, color: Colors.white,
                                              fontWeight: FontWeight.w600
                                          )),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                InkWell(
                                  onTap: ()
                                  {
                                    /**
                                     * Navigate to login() function
                                     * for web service request
                                     */
                                    Navigator.push(context, MaterialPageRoute(builder:
                                        (context) => UserRole())
                                    );
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0xFF1f1f1f), // Shadow color
                                          offset: Offset(0, 2), // Offset of the shadow
                                          blurRadius: 4, // Spread of the shadow
                                          spreadRadius: 0, // Spread radius of the shadow
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                          "Change Role",
                                          style: GoogleFonts.poppins(
                                              fontSize: 20, color: Colors.black,
                                              fontWeight: FontWeight.w600
                                          )),
                                    ),
                                  ),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("No account yet?",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black
                                        )),
                                    TextButton(onPressed: (){
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context)
                                          => UserRegisterRole()));
                                    }, child: Text("Create an account?",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),),
                                    ),
                                  ],
                                ),

                              ],
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
