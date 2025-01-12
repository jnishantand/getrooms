import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getroom/Auth/Login/login.dart';
import 'package:getroom/Storage/local.dart';
import 'package:getroom/cubits/theme_cubit.dart';
import 'package:getroom/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getroom/utill/utill.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

final localStorage = LocalStorage();
final listItems = [
  "Profile",
  "darkmode",
  "Terms and Conditions",
  "Privicy Policy",
  "About US",
  "Logout"
];

class _SettingsState extends State<Settings> {
  Widget options() {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Utill.cutom_button(
              width: 80,
              height: 35,
              onTap: () async {
                await localStorage.clearAll();
                Get.back();
                Get.to(LoginPage());
              },
              title: "sure"),
          SizedBox(
            width: 8.0,
          ),
          Utill.cutom_button(
              width: 80, height: 35, onTap: () => Get.back(), title: "cancel"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 100,
              pinned: true,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text("Settings"),
                collapseMode: CollapseMode.parallax,
                centerTitle: true,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((c, i) {
                final item = listItems[i];
                return BlocBuilder<ThemeCubit, ThemeData>(
                    builder: (context, theme) {
                      return GestureDetector(
                        onTap: () {
                          goTO(i);
                        },
                        child: Container(
                          height: 80,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey),
                          child: Center(
                              child: Text(i == 1
                                  ? theme.brightness == Brightness.light
                                  ? "Dark Mode"
                                  : "Light Mode"
                                  : item)),
                        ),
                      );
                    });
              }, childCount: listItems.length),
            ),
          ],
        ));
  }

  void goTO(int i) {
    debugPrint("clicked $i");
    switch (i) {
      case 0:
        {
          Get.toNamed('/profile');
        }
        ;
      case 1:
        {
          context.read<ThemeCubit>().toggleTheme();
        }
        ;
      case 5:
        {
          Utill.CustomDialog(
              context: context, title: "Logout", widget: options());
        }
      case 2:
        {
          Get.toNamed('/pdf');
        }
      case 3:
        {
          Get.toNamed('/pdf');
        }
      case 4:
        {
          Get.toNamed('/pdf');
        }
    }
  }
}
