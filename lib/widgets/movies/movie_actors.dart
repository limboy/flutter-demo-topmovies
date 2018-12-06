import 'package:flutter/material.dart';
import 'package:topmovies/blocs/movies/movie_detail_bloc.dart';
import 'package:topmovies/blocs/bloc_provider.dart';
import 'package:topmovies/models/movie.dart';
import 'package:topmovies/models/actor.dart';

const _defaultAvatar =
    'https://img3.doubanio.com/f/movie/8dd0c794499fe925ae2ae89ee30cd225750457b4/pics/movie/celebrity-default-medium.png';

class _MovieActor extends StatelessWidget {
  final Actor actor;
  _MovieActor({Key key, this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: LayoutBuilder(builder: (context, constraint) {
        final height = constraint.maxHeight;
        return Column(
          children: <Widget>[
            Container(
              height: height - 30,
              width: double.infinity,
              child: Image.network(
                actor.avatar == null ? _defaultAvatar : actor.avatar,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              actor.name,
              overflow: TextOverflow.ellipsis,
            )
          ],
        );
      }),
    );
  }
}

class MovieActors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieDetailBloc>(context);
    return StreamBuilder<Movie>(
      stream: bloc.movie,
      initialData: bloc.breifMovie,
      builder: (context, snapshot) {
        final movie = snapshot.data;
        return Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 7.0),
            ),
            Container(
                padding: EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey[300], width: 0.5),
                      bottom: BorderSide(color: Colors.grey[300], width: 0.5),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          '影人',
                          style: TextStyle(fontSize: 18),
                        )),
                    Container(
                      height: 180,
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        itemExtent: 120,
                        scrollDirection: Axis.horizontal,
                        children: movie.actors
                            .map<Widget>((actor) => _MovieActor(
                                  actor: actor,
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                )),
          ],
        );
      },
    );
  }
}
