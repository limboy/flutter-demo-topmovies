import 'package:flutter/material.dart';
import 'package:topmovies/blocs/bloc_provider.dart';
import 'package:topmovies/blocs/movies/movie_detail_bloc.dart';
import 'package:topmovies/models/movie.dart';

class MovieSummary extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MovieSummaryState();
  }
}

class _MovieSummaryState extends State<MovieSummary> {
  String summary = 'loading...';
  bool shouldAddMoreArrow = false;
  Movie movie;

  onTapMore() {
    setState(() {
      summary = movie.summary;
      shouldAddMoreArrow = false;
    });
  }

  @override
  void initState() {
    final bloc = BlocProvider.of<MovieDetailBloc>(context);
    movie = bloc.breifMovie;

    bloc.movie.listen((aMovie) {
      movie = aMovie;
      if (aMovie.summary.length > 0) {
        summary = aMovie.summary;
      }

      if (summary.length > 120) {
        shouldAddMoreArrow = true;
        summary = summary.substring(0, 120) + '...';
      }
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                top: BorderSide(color: Colors.grey[300], width: 0.5),
                bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
        child: Column(
          children: <Widget>[
            Text(
              summary,
              style: TextStyle(color: Colors.black),
            ),
            (() {
              if (shouldAddMoreArrow) {
                return GestureDetector(
                    onTap: onTapMore,
                    child: Center(
                        child: Container(
                      height: 20,
                      width: 24,
                      // color: Colors.blue,
                      child: Center(child: Icon(Icons.arrow_drop_down)),
                    )));
              } else {
                return Container();
              }
            }())
          ],
        ),
      ),
    );
  }
}

class _MovieSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieDetailBloc>(context);
    return StreamBuilder<Movie>(
      stream: bloc.movie,
      initialData: bloc.breifMovie,
      builder: (context, snapshot) {
        final movie = snapshot.data;
        return Container(
          padding: EdgeInsets.only(top: 15),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey, width: 0.5),
                    bottom: BorderSide(color: Colors.grey, width: 0.5))),
            child: Text(movie.summary),
          ),
        );
      },
    );
  }
}
