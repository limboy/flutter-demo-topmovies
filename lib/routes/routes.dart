import 'package:flutter/material.dart';
import 'package:topmovies/pages/home.dart';
import 'package:topmovies/pages/movie.dart';
import 'router.dart';

class Routes {
  static String root = '/';
  static String detail = '/movie/{id}';

  static configureRoutes() {
    Router.register(root, (BuildContext context, Map urlParams, {Map params}) {
      return Home();
    });

    Router.register(detail, (BuildContext context, Map urlParams,
        {Map params}) {
      return MoviePage(
        movieID: urlParams['id'],
        movie:
            params != null && params['movie'] != null ? params['movie'] : null,
      );
    });
  }
}
