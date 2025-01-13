import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String fullName = "Name";
  String email = "Email";
  String address = "Address";
  String? imagePath;

  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource source) async {
    final pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        imagePath = pickedImage.path;
      });
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Choose from Gallery"),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Take a Photo"),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String tempName = fullName;
        String tempEmail = email;
        String tempAddress = address;
        return AlertDialog(
          title: Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Full Name"),
                onChanged: (value) => tempName = value,
                controller: TextEditingController(text: fullName),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Email Address"),
                onChanged: (value) => tempEmail = value,
                controller: TextEditingController(text: email),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Address"),
                onChanged: (value) => tempAddress = value,
                controller: TextEditingController(text: address),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  fullName = tempName;
                  email = tempEmail;
                });
                Navigator.of(context).pop();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

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
      debugPrint("njj:Room added successfully!");
    } catch (e) {
      debugPrint("njj Error adding room: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> fetchRooms() {
    return FirebaseFirestore.instance.collection('rooms')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }


  Stream<List<Map<String, dynamic>>> filterRooms({String? location, String? category}) {
    Query query = FirebaseFirestore.instance.collection('rooms');

    if (location != null) {
      query = query.where('location', isEqualTo: location);
    }
    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    return query.orderBy('createdAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  addRoom(title: "Room 1", price: 100, isBooked: false, location: "Kathmandu", category: "Single", imageUrls: ["https://picsum.photos/200/300", "https://picsum.photos/200/300", "https://picsum.photos/200/300"]);
  //   final rooms=fetchRooms();
  //   rooms.listen((event) {
  //     debugPrint("njj: $event");
  //   });

    filterRooms(location: "Kathmandu", category: "Single").listen((event) {
      debugPrint("njj: $event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                      imagePath != null ? FileImage(File(imagePath!)) : null,
                      child: imagePath == null
                          ? Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey[700],
                      )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _showImagePickerOptions,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  fullName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  email,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),    SizedBox(height: 8),
                Text(
                  address,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _editProfile,
                  icon: Icon(Icons.edit),
                  label: Text("Edit Profile"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}