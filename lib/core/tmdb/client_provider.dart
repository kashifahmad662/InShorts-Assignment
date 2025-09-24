import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import 'api_client.dart';
import 'dio_provider.dart';

final tmdbClientProvider = Provider<TmdbApiClient>((ref) {
  final Dio dio = ref.watch(dioProvider);
  return TmdbApiClient(dio);
});

