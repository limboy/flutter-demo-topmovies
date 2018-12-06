import 'package:flutter/material.dart';
import 'env.dart';
import 'services/real_api.dart';
import 'blocs/bloc_provider.dart';
import 'blocs/movies/movies_bloc.dart';
import 'routes/routes.dart';
import 'package:topmovies/pages/home.dart';

void main() {
  Env.apiClient = RealAPI();
  Routes.configureRoutes();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        bloc: MoviesBloc(),
        child: MaterialApp(
          title: 'Douban Movie Top 250',
          home: Home(),
        ));
  }
}
