import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'presentation/app/app.dart';
import 'presentation/app/init_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Hive.initFlutter();
  final container = await createAppContainer();
  runApp(UncontrolledProviderScope(container: container, child: const AppRoot()));
}

// AppRoot is defined in presentation/app/app.dart
