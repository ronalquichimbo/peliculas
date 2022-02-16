import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provide.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar Peliculas';

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: Icon(Icons.arrow_back),
      //con este se puede enviar informarcion pero ahora se pone null porque no quiero enviar nada
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('buildres');
  }

  Widget _emptyContainer() {
    return Container(
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: Colors.black38,
          size: 130,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //indica si esta vacio el query.isEmpty
    if (query.isEmpty) {
      return _emptyContainer();
    }

    // creamos un provides y no se redibuja
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      //future: moviesProvider.searchMovie(query),

      stream: moviesProvider.suggestionStream,
      builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) => _MovieItem(movie: movies[index]),
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  final Movie movie;
  const _MovieItem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroid = 'searchmovies-${movie.id}detaikls';
    return ListTile(
        leading: Hero(
          tag: movie.heroid!,
          child: FadeInImage(
            placeholder: AssetImage('assets/no-image.jpg'),
            image: NetworkImage(movie.fullPosterImg),
            width: 50,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () {
          Navigator.pushNamed(context, 'details', arguments: movie);
        });
  }
}
