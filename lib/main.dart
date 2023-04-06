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

  // @override
  // Widget build(BuildContext context) {
  //   return MaterialApp(
  //     title: 'Weather App',

  //     // to hide debug banner
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(
  //       primarySwatch: Colors.green,
  //     ),
  //     home: SplashScreen(),
  //     routes: {
  //       '/home': (context) => WeatherScreen(),
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
      );

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        routes: <GoRoute>[
          GoRoute(
            path: 'weather',
            builder: (BuildContext context, GoRouterState state) =>
                const WeatherScreen(),
          ),
          GoRoute(
            path: 'calculator',
            builder: (BuildContext context, GoRouterState state) =>
                CalculatorApp(),
          ),
        ],
        path: '/',
        builder: (BuildContext context, GoRouterState state) => SplashScreen(),
      ),
    ],
  );
}
