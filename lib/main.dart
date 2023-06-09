import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dashboard/view/splash_screen.dart';
import 'package:flutter_dashboard/view/weather_screen.dart';
import 'package:flutter_dashboard/view/calculator_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false, // this line removes the debug banner
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
      );
  // Routes definition for different screens within the page
  final GoRouter _router = GoRouter(routes: <GoRoute>[
    GoRoute(
      path: '/weather',
      builder: (BuildContext context, GoRouterState state) =>
          const WeatherScreen(),
    ),
    GoRoute(
      path: '/calculator',
      builder: (BuildContext context, GoRouterState state) => CalculatorApp(),
    ),
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => SplashScreen(),
    ),
  ]);
}
