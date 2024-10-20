import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lpms/models/ShippingList.dart';
import 'package:lpms/util/Uitlity.dart';

import '../../screens/BookingCreationExport.dart';
import '../../util/Global.dart';

// City model class
class City {
  final String name;
  final String country;

  City({required this.name, required this.country});
}

// City Service to simulate fetching city data
class CityService {
  static final List<City> _cities = [
    City(name: 'New York', country: 'USA'),
    City(name: 'Los Angeles', country: 'USA'),
    City(name: 'London', country: 'UK'),
    City(name: 'Paris', country: 'France'),
    City(name: 'Tokyo', country: 'Japan'),
  ];

  // Method to find cities based on search
  static List<City> find(String search) {
    return _cities.where((city) => city.name.toLowerCase().contains(search.toLowerCase())).toList();
  }

  // Method to check if the input matches a city exactly
  static bool isValidCity(String input) {
    return _cities.any((city) => '${city.name}, ${city.country}'.toLowerCase() == input.toLowerCase());
  }
}

class CHAAgentService {
  static List<CargoTypeExporterImporterAgent> find(String search) {
    String normalizedSearch = Utils.normalizeString(search);
    return chaAgentList.where((agent) {
      String normalizedAgentName =  Utils.normalizeString(agent.nameDisplay);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeString(input);
    return chaAgentList.any((agent) {
      String normalizedAgentName = normalizeString(agent.nameDisplay);
      return normalizedAgentName == normalizedInput;
    });
  }
}

 String normalizeString(String input) {

return input.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '').toLowerCase().trim();
}

class ExporterService {
  static List<CargoTypeExporterImporterAgent> find(String search) {
    String normalizedSearch = Utils.normalizeString(search);
    return exporterList.where((agent) {
      String normalizedAgentName =  Utils.normalizeString(agent.nameDisplay);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeString(input);
    return exporterList.any((agent) {
      String normalizedAgentName = normalizeString(agent.nameDisplay);
      return normalizedAgentName == normalizedInput;
    });
  }
}

class ImporterService {
  static List<CargoTypeExporterImporterAgent> find(String search) {
    String normalizedSearch = Utils.normalizeString(search);
    return importerList.where((agent) {
      String normalizedAgentName =  Utils.normalizeString(agent.nameDisplay);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeString(input);
    return importerList.any((agent) {
      String normalizedAgentName = normalizeString(agent.nameDisplay);
      return normalizedAgentName == normalizedInput;
    });
  }
}

class CargoTypeService {

  static List<CargoTypeExporterImporterAgent> find(String search) {
    String normalizedSearch = Utils.normalizeString(search);
    return cargoTypeList.where((agent) {
      String normalizedAgentName =  Utils.normalizeString(agent.nameDisplay);
      return normalizedAgentName.contains(normalizedSearch);
    }).toList();
  }

  static bool isValidAgent(String input) {
    String normalizedInput = normalizeString(input);
    return cargoTypeList.any((agent) {
      String normalizedAgentName = normalizeString(agent.nameDisplay);
      return normalizedAgentName == normalizedInput;
    });
  }
}
class SelectedVehicleService {
  static List<Vehicle> find(String search) {
    return selectedVehicleList.where((agent) => agent.name.toLowerCase().contains(search.toLowerCase())).toList();
  }
  static bool isValidAgent(String input) {
    return selectedVehicleList.any((agent) => agent.name.toLowerCase() == input.toLowerCase());
  }
}



class AutoSuggestCityForm extends StatefulWidget {
  const AutoSuggestCityForm({super.key});

  @override
  _AutoSuggestCityFormState createState() => _AutoSuggestCityFormState();
}

class _AutoSuggestCityFormState extends State<AutoSuggestCityForm> {
  final TextEditingController _cityController = TextEditingController();
  final FocusNode _cityFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double _textFieldHeight = 45; // Default initial height
  final double initialHeight = 45;
  final double errorHeight = 65;

  @override
  void initState() {
    super.initState();

    // Add a listener to clear the text if focus is lost and input is invalid
    _cityFocusNode.addListener(() {
      if (!_cityFocusNode.hasFocus) {
        if (!CityService.isValidCity(_cityController.text)) {
          _cityController.clear(); // Clear the text if invalid
        }
      }
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    _cityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('City Auto Suggest Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              FormField<String>(
                validator: (value) {
                  if (_cityController.text.isEmpty) {
                    setState(() {
                      _textFieldHeight = 45;
                    });
                    return 'Please select a valid city';
                  }
                  setState(() {
                    _textFieldHeight = initialHeight; // Reset to initial height if valid
                  });
                  return null; // Valid input
                },
                builder: (formFieldState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: _textFieldHeight, // Dynamic height based on validation
                        child: TypeAheadField<City>(
                          textFieldConfiguration: TextFieldConfiguration(


                            controller: _cityController,
                            focusNode: _cityFocusNode,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                              border: OutlineInputBorder(),
                              labelText: 'City and Country',
                            ),
                          ),
                          suggestionsCallback: (search) => CityService.find(search),
                          itemBuilder: (context, city) {
                            return ListTile(
                              title: Text(city.name),
                              subtitle: Text(city.country),
                            );
                          },
                          onSuggestionSelected: (city) {
                            // Set the selected city's name and country in the TextField
                            _cityController.text = '${city.name}, ${city.country}';
                            formFieldState.didChange(_cityController.text); // Notify form of change
                          },
                          noItemsFoundBuilder: (context) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No Cities Found'),
                          ),
                        ),
                      ),
                      if (formFieldState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            formFieldState.errorText ?? '',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  );
                },
              ),

              SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, proceed to the next page or handle form submission
                    print("City selected: ${_cityController.text}");
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AutoSuggestCityForm(),
  ));
}
