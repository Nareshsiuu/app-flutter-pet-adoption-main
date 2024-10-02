import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PetForm extends StatefulWidget {
  @override
  _PetFormState createState() => _PetFormState();
}

enum PetType { Dog, Cat, Rabbit, Bird }
enum DogBreed { Labrador, Beagle, Bulldog }
enum CatBreed { Persian, Sphynx, Siamese }
enum RabbitBreed { HollandLop, NetherlandDwarf, Lionhead }
enum BirdBreed { Parrot, Canary, Finch }
enum Gender { Male, Female }

class _PetFormState extends State<PetForm> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> _medicalHistories = [];
  File? _image;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();

  PetType? _selectedType;
  dynamic _selectedBreed;
  Gender? _selectedGender;

  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  final TextEditingController _eventTypeController = TextEditingController();

  List<DropdownMenuItem<dynamic>> getBreedItems() {
    // Function to get breed items based on pet type
    if (_selectedType == PetType.Dog) {
      return DogBreed.values.map((DogBreed breed) {
        return DropdownMenuItem<DogBreed>(
          value: breed,
          child: Text(breed.toString().split('.').last),
        );
      }).toList();
    } else if (_selectedType == PetType.Cat) {
      return CatBreed.values.map((CatBreed breed) {
        return DropdownMenuItem<CatBreed>(
          value: breed,
          child: Text(breed.toString().split('.').last),
        );
      }).toList();
    } else if (_selectedType == PetType.Rabbit) {
      return RabbitBreed.values.map((RabbitBreed breed) {
        return DropdownMenuItem<RabbitBreed>(
          value: breed,
          child: Text(breed.toString().split('.').last),
        );
      }).toList();
    } else if (_selectedType == PetType.Bird) {
      return BirdBreed.values.map((BirdBreed breed) {
        return DropdownMenuItem<BirdBreed>(
          value: breed,
          child: Text(breed.toString().split('.').last),
        );
      }).toList();
    }
    return [];
  }

  Future<String> _uploadImage(File image) async {
    try {
      // Create a reference to Firebase Storage
      String filePath = 'pet_images/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(filePath);
      await ref.putFile(image);
      // Get the download URL
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Image upload failed: $e');
    }
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      String imageUrl = '';

      if (_image != null) {
        try {
          imageUrl = await _uploadImage(_image!);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: $e')),
          );
          return;
        }
      }

      final pet = {
        'name': _nameController.text,
        'type': _selectedType?.toString().split('.').last ?? '',
        'description': _descriptionController.text,
        'breed': _selectedBreed?.toString().split('.').last ?? '',
        'age': int.tryParse(_ageController.text) ?? 0,
        'color': _colorController.text,
        'gender': _selectedGender?.toString().split('.').last ?? '',
        'medicalHistory': _medicalHistories.map((item) {
          return {
            'date': item['date'],
            'description': item['description'],
            'eventType': item['eventType'],
          };
        }).toList(),
        'imagePath': imageUrl,
      };

      // Debugging: Print the pet data before submission
      print('Submitting pet data: $pet');

      try {
        await FirebaseFirestore.instance.collection('pets').add(pet);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pet added successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add pet: $e')),
        );
      }

      // Clear form fields
      _formKey.currentState?.reset();
      _nameController.clear();
      _descriptionController.clear();
      _ageController.clear();
      _colorController.clear();
      _medicalHistories.clear();
      _eventDateController.clear();
      _eventDescriptionController.clear();
      _eventTypeController.clear();
      setState(() {
        _image = null;
        _selectedType = null;
        _selectedBreed = null;
        _selectedGender = null;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePicture() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addMedicalHistory() {
    if (_eventDateController.text.isNotEmpty &&
        _eventDescriptionController.text.isNotEmpty &&
        _eventTypeController.text.isNotEmpty) {
      setState(() {
        _medicalHistories.add({
          'date': _eventDateController.text,
          'description': _eventDescriptionController.text,
          'eventType': _eventTypeController.text,
        });
      });

      // Debugging: Print the medical history list
      print('Current medical histories: $_medicalHistories');

      _eventDateController.clear();
      _eventDescriptionController.clear();
      _eventTypeController.clear();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _eventDateController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format the date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Pet'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Enter Pet Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the pet\'s name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<PetType>(
                value: _selectedType,
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
                items: PetType.values.map((PetType type) {
                  return DropdownMenuItem<PetType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                    _selectedBreed = null; // Reset breed when type changes
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a pet type' : null,
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<dynamic>(
                value: _selectedBreed,
                decoration: InputDecoration(
                  labelText: 'Breed',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
                items: getBreedItems(),
                onChanged: (value) {
                  setState(() {
                    _selectedBreed = value;
                  });
                },
                hint: Text('Please select a breed'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  labelText: 'Age (in years)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _colorController,
                decoration: InputDecoration(
                  labelText: 'Color',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<Gender>(
                value: _selectedGender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
                items: Gender.values.map((Gender gender) {
                  return DropdownMenuItem<Gender>(
                    value: gender,
                    child: Text(gender.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Upload Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _takePicture,
                    child: Text('Take Picture'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _image != null
                  ? Image.file(
                _image!,
                height: 150,
                width: 150,
              )
                  : Text('No image selected.'),
              SizedBox(height: 20),
              // Medical history section
              Text(
                'Add Medical History',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Date: ${_eventDateController.text.isNotEmpty ? _eventDateController.text : 'Select a date'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text('Select Date'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _eventTypeController,
                decoration: InputDecoration(
                  labelText: 'Event Type',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addMedicalHistory,
                child: Text('Add Medical History'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
