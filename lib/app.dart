import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kreative_kindle/features/splash/presentation/pages/splash_screen.dart';
import 'core/providers/theme_provider.dart';
import 'theme/theme_data.dart';

class KreativeKindleApp extends ConsumerStatefulWidget {
  const KreativeKindleApp({super.key});

  @override
  ConsumerState<KreativeKindleApp> createState() => _KreativeKindleAppState();
}

class _KreativeKindleAppState extends ConsumerState<KreativeKindleApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Fires whenever the device switches Night Mode / Dark Mode on or off.
  /// This is the "ambient light / bedtime sensor" use case — the app
  /// automatically switches to its dark theme when the device does.
  @override
  void didChangePlatformBrightness() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    ref.read(themeProvider.notifier).setTheme(brightness == Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kreative Kindle',
      theme: getApplicationTheme(),
      darkTheme: getDarkApplicationTheme(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: SplashScreen(),
    );
  }
}
