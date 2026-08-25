import 'package:flutter/material.dart';

class AddressProvider extends ChangeNotifier {
  String? _name;
  String? _phone;
  String? _address;
  String? _city;
  String? _postalCode;

  String? get name => _name;
  String? get phone => _phone;
  String? get address => _address;
  String? get city => _city;
  String? get postalCode => _postalCode;

  bool get hasAddress {
    return _address != null &&
        _address!.trim().isNotEmpty &&
        _city != null &&
        _city!.trim().isNotEmpty;
  }

  void saveAddress({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String postalCode,
  }) {
    _name = name;
    _phone = phone;
    _address = address;
    _city = city;
    _postalCode = postalCode;

    notifyListeners();
  }

  void clearAddress() {
    _name = null;
    _phone = null;
    _address = null;
    _city = null;
    _postalCode = null;

    notifyListeners();
  }
}