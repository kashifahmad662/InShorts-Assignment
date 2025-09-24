import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_client.g.dart';

const String kTmdbBaseUrl = 'https://api.themoviedb.org/3';

@RestApi(baseUrl: kTmdbBaseUrl)
abstract class TmdbApiClient {
  factory TmdbApiClient(Dio dio, {String baseUrl}) = _TmdbApiClient;

  @GET('/trending/movie/day')
  Future<PagedResponse<MovieDto>> getTrendingMovies({@Query('page') int page = 1});

  @GET('/movie/now_playing')
  Future<PagedResponse<MovieDto>> getNowPlaying({@Query('page') int page = 1});

  @GET('/search/movie')
  Future<PagedResponse<MovieDto>> searchMovies({@Query('query') required String query, @Query('page') int page = 1});

  @GET('/movie/{id}')
  Future<MovieDetailDto> getMovieDetail(@Path('id') int id);
}

@JsonSerializable(genericArgumentFactories: true)
class PagedResponse<T> {
  PagedResponse({required this.page, required this.results, required this.totalPages, required this.totalResults});

  final int page;
  final List<T> results;
  @JsonKey(name: 'total_pages')
  final int totalPages;
  @JsonKey(name: 'total_results')
  final int totalResults;

  factory PagedResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$PagedResponseFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$PagedResponseToJson(this, toJsonT);
}

@JsonSerializable()
class MovieDto {
  MovieDto(
      {required this.id,
      required this.title,
      this.overview,
      this.posterPath,
      this.backdropPath,
      this.releaseDate,
      this.voteAverage});

  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? voteAverage;

  factory MovieDto.fromJson(Map<String, dynamic> json) => _$MovieDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDtoToJson(this);
}

@JsonSerializable()
class MovieDetailDto {
  MovieDetailDto(
      {required this.id,
      required this.title,
      this.overview,
      @JsonKey(name: 'poster_path') this.posterPath,
      @JsonKey(name: 'backdrop_path') this.backdropPath,
      @JsonKey(name: 'release_date') this.releaseDate,
      @JsonKey(name: 'vote_average') this.voteAverage,
      this.runtime});

  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final String? releaseDate;
  final double? voteAverage;
  final int? runtime;

  factory MovieDetailDto.fromJson(Map<String, dynamic> json) => _$MovieDetailDtoFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailDtoToJson(this);
}
