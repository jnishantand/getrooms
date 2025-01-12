import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getroom/Auth/Login/login.dart';
import 'package:getroom/Auth/signup/signup.dart';
import 'package:getroom/cubits/theme_cubit.dart';
import 'package:getroom/pages/details/details.dart';
import 'package:getroom/pages/home/home.dart';
import 'package:getroom/pages/payment/payment_screen.dart';
import 'package:getroom/pages/pdf/pdf.dart';
import 'package:getroom/pages/profile/profile.dart';
import 'package:getroom/pages/splash.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(BlocProvider(
    create: (_) => ThemeCubit(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit,ThemeData>(
      builder: (context, state) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: state,
          initialRoute: '/',
          routes: {
            '/': (context) => const Splash(),
            '/signup': (context) => const SignUpPage(), // Create SignUpPage widget
            '/forgot-password': (context) => const ForgotPasswordPage(), // Create ForgotPasswordPage widget
            '/home': (context) => const HomePage(), // Create ForgotPasswordPage widget
            '/login': (context) =>  LoginPage(), // Create ForgotPasswordPage widget
            '/details': (context) =>  DetailsPage(), // Create ForgotPasswordPage widget
            '/paymentScreen': (context) =>  PaymentScreen(), // Create ForgotPasswordPage widget
            '/pdf': (context) =>  PDFViewerScreen(),
            '/profile': (context) =>  ProfilePage()


          },
        );
      },
    );
  }
}
