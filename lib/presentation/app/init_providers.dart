import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/local/hive_adapters.dart';
import '../../data/local/local_data_source.dart';
import '../../data/repository/movie_repository.dart';

Future<ProviderContainer> createAppContainer() async {
  Hive.registerAdapter(MovieEntityAdapter());
  Hive.registerAdapter(MovieDetailEntityAdapter());

  final trending = await Hive.openBox<MovieEntity>(Boxes.trending);
  final nowPlaying = await Hive.openBox<MovieEntity>(Boxes.nowPlaying);
  final bookmarks = await Hive.openBox<MovieEntity>(Boxes.bookmarks);
  final details = await Hive.openBox<MovieDetailEntity>(Boxes.details);

  final local = LocalDataSource(
    trendingBox: trending,
    nowPlayingBox: nowPlaying,
    bookmarkBox: bookmarks,
    detailBox: details,
  );

  final container = ProviderContainer(
    overrides: [
      localDataSourceProvider.overrideWithValue(local),
    ],
  );
  return container;
}

