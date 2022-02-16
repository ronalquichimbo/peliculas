import 'package:flutter/cupertino.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provide.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int moviedId;

  const CastingCards({Key? key, required this.moviedId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //creamos un provider de moviesprovider, listen para no volver a redibujar
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMoviesCast(moviedId),
      builder: (context, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            constraints: BoxConstraints(maxWidth: 150),
            height: 180,
            child: CupertinoActivityIndicator(),
          );
        }
        // para simplicar el snapshot
        final List<Cast> cast = snapshot.data!;
        return Container(
          margin: EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemCount: cast.length,
            //se enviar el parameneto
            itemBuilder: (_, int index) => _CastCard(
              actor: cast[index],
            ),
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;

  const _CastCard({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 180,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: AssetImage(
                'assets/loading.gif',
              ),
              image: NetworkImage(actor.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
