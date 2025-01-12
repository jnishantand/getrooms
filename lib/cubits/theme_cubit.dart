import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeData>{
  ThemeCubit():super(_lightTheme);

  static final ThemeData _lightTheme=ThemeData(brightness: Brightness.light,primarySwatch: Colors.blue);
  static final ThemeData _darkTheme=ThemeData(brightness: Brightness.dark,primarySwatch: Colors.blue);

  void toggleTheme(){

    emit(state.brightness==Brightness.light ? _darkTheme :_lightTheme);
    debugPrint("njjj:clicked${state.brightness}");
  }
  
}