import 'package:flutter/material.dart';

class MovieDetailScreen extends StatelessWidget {
  final Map<String, dynamic> movie;

  MovieDetailScreen({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (movie['image'] != null)
                Image.network(
                  movie['image']['original'],
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              if (movie['image'] == null)
                Container(
                  color: Colors.grey,
                  height: 200,
                  width: 200,
                ),
              SizedBox(height: 16),
              Text('Description', style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              Text(
                '${movie['summary']}',
                style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Ratings: ${movie['rating']['average'] ?? 'Not available'}',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600,color: const Color.fromARGB(255, 254, 92, 81)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
