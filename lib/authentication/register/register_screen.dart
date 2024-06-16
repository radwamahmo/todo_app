 import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/authentication/register/custom_text_form_feild.dart';
import 'package:todo_app/dialog_utils.dart';
import 'package:todo_app/firebase_utils.dart';
import 'package:todo_app/home/home_screen.dart';
import 'package:todo_app/model/my_user.dart';
import 'package:todo_app/my_theme.dart';
import 'package:todo_app/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
 static const String routeName = 'register screen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
TextEditingController nameController = TextEditingController(text:'Radwa');

TextEditingController emailController = TextEditingController(text:'radwa@route.com');

TextEditingController passwordController = TextEditingController(text:'123456');

TextEditingController confirmPasswordController = TextEditingController(text:'123456');

var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: MyTheme.whiteColor,
           child: Image.asset("assets/images/background.png",
                width:double.infinity,
                height: double.infinity,
                fit: BoxFit.fill)
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Create Account'),
            centerTitle: true,

          ),
          body:SingleChildScrollView(
           child:   Column(

                children: [
                  Form(
                    key: formKey,
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height*0.25,
                      ),
                      CustomTextFormFeild(label: 'User Name',
                      controller: nameController,
                      validator: (text){
                        if(text == null  || text.trim().isEmpty){
                          return 'Please enter User Name';
                        }
                        return null;
                      },
                      ),
                      CustomTextFormFeild(label: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                        validator: (text){
                          if(text == null  || text.trim().isEmpty){
                            return 'Please enter Email ';
                          }
                          bool emailValid =
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(text);
                          if(!emailValid){
                            return 'Please enter valid email';
                          }
                          return null;
                        },),
                      CustomTextFormFeild(label: 'Password',
                      controller: passwordController,
                      keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (text){
                          if(text == null  || text.trim().isEmpty){
                            return 'Please enter Password';
                          }
                          if(text.length < 6 ){
                            return 'Password should be at least 6 chars.';
                          }
                          return null;
                        },),
                      CustomTextFormFeild(label: 'Confirm Password',

                      keyboardType: TextInputType.number,
                        obscureText: true,
                        validator: (text){
                          if(text == null  || text.trim().isEmpty){
                            return 'Please Confirm Password';
                          }
                          if(text != passwordController.text){
                            return 'Confirm Password does not match Password' ;
                          }
                          return null;
                        },
                        controller: confirmPasswordController,
                      ),
                      Padding(
                          padding :const EdgeInsets.all(10.0) ,
                        child:  ElevatedButton(onPressed: (){
                          register();
                        }, child: Text('Create Account',
                        style: Theme.of(context).textTheme.titleLarge,))
                      )

                    ],
                  ))
                ],
              )
    )

        )

      ],
    );
  }

  void register()async{
    if(formKey.currentState?.validate()== true){
      DialogUtils.showLoading(context:context,message: 'Loading',isDismissible: false);

      try {
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        MyUser myUser = MyUser(
            id: credential.user?.uid ?? '',
            name: nameController.text,
            email: emailController.text);
       await FireBaseUtils.addUserToFireStore(myUser);
       var authProvider = Provider.of<AuthProviders>(context, listen: false);
       authProvider.updateUser(myUser);

        DialogUtils.hideLoading(context);

        DialogUtils.showMessage(context: context, message: 'Register Successfully',
        title: 'Success',posActionName:'ok', posAction: (){
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            });

        print('register successfully');
        print(credential.user?.uid??'');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          DialogUtils.hideLoading(context);

          DialogUtils.showMessage(context: context, message: 'The password provided is too weak.',
              title: 'Error',posActionName:'ok');
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          DialogUtils.hideLoading(context);

          DialogUtils.showMessage(context: context, message: 'The account already exists for that email.',
              title: 'Error',posActionName:'ok');
          print('The account already exists for that email.');
        }
      } catch (e) {
        DialogUtils.hideLoading(context);

        DialogUtils.showMessage(context: context, message: '${e.toString()}',
            title: 'Error',posActionName:'ok');
        print(e);
      }
    }
  }
}
