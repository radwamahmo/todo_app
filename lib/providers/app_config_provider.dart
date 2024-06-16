import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_utils.dart';
import '../model/task.dart';

class AppConfigProvider extends ChangeNotifier{
 String appLanguage = 'en' ;
 ThemeMode appTheme = ThemeMode.light;




 Future<void> changeLanguage(String newLanguage) async {

  if(appLanguage == newLanguage){
    return ;
  }
  appLanguage = newLanguage ;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('lang',newLanguage);
  notifyListeners();
 }


 Future<void> changeTheme(ThemeMode newMode) async {
  if(appTheme == newMode){
   return ;
  }
  appTheme = newMode;
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('theme',newMode==ThemeMode.dark?'dark':'light');
  notifyListeners();
 }


 bool isDarkMode(){
  return appTheme == ThemeMode.dark ;
 }





}