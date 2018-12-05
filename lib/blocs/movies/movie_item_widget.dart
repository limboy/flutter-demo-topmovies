import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'movie_item_bloc.dart';
import 'package:topmovies/blocs/bloc_provider.dart';
import 'package:topmovies/models/movie.dart';
import 'package:transparent_image/transparent_image.dart';

class MovieFavPopupMixin {
  showPopup(BuildContext context, MovieItemBloc bloc, Movie movie) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (_context) {
            final likeAction = CupertinoActionSheetAction(
              onPressed: () {
                bloc.toggleFavorite(context);
                Navigator.of(context).pop();
              },
              child: Text(movie.hasLiked ? '取消收藏' : '收藏'),
            );

            final cancelAction = CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            );

            final actionSheet = CupertinoActionSheet(
              message: Text('如果觉得电影不错的话，可以收藏哦'),
              actions: <Widget>[
                likeAction,
              ],
              cancelButton: cancelAction,
            );

            return actionSheet;
          });
    } else {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext _context) {
            return SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.favorite_border),
                    title: Text(movie.hasLiked ? '取消收藏' : '收藏'),
                    onTap: () {
                      bloc.toggleFavorite(context);
                    },
                  )
                ],
              ),
            );
          });
    }
  }
}

class MovieItemBig extends StatelessWidget with MovieFavPopupMixin {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieItemBloc>(context);
    return StreamBuilder(
      stream: bloc.movie,
      builder: (context, snapshot) {
        final movie = snapshot.data as Movie;
        if (movie == null) {
          return Container();
        }

        return Container(
            color: Colors.black87,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => bloc.onTap(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Image.network(
                          movie.poster,
                          width: 150,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 30,
                          height: 18,
                          child: Container(
                              alignment: Alignment.center,
                              color: Colors.green,
                              child: Text(
                                movie.rating,
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                      ],
                    ),
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        movie.title,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showPopup(context, bloc, movie);
                                      },
                                      child: Icon(
                                        Icons.more_vert,
                                        size: 20,
                                        color: movie.hasLiked
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                ),
                                Text(
                                  '导演: ${movie.director}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white54),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                ),
                                Text(
                                  '主演: ${movie.actors[0].name}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white54),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                ),
                                Text(
                                  '上映: ${movie.year}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white54),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                Text(
                                  movie.shortReview,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                ),
                              ],
                            )))
                  ],
                ),
              ),
            ));
      },
    );
  }
}

class MovieItemSmall extends StatelessWidget with MovieFavPopupMixin {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieItemBloc>(context);
    return StreamBuilder(
        stream: bloc.movie,
        builder: (context, snapshot) {
          final movie = snapshot.data as Movie;
          if (movie == null) {
            return Container();
          }
          return LayoutBuilder(builder: (context, constraints) {
            return Material(
              color: Colors.grey,
              child: InkWell(
                onTap: () => bloc.onTap(context),
                child: Stack(children: <Widget>[
                  Positioned.fill(
                    child: Hero(
                      tag: 'movie-${movie.id}',
                      child: FadeInImage.memoryNetwork(
                        image: movie.poster,
                        fadeInDuration: Duration(milliseconds: 200),
                        placeholder: kTransparentImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned.fromRect(
                    rect: Rect.fromLTWH(0, 0, 30, 18),
                    child: Container(
                        alignment: Alignment.center,
                        color: Colors.green,
                        child: Text(
                          movie.rating,
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                  Positioned.fill(
                      left: 0,
                      top: constraints.maxHeight - 60,
                      child: Container(
                          color: Colors.black87,
                          child: Padding(
                            padding: EdgeInsets.all(7.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          movie.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showPopup(context, bloc, movie);
                                        },
                                        child: Icon(
                                          Icons.more_vert,
                                          size: 18,
                                          color: movie.hasLiked
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    movie.actors
                                        .map((actor) => actor.name)
                                        .join("/"),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.white70, fontSize: 14),
                                  ),
                                ]),
                          ))),
                ]),
              ),
            );
          });
        });
  }
}
