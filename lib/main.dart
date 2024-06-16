import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/authentication/register/register_screen.dart';
import 'package:todo_app/edit_task.dart';
import 'package:todo_app/firebase_options.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/providers/app_config_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/providers/auth_provider.dart';
import 'package:todo_app/providers/list_provider.dart';
import 'package:todo_app/splash_screen.dart';

import 'authentication/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'name-here',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
   MultiProvider(providers: [
      ChangeNotifierProvider(
      create: (context) => AppConfigProvider()),
  ChangeNotifierProvider(
  create: (context) => ListProvider()),
     ChangeNotifierProvider(
         create: (context) => AuthProviders()),
  ],
  child: MyApp()),
  );




}

class MyApp extends StatelessWidget {
  late AppConfigProvider provider;
  late ListProvider listProvider;


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    provider = Provider.of<AppConfigProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    initSharedPref();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: {
        SimpleAnimation.routeName: (context) => SimpleAnimation(),
        HomeScreen.routeName: (context) => HomeScreen(),
        RegisterScreen.routeName: (context) => RegisterScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        EditTaskScreen.routeName: (context) => EditTaskScreen(),
      },
      home: SimpleAnimation(),
      theme: ThemeData(),
      themeMode: provider.appTheme,
      darkTheme: MyTheme.DarkMode,
      locale: Locale(provider.appLanguage),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }

  initSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lang = prefs.getString('lang');
    String? theme = prefs.getString('lang');
    provider.changeLanguage(lang ?? 'light');
    if (theme == 'dark') {
      provider.changeTheme(ThemeMode.dark);
    } else if (theme == 'light') {
      provider.changeTheme(ThemeMode.light);
    }
  }
}
