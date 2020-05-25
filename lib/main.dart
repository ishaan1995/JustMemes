import 'package:flutter/material.dart';
import 'splash.dart';

void main() async {
  ///
  /// setup binding to call native method calls before `runApp` is called.
  /// issue detected in flutter: 1.9.6-pre.60
  /// read more [https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding/ensureInitialized.html]
  /// WidgetsFlutterBinding.ensureInitialized();
  ///
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Funny Memes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}
