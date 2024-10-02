import 'package:flutter/material.dart';
import 'package:pet_app/screens/blog/blogs_modal.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  BlogDetailScreen({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Image at the top
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(blog.imagePath), // Use the blog's image from assets
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Blog Title
                  Text(
                    blog.title,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Blog Description (optional summary)
                  Text(
                    blog.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                  Divider(height: 30, thickness: 1),

                  // Blog Content (longer text with better formatting)
                  Text(
                    blog.content,
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5, // Improve line spacing for readability
                    ),
                    textAlign: TextAlign.justify, // Align content evenly
                  ),

                  // Add spacing at the end
                  SizedBox(height: 20),

                  // Optional: You can add a "Read More" button at the end
                  ElevatedButton(
                    onPressed: () {
                      // Implement any action (e.g., navigate to full article page)
                    },
                    child: Text('Read More'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

