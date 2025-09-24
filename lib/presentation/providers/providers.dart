import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/hive_adapters.dart';
import '../../data/repository/movie_repository.dart';

final trendingProvider = FutureProvider<List<MovieEntity>>((ref) async {
  final repo = ref.watch(movieRepositoryProvider);
  return repo.getTrending(refresh: true);
});

final nowPlayingProvider = FutureProvider<List<MovieEntity>>((ref) async {
  final repo = ref.watch(movieRepositoryProvider);
  return repo.getNowPlaying(refresh: true);
});

final bookmarksProvider = Provider<List<MovieEntity>>((ref) {
  final repo = ref.watch(movieRepositoryProvider);
  return repo.bookmarks();
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider.autoDispose<List<MovieEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  final repo = ref.watch(movieRepositoryProvider);
  return repo.search(query);
});

