import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getroom/cubits/addroomcubit/addroomcubit.dart';
import 'package:getroom/cubits/addroomcubit/addroomstates.dart';
import 'package:image_picker/image_picker.dart';

class AddRoomForm extends StatefulWidget {
  @override
  _AddRoomFormState createState() => _AddRoomFormState();
}

class _AddRoomFormState extends State<AddRoomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  bool _isAvailable = true;
  String? _selectedCategory;
  List<XFile> _images = [];

  final List<String> _categories = ['Single Room', 'Double Room', 'Suite'];

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process the form data
      print('Title: ${_titleController.text}');
      print('Location: ${_locationController.text}');
      print('Price: ${_priceController.text}');
      print('Availability: $_isAvailable');
      print('Category: $_selectedCategory');
      print('Images count: ${_images.length}');

      if (_images.isEmpty) {
        print('Please pick images');
        return;
      } else if (_selectedCategory == null) {
        print('Please select a category');
        return;
      } else if (_titleController.text.isEmpty) {
        print('Please enter a title');
        return;
      } else if (_locationController.text.isEmpty) {
        print('Please enter a location');
        return;
      } else if (_priceController.text.isEmpty) {
        print('Please enter a price');
        return;
      }
     else if (_selectedCategory == null) {
      print('Please select a category');
      return;
    } else {
      print('njj add form');
      final roomData = {
        'title': _titleController.text,
        'location': _locationController.text,
        'price': _priceController.text,
        'isBooked': _isAvailable,
        'category': _selectedCategory,
        'images': _images,
      };
      context.read<AddRoomCubit>().addRoom(roomData: roomData);
    }}}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Room Details'),
      ),
      body: BlocConsumer<AddRoomCubit,AddRoomState>( listener: (BuildContext context, state) {

      }, builder: (BuildContext context, Object? state) {
        if(state is AddRoomLoading){
          return Center(child: CircularProgressIndicator());
        } if(state is AddRoomFailed){
          return Center(child: Text(state.message));
        } if(state is AddRoomSuccess){
          return Center(child: Text(state.message));
        }if(state is AddRoomSuccess){
          return Center(child: Text(state.message));
        }if(state is AddRoomInitial){
          return _buildForm();
        }else{
          return Center(child: Text('Error'));
        }
      }, )
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Room Title'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a title' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) =>
                value!.isEmpty ? 'Please enter a location' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Please enter a price' : null,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Availability'),
                  Switch(
                    value: _isAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                  ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text('Select Category'),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a category' : null,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImages,
                child: Text('Pick Images'),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: _images.map((image) {
                  return Image.file(
                    File(image.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
