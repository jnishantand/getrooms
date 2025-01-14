import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FirebaseRepo {
  FirebaseRepo._();

  static final FirebaseRepo firebaseRepo = FirebaseRepo._();

  Future<void> initialize() async {
    await Firebase.initializeApp();
  }


  static Future<String> addRoom({
    required String title,
    required String price,
    required bool isBooked,
    required String location,
    required String category,
    required List<String> imageUrls,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').add({
        'title': title,
        'price': int.parse(price),
        'isBooked': isBooked,
        'location': location,
        'category': category,
        'imageUrls': imageUrls==null?[]:imageUrls??[],
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint("njj:Room added successfully!");
      return "njj:Room added successfully!";
    } catch (e) {
      debugPrint("njj Error adding room: $e");
      return "njj Error adding room: $e";
    }
  }

 static Stream<List<Map<String, dynamic>>> fetchRooms() {
    return FirebaseFirestore.instance.collection('rooms')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }


 static Stream<List<Map<String, dynamic>>> filterRooms({String? location, String? category}) {
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


 static Future<String> uploadImage(File image) async {
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

  static Future<void> deleteRoom(String roomId) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).delete();
      debugPrint("Room deleted successfully!");
    } catch (e) {
      debugPrint("Error deleting room: $e");
    }
  }
  static Future<void> updateRoom({
    required String roomId,
    String? title,
    int? price,
    bool? isBooked,
    String? location,
    String? category,
    List<String>? imageUrls,
  }) async {
    try {
      Map<String, dynamic> updatedData = {};

      // Add fields to be updated only if they are not null
      if (title != null) updatedData['title'] = title;
      if (price != null) updatedData['price'] = price;
      if (isBooked != null) updatedData['isBooked'] = isBooked;
      if (location != null) updatedData['location'] = location;
      if (category != null) updatedData['category'] = category;
      if (imageUrls != null) updatedData['images'] = imageUrls;

      await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomId)
          .update(updatedData);

      debugPrint("Room updated successfully!");
    } catch (e) {
      debugPrint("Error updating room: $e");
    }
  }


}