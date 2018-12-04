import 'package:rxdart/rxdart.dart';
import 'package:topmovies/models/movie.dart';
import 'package:topmovies/env.dart';
import 'package:topmovies/blocs/bloc_base.dart';

class MoviesBloc extends BlocBase {
  final BehaviorSubject<List<Movie>> _movies = BehaviorSubject(seedValue: []);
  final BehaviorSubject<bool> _isLoadingMore = BehaviorSubject();
  var _currentStart = 0;
  var _displayedIndexes = List<int>();

  Observable<List<Movie>> get movies => _movies.stream;
  Observable<bool> get isLoadingMore => _isLoadingMore.stream;

  MoviesBloc() {
    _getMovies();
  }

  _getMovies() {
    Env.apiClient.getMovieList(_currentStart).then((movieEnvelope) {
      final _allMovies = List.of(_movies.value)..addAll(movieEnvelope.movies);
      _movies.add(_allMovies);
      _isLoadingMore.add(false);
      _currentStart += 20;
    });
  }

  displayingItemOfIndex(int index) {
    if (!_displayedIndexes.contains(index)) {
      _displayedIndexes.add(index);
    }

    if (index == _currentStart - 1) {
      if (!_isLoadingMore.value) {
        _isLoadingMore.add(true);
        _getMovies();
      }
    }
  }

  dispose() {
    _movies.close();
    _isLoadingMore.close();
  }
}
