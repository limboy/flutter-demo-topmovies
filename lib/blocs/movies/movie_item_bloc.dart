import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart' show BehaviorSubject;
import 'package:topmovies/models/movie.dart';
import 'package:topmovies/blocs/bloc_base.dart';
import 'package:topmovies/routes/router.dart';
import 'package:topmovies/pages/movie.dart';

class FavoriteNotification extends Notification {
  final bool isFavorite;
  final Movie movie;

  FavoriteNotification({this.isFavorite, this.movie});
}

class MovieItemBloc implements BlocBase {
  BehaviorSubject<Movie> _movie;

  Stream<Movie> get movie {
    return _movie.stream;
  }

  MovieItemBloc(Movie aMovie) {
    _movie = BehaviorSubject();
    if (aMovie != null) {
      _movie.add(aMovie);
    }
  }

  dispose() {
    // 这里不 close，因为 item widget 还会被复用，到时发现 bloc 处于 close 状态，就会抛 exception
    // _movie.close();
  }

  realDispose() {
    _movie.close();
  }

  toggleFavorite(BuildContext context) {
    var currentMovie = _movie.value;
    currentMovie.hasLiked = !currentMovie.hasLiked;
    FavoriteNotification(isFavorite: currentMovie.hasLiked, movie: currentMovie)
        .dispatch(context);
    _movie.add(currentMovie);
  }

  onTap(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      MoviePage moviePage = Router.getWidget(
          '/movie/${_movie.value.id}', context,
          params: {'movie': _movie.value});
      return moviePage;
    }));
  }
}
