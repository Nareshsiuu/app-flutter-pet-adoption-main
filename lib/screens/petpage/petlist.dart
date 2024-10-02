import 'dart:async'; // For stream
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pet_app/screens/petpage/con.dart';
import 'package:pet_app/screens/petpage/pet_details.dart';
import 'package:pet_app/screens/petpage/petdata.dart';

import 'firebasepets.dart'; // Assuming this file contains the Pet class

class PetListScreen extends StatefulWidget {
  @override
  _PetListScreenState createState() => _PetListScreenState();
}

class _PetListScreenState extends State<PetListScreen> {
  String? selectedType;
  String searchQuery = '';
  List<Pet> allPets = [];


  void loadPets() async {
    List<Pet> firebasePets = await fetchPetsFromFirebase();
    setState(() {
      allPets = pets + firebasePets; // Combine local and Firebase pets
    });
  }

  // Simulated pet data stream (replace this with your actual stream)
  Stream<List<Pet>> getPetsStream() async* {
    // Simulating data fetch with a delay
    await Future.delayed(Duration(seconds: 1));

    // Emitting a list of pets. Replace this with actual data from your data source
    yield allPets;
  }

  // Method to trigger the refresh (re-fetch the stream)
  void refreshPets() {
    setState(() {
      loadPets();
      // Triggers a rebuild to refresh the data
    });
  }

  @override
  void initState() {
    super.initState();
    loadPets();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet List'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: refreshPets, // Call the refresh function
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter area
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      hint: Text('Select Pet Type', style: TextStyle(color: Colors.black54)),
                      value: selectedType,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedType = newValue;
                        });
                      },
                      isExpanded: true,
                      underline: SizedBox(), // Hide the default underline
                      items: <String>['All', 'Dog', 'Cat', 'Parrot', 'Rabbit', 'Bird', 'Hamster', 'Ferret']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                // Search bar
                Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                    ),
                    onChanged: (query) {
                      setState(() {
                        searchQuery = query;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // List of filtered pets using StreamBuilder
          Expanded(
            child: StreamBuilder<List<Pet>>(
              stream: getPetsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error fetching pets'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No pets found.'));
                }

                // Filter the list of pets based on the search query and selected type
                List<Pet> filteredPets = snapshot.data!.where((pet) {
                  final matchesType = selectedType == null || selectedType == 'All' || pet.type == selectedType;
                  final matchesSearchQuery = pet.name.toLowerCase().contains(searchQuery.toLowerCase());
                  return matchesType && matchesSearchQuery;
                }).toList();

                return filteredPets.isNotEmpty
                    ? ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: filteredPets.length,
                  itemBuilder: (context, index) {
                    final pet = filteredPets[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PetDetailScreen(pet: pet),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: pet.imagePath.isNotEmpty && pet.imagePath.startsWith('http')
                                  ? Image.network(
                                pet.imagePath,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                              )
                                  : pet.imagePath.startsWith('assets/')
                                  ? Image.asset(
                                pet.imagePath,
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                              )
                                  : Image.file(
                                File(pet.imagePath),
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black54,
                                padding: EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pet.name,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      pet.type,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.pets, color: Colors.white, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          pet.breed,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Icon(Icons.calendar_today, color: Colors.white, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          '${pet.age} yrs',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.color_lens, color: Colors.white, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          pet.color,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Icon(Icons.transgender, color: Colors.white, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          pet.gender,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
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
                )
                    : Center(
                  child: Text(
                    'No pets found matching your criteria.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
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
