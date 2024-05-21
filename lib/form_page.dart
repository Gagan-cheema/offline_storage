import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_99oranges/main.dart';

class LocationFormPage extends StatefulWidget {
  const LocationFormPage({super.key});

  @override
  _LocationFormPageState createState() => _LocationFormPageState();
}

class _LocationFormPageState extends State<LocationFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _address;
  String? _remark;
  int _status = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                onSaved: (value) => _address = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Remark'),
                onSaved: (value) => _remark = value,
              ),
              DropdownButtonFormField<int>(
                value: _status,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('Active')),
                  DropdownMenuItem(value: 0, child: Text('Inactive')),
                ],
                onChanged: (value) => setState(() => _status = value!),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    final location = {
                      'name': _name,
                      'address': _address,
                      'remark': _remark,
                      'status': _status,
                      'created_at': DateTime.now().toString(),
                      'updated_at': DateTime.now().toString(),
                    };
                    Provider.of<LocationProvider>(context, listen: false).addLocation(location);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
