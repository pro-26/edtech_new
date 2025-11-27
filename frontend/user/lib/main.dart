import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:get/get.dart';

import 'package:ed_tech/app/core/theme/app_theme.dart';
import 'package:ed_tech/app/routes/app_bindings.dart';

import 'app/routes/app_pages.dart';

/*
  This file is the main entry point for the EdTech application.
  It initializes the Appwrite client and sets up the GetX routing system.
  The application uses a light and dark theme, and it is configured to run with system settings.

  created by : Muhammed Shabeer OP
  date : 2025-08-07
  updated date : 2025-08-03
*/

void main() {
  // Always ensure binding is the very first call before any plugin / GetX usage.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'EdTech',
      builder: FToastBuilder(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      unknownRoute: AppPages.unknownRoute,
      theme: lightTheme,
      initialBinding: InitialBindings(), // use : used for centralize services
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      popGesture: true,
      enableLog: kDebugMode,
      logWriterCallback: (String log, {bool? isError}) => debugPrint(log),
      navigatorObservers:
          [], //used for route observability || typically for user flow tracking
    );
  }
}
