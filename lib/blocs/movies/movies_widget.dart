import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:topmovies/models/movie.dart';
import 'package:flutter/cupertino.dart';
import 'package:topmovies/blocs/bloc_provider.dart';
import 'package:topmovies/blocs/movies/movies_bloc.dart';
import 'movie_item_widget.dart';
import 'movie_item_bloc.dart';

const int _childrenPerBlock = 5;
const int _rowsPerBlock = 3;

class _MoviesGridLayout extends SliverGridLayout {
  const _MoviesGridLayout({
    @required this.rowStride,
    @required this.columnStride,
    @required this.tileHeight,
    @required this.tileWidth,
  });

  final double rowStride; // 一行有多高
  final double columnStride; // 一列有多宽
  final double tileHeight; // 一行有多高（不带 spacing）
  final double tileWidth; // 一列有多宽（不带 spacing）

  int rowOfIndex(int index) {
    return index ~/ _childrenPerBlock * _rowsPerBlock +
        <int>[0, 1, 1, 2, 2][index % _childrenPerBlock];
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    final nthRow = scrollOffset ~/ rowStride;
    return <int>[0, 1, 3][nthRow % _rowsPerBlock] +
        nthRow ~/ _rowsPerBlock * _childrenPerBlock;
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final nthRow = scrollOffset ~/ rowStride;
    return <int>[0, 2, 4][nthRow % _rowsPerBlock] +
        nthRow ~/ _rowsPerBlock * _childrenPerBlock;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    return SliverGridGeometry(
      crossAxisExtent:
          <int>[1, 0, 0, 0, 0][index % _childrenPerBlock] * columnStride +
              tileWidth,
      mainAxisExtent: tileHeight,
      crossAxisOffset:
          <int>[0, 0, 1, 0, 1][index % _childrenPerBlock] * columnStride,
      scrollOffset: rowOfIndex(index) * rowStride,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    return rowOfIndex(childCount) * rowStride;
  }
}

class _MoviesGridDelegate extends SliverGridDelegate {
  static const int _spacing = 10;

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth = (constraints.crossAxisExtent - _spacing) / 2.0;
    const double tileHeight = 250;
    return _MoviesGridLayout(
      tileWidth: tileWidth,
      tileHeight: tileHeight,
      rowStride: tileHeight + _spacing,
      columnStride: tileWidth + _spacing,
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegate oldDelegate) {
    return false;
  }
}

class Movies extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MoviesState();
  }
}

class _MoviesState extends State<Movies> {
  // 等到 dispose 时，统一 close
  Set<MovieItemBloc> itemBlocs = Set();

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MoviesBloc>(context);
    return StreamBuilder<List<Movie>>(
        stream: bloc.movies,
        builder: (context, snapshot) {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          }

          final movies = snapshot.data;

          return GridView.builder(
            gridDelegate: _MoviesGridDelegate(),
            padding: EdgeInsets.all(10.0),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              bloc.displayingItemOfIndex(index);
              final movieBloc = MovieItemBloc(movies[index]);
              itemBlocs.add(movieBloc);
              if (((index + 1) % _childrenPerBlock) == 1) {
                return BlocProvider(
                  bloc: movieBloc,
                  child: MovieItemBig(),
                );
              } else {
                return BlocProvider(
                  bloc: movieBloc,
                  child: MovieItemSmall(),
                );
              }
            },
          );
        });
  }

  @override
  void dispose() {
    itemBlocs.forEach((bloc) => bloc.realDispose());
    super.dispose();
  }
}
