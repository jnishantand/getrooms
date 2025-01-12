import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utill {
  static final _instance = Utill._internal();

  factory Utill() {
    return _instance;
  }

  Utill._internal();

  static CustomDialog({BuildContext? context, String? title, Widget? widget,bool? isOptions}) {
    return showDialog(
        context: context!,
        builder: (context) {
          return AlertDialog(
            title: Text(title!),
            content: widget!,

          );
        });
  }

  static cutom_button({double? width,double? height,void Function()? onTap,String? title}){
    return GestureDetector(
        onTap: onTap!,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: Colors.blue),
          width: width!,height: height!,child: Center(child: Text(title!),),));
  }
}
