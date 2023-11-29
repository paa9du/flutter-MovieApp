


// import 'package:flutter/material.dart';
// import 'package:flutter_movie_app/screens/TopRatedScreen.dart';
// import 'package:flutter_movie_app/screens/movie_details_screen.dart';
// import 'package:flutter_movie_app/screens/movie_list_screen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../data/models/movie.dart';
// // Import the MovieDetails model

// class TopRatedScreen extends StatefulWidget {
//   const TopRatedScreen({Key? key}) : super(key: key);

//   @override
//   _TopRatedScreenState createState() => _TopRatedScreenState();
// }

// class _TopRatedScreenState extends State<TopRatedScreen> {
//   double width = double.infinity;
//   late TextEditingController _textController;
//   late Future<List<MovieModel>> futureMovies;
//   String text = 'Clear';
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _textController = TextEditingController();
//     futureMovies = fetchMovies();
//   }

//   Future<List<MovieModel>> fetchMovies() async {
//     final response = await http.get(Uri.parse(
//         'https://api.themoviedb.org/3/movie/top_rated?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body)['results'];
//       return data.map((json) => MovieModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load movies');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: SearchBar(),
//       body: FutureBuilder<List<MovieModel>>(
//         future: futureMovies,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             List<MovieModel> movies = snapshot.data!;
//             return ListView.builder(
//               itemCount: movies.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             MovieDetailsScreen(movieId: movies[index].id),
//                       ),
//                     );
//                   },
//                   child:
//                       // ListTile(
//                       //   title: Padding(
//                       //     padding: const EdgeInsets.all(10.0),
//                       //     child: Text(
//                       //       movies[index].title,
//                       //       style: TextStyle(
//                       //         color: Colors.black,
//                       //         fontSize: 20,
//                       //         fontWeight: FontWeight.bold,
//                       //       ),
//                       //     ),
//                       //   ),
//                       //   subtitle: Padding(
//                       //     padding: const EdgeInsets.all(10.0),
//                       //     child: Text(
//                       //       movies[index].overview,
//                       //       maxLines: 4,
//                       //       overflow: TextOverflow.ellipsis,
//                       //     ),
//                       //   ),
//                       //   leading: Container(
//                       //     width: 110,
//                       //     height: double.infinity,
//                       //     child: Image.network(
//                       //       'https://image.tmdb.org/t/p/w200${movies[index].posterPath}',
//                       //       fit: BoxFit.cover,
//                       //     ),
//                       //   ),
//                       // ),
//                       Card(
//                     color: Color.fromARGB(255, 213, 152, 8),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 MovieDetailsScreen(movieId: movies[index].id),
//                           ),
//                         );
//                       },
//                       child: Row(
//                         children: [
//                           Container(
//                             width: 110,
//                             height: 150, // Adjust the height as needed
//                             child: Image.network(
//                               'https://image.tmdb.org/t/p/w200${movies[index].posterPath}',
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     movies[index].title,
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     movies[index].overview,
//                                     maxLines: 4,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       bottomNavigationBar: Container(
//         height: MediaQuery.of(context).size.height *
//             0.08, // Set the height as a percentage of the screen height
//         child: BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.movie_sharp,
//                 size: 40,
//               ),
//               label: 'Now Playing',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.star,
//                 size: 40,
//               ),
//               label: 'Top Rated',
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//         ),
//       ),
//     );
//   }

//   AppBar SearchBar() {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       title: Container(
//         width: width,
//         height: 45,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: TextField(
//               controller: _textController,
//               textAlign: TextAlign.center,
//               onTap: () {
//                 setState(() {
//                   width = 280;
//                   if (width == double.infinity) {
//                   } else {
//                     text = 'Clear';
//                   }
//                 });
//               },
//               onChanged: (text) {
//                 setState(() {
//                   width = text.isEmpty ? double.infinity : 280;
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 10.0,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   size: 23,
//                 ),
//                 suffixIcon: _textController.text.isEmpty
//                     ? null
//                     : GestureDetector(
//                         onTap: () {
//                           _textController.clear();
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Icon(
//                             Icons.clear,
//                             size: 23,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       if (index == 0) {
//         // Handle Home tap
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => MovieListScreen(),
//             ));
//       } else if (index == 1) {
//         // Handle Favorites tap
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => TopRatedScreen(),
//             ));
//       }
//     });
//     // You can add logic here for each tab
//     // For example, navigate to a different screen based on the index
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }
// }









//------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_movie_app/screens/TopRatedScreen.dart';
// import 'package:flutter_movie_app/screens/movie_details_screen.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../data/models/movie.dart';
// // Import the MovieDetails model

