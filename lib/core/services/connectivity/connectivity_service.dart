import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<bool>((ref) async* {
  // Check current status immediately on startup
  final initial = await Connectivity().checkConnectivity();
  yield initial.first != ConnectivityResult.none;

  // Then listen for changes
  await for (final results in Connectivity().onConnectivityChanged) {
    if (results.isEmpty) {
      yield false;
    } else {
      yield results.first != ConnectivityResult.none;
    }
  }
});

final isOnlineProvider = Provider<bool>((ref) {
  return ref
      .watch(connectivityProvider)
      .maybeWhen(data: (isOnline) => isOnline, orElse: () => true);
});
