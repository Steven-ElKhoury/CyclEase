import 'package:flutter/material.dart';
import 'package:cyclease/models/profile.dart';

class ProfileProvider extends ChangeNotifier {
  List<Profile> _profiles = [];
  Profile? _selectedProfile;

  void setSelectedProfile(Profile profile) {
    _selectedProfile = profile;
    notifyListeners();
  }

  Profile? get selectedProfile => _selectedProfile;

  List<Profile> get profiles => _profiles;

  void setProfiles(List<Profile> profiles) {
    _profiles = profiles;
    notifyListeners();
  }

  void addProfile(Profile profile) {
    _profiles.add(profile);
    notifyListeners();
  }

  void removeProfile(Profile profile) {
    _profiles.remove(profile);
    notifyListeners();
  }
}