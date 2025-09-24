import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final apiKey = dotenv.env['TMDB_API_KEY'];
  final dio = Dio(
    BaseOptions(
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );
  dio.interceptors.add(
    LogInterceptor(
      // Optional: Customize how logs are printed.
      // For Flutter, use debugPrint to avoid log truncation in console.
      logPrint: (o) => debugPrint(o.toString()),
      request: true, // Log request details
      requestHeader: true, // Log request headers
      requestBody: true, // Log request body
      responseHeader: true, // Log response headers
      responseBody: true, // Log response body
      error: true, // Log errors
    ),
  );
  return dio;
});
