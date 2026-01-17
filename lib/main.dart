import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/profile.dart';
import 'screens/add_medication.dart';
import 'screens/add_medication_camera.dart';
import 'screens/check_interaction.dart';
import 'screens/settings.dart';
import 'screens/add_medication_manual.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/add': (context) => const AddMedicationScreen(),
        '/scan': (context) => const ScanMedicationScreen(),
        '/add-manual': (context) => const AddMedicationManualScreen(),
        '/interaction': (context) => const InteractionCheckScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/add_medication_manual': (context) => const AddMedicationManualScreen(),
      },
    );
  }
}
