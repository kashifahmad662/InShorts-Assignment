import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/hive_adapters.dart';
import '../details/movie_details_page.dart';
import '../providers/providers.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  late final TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: ref.read(searchQueryProvider));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final v = value.trim();
      // Deep link pattern: https://example.com/m/{id}
      final uri = Uri.tryParse(v);
      if (uri != null && uri.host == 'example.com' && uri.pathSegments.length == 2 && uri.pathSegments.first == 'm') {
        final id = int.tryParse(uri.pathSegments[1]);
        if (id != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => MovieDetailsPage(movieId: id, fallback: null)));
          return;
        }
      }
      ref.read(searchQueryProvider.notifier).state = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: const InputDecoration(
                hintText: 'Search movies or paste link https://example.com/m/{id}',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: results.when(
              data: (items) => ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final m = items[index];
                  final url = m.posterPath != null ? 'https://image.tmdb.org/t/p/w154${m.posterPath}' : null;
                  return ListTile(
                    leading: url != null ? Image.network(url, width: 56, fit: BoxFit.cover) : const Icon(Icons.movie),
                    title: Text(m.title),
                    subtitle: m.overview != null ? Text(m.overview!, maxLines: 2, overflow: TextOverflow.ellipsis) : null,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => MovieDetailsPage(movieId: m.id, fallback: m)));
                    },
                  );
                },
              ),
              error: (e, _) => Center(child: Text('Error: $e')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }
}
