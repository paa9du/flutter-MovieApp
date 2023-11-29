import 'package:flutter/material.dart';
import 'package:flutter_movie_app/screens/TopRatedScreen.dart';
import 'package:flutter_movie_app/screens/NowPlaying_MovieDetails.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../data/models/movieList_Model.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  double width = double.infinity;
  late TextEditingController _textController;
  late Future<List<MovieModel>> futureMovies;
  String text = 'Clear';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    // Initially, fetch all movies
    futureMovies = fetchMovies('');
  }

  Future<List<MovieModel>> fetchMovies(String query) async {
    // Use the search API only if a non-empty query is provided
    final apiUrl = query.isNotEmpty
        ? 'https://api.themoviedb.org/3/search/movie?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&query=$query'
        : 'https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['results'];
      return data.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchBar(),
      body: FutureBuilder<List<MovieModel>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<MovieModel> movies = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailsScreen(movieId: movies[index].id),
                        ),
                      );
                    },
                    child: Card(
                      color: Color.fromARGB(255, 213, 152, 8),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailsScreen(movieId: movies[index].id),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 110,
                              height: 150,
                              child: Image.network(
                                'https://image.tmdb.org/t/p/w200${movies[index].posterPath}',
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movies[index].title,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      movies[index].overview,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height * 0.08,
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

  AppBar SearchBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        width: width,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextField(
              controller: _textController,
              textAlign: TextAlign.center,
              // onTap: () {
              //   setState(() {
              //     width = double.infinity;
              //     if (width == double.infinity) {
              //     } else {
              //       text = 'Clear';
              //     }
              //   });
              // },
              onChanged: (text) {
                setState(() {
                  // width = text.isEmpty ? double.infinity : 280;
                  futureMovies = fetchMovies(text);
                });
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 23,
                ),
                suffixIcon: _textController.text.isEmpty
                    ? null
                    : GestureDetector(
                        onTap: () {
                          _textController.clear();
                          setState(() {
                            // If the text field is cleared, fetch all movies
                            futureMovies = fetchMovies('');
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: const Icon(
                            Icons.clear,
                            size: 23,
                            color: Colors.black,
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieListScreen(),
          ),
        );
      } else if (index == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TopRatedScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
