/// ShareMe — GoRouter configuration.
///
/// All 10 routes from App Flow §1 defined here.
/// Each route maps to its corresponding screen.
library;

import 'package:go_router/go_router.dart';

import '../features/discovery/presentation/screens/radar_screen.dart';
import '../features/file_picker/presentation/screens/file_picker_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/pairing/presentation/screens/connecting_screen.dart';
import '../features/permissions/presentation/screens/permission_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/transfer/presentation/screens/transfer_complete_screen.dart';
import '../features/transfer/presentation/screens/transfer_failed_screen.dart';
import '../features/transfer/presentation/screens/transfer_progress_screen.dart';
import 'route_names.dart';

/// The app's router configuration.
///
/// Initial route is splash (`/`), which will auto-navigate to
/// home or permissions based on permission state (implemented in M1).
final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.splash,
  routes: [
    GoRoute(
      path: RoutePaths.splash,
      name: RouteNames.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePaths.permissions,
      name: RouteNames.permissions,
      builder: (context, state) => const PermissionScreen(),
    ),
    GoRoute(
      path: RoutePaths.home,
      name: RouteNames.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RoutePaths.filePicker,
      name: RouteNames.filePicker,
      builder: (context, state) => const FilePickerScreen(),
    ),
    GoRoute(
      path: RoutePaths.radar,
      name: RouteNames.radar,
      builder: (context, state) => const RadarScreen(),
    ),
    GoRoute(
      path: RoutePaths.connecting,
      name: RouteNames.connecting,
      builder: (context, state) => const ConnectingScreen(),
    ),
    GoRoute(
      path: RoutePaths.transferProgress,
      name: RouteNames.transferProgress,
      builder: (context, state) => const TransferProgressScreen(),
    ),
    GoRoute(
      path: RoutePaths.transferComplete,
      name: RouteNames.transferComplete,
      builder: (context, state) => const TransferCompleteScreen(),
    ),
    GoRoute(
      path: RoutePaths.transferFailed,
      name: RouteNames.transferFailed,
      builder: (context, state) => const TransferFailedScreen(),
    ),
    GoRoute(
      path: RoutePaths.settings,
      name: RouteNames.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
