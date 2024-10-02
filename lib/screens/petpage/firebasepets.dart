import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_app/screens/petpage/con.dart';
import 'package:pet_app/screens/petpage/medical.dart';

Future<List<Pet>> fetchPetsFromFirebase() async {
  List<Pet> petList = [];
  CollectionReference petsCollection = FirebaseFirestore.instance.collection('pets');

  try {
    QuerySnapshot snapshot = await petsCollection.get();

    for (var doc in snapshot.docs) {
      // Check if the document contains all necessary fields
      if (doc.exists) {
        // Fetch the medicalHistory as a list of maps
        List<dynamic> medicalHistoryData = doc['medicalHistory'] ?? [];

        // Parse the medicalHistory
        List<MedicalHistory> medicalHistoryList = medicalHistoryData.map((mh) {
          return MedicalHistory(
            date: DateTime.parse(mh['date']),
            description: mh['description'],
            eventType: mh['eventType'],
          );
        }).toList();

        // Add the pet with medical history to the list
        petList.add(Pet(
          name: doc['name'],
          type: doc['type'],
          description: doc['description'],
          imagePath: doc['imagePath'],
          breed: doc['breed'],
          age: doc['age'],
          color: doc['color'],
          gender: doc['gender'],
          medicalHistory: medicalHistoryList,
        ));
      } else {
        print('Document ${doc.id} does not exist');
      }
    }
  } catch (e) {
    print('Error fetching pets: $e');
  }

  return petList;
}
