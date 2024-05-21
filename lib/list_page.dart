import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_99oranges/api_services.dart';
import 'package:task_99oranges/form_page.dart';
import 'package:task_99oranges/main.dart';

class LocationListPage extends StatefulWidget {
  const LocationListPage({super.key});

  @override
  State<LocationListPage> createState() => _LocationListPageState();
}

class _LocationListPageState extends State<LocationListPage> {
  @override
  void initState() {
    ApiService().login();
    Provider.of<LocationProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Locations')),
      body: Consumer<LocationProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            reverse: true,
            itemCount: provider.locations.length,
            itemBuilder: (context, index) {
              final location = provider.locations[index];
              return ListTile(
                title: Text(location['name']),
                subtitle: Text(location['address']),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LocationFormPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
