import 'package:flutter/material.dart';

class Movie_Cell extends StatefulWidget {
  const Movie_Cell({super.key});

  @override
  State<Movie_Cell> createState() => _Movie_CellState();
}

class _Movie_CellState extends State<Movie_Cell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 204, 142, 10),
    );
  }
}
