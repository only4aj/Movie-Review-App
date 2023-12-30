import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'search_screen.dart';
import 'details_screen.dart';

class MovieScreen extends StatefulWidget {
  @override
  _MovieScreenState createState() => _MovieScreenState();
}

class _MovieScreenState extends State<MovieScreen> {
  int index = 0;
  final http.Client client = http.Client();
  List<dynamic> movies = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await client.get(
        Uri.parse('http://api.tvmaze.com/search/shows?q=all'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          movies = responseData;
        });
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 246, 218),
        title: Text(
          'Movie Reviews',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 56, 43, 43),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
            },
            icon: Icon(Icons.search),
            color: Color.fromARGB(255, 56, 43, 43),
            iconSize: 30,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (selectedIndex) {
          setState(() {
            index = selectedIndex;
            if (index == 1) {
              // Navigate to SearchScreen when "Find" is tapped
              Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
            }
          });
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_searching_rounded),
            label: 'Find',
          ),
        ],
      ),
      body: movies.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text('Movies', style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold, color: Color.fromARGB(255, 89, 58, 46)),),
                  for (var movie in movies)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailScreen(movie: movie['show']),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (movie['show']['image'] != null)
                                Image.network(
                                  movie['show']['image']['original'],
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              if (movie['show']['image'] == null)
                                Container(
                                  color: Colors.grey,
                                  height: 200,
                                  width: double.infinity,
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  movie['show']['name'] ?? 'Unknown Title',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  movie['show']['summary'] ?? 'No summary available',
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
            ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MovieScreen(),
  ));
}
