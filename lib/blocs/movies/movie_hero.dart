import 'package:flutter/material.dart';
import 'package:topmovies/models/movie.dart';
import 'package:topmovies/blocs/bloc_provider.dart';
import 'package:topmovies/blocs/movies/movie_detail_bloc.dart';

class MovieHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieDetailBloc>(context);
    return StreamBuilder<Movie>(
      stream: bloc.movie,
      initialData: bloc.breifMovie,
      builder: (context, snapshot) {
        final Movie movie = snapshot.data;
        return SliverAppBar(
          // title: Text(movie.title),
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            title: Text(movie.title),
            background: Hero(
              tag: 'movie-${movie.id}',
              child: Image.network(
                movie.poster,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
