import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getroom/pages/home/menu/search.dart';
import 'package:getroom/utill/utill.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<Map<String, dynamic>> items = [
    {
      'image': 'https://picsum.photos/id/12/2500/1667',
      'title': 'Beautiful Villa',
      'rating': 4.5,
      'location': 'California, USA',
      'price': '\$200/night',
    },
    {
      'image': 'https://picsum.photos/id/26/4209/2769',
      'title': 'Modern Apartment',
      'rating': 4.8,
      'location': 'New York, USA',
      'price': '\$150/night',
    },
    {
      'image': 'https://picsum.photos/id/21/3008/2008',
      'title': 'Cozy Cottage',
      'rating': 4.3,
      'location': 'Ontario, Canada',
      'price': '\$100/night',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(

        slivers: [
          SliverAppBar(
            toolbarHeight: 100,
            pinned: true,
            expandedHeight: 300,
            centerTitle: false,
            flexibleSpace: Container(
              height: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        "https://fastly.picsum.photos/id/0/5000/3333.jpg?hmac=_j6ghY5fCfSD6tvtcV74zXivkJSPIfR9B8w34XeQmvU",
                        fit: BoxFit.cover,
                        width: 300,
                      ),
                    ),
                  );
                },
              ),
            ),
            title: Text("rooms"),
            bottom: PreferredSize(
                preferredSize: Size(100, 50),
                child: Container(
                  color: Colors.red,
                )),
          ),
          SliverFillRemaining(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (c, i) {
                    return Utill.dashBoardRowItem(items);
                  },
                  separatorBuilder: (c, i) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  itemCount: items.length),
            ),
          ))
        ],
      )),
    );
  }
}
