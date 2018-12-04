import 'dart:io';
import 'api.dart';
import 'dart:convert';
import 'package:topmovies/models/movie.dart';

class RealAPI extends API {
  @override
  Future<MovieEnvelope> getMovieList(int start) async {
    var client = HttpClient();
    var request = await client.getUrl(
        Uri.parse('https://api.douban.com/v2/movie/top250?start=$start'));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    return MovieEnvelope.fromJSON(data);
  }

  @override
  Future<Movie> getMovie(String movieID) async {
    var client = HttpClient();
    var request = await client
        .getUrl(Uri.parse('https://api.douban.com/v2/movie/subject/$movieID'));
    var response = await request.close();
    var responseBody = await response.transform(utf8.decoder).join();
    Map data = json.decode(responseBody);
    return Movie.fromJSON(data);
  }
}
