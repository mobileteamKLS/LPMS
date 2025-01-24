import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lpms/models/ShippingList.dart';
import 'package:lpms/util/Uitlity.dart';

import '../../screens/slot_booking/BookingCreationExport.dart';
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
    print("____$normalizedSearch");
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
    print("____$normalizedSearch");
    return cargoTypeList.where((agent) {
      String normalizedAgentName =  Utils.normalizeString(agent.description);
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
