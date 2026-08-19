import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/services/hive_service.dart';
import 'app/data/services/firebase_service.dart';
import 'app/data/services/connectivity_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Hive
  final hiveService = HiveService();
  await hiveService.init();
  Get.put(hiveService);

  // Initialize Firebase Service
  Get.put(FirebaseService());

  // Initialize Connectivity
  Get.put(ConnectivityService());

  runApp(
    GetMaterialApp(
      title: "Task Management App",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1), // Dark Blue
          primary: const Color(0xFF0D47A1),
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: const Color(0xFF0D47A1),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF0D47A1),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          brightness: Brightness.dark,
          primary: const Color(
            0xFF42A5F5,
          ), // Lighter blue for dark mode visibility
          onPrimary: Colors.black,
          surface: const Color(0xFF121212),
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF42A5F5),
          foregroundColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    ),
  );
}
