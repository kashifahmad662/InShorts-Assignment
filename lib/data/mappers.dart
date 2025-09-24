import '../core/tmdb/api_client.dart';
import 'local/hive_adapters.dart';

extension MovieDtoMapper on MovieDto {
  MovieEntity toEntity() => MovieEntity(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        releaseDate: releaseDate,
        voteAverage: voteAverage,
      );
}

extension MovieDetailDtoMapper on MovieDetailDto {
  MovieDetailEntity toEntity() => MovieDetailEntity(
        id: id,
        title: title,
        overview: overview,
        posterPath: posterPath,
        backdropPath: backdropPath,
        releaseDate: releaseDate,
        voteAverage: voteAverage,
        runtime: runtime,
      );
}

