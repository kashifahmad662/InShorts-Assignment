import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/local/hive_adapters.dart';
import '../../data/repository/movie_repository.dart';

class MovieDetailsPage extends ConsumerWidget {
  const MovieDetailsPage({super.key, required this.movieId, required this.fallback});
  final int movieId;
  final MovieEntity? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(movieRepositoryProvider);
    final detail = repo.getDetail(movieId);

    return FutureBuilder<MovieDetailEntity?>(
      future: detail,
      builder: (context, snap) {
        final d = snap.data;
        final title = d?.title ?? fallback?.title ?? 'Movie';
        final backdrop = d?.backdropPath ?? fallback?.backdropPath;
        final poster = d?.posterPath ?? fallback?.posterPath;
        final overview = d?.overview ?? fallback?.overview;
        final isBookmarked = repo.isBookmarked(movieId);
        final shareUrl = 'https://example.com/m/$movieId';

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => Share.share('Check this movie: $title\n$shareUrl'),
              ),
              IconButton(
                icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
                onPressed: () async {
                  final base = MovieEntity(
                    id: movieId,
                    title: title,
                    overview: overview,
                    posterPath: poster,
                    backdropPath: backdrop,
                    releaseDate: d?.releaseDate,
                    voteAverage: d?.voteAverage,
                  );
                  await repo.toggleBookmark(base);
                  // force rebuild
                  (context as Element).markNeedsBuild();
                },
              ),
            ],
          ),
          body: ListView(
            children: [
              if (backdrop != null)
                Image.network('https://image.tmdb.org/t/p/w780$backdrop', fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (poster != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network('https://image.tmdb.org/t/p/w185$poster', height: 180),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: Theme.of(context).textTheme.titleLarge),
                              if (d?.voteAverage != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(children: [
                                    const Icon(Icons.star, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text('${d!.voteAverage!.toStringAsFixed(1)} / 10'),
                                  ]),
                                ),
                              if (d?.runtime != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text('Runtime: ${d!.runtime} min'),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (overview != null) Text(overview),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
