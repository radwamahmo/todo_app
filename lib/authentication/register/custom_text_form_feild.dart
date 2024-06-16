 import 'package:flutter/material.dart';
import 'package:todo_app/my_theme.dart';
typedef MyValidator = String? Function(String?);
class CustomTextFormFeild extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  TextEditingController controller ;
  MyValidator validator;
  bool obscureText ;
  CustomTextFormFeild({required this.label, this.keyboardType= TextInputType.text,
  required this.controller, required this.validator,
  this.obscureText = false
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: label,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: MyTheme.appColor ,
              width: 2
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: MyTheme.appColor ,
                width: 2
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: MyTheme.redColor,
                width: 2
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
                color: MyTheme.redColor,
                width: 2
            ),
          ),
        ),
        keyboardType: keyboardType ,
        controller:controller ,
        validator: validator,
        obscureText:obscureText ,
      ),

    );
  }
}
