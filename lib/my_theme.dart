
import 'package:flutter/material.dart';

class MyTheme{
 static Color blueColor = Color(0xff5D9CEC);
 static Color appColor = Color(0xffDFECDB);
 static Color whiteColor = Color(0xffffffff);
 static Color blackColor = Color(0xff383838);
 static Color greenColor = Color(0xff61E757);
 static Color redColor = Color(0xffEC4B4B);
 static Color grayColor = Color(0xff707070);
 static Color backgroundLightColor = Color(0xffDFECDB);
 static Color backgroundDarkColor = Color(0xff060E1E);
 static Color blackDarkColor = Color(0xff141922);


 static ThemeData lightTheme = ThemeData(
   primaryColor: MyTheme.appColor,
   scaffoldBackgroundColor: MyTheme.appColor,
  appBarTheme: AppBarTheme(
   backgroundColor: Colors.blueAccent ,
   elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
   selectedItemColor: Colors.blueAccent  ,
   unselectedItemColor: grayColor,
      backgroundColor: Colors.transparent,
      elevation: 0
  ),
  bottomSheetTheme: BottomSheetThemeData(
   shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(25),
    side: BorderSide(
     color: appColor ,
     width: 4
    )
   )
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
   backgroundColor: appColor ,

  ),
  textTheme: TextTheme(
   titleLarge: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: whiteColor
   ),
       titleMedium:TextStyle(
           fontSize: 20,
           fontWeight: FontWeight.bold,
           color: blackDarkColor
       ),
   titleSmall: TextStyle(
       fontSize: 18,
       fontWeight: FontWeight.bold,
       color: blackColor
   ),

  )
 );
 static ThemeData DarkMode = ThemeData(

     primaryColor: blackDarkColor,
     scaffoldBackgroundColor: Colors.transparent,
     appBarTheme: AppBarTheme(
         backgroundColor: Colors.blueAccent,
         elevation:0,
         centerTitle: true,
         iconTheme: IconThemeData(
             color:  whiteColor
         )
     ),
     bottomNavigationBarTheme: BottomNavigationBarThemeData(
         selectedItemColor: Colors.blueAccent  ,
         unselectedItemColor: whiteColor,

         backgroundColor: blackDarkColor
     ),
     textTheme: TextTheme(
         titleLarge: TextStyle(
             fontSize: 30,
             fontWeight: FontWeight.bold,
             color: whiteColor
         ),
         titleMedium: TextStyle(
             fontSize: 25,
             fontWeight: FontWeight.w500,
             color: blackDarkColor
         ),
         titleSmall:  TextStyle(
             fontSize: 25,
             fontWeight: FontWeight.w400,
             color: whiteColor
         )
     )
 );
}