// class MovieListScreen extends StatefulWidget {
//   const MovieListScreen({Key? key}) : super(key: key);

//   @override
//   _MovieListScreenState createState() => _MovieListScreenState();
// }

// class _MovieListScreenState extends State<MovieListScreen> {
//   double width = double.infinity;
//   late TextEditingController _textController;
//   late Future<List<MovieModel>> futureMovies;
//   String text = 'Clear';
//   int _selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _textController = TextEditingController();
//     futureMovies = fetchMovies();
//   }

//   Future<List<MovieModel>> fetchMovies() async {
//     final response = await http.get(Uri.parse(
//         'https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed'));

//     if (response.statusCode == 200) {
//       final List<dynamic> data = jsonDecode(response.body)['results'];
//       return data.map((json) => MovieModel.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load movies');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: SearchBar(),
//       body: FutureBuilder<List<MovieModel>>(
//         future: futureMovies,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             List<MovieModel> movies = snapshot.data!;
//             return ListView.builder(
//               shrinkWrap: true,
//               itemCount: movies.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   //   color: Color.fromARGB(255, 213, 152, 8),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               MovieDetailsScreen(movieId: movies[index].id),
//                         ),
//                       );
//                     },
//                     child:
//                         // ListTile(
//                         //   title: Padding(
//                         //     padding: const EdgeInsets.all(10.0),
//                         //     child: Text(
//                         //       movies[index].title,
//                         //       style: TextStyle(
//                         //         color: Colors.black,
//                         //         fontSize: 20,
//                         //         fontWeight: FontWeight.bold,
//                         //       ),
//                         //     ),
//                         //   ),
//                         //   subtitle: Padding(
//                         //     padding: const EdgeInsets.all(10.0),
//                         //     child: Text(
//                         //       movies[index].overview,
//                         //       maxLines: 4,
//                         //       overflow: TextOverflow.ellipsis,
//                         //     ),
//                         //   ),
//                         //   leading: Image.network(
//                         //     'https://image.tmdb.org/t/p/w200${movies[index].posterPath}',
//                         //     fit: BoxFit.cover,
//                         //   ),
//                         // ),
//                         Card(
//                       color: Color.fromARGB(255, 213, 152, 8),
//                       child: InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   MovieDetailsScreen(movieId: movies[index].id),
//                             ),
//                           );
//                         },
//                         child: Row(
//                           children: [
//                             Container(
//                               width: 110,
//                               height: 150, // Adjust the height as needed
//                               child: Image.network(
//                                 'https://image.tmdb.org/t/p/w200${movies[index].posterPath}',
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       movies[index].title,
//                                       style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: 20),
//                                     Text(
//                                       movies[index].overview,
//                                       maxLines: 4,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//       bottomNavigationBar: Container(
//         height: MediaQuery.of(context).size.height *
//             0.08, // Set the height as a percentage of the screen height
//         child: BottomNavigationBar(
//           items: const <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.movie_sharp,
//                 size: 40,
//               ),
//               label: 'Now Playing',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.star,
//                 size: 40,
//               ),
//               label: 'Top Rated',
//             ),
//           ],
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//         ),
//       ),
//     );
//   }

//   AppBar SearchBar() {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       title: Container(
//         width: width,
//         height: 45,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: TextField(
//               controller: _textController,
//               textAlign: TextAlign.center,
//               onTap: () {
//                 setState(() {
//                   width = 280;
//                   if (width == double.infinity) {
//                   } else {
//                     text = 'Clear';
//                   }
//                 });
//               },
//               onChanged: (text) {
//                 setState(() {
//                   width = text.isEmpty ? double.infinity : 280;
//                 });
//               },
//               decoration: InputDecoration(
//                 hintText: 'Search',
//                 hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
//                 contentPadding: EdgeInsets.symmetric(
//                   vertical: 10.0,
//                 ),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   size: 23,
//                 ),
//                 suffixIcon: _textController.text.isEmpty
//                     ? null
//                     : GestureDetector(
//                         onTap: () {
//                           _textController.clear();
//                         },
//                         child: Container(
//                           padding: EdgeInsets.symmetric(horizontal: 8.0),
//                           child: Icon(
//                             Icons.clear,
//                             size: 23,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//       if (index == 0) {
//         // Handle Home tap
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => MovieListScreen(),
//             ));
//       } else if (index == 1) {
//         // Handle Favorites tap
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => TopRatedScreen(),
//             ));
//       }
//     });
//     // You can add logic here for each tab
//     // For example, navigate to a different screen based on the index
//   }

//   @override
//   void dispose() {
//     _textController.dispose();
//     super.dispose();
//   }
// }
