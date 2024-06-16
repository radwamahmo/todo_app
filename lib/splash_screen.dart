import 'package:flutter/material.dart';

import 'package:todo_app/home/home_screen.dart';


class SimpleAnimation extends StatefulWidget {
   SimpleAnimation({Key? key, this.loading}) : super(key: key);
  final bool? loading;
  static const String routeName = 'simple screen';

  @override
  State<SimpleAnimation> createState() => _SimpleAnimationState();
}

class _SimpleAnimationState extends State<SimpleAnimation> {
  @override

  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  HomeScreen(),
          ));
    });
    return  Scaffold(
      body: Center(
          child: Image.asset('assets/images/splash@3x.png',
              fit: BoxFit.cover)
      ),
    );
  }
}