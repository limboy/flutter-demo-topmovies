import 'package:flutter/material.dart';
import 'package:topmovies/models/movie.dart';
import 'package:topmovies/blocs/bloc_provider.dart';
import 'package:topmovies/blocs/movies/movie_detail_bloc.dart';
import 'package:topmovies/widgets/movies/movie_hero.dart';
import 'package:topmovies/widgets/movies/movie_actors.dart';
import 'package:topmovies/widgets/movies/movie_summary.dart';
import 'package:topmovies/widgets/movies/movie_reviews.dart';

class MoviePage extends StatefulWidget {
  final String movieID;
  final Movie movie;
  MoviePage({Key key, this.movieID, this.movie}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    final bloc = MovieDetailBloc(movieID: movieID, breifMovie: movie);
    return _MoviePageState(bloc: bloc);
  }
}

class _MoviePageState extends State<MoviePage> {
  final MovieDetailBloc bloc;
  Movie movie;
  TabContentType currentTabType = TabContentType.reviews;

  _MoviePageState({this.bloc, Movie movie});

  @override
  void initState() {
    movie = bloc.breifMovie;
    bloc.movie.listen((_movie) {
      setState(() {
        movie = _movie;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff4f4f4),
        body: BlocProvider(
          bloc: bloc,
          child: (() {
            if (movie == null) {
              return Center(
                child: Text('loading'),
              );
            } else {
              return NotificationListener<TabSwitchNotification>(
                onNotification: (notification) {
                  setState(() {
                    currentTabType = notification.tabContentType;
                  });
                },
                child: DefaultTabController(
                    length: 2,
                    child: SafeArea(
                        top: false,
                        child: CustomScrollView(
                          slivers: <Widget>[
                            MovieHero(),
                            SliverToBoxAdapter(
                              child: MovieSummary(),
                            ),
                            SliverToBoxAdapter(
                              child: MovieActors(),
                            ),
                            SliverPadding(
                              padding: EdgeInsets.all(7.0),
                            ),
                            MovieReviewTabbar(),
                            MovieReviewTabbarContent(
                              tabContentType: currentTabType,
                            ),
                          ],
                        ))),
              );
            }
          }()),
        ));
  }
}
