import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class User {
  User({String? name, String? wokr});
}



class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final listOfUser = <User>[
    User(name:"name1", wokr:"wokr1"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("data"),
                  Text("data"),
                  Text("data"),
                ],
              ),
              background: Image.network(
                  "https://fastly.picsum.photos/id/0/5000/3333.jpg?hmac=_j6ghY5fCfSD6tvtcV74zXivkJSPIfR9B8w34XeQmvU"),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(childCount: listOfUser.length,
                (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  "${listOfUser[index]}",
                ),
              );
            }),
          )
        ],
      ),
    );
  }
}
