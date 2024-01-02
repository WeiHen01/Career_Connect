import 'dart:io';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';
import 'adminhome_navi.dart';

class AdminEdit extends StatefulWidget {
  const AdminEdit({required this.id});
  final int id;

  @override
  State<AdminEdit> createState() => _AdminEditState();
}

class _AdminEditState extends State<AdminEdit> {

  User? _user;
  int id = 0;
  int adminId = 0;
  String username = "", email = "",
      phone = "", position = "", password = "";

  final TextEditingController usernamectrl = TextEditingController();
  final TextEditingController emailctrl = TextEditingController();
  final TextEditingController positionctrl = TextEditingController();
  final TextEditingController passwordctrl = TextEditingController();

  /**
   * Function to display account information
   * based on username passed from Login page
   */
  Future<void> getUser() async {

    final response = await http.get(Uri.parse(''
        'http://10.0.2.2:8080/inployed/user/account/adminId/${widget.id}'));

    if (response.statusCode == 200) {

      // Parse the JSON response into a `User` object.
      final user = User.fromJson(jsonDecode(response.body));

      setState(() {
        _user = user;
        username = user.username;
        email = user.userEmail;
        position = user.userPosition;
        password = user.password;

      });
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  ImagePicker picker = ImagePicker();
  File? _image;

  /// Get from gallery
  _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> updateAdminAccount() async{

    /**
     * optionally update only the text field is not null
     */
    Map<String, dynamic> requestBody = {};

    if (usernamectrl.text != null && usernamectrl.text.isNotEmpty) {
      requestBody["username"] = usernamectrl.text;
      username = usernamectrl.text;
    }

    if (emailctrl.text != null && emailctrl.text.isNotEmpty) {
      requestBody["userEmail"] = emailctrl.text;
      email = emailctrl.text;
    }

    if (positionctrl.text != null && positionctrl.text.isNotEmpty) {
      requestBody["userPosition"] = positionctrl.text;
      position = positionctrl.text;

    }

    if (passwordctrl.text != null && passwordctrl.text.isNotEmpty) {
      requestBody["userpassword"] = passwordctrl.text;
      password = passwordctrl.text;
    }

    final response = await http.put(Uri.parse("http://10.0.2.2:8080/inployed/user/updateAdmin/${widget.id}"),
      headers:{
        "Content-type":"Application/json"
      },

      body: jsonEncode(requestBody),
    );

    print(response.body);

    if(response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Update successfully',
        backgroundColor: Colors.white,
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16.0,
      );

      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder:
              (context) => AdminHomeNavi(username: username, userid: widget.id, tabIndexes: 3,)),
              (route) => false
      );
    }
    else{
      Fluttertoast.showToast(
        msg: 'Update failed!',
        backgroundColor: Colors.white,
        textColor: Colors.red,
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  //Color(0xFFFBC2EB), // #fbc2eb
                  //Color(0xFFA6C1EE), #a6c1ee
                  Color.fromRGBO(249, 151, 119, 1),
                  Color.fromRGBO(98, 58, 162, 1),
                ],
              )
          ),
        ),
        title: Text("Edit your profile", style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold, fontSize: 25,
        ),),
      ),
      body: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  //Color(0xFFFBC2EB), // #fbc2eb
                  //Color(0xFFA6C1EE), #a6c1ee
                  Color.fromRGBO(249, 151, 119, 1),
                  Color.fromRGBO(98, 58, 162, 1),
                ],
              )
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 130, height: 130, decoration: BoxDecoration(
                            border: Border.all(width: 4, color: Colors.white),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1)
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: _image == null
                                ? DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("images/avatar01.jpg")
                            )
                                : DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(_image!)
                            )
                        ),
                        ),
                        Positioned(
                            bottom: 0, right: 0,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: IconButton(onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text("Upload Image",style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold, fontSize: 25,
                                        ),),
                                        content: Text("Edit your image",style: GoogleFonts.poppins(
                                          fontSize: 18,
                                        ),),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              _getFromCamera();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(14),
                                              child: Text("Camera", style: GoogleFonts.poppins(
                                                fontSize: 15,
                                              ),),
                                            ),
                                          ),

                                          TextButton(
                                            onPressed: () {
                                              _getFromGallery();
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(14),
                                              child: Text("Gallery", style: GoogleFonts.poppins(
                                                fontSize: 15,
                                              ),),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }, icon: const Icon(Icons.photo_camera)),
                                ),


                              ],
                            )


                        )
                      ],
                    ),

                  ],
                ),

                SizedBox(height: 25,),


                Row(
                  children: [
                    Text("Username",style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 15,
                    ),),

                    SizedBox(width: 10,),

                    Expanded(
                      child: TextField(
                        // Hide text when _password is false
                        controller: usernamectrl,
                        decoration: InputDecoration(
                          //errorText: 'Please enter a valid value',
                            filled: true,
                            fillColor: Colors.white70,
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Set your new username",
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.bold
                            ),
                            labelText: "$username",
                            labelStyle: GoogleFonts.poppins(
                                fontSize: 15, color: Colors.black
                            )
                        ),
                        style: GoogleFonts.poppins(
                            fontSize: 15
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10,),

                Row(
                  children: [
                    Text("Email",style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 15,
                    ),),

                    SizedBox(width: 48,),

                    Expanded(
                      child: TextField(
                        // Hide text when _password is false
                        controller: emailctrl,
                        decoration: InputDecoration(
                          //errorText: 'Please enter a valid value',
                            filled: true,
                            fillColor: Colors.white70,
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Set your new email",
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.bold
                            ),
                            labelText: "$email",
                            labelStyle: GoogleFonts.poppins(
                                fontSize: 15, color: Colors.black
                            )
                        ),
                        style: GoogleFonts.poppins(
                            fontSize: 15
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10,),

                Row(
                  children: [
                    Text("Position",style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 15,
                    ),),

                    SizedBox(width: 28,),

                    Expanded(
                      child: TextField(
                        // Hide text when _password is false
                        controller: positionctrl,
                        decoration: InputDecoration(
                          //errorText: 'Please enter a valid value',
                            filled: true,
                            fillColor: Colors.white70,
                            prefixIcon: Icon(Icons.business_center),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Set your new position",
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.bold
                            ),
                            labelText: "$position",
                            labelStyle: GoogleFonts.poppins(
                                fontSize: 15, color: Colors.black
                            )
                        ),
                        style: GoogleFonts.poppins(
                            fontSize: 15
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10,),

                Row(
                  children: [
                    Text("Password",style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 15,
                    ),),

                    SizedBox(width: 15,),

                    Expanded(
                      child: TextField(
                        // Hide text when _password is false
                        controller: passwordctrl,
                        decoration: InputDecoration(
                          //errorText: 'Please enter a valid value',
                            filled: true,
                            fillColor: Colors.white70,
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Set your new password",
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 15, fontWeight: FontWeight.bold
                            ),
                            labelText: "$password",
                            labelStyle: GoogleFonts.poppins(
                                fontSize: 15, color: Colors.black
                            )
                        ),
                        style: GoogleFonts.poppins(
                            fontSize: 15
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 50,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: ()
                      {
                        /**
                         * Navigate to login() function
                         * for web service request
                         */
                        updateAdminAccount();

                      },
                      child: Container(
                        width: 120,
                        height: 40,
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
                              "Save",
                              style: GoogleFonts.poppins(
                                  fontSize: 20, color: Colors.white,
                                  fontWeight: FontWeight.w600
                              )),
                        ),
                      ),
                    ),

                    SizedBox(width: 10,),

                    InkWell(
                      onTap: ()
                      {
                        /**
                         * Navigate to login() function
                         * for web service request
                         */
                        Navigator.pop(context);

                      },
                      child: Container(
                        width: 120,
                        height: 40,
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
                              "Cancel",
                              style: GoogleFonts.poppins(
                                  fontSize: 20, color: Colors.black,
                                  fontWeight: FontWeight.w600
                              )),
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          )
      ),
    );
  }
}
