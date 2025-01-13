import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getroom/pages/home/menu/search.dart';
import 'package:getroom/utill/utill.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? userName = "There!";
  final List<String> Categorieslist = [
    "Trending",
    "Featured",
    "Newly added",
    "Single only"
  ];
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
    {
      'image': 'https://picsum.photos/id/21/3008/2008',
      'title': 'Full furnished',
      'rating': 4,
      'location': 'Indore',
      'price': '\$30/night',
    },
  ];


  Future<void> addRoom({
    required String title,
    required int price,
    required bool isBooked,
    required String location,
    required String category,
    required List<String> imageUrls,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').add({
        'title': title,
        'price': price,
        'isBooked': isBooked,
        'location': location,
        'category': category,
        'images': imageUrls,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("Room added successfully!");
    } catch (e) {
      print("Error adding room: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> fetchRooms() {
    return FirebaseFirestore.instance.collection('rooms')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }


  Future<String> uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child('room_images/$fileName');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  Stream<List<Map<String, dynamic>>> filterRooms({String? location, String? category}) {
    Query query = FirebaseFirestore.instance.collection('rooms');

    if (location != null) {
      query = query.where('location', isEqualTo: location);
    }
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    return query.orderBy('createdAt', descending: true).snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList() as List<Map<String,dynamic>>);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            pinned: true,
            expandedHeight: 100,
            centerTitle: false,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(onPressed: (){
                  debugPrint("clciked");
                 Get.toNamed('/notification');
                }, icon:Icon(Icons.notifications),),
              )
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text("Hii ${userName}")],
            ),
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                  width: double.infinity,
                  height: 200,
                  child: ListView.builder(
                    itemBuilder: (c, i) {
                      return Image.network(
                        "https://fastly.picsum.photos/id/0/5000/3333.jpg?hmac=_j6ghY5fCfSD6tvtcV74zXivkJSPIfR9B8w34XeQmvU",
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                      );
                    },
                    itemCount: 2,
                    scrollDirection: Axis.horizontal,
                  )),
            )
          ),
          SliverFillRemaining(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (c, i) {
                        return Utill.dashBoardRowItem(items, Categorieslist[i]);
                      },
                      shrinkWrap: true,
                      separatorBuilder: (c, i) {
                        return SizedBox(
                          height: 50,
                          child: Divider(
                            height: 1,
                          ),
                        );
                      },
                      itemCount: items.length),
                ),
              ],
            ),
          ))
        ],
      )),
    );
  }
}
