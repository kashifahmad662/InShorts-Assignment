import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repository/movie_repository.dart';

class SavedPage extends ConsumerWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(movieRepositoryProvider);
    final items = repo.bookmarks();
    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: items.isEmpty
          ? const Center(child: Text('No bookmarks yet'))
          : ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final m = items[index];
                final url = m.posterPath != null ? 'https://image.tmdb.org/t/p/w154${m.posterPath}' : null;
                return ListTile(
                  leading: url != null ? Image.network(url, width: 56, fit: BoxFit.cover) : const Icon(Icons.movie),
                  title: Text(m.title),
                );
              },
            ),
    );
  }
}
