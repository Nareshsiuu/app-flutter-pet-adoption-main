import 'package:cloud_firestore/cloud_firestore.dart';

class MedicalHistory {
  final DateTime date;
  final String description;
  final String eventType;

  MedicalHistory({
    required this.date,
    required this.description,
    required this.eventType,
  });


}
