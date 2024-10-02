import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class NearbySheltersScreen extends StatefulWidget {
  @override
  _NearbySheltersScreenState createState() => _NearbySheltersScreenState();
}

class _NearbySheltersScreenState extends State<NearbySheltersScreen> {
  LatLng _currentPosition = LatLng(0, 0);
  List<Marker> _shelterMarkers = [];
  bool _locationFetched = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _locationFetched = true;
      _fetchShelters();
    });
  }

  Future<void> _fetchShelters() async {
    // Simulate fetching shelters with random coordinates
    final random = Random();
    setState(() {
      _shelterMarkers = List.generate(5, (index) {
        // Randomly adjust the latitude and longitude
        double randomLat = _currentPosition.latitude + (random.nextDouble() - 0.5) * 0.02; // Adjust latitude
        double randomLng = _currentPosition.longitude + (random.nextDouble() - 0.5) * 0.02; // Adjust longitude
        return Marker(
          width: 80.0,
          height: 80.0,
          point: LatLng(randomLat, randomLng),
          builder: (ctx) => Container(
            child: Icon(Icons.pets, color: Colors.primaries[index % Colors.primaries.length]),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Nearby Pet Shelters'),
      ),
      body: _locationFetched
          ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search nearby shelters',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _currentPosition,
                zoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: _shelterMarkers,
                ),
              ],
            ),
          ),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
