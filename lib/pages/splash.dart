import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getroom/Storage/local.dart';
import 'package:getroom/pages/home/home.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final localStorage = LocalStorage();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () async {
      final isLoggedIn = await localStorage.isLoggedIn();
      if (isLoggedIn != null && isLoggedIn == true) {
        Get.offAll(() => HomePage());
      }else{
        Get.toNamed("/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          alignment: AlignmentDirectional.center,
          child: Center(
              child: TweenAnimationBuilder(
            tween: Tween(begin: 1.0, end: 3.14),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: Duration(seconds: 2),
            builder: (BuildContext context, double value, Widget? child) {
              return Transform.rotate(
                angle: value,
                child: FlutterLogo(),
              );
            },
          ))),
    );
  }
}
