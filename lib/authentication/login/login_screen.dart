import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/authentication/register/custom_text_form_feild.dart';
import 'package:todo_app/authentication/register/register_screen.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'login screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController(text:'radwa@route.com');

  TextEditingController passwordController = TextEditingController(text:'123456');

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            color: MyTheme.whiteColor,
            child: Image.asset("assets/images/background.png",
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill)),
        Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('Login'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Welcome Back!',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        CustomTextFormFeild(
                          label: 'Email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter Email ';
                            }
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(text);
                            if (!emailValid) {
                              return 'Please enter valid email';
                            }
                            return null;
                          },
                        ),
                        CustomTextFormFeild(
                          label: 'Password',
                          controller: passwordController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          validator: (text) {
                            if (text == null || text.trim().isEmpty) {
                              return 'Please enter Password';
                            }
                            if (text.length < 6) {
                              return 'Password should be at least 6 chars.';
                            }
                            return null;
                          },
                        ),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  login();
                                },
                                child: Text(
                                  'Login',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ))),
                        Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                                onPressed: () {

                                  Navigator.of(context)
                                      .pushNamed(RegisterScreen.routeName);
                                },
                                child: Text(
                                  'OR Create Account',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(color: MyTheme.blueColor),
                                ))),
                      ],
                    ))
              ],
            )))
      ],
    );
  }

  void login()async {
    if (formKey.currentState?.validate() == true) {
      DialogUtils.showLoading(context:context,message: 'Loading',isDismissible: false);
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text
        );

       var user = await FireBaseUtils.readUserFromFireStore(credential.user?.uid??'');
       if(user == null){
         return ;
       }
        var authProvider = Provider.of<AuthProviders>(context, listen: false);
        authProvider.updateUser(user);

            DialogUtils.hideLoading(context);

        DialogUtils.showMessage(context: context, message: 'Login Successfully',
            title: 'Success',posActionName:'ok', posAction: (){
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });
        print('Login successfully');
        print(credential.user?.uid??'');
      }
      on FirebaseAuthException catch (e) {
        if (e.code == 'invalid-credential') {
          DialogUtils.hideLoading(context);

          DialogUtils.showMessage(context: context,
              message: 'The supplied auth credential is incorrect, malformed or has expired.',
              title: 'Error',posActionName:'ok');
          print('The supplied auth credential is incorrect, malformed or has expired.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
      catch(e){
        DialogUtils.hideLoading(context);

        DialogUtils.showMessage(context: context,
            message: '${e.toString()}',
            title: 'Error',posActionName:'ok');
        print(e.toString());
      }
    }
  }
}
