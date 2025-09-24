import 'package:hive/hive.dart';

import 'hive_adapters.dart';

class LocalDataSource {
  LocalDataSource({required this.trendingBox, required this.nowPlayingBox, required this.bookmarkBox, required this.detailBox});

  final Box<MovieEntity> trendingBox;
  final Box<MovieEntity> nowPlayingBox;
  final Box<MovieEntity> bookmarkBox;
  final Box<MovieDetailEntity> detailBox;

  Future<void> cacheTrending(List<MovieEntity> movies) async {
    await trendingBox.clear();
    await trendingBox.addAll(movies);
  }

  Future<void> cacheNowPlaying(List<MovieEntity> movies) async {
    await nowPlayingBox.clear();
    await nowPlayingBox.addAll(movies);
  }

  List<MovieEntity> getTrending() => trendingBox.values.toList(growable: false);
  List<MovieEntity> getNowPlaying() => nowPlayingBox.values.toList(growable: false);

  Future<void> upsertDetail(MovieDetailEntity detail) async {
    await detailBox.put(detail.id, detail);
  }

  MovieDetailEntity? getDetail(int id) => detailBox.get(id);

  Future<void> toggleBookmark(MovieEntity movie) async {
    if (bookmarkBox.values.any((m) => m.id == movie.id)) {
      final key = bookmarkBox.keys.firstWhere((k) => bookmarkBox.get(k)!.id == movie.id);
      await bookmarkBox.delete(key);
    } else {
      await bookmarkBox.add(movie);
    }
  }

  List<MovieEntity> getBookmarks() => bookmarkBox.values.toList(growable: false);
  bool isBookmarked(int id) => bookmarkBox.values.any((m) => m.id == id);
}

