import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'product_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProductRepository().loadData();
  runApp(const StepUpApp());
}

class StepUpApp extends StatelessWidget {
  const StepUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'StepUp',
      theme: ThemeData(
        fontFamily: 'Inter',
        primaryColor: Colors.black,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF8F9FA),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
