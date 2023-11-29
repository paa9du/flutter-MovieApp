import 'package:flutter/material.dart';
import 'package:flutter_movie_app/screens/TopRatedScreen.dart';
import 'package:flutter_movie_app/screens/NowPlayingScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/models/MovieDetails_Model.dart';

class MovieDetailsScreen1 extends StatefulWidget {
  final int movieId;
  const MovieDetailsScreen1({Key? key, required this.movieId})
      : super(key: key);

  @override
  _MovieDetailsScreen1State createState() => _MovieDetailsScreen1State();
}

class _MovieDetailsScreen1State extends State<MovieDetailsScreen1> {
  int _selectedIndex = 0;
  late Future<MovieDetails> futureMovieDetails;

  @override
  void initState() {
    super.initState();
    futureMovieDetails = fetchMovieDetails(widget.movieId);
  }

  Future<MovieDetails> fetchMovieDetails(int movieId) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'));

    if (response.statusCode == 200) {
      print(response.body); // Debug print
      final Map<String, dynamic> data = jsonDecode(response.body);
      return MovieDetails.fromJson(data);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          child: const Text(
            "Back",
            style: TextStyle(color: Colors.black),
          ),
        ),
        centerTitle: false,
      ),
      body: FutureBuilder<MovieDetails>(
        future: futureMovieDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          } else {
            MovieDetails movieDetails = snapshot.data!;
            print('Title: ${movieDetails.title}'); // Debug print
            print('Release Date: ${movieDetails.releaseDate}'); // Debug print
            // Add more print statements for other fields

            return Stack(
              children: [
                // Background Cover
                Image.network(
                  'https://image.tmdb.org/t/p/original${movieDetails.backdropPath}',
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                ),
                // Details Box
                Container(
                  padding: const EdgeInsets.only(
                      top: 200.0, right: 40.0, left: 60.0, bottom: 20.0),
                  child: ColoredBox(
                    color:
                        const Color.fromARGB(255, 67, 67, 67).withOpacity(0.7),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text with black background
                          Container(
                            child: Text(
                              movieDetails.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 18),
                          // Other text without black background
                          Text(
                            'Release Date: ${movieDetails.releaseDate}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Row(
                            children: [
                              Icon(
                                Icons.arrow_upward,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '10%',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                width: 80,
                              ),
                              Icon(
                                Icons.alarm,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '0 hr 0 mins',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),
                          Text(
                            'Overview: ${movieDetails.overview}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Average Vote: ${movieDetails.voteAverage}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height *
            0.08, // Set the height as a percentage of the screen height
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.movie_sharp,
                size: 40,
              ),
              label: 'Now Playing',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                size: 40,
              ),
              label: 'Top Rated',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        // Handle Home tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieListScreen(),
          ),
        );
      } else if (index == 1) {
        // Handle Favorites tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopRatedScreen(),
          ),
        );
      }
    });
    // You can add logic here for each tab
    // For example, navigate to a different screen based on the index
  }
}
