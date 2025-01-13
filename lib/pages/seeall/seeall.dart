import 'package:flutter/material.dart';

class SeeAll extends StatefulWidget {
  @override
  _SeeAllState createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  String selectedCategory = "All";
  final List<String> categories = ["All", "Single", "1BHK", "2BHK", "3BHK"];

  final List<Map<String, dynamic>> properties = [
    {
      "category": "Single",
      "image": "https://picsum.photos/id/10/2500/1667",
      "title": "Cozy Single Room",
      "price": "\$200/month",
      "location": "New York, USA",
      "rating": 4.5,
    },
    {
      "category": "1BHK",
      "image": "https://picsum.photos/id/11/2500/1667",
      "title": "Modern 1BHK Apartment",
      "price": "\$500/month",
      "location": "San Francisco, USA",
      "rating": 4.8,
    },
    {
      "category": "2BHK",
      "image": "https://picsum.photos/id/12/2500/1667",
      "title": "Spacious 2BHK Flat",
      "price": "\$800/month",
      "location": "Los Angeles, USA",
      "rating": 4.7,
    },
    {
      "category": "3BHK",
      "image": "https://picsum.photos/id/13/2500/1667",
      "title": "Luxury 3BHK Villa",
      "price": "\$1200/month",
      "location": "Miami, USA",
      "rating": 5.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProperties = selectedCategory == "All"
        ? properties
        : properties.where((property) => property["category"] == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Property Listings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Category Selection
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: selectedCategory == category ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        style: TextStyle(
                          color: selectedCategory == category ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Property Grid
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(10.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final property = filteredProperties[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to detail page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(property: property),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Stack(
                              children: [
                                // Background Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    property["image"],
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // Overlay Details
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          property["title"],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          property["price"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          property["location"],
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          children: List.generate(
                                            5,
                                                (starIndex) => Icon(
                                              Icons.star,
                                              size: 15,
                                              color: starIndex < property["rating"] ? Colors.yellow : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: filteredProperties.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> property;

  const DetailPage({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(property["title"]),
      ),
      body: Column(
        children: [
          Image.network(property["image"], fit: BoxFit.cover, height: 300, width: double.infinity),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property["title"],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  property["price"],
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                SizedBox(height: 10),
                Text(
                  property["location"],
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                SizedBox(height: 10),
                Row(
                  children: List.generate(
                    5,
                        (index) => Icon(
                      Icons.star,
                      color: index < property["rating"] ? Colors.yellow : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
