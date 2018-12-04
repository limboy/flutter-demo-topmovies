import 'package:topmovies/models/movie.dart';

// 抽象出这个类是为了方便测试
abstract class API {
  Future<MovieEnvelope> getMovieList(int start);
  Future<Movie> getMovie(String movieID);
}
