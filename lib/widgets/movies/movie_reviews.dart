import 'package:flutter/material.dart';
import 'package:topmovies/blocs/bloc_provider.dart';
import 'package:topmovies/blocs/movies/movie_detail_bloc.dart';
import 'package:topmovies/models/review.dart';
import 'package:topmovies/models/movie.dart';

enum TabContentType {
  reviews,
  comments,
}

class TabSwitchNotification extends Notification {
  final TabContentType tabContentType;

  TabSwitchNotification({this.tabContentType});
}

class _MovieReviewTabbarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _MovieReviewTabbarDelegate({this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
          top: BorderSide(width: 0.5, color: Colors.grey[300]),
          bottom: BorderSide(width: 0.5, color: Colors.grey[300]),
        )),
        height: tabBar.preferredSize.height,
        child: Material(color: Colors.white, child: tabBar));
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class MovieReviewTabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _controller = DefaultTabController.of(context);
    _controller.addListener(() {
      if (_controller.index == 0) {
        TabSwitchNotification(tabContentType: TabContentType.reviews)
            .dispatch(context);
      } else {
        TabSwitchNotification(tabContentType: TabContentType.comments)
            .dispatch(context);
      }
    });

    final TabBar _tabBar = TabBar(
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.black54,
      indicatorWeight: 2.5,
      tabs: <Widget>[
        Text('点评'),
        Text('回复'),
      ],
    );
    return SliverPersistentHeader(
      floating: false,
      pinned: true,
      delegate: _MovieReviewTabbarDelegate(tabBar: _tabBar),
    );
  }
}

class _MovieReview extends StatelessWidget {
  final String avatar;
  final String content;

  _MovieReview({Key key, this.avatar, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border(
            bottom:
                BorderSide(width: 0.5, color: Theme.of(context).dividerColor)),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(avatar),
                )),
            width: 32,
            height: 32,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  content,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MovieReviewTabbarContent extends StatelessWidget {
  final TabContentType tabContentType;

  MovieReviewTabbarContent({this.tabContentType});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<MovieDetailBloc>(context);
    return StreamBuilder<Movie>(
      stream: bloc.movie,
      initialData: bloc.breifMovie,
      builder: (context, snapshot) {
        final movie = snapshot.data;
        switch (tabContentType) {
          case TabContentType.reviews:
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _MovieReview(
                  content: movie.reviews[index].content,
                  avatar: movie.reviews[index].avatar,
                );
              }, childCount: movie.reviews.length),
            );
          case TabContentType.comments:
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _MovieReview(
                  content: movie.comments[index].content,
                  avatar: movie.comments[index].avatar,
                );
              }, childCount: movie.reviews.length),
            );
        }
      },
    );
  }
}
