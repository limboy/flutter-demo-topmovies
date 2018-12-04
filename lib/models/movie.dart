import 'actor.dart';
import 'review.dart';
import 'comment.dart';

class Movie {
  String id;
  String rating;
  String title;
  String director;
  String year;
  String poster;
  String summary;
  String shortReview = '我是一条短评';
  bool hasLiked = false;
  List<Actor> actors;
  List<Review> reviews = [
    Review(),
    Review(),
    Review(),
    Review(),
  ];
  List<Comment> comments = [
    Comment(),
    Comment(),
    Comment(),
    Comment(),
  ];

  Movie(
      {this.id,
      this.rating,
      this.title,
      this.director,
      this.year,
      this.poster,
      this.summary,
      this.actors});

  Movie.fromJSON(Map<String, dynamic> json) {
    this.id = json['id'];
    this.rating = json['rating']['average'].toString();
    this.title = json['title'];
    this.director = json['directors'][0]['name'];
    this.year = json['year'];
    this.poster =
        (json['images']['small'] as String).replaceAll('s_ratio', 'm_ratio');
    this.summary = json['summary'] ?? '';
    this.actors = (json['casts'] as List).map((item) {
      final name = item['name'];
      if (item != null &&
          item['avatars'] != null &&
          item['avatars'].length > 0) {
        return Actor(name: name, avatar: item['avatars']['medium']);
      } else {
        return Actor(name: name);
      }
    }).toList();
  }
}

class MovieEnvelope {
  int count;
  int start;
  int total;
  List<Movie> movies;

  MovieEnvelope({this.count, this.start, this.total, this.movies});

  MovieEnvelope.fromJSON(Map data) {
    this.count = data['count'];
    this.start = data['start'];
    this.total = data['total'];
    List<Movie> movies = [];
    (data['subjects'] as List).forEach((item) {
      Movie movie = Movie.fromJSON(item);
      movies.add(movie);
    });
    this.movies = movies;
  }
}
