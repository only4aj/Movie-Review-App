import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];

  Future<void> searchMovies(String searchTerm) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.tvmaze.com/search/shows?q=$searchTerm'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          searchResults = responseData;
        });
      } else {
        throw Exception('Failed to search movies');
      }
    } catch (error) {
      print('Error searching movies: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Enter search term',
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final searchTerm = searchController.text;
                  if (searchTerm.isNotEmpty) {
                    // Perform search
                    searchMovies(searchTerm);
                  }
                },
                child: Text('Search'),
              ),
              SizedBox(height: 16),
              if (searchResults.isNotEmpty)
                Column(
                  children: [
                    Text(
                      'Search Results:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    for (var result in searchResults)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailScreen(movie: result['show']),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (result['show']['image'] != null)
                                  Image.network(
                                    result['show']['image']['original'],
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                if (result['show']['image'] == null)
                                  Container(
                                    color: Colors.grey,
                                    height: 200,
                                    width: double.infinity,
                                  ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    result['show']['name'] ?? 'Unknown Title',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    result['show']['summary'] ?? 'No summary available',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
