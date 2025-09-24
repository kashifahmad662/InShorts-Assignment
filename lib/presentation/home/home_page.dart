import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/hive_adapters.dart';
import '../../data/repository/movie_repository.dart';
import '../details/movie_details_page.dart';
import '../providers/providers.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trending = ref.watch(trendingProvider);
    final nowPlaying = ref.watch(nowPlayingProvider);
    final online = ref.watch(onlineStatusProvider).value ?? true;
    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: Column(
        children: [
          if (!online)
            Container(
              width: double.infinity,
              color: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 6),
              child:
                  const Center(child: Text('Offline mode: showing cached data', style: TextStyle(color: Colors.white))),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Re-fetch by invalidating providers
                ref.invalidate(trendingProvider);
                ref.invalidate(nowPlayingProvider);
                await Future.wait([
                  ref.read(trendingProvider.future),
                  ref.read(nowPlayingProvider.future),
                ]);
              },
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  const Text('Trending', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 250,
                    child: trending.when(
                      data: (items) => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final m = items[index];
                          return _PosterCard(
                            title: m.title,
                            path: m.posterPath,
                            onTap: () => _openDetails(context, m),
                          );
                        },
                      ),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      loading: () => const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Now Playing', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 250,
                    child: nowPlaying.when(
                      data: (items) => ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final m = items[index];
                          return _PosterCard(
                            title: m.title,
                            path: m.posterPath,
                            onTap: () => _openDetails(context, m),
                          );
                        },
                      ),
                      error: (e, _) => Center(child: Text('Error: $e')),
                      loading: () => const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDetails(BuildContext context, MovieEntity m) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MovieDetailsPage(movieId: m.id, fallback: m),
      ),
    );
  }
}

class _PosterCard extends StatelessWidget {
  const _PosterCard({required this.title, required this.path, this.onTap});
  final String title;
  final String? path;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final url = path != null ? 'https://image.tmdb.org/t/p/w342$path' : null;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: url != null ? Image.network(url, fit: BoxFit.cover) : Container(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
