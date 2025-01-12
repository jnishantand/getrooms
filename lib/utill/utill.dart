import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getroom/pages/home/menu/search.dart';

class Utill {
  static final _instance = Utill._internal();

  factory Utill() {
    return _instance;
  }

  Utill._internal();

  static CustomDialog(
      {BuildContext? context, String? title, Widget? widget, bool? isOptions}) {
    return showDialog(
        context: context!,
        builder: (context) {
          return AlertDialog(
            title: Text(title!),
            content: widget!,
          );
        });
  }

  static cutom_button(
      {double? width, double? height, void Function()? onTap, String? title}) {
    return GestureDetector(
        onTap: onTap!,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.blue),
          width: width!,
          height: height!,
          child: Center(
            child: Text(title!),
          ),
        ));
  }

  static Container dashBoardRowItem( dynamic items) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(alignment: Alignment.topLeft, child: Text("New Rooms")),
          SizedBox(
            height: 250.0, // Fixed height for the horizontal list
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    children: [
                      // Background Image
                      Container(
                        width: 200.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          image: DecorationImage(
                            image: NetworkImage(item['image']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Foreground Details
                      Positioned(
                        bottom: 10.0,
                        left: 10.0,
                        right: 10.0,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Row(
                                children: [
                                  Icon(Icons.star, color: Colors.yellow, size: 16.0),
                                  const SizedBox(width: 4.0),
                                  Text(
                                    '${item['rating']}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                item['location'],
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                item['price'],
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
