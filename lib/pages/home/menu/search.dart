import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getroom/pages/home/menu/settings.dart';
import 'package:getroom/utill/utill.dart';

class Rooms {
  List<String> images;
  String title;
  String location;
  String ratings;

  Rooms({required this.images, required this.title, required this.location,required this.ratings});
}

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();

  List<Rooms> roomsList = <Rooms>[
    Rooms(images: [], title: "Room1", location: "Malwa mill",ratings: "3"),
    Rooms(images: [], title: "Room1", location: "Vijay Nagar",ratings: "1"),
    Rooms(images: [], title: "Room1", location: "Sayaji Squre",ratings: "2"),
    Rooms(images: [], title: "Room1", location: "Pani pura",ratings: "5"),
    Rooms(images: [], title: "Room1", location: "Scheme no54",ratings: "3"),
  ];

  @override
  void initState() {
    searchController.addListener(() {
      debugPrint("njj${searchController.text}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.small(
          onPressed: () {
            Utill.CustomDialog(
                context: context,
                title: "Search",
                widget: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: TextField(
                          controller: searchController,
                        ),
                      ),
                      Center(
                        child: MaterialButton(
                          onPressed: () {
                            debugPrint("njjj${searchController.text}");
                            Get.back();
                          },
                          child: Text("Search"),
                        ),
                      ),
                    ],
                  ),
                ));
          },
          child: Icon(Icons.search_rounded),
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 100,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("Available rooms"),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return InkWell(
                  onTap:(){
                    Get.toNamed("/details")
                  },
                  child: RoomCard(
                    imageUrls: [
                      "https://fastly.picsum.photos/id/0/5000/3333.jpg?hmac=_j6ghY5fCfSD6tvtcV74zXivkJSPIfR9B8w34XeQmvU",
                      "https://picsum.photos/id/1/5000/3333"
                    ],
                    title: roomsList[index].title,
                    location: roomsList[index].location,
                    rating: double.parse(roomsList[index].ratings),
                  ),
                );
              }, childCount: roomsList.length),
            )
          ],
        ));
  }
}

class RoomCard extends StatelessWidget {
  final List<String> imageUrls; // List of image URLs
  final String title;
  final String location;
  final double rating;

  RoomCard({
    required this.imageUrls,
    required this.title,
    required this.location,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Images Carousel
          Container(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                      width: 300,
                    ),
                  ),
                );
              },
            ),
          ),

          // Title and Location
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 16,
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Rating
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
