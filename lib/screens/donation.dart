import 'package:flutter/material.dart';

class DonationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate to Help Pets"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView( // Makes the page scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Image from Assets
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  'assets/images/donation.jpg', // Asset path
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),

              // Donation Title
              Text(
                "Make a Difference!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[900],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),

              // Donation Description
              Text(
                "Your donations help us provide food, shelter, and medical care to pets in need. "
                    "Choose an amount to make a change today.",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Donation Amounts Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _donationButton(context, "₹100"),
                  _donationButton(context, "₹500"),
                  _donationButton(context, "₹1000"),
                  _donationButton(context, "Other"),
                ],
              ),
              SizedBox(height: 20),

              // Custom Amount Input
              TextField(
                decoration: InputDecoration(
                  labelText: "Enter a custom amount",
                  prefixIcon: Icon(Icons.currency_rupee, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),

              // Donate Button
              ElevatedButton(
                onPressed: () {
                  // Handle donation logic
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15), backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Donate Now",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // Thank You Note
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Thank you for your generosity!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.teal[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Donation Button Widget
  Widget _donationButton(BuildContext context, String amount) {
    return ElevatedButton(
      onPressed: () {
        // Handle donation amount selection
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        amount,
        style: TextStyle(
          fontSize: 18,
          color: Colors.teal[900],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
