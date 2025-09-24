import 'package:hive/hive.dart';

part 'hive_adapters.g.dart';

@HiveType(typeId: 1)
class MovieEntity extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? overview;
  @HiveField(3)
  String? posterPath;
  @HiveField(4)
  String? backdropPath;
  @HiveField(5)
  String? releaseDate;
  @HiveField(6)
  double? voteAverage;

  MovieEntity({required this.id, required this.title, this.overview, this.posterPath, this.backdropPath, this.releaseDate, this.voteAverage});
}

@HiveType(typeId: 2)
class MovieDetailEntity extends HiveObject {
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? overview;
  @HiveField(3)
  String? posterPath;
  @HiveField(4)
  String? backdropPath;
  @HiveField(5)
  String? releaseDate;
  @HiveField(6)
  double? voteAverage;
  @HiveField(7)
  int? runtime;

  MovieDetailEntity({required this.id, required this.title, this.overview, this.posterPath, this.backdropPath, this.releaseDate, this.voteAverage, this.runtime});
}

class Boxes {
  static const String trending = 'trending_movies';
  static const String nowPlaying = 'now_playing_movies';
  static const String bookmarks = 'bookmarked_movies';
  static const String details = 'movie_details';
}

