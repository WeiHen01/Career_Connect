//import 'package:bitu3923_group05/view/admin/adminlogin.dart';
import 'package:bitu3923_group05/view/company/Company%20Login.dart';
import 'package:bitu3923_group05/view/widget/register_role.dart';
import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

import '../admin/adminlogin.dart';
import '../user/login.dart';

class UserRole extends StatefulWidget {
  const UserRole({super.key});

  @override
  State<UserRole> createState() => _UserRoleState();
}

class _UserRoleState extends State<UserRole> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(249, 151, 119, 1),
                Color.fromRGBO(98, 58, 162, 1),// #a6c1ee
              ],
            )
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Which role do you want to login?", style: GoogleFonts.poppins(
                  fontSize: 22, color: Colors.white,
                  fontWeight: FontWeight.w800
              )),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: ()=>Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage()
                                //HomeNavi(username: "Hafizah", tabIndexes: 0,),
                        )),
                    child: Card(
                      elevation: 10,
                      child: Container(
                        width: 180,
                        height: 180,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFFA6C1EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/user.png', width: 130, height: 120,),
                            Text("Job Seeker", style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.black,
                                fontWeight: FontWeight.w600
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=>Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => CompanyLogin()
                        )),
                    child: Card(
                      elevation: 10,
                      child: Container(
                        width: 180,
                        height: 180,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0xFFA6C1EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/company.png', width: 130, height: 120,),
                            Text("Company", style: GoogleFonts.poppins(
                                fontSize: 18, color: Colors.black,
                                fontWeight: FontWeight.w600
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => AdminLoginPage()
                      ));

                },
                child: Card(
                  elevation: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFA6C1EE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Image.asset('images/admin.png', width: 130, height: 120,),
                        Text("Administration", style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.black,
                            fontWeight: FontWeight.w600
                        )),
                      ],
                    ),
                  ),
                ),
              ),


              SizedBox(height: 40),

              InkWell(
                onTap: ()
                {
                  /**
                   * Navigate to register() function
                   * for web service request
                   */
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (context) => UserRegisterRole()
                      ));
                },
                child: Container(
                  width: double.infinity,
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
                        "Go to Register",
                        style: GoogleFonts.poppins(
                            fontSize: 20, color: Colors.black,
                            fontWeight: FontWeight.w600
                        )),
                  ),
                ),
              ),
            ],
          ),
        )





      )

    );
  }
}
