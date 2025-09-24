import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/tmdb/api_client.dart';
import '../../core/tmdb/client_provider.dart';
import '../local/hive_adapters.dart';
import '../local/local_data_source.dart';
import '../mappers.dart';

class MovieRepository {
  MovieRepository({required this.api, required this.local, required this.connectivity});

  final TmdbApiClient api;
  final LocalDataSource local;
  final Connectivity connectivity;

  Future<List<MovieEntity>> getTrending({bool refresh = true}) async {
    final cached = local.getTrending();
    if (cached.isNotEmpty && !refresh) return cached;
    if (await _isOnline()) {
      final response = await api.getTrendingMovies();
      final movies = response.results.map((e) => e.toEntity()).toList();
      await local.cacheTrending(movies);
      return movies;
    }
    return cached;
  }

  Future<List<MovieEntity>> getNowPlaying({bool refresh = true}) async {
    final cached = local.getNowPlaying();
    if (cached.isNotEmpty && !refresh) return cached;
    if (await _isOnline()) {
      final response = await api.getNowPlaying();
      final movies = response.results.map((e) => e.toEntity()).toList();
      await local.cacheNowPlaying(movies);
      return movies;
    }
    return cached;
  }

  Future<List<MovieEntity>> search(String query) async {
    if (await _isOnline()) {
      final response = await api.searchMovies(query: query);
      return response.results.map((e) => e.toEntity()).toList();
    }
    return [];
  }

  Future<MovieDetailEntity?> getDetail(int id) async {
    final cached = local.getDetail(id);
    if (cached != null) return cached;
    if (await _isOnline()) {
      final dto = await api.getMovieDetail(id);
      final entity = dto.toEntity();
      await local.upsertDetail(entity);
      return entity;
    }
    return null;
  }

  Future<void> toggleBookmark(MovieEntity movie) => local.toggleBookmark(movie);
  List<MovieEntity> bookmarks() => local.getBookmarks();
  bool isBookmarked(int id) => local.isBookmarked(id);

  Future<bool> _isOnline() async {
    final result = await connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}

final connectivityProvider = Provider<Connectivity>((ref) => Connectivity());

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  throw UnimplementedError('Initialized in main with Hive boxes');
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final api = ref.watch(tmdbClientProvider);
  final local = ref.watch(localDataSourceProvider);
  final conn = ref.watch(connectivityProvider);
  return MovieRepository(api: api, local: local, connectivity: conn);
});

final onlineStatusProvider = StreamProvider<bool>((ref) {
  final conn = ref.watch(connectivityProvider);
  return conn.onConnectivityChanged.map((event) => event != ConnectivityResult.none).distinct();
});

