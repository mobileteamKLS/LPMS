import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lpms/models/ShippingList.dart';
import 'package:lpms/util/Uitlity.dart';

import '../../screens/slot_booking/BookingCreationExport.dart';
import '../../util/Global.dart';

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
