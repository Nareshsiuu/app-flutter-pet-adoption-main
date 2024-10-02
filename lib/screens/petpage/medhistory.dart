import 'package:flutter/material.dart';

import 'con.dart';
import 'package:intl/intl.dart';

class PetHistoryScreen extends StatelessWidget {
  final Pet pet;

  PetHistoryScreen({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${pet.name} Medical History'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: pet.medicalHistory.length,
        itemBuilder: (context, index) {
          final history = pet.medicalHistory[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(history.eventType),
              subtitle: Text(history.description),
              trailing: Text(DateFormat('MM/dd/yyyy').format(history.date)),
            ),
          );
        },
      ),
    );
  }
}


