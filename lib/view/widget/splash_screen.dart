import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// library to use Google Fonts
import 'package:google_fonts/google_fonts.dart';

import 'ip_address.dart';

/**
 * This is the splash screen or launching screen
 * which is the first screen a user sees when they open the app.
 * It stays visible while the app is loading.
 */

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 5), ()
    {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => IPAddressInput()));
    });

    /**
     * set the duration of this screen to be displayed
     * before auto navigate to the next page
     */
    /*Timer(Duration(seconds: 35),
            ()=>Navigator.pushReplacement(
                context, MaterialPageRoute(
                    builder: (context)=>OnBoarding())));*/
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            // Linear gradient for background
            gradient: LinearGradient(

              //determine the direction and angle of each color stop in gradient
              begin: Alignment.topRight,
              end: Alignment.bottomRight,

              //0xFF is needed to convert RGB Hex code to int value
              // Hex code here is 29539B and 1E3B70
              // Gradient Name: Unloved Teen
              colors: [
                Color(0xFFFBC2EB), // #fbc2eb
                Color(0xFFA6C1EE), // #a6c1ee
              ],
            )
          ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
                'images/job_seek.png',
            height: 300, width: 300),
            Text("Let the world be freed from jobless",
            style: GoogleFonts.poppins(
                fontSize: 20, color: Colors.black,
                fontWeight: FontWeight.bold,)
            ),

            const CircularProgressIndicator(
              color: Colors.yellow,
              strokeWidth: 5.0,

            )


          ],
        ),
      ),
    );
  }
}
