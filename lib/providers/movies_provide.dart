import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncer.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = "19171d76ca001a3af5f7ab9c6e0eed67";
  String _baseUrl = "api.themoviedb.org";
  String _language = "es-ES";
  int _con = 0;

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  //int es de la pelicula
  Map<int, List<Cast>> moviesCast = {};

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
  );

//StreamControl
  final StreamController<List<Movie>> _suggestionStreamContoller =
      new StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      this._suggestionStreamContoller.stream;

  MoviesProvider() {
    print('MoviesProvider inicializado');
    this.getOnDisplayerMovies();
    this.getPopularMovies();
    //_suggestionStreamContoller.close();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayerMovies() async {
    print('getOndDisplayerMOvies');

    // Await the http get response, then decode the json-formatted response.

    final jsonData = await _getJsonData('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovies = nowPlayingResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _con++;
    final jsonData = await _getJsonData('3/movie/popular', _con);

    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];

    notifyListeners();
  }

  //se crea un future para tener un metodo asincrono.

  Future<List<Cast>> getMoviesCast(int movieId) async {
    //Todo: Revisar el mapa
    // para cargar en memoria
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await _getJsonData('3/movie/$movieId/credits');

    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    final url = Uri.https(_baseUrl, "3/search/movie", {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
      'query': query
    });
    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searcTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      //
      //print("tenemos valores a buscar: $value");
      final results = await this.searchMovie(value);
      this._suggestionStreamContoller.add(results);
    };
    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = searcTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
