import 'package:flutter/material.dart';

class AdoptionHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adoption History'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.pets),
            title: Text('Bella - Adopted on 2022-05-12'),
          ),
          ListTile(
            leading: Icon(Icons.pets),
            title: Text('Max - Adopted on 2021-11-07'),
          ),
        ],
      ),
    );
  }
}
