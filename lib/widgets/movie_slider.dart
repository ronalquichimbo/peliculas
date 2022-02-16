import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  const MovieSlider(
      {Key? key,
      required this.onNextPage,
      required this.movies,
      this.title = "POPULAR"})
      : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        this.widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.movies.length == 0) {
      return Container(
        width: double.infinity,
        height: 260,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (this.widget.title != null) //...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                this.widget.title!,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          // ] else ...[
          //   Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 20),
          //     child: Text(
          //       "Popular",
          //       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //     ),
          //   ),
          // ],
          SizedBox(
            height: 7,
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, int index) =>
                  _MoviePoster(movie: widget.movies[index]),
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;

  const _MoviePoster({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroid = 'popularesmovies-${movie.id}';
    return Container(
      child: Container(
        width: 130,
        height: 190,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () =>
                  Navigator.pushNamed(context, 'details', arguments: movie),
              child: Hero(
                tag: movie.heroid!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/loading.gif'),
                    image: NetworkImage(
                      movie.fullPosterImg,
                    ),
                    width: 130,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
