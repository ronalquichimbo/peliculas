import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provide.dart';
import 'package:peliculas/search/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Películas en cines',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search_rounded,
                color: Colors.white,
              ),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //tarjeyas  principales
              CardSwiper(
                movies: moviesProvider.onDisplayMovies,
              ),
              //slider peliculas
              MovieSlider(
                movies: moviesProvider.popularMovies,
                title: "Popular",
                onNextPage: () => moviesProvider.getPopularMovies(),
              ),
            ],
          ),
        ));
  }
}
