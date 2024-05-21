import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_99oranges/api_services.dart';
import 'package:task_99oranges/db_helper.dart';
import 'package:task_99oranges/list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().deleteAllLocations();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LocationListPage(),
    );
  }
}

class LocationProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ApiService _apiService = ApiService();

  List<Map<String, dynamic>> _locations = [];

  List<Map<String, dynamic>> get locations => _locations;

  Future<void> fetchLocations() async {
    _locations = await _dbHelper.fetchLocations();
    notifyListeners();
  }

  Future<void> addLocation(Map<String, dynamic> location) async {
    await _dbHelper.insertLocation(location);
    await syncLocations();
    fetchLocations();
  }

  Future<void> syncLocations() async {
    await _apiService.login();
    final locations = await _dbHelper.fetchLocations();
    for (final location in locations) {
      await _apiService.createLocation(location);
    }
    await _dbHelper.deleteAllLocations();
    final remoteLocations = await _apiService.fetchLocations();
    for (final location in remoteLocations) {
      await _dbHelper.insertLocation(location);
    }
    fetchLocations();
  }
}
