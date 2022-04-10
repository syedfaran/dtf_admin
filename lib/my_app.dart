import 'package:dtf_web/constants/route_string.dart';
import 'package:dtf_web/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        breakpoints: const [
          ResponsiveBreakpoint.resize(350, name: MOBILE),
          ResponsiveBreakpoint.autoScale(600, name: TABLET),
          ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
        ],
      ),
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.amber),

      initialRoute: RouteString.initial,
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorObservers: const [],
    );
  }
}